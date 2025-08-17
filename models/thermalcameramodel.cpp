#include "ThermalCameraModel.h"
#include <QDebug>
#include <QNetworkDatagram>
#include<QtEndian>
#include<QDateTime>
// JPEG markers
const QByteArray ThermalCameraModel::JPEG_START_MARKER = QByteArray::fromHex("FFD8");
const QByteArray ThermalCameraModel::JPEG_END_MARKER = QByteArray::fromHex("FFD9");

ThermalCameraModel::ThermalCameraModel(QObject *parent)
    : QObject(parent)
    , m_udpSocket(nullptr)
    , m_processTimer(new QTimer(this))
    , m_streaming(false)
    , m_fragmentTimeout(5000)
{
    // Timer to process buffer periodically
    m_processTimer->setInterval(16);
    connect(m_processTimer, &QTimer::timeout, this, &ThermalCameraModel::processBuffer);

    // Timer to clean up incomplete frames
    m_cleanupTimer = new QTimer(this);
    m_cleanupTimer->setInterval(1000); // Check every second
    connect(m_cleanupTimer, &QTimer::timeout, this, &ThermalCameraModel::cleanupIncompleteFrames);
}

ThermalCameraModel::~ThermalCameraModel()
{
    stopStreaming();
}

void ThermalCameraModel::startStreaming(const QString &ipAddress, int port)
{
    if (m_streaming) {
        stopStreaming();
    }

    m_settings.ipAddress = ipAddress;
    m_settings.port = port;

    // Create UDP socket
    m_udpSocket = new QUdpSocket(this);

    // Connect signals
    connect(m_udpSocket, &QUdpSocket::readyRead, this, &ThermalCameraModel::readPendingDatagrams);
    connect(m_udpSocket, QOverload<QAbstractSocket::SocketError>::of(&QUdpSocket::errorOccurred),
            this, &ThermalCameraModel::onSocketError);

    // Bind to the specified port
    if (m_udpSocket->bind(QHostAddress::AnyIPv4, port)) {
        m_streaming = true;
        m_processTimer->start();
        m_cleanupTimer->start();
        emit streamingStatusChanged(true);
        emit connectionEstablished();
        qDebug() << "Started UDP streaming on port:" << port;
    } else {
        emit errorOccurred("Failed to bind to port " + QString::number(port) + ": " + m_udpSocket->errorString());
        delete m_udpSocket;
        m_udpSocket = nullptr;
    }
}

void ThermalCameraModel::stopStreaming()
{
    if (!m_streaming) {
        return;
    }

    m_processTimer->stop();
    m_cleanupTimer->stop();

    if (m_udpSocket) {
        m_udpSocket->close();
        m_udpSocket->deleteLater();
        m_udpSocket = nullptr;
    }

    clearBuffer();
    clearIncompleteFrames();
    m_streaming = false;
    emit streamingStatusChanged(false);
    qDebug() << "Stopped UDP streaming";
}

bool ThermalCameraModel::isStreaming() const
{
    return m_streaming;
}

void ThermalCameraModel::readPendingDatagrams()
{
    while (m_udpSocket && m_udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_udpSocket->receiveDatagram();
        QByteArray data = datagram.data();

        if (!data.isEmpty()) {
            processFragmentedPacket(data);
        }
    }
}

void ThermalCameraModel::processFragmentedPacket(const QByteArray &packet)
{

    // Check if packet has header (minimum 14 bytes for header)
    if (packet.size() < 14) {
        qDebug() << "Packet too small for header:" << packet.size();
        return;
    }

    // Parse header: frame_id(2) + total_fragments(4) + fragment_index(4) + fragment_size(4)
    const char* data = packet.constData();
    quint16 frameId = qFromBigEndian<quint16>(reinterpret_cast<const uchar*>(data));
    quint32 totalFragments = qFromBigEndian<quint32>(reinterpret_cast<const uchar*>(data + 2));
    quint32 fragmentIndex = qFromBigEndian<quint32>(reinterpret_cast<const uchar*>(data + 6));
    quint32 fragmentSize = qFromBigEndian<quint32>(reinterpret_cast<const uchar*>(data + 10));
    // Validate header
    if (fragmentIndex >= totalFragments || fragmentSize != (packet.size() - 14)) {
        qDebug() << "Invalid fragment header - Index:" << fragmentIndex
                 << "Total:" << totalFragments << "Size:" << fragmentSize ;
        return;
    }

    // Extract fragment data
    QByteArray fragmentData = packet.mid(14);

    QMutexLocker locker(&m_bufferMutex);

    // Initialize frame reassembly if this is the first fragment
    if (!m_incompleteFrames.contains(frameId)) {
        FrameAssembly assembly;
        assembly.totalFragments = totalFragments;
        assembly.receivedFragments = 0;
        assembly.fragments.resize(totalFragments);
        assembly.timestamp = QDateTime::currentMSecsSinceEpoch();
        m_incompleteFrames[frameId] = assembly;

        qDebug() << "Started reassembly for frame" << frameId << "with" << totalFragments << "fragments";
    }

    FrameAssembly& assembly = m_incompleteFrames[frameId];

    // Check if we already have this fragment
    if (!assembly.fragments[fragmentIndex].isEmpty()) {
        qDebug() << "Duplicate fragment" << fragmentIndex << "for frame" << frameId;
        return;
    }

    // Store the fragment
    assembly.fragments[fragmentIndex] = fragmentData;
    assembly.receivedFragments++;

    qDebug() << "Received fragment" << fragmentIndex << "/" << totalFragments
             << "for frame" << frameId << "(" << assembly.receivedFragments << "/" << totalFragments << ")";

    // Check if frame is complete
    if (assembly.receivedFragments == assembly.totalFragments) {
        // Reassemble the complete frame
        QByteArray completeFrame;
        for (const QByteArray& fragment : assembly.fragments) {
            completeFrame.append(fragment);
        }

        qDebug() << "Frame" << frameId << "complete, total size:" << completeFrame.size();

        // Validate and emit the complete frame
        if (isValidJpegFrame(completeFrame)) {
            emit frameReceived(completeFrame);
            qDebug() << "Valid complete frame emitted for frame ID:" << frameId;
        } else {
            qDebug() << "Invalid complete frame for frame ID:" << frameId;
        }

        // Remove completed frame from incomplete frames
        m_incompleteFrames.remove(frameId);
    }
}

void ThermalCameraModel::cleanupIncompleteFrames()
{
    QMutexLocker locker(&m_bufferMutex);

    qint64 currentTime = QDateTime::currentMSecsSinceEpoch();
    QList<quint32> framesToRemove;

    for (auto it = m_incompleteFrames.begin(); it != m_incompleteFrames.end(); ++it) {
        if (currentTime - it.value().timestamp > m_fragmentTimeout) {
            framesToRemove.append(it.key());
        }
    }

    for (quint16  frameId : framesToRemove) {
        qDebug() << "Removing incomplete frame" << frameId << "due to timeout";
        m_incompleteFrames.remove(frameId);
    }
}

void ThermalCameraModel::processBuffer()
{
    QMutexLocker locker(&m_bufferMutex);
    if (m_frameBuffer.isEmpty()) {
        return;
    }

    extractFramesFromBuffer();
}

void ThermalCameraModel::extractFramesFromBuffer()
{
    int startPos = 0;
    int framesExtracted = 0;

    while (true) {
        // Find JPEG start marker
        int jpegStart = m_frameBuffer.indexOf(JPEG_START_MARKER, startPos);
        if (jpegStart == -1) {
            // No more JPEG start markers, remove processed data
            if (startPos > 0) {
                m_frameBuffer.remove(0, startPos);
            }
            break;
        }

        // Find JPEG end marker after the start
        int jpegEnd = m_frameBuffer.indexOf(JPEG_END_MARKER, jpegStart + 2);
        if (jpegEnd == -1) {
            // Incomplete frame, wait for more data
            if (jpegStart > 0) {
                // Remove any data before the incomplete frame
                m_frameBuffer.remove(0, jpegStart);
            }
            break;
        }

        // Extract complete JPEG frame
        int frameLength = jpegEnd - jpegStart + 2; // +2 for end marker length
        QByteArray frameData = m_frameBuffer.mid(jpegStart, frameLength);

        // Validate frame
        if (isValidJpegFrame(frameData)) {
            emit frameReceived(frameData);
            framesExtracted++;
            qDebug() << "Valid frame emitted, total extracted:" << framesExtracted;
        } else {
            qDebug() << "Invalid frame detected, skipping";
        }

        // Move to next potential frame
        startPos = jpegEnd + 2;

        // Remove processed data
        if (startPos > 1024) { // Only remove if we've processed a reasonable amount
            m_frameBuffer.remove(0, startPos);
            startPos = 0;
        }
    }

    if (framesExtracted > 0) {
        qDebug() << "Extracted" << framesExtracted << "frames in this cycle";
    }
}

bool ThermalCameraModel::isValidJpegFrame(const QByteArray &data)
{
    // Basic validation: must start with JPEG start marker and end with JPEG end marker
    if (data.size() < 4) {
        qDebug() << "Frame too small:" << data.size() << "bytes";
        return false;
    }

    bool validStart = data.startsWith(JPEG_START_MARKER);
    bool validEnd = data.endsWith(JPEG_END_MARKER);

    if (!validStart) {
        qDebug() << "Invalid JPEG start marker";
    }
    if (!validEnd) {
        qDebug() << "Invalid JPEG end marker";
    }

    // For Full HD frames, allow larger size range
    if (data.size() < 1024 || data.size() > 5 * 1024 * 1024) { // Up to 5MB for Full HD
        qDebug() << "Frame size out of reasonable range:" << data.size();
        return false;
    }

    return validStart && validEnd;
}

void ThermalCameraModel::clearBuffer()
{
    QMutexLocker locker(&m_bufferMutex);
    m_frameBuffer.clear();
    qDebug() << "Buffer cleared";
}

void ThermalCameraModel::clearIncompleteFrames()
{
    QMutexLocker locker(&m_bufferMutex);
    m_incompleteFrames.clear();
    qDebug() << "Incomplete frames cleared";
}

void ThermalCameraModel::onSocketError()
{
    if (m_udpSocket) {
        QString errorString = m_udpSocket->errorString();
        emit errorOccurred("UDP Socket Error: " + errorString);
        qDebug() << "UDP Socket Error:" << errorString;
    }
}
