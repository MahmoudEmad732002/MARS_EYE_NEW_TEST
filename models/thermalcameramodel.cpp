#include "ThermalCameraModel.h"
#include <QDebug>
#include <QNetworkDatagram>

// JPEG markers
const QByteArray ThermalCameraModel::JPEG_START_MARKER = QByteArray::fromHex("FFD8");
const QByteArray ThermalCameraModel::JPEG_END_MARKER = QByteArray::fromHex("FFD9");

ThermalCameraModel::ThermalCameraModel(QObject *parent)
    : QObject(parent)
    , m_udpSocket(nullptr)
    , m_processTimer(new QTimer(this))
    , m_streaming(false)
{
    // Timer to process buffer periodically
    m_processTimer->setInterval(16); // ~60 FPS processing
    connect(m_processTimer, &QTimer::timeout, this, &ThermalCameraModel::processBuffer);
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
        emit streamingStatusChanged(true);
        emit connectionEstablished();
        qDebug() << "Started thermal UDP streaming on port:" << port;
    } else {
        emit errorOccurred("Failed to bind to thermal port " + QString::number(port) + ": " + m_udpSocket->errorString());
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

    if (m_udpSocket) {
        m_udpSocket->close();
        m_udpSocket->deleteLater();
        m_udpSocket = nullptr;
    }

    clearBuffer();
    m_streaming = false;
    emit streamingStatusChanged(false);
    qDebug() << "Stopped thermal UDP streaming";
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
            QMutexLocker locker(&m_bufferMutex);
            m_frameBuffer.append(data);

            // Debug: Log received data size
            qDebug() << "Received thermal UDP packet, size:" << data.size() << "Total buffer size:" << m_frameBuffer.size();

            // Limit buffer size to prevent memory issues (10MB max)
            if (m_frameBuffer.size() > 10 * 1024 * 1024) {
                // Keep only the last 5MB
                m_frameBuffer = m_frameBuffer.right(5 * 1024 * 1024);
                qDebug() << "Thermal buffer trimmed to prevent overflow";
            }
        }
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
            qDebug() << "Valid thermal frame emitted, total extracted:" << framesExtracted;
        } else {
            qDebug() << "Invalid thermal frame detected, skipping";
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
        qDebug() << "Extracted" << framesExtracted << "thermal frames in this cycle";
    }
}

bool ThermalCameraModel::isValidJpegFrame(const QByteArray &data)
{
    // Basic validation: must start with JPEG start marker and end with JPEG end marker
    if (data.size() < 4) {
        qDebug() << "Thermal frame too small:" << data.size() << "bytes";
        return false;
    }

    bool validStart = data.startsWith(JPEG_START_MARKER);
    bool validEnd = data.endsWith(JPEG_END_MARKER);

    if (!validStart) {
        qDebug() << "Invalid thermal JPEG start marker";
    }
    if (!validEnd) {
        qDebug() << "Invalid thermal JPEG end marker";
    }

    // Additional validation: reasonable size (1KB to 1MB)
    if (data.size() < 1024 || data.size() > 1024 * 1024) {
        qDebug() << "Thermal frame size out of reasonable range:" << data.size();
        return false;
    }

    return validStart && validEnd;
}

void ThermalCameraModel::clearBuffer()
{
    QMutexLocker locker(&m_bufferMutex);
    m_frameBuffer.clear();
    qDebug() << "Thermal buffer cleared";
}

void ThermalCameraModel::onSocketError()
{
    if (m_udpSocket) {
        QString errorString = m_udpSocket->errorString();
        emit errorOccurred("Thermal UDP Socket Error: " + errorString);
        qDebug() << "Thermal UDP Socket Error:" << errorString;
    }
}
