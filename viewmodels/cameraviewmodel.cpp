#include "cameraviewmodel.h"
#include <QTimer>
#include <QDateTime>
#include <QQmlEngine>
#include <QDebug>
#include <QMutex>
#include<QPainter>
// Global image provider instance
static CameraImageProvider* g_imageProvider = nullptr;

CameraViewModel::CameraViewModel(QObject *parent)
    : QObject(parent)
    , m_cameraThread(new QThread(this))
    , m_cameraModel(nullptr)
    , m_ipAddress("127.0.0.1")
    , m_port(5000)
    , m_streaming(false)
    , m_cameraStatus("Disconnected")
    , m_frameCount(0)
    , m_frameRate(0.0)
    , m_frameRateTimer(new QTimer(this))
    , m_framesInLastSecond(0)
    , m_lastFrameTime(0), m_ctrlSocket(nullptr)
    , m_trackingEnabled(false)
{
    setupThread();

    // Setup frame rate calculation timer
    m_frameRateTimer->setInterval(1000); // Update every second
    connect(m_frameRateTimer, &QTimer::timeout, this, &CameraViewModel::calculateFrameRate);
    m_frameRateTimer->start();
}

CameraViewModel::~CameraViewModel()
{
    if (m_streaming) {
        stopStream();
    }

    // Clean up thread
    m_cameraThread->quit();
    m_cameraThread->wait(3000);
}

void CameraViewModel::setupThread()
{
    // Create camera model and move to thread
    m_cameraModel = new CameraModel();
    m_cameraModel->moveToThread(m_cameraThread);

    // Connect signals for thread communication
    connect(this, &CameraViewModel::requestStartStream,
            m_cameraModel, &CameraModel::startStreaming);
    connect(this, &CameraViewModel::requestStopStream,
            m_cameraModel, &CameraModel::stopStreaming);

    // Connect camera model signals
    connect(m_cameraModel, &CameraModel::streamingStatusChanged,
            this, &CameraViewModel::onStreamingStatusChanged);
    connect(m_cameraModel, &CameraModel::frameReceived,
            this, &CameraViewModel::onFrameReceived);
    connect(m_cameraModel, &CameraModel::errorOccurred,
            this, &CameraViewModel::onCameraError);
    connect(m_cameraModel, &CameraModel::connectionEstablished,
            this, &CameraViewModel::onConnectionEstablished);

    // Cleanup when thread finishes
    connect(m_cameraThread, &QThread::finished, m_cameraModel, &QObject::deleteLater);

    // Start the thread
    m_cameraThread->start();
}

void CameraViewModel::setIpAddress(const QString &ipAddress)
{
    if (m_ipAddress != ipAddress) {
        m_ipAddress = ipAddress;
        emit ipAddressChanged();
    }
}

void CameraViewModel::setPort(int port)
{
    if (m_port != port) {
        m_port = port;
        emit portChanged();
    }
}

void CameraViewModel::toggleStream()
{
    if (m_streaming) {
        stopStream();
    } else {
        startStream();
    }
}
void CameraViewModel::startStream()
{
    if (!m_streaming) {
        m_cameraStatus = "Connecting...";
        emit cameraStatusChanged();
        qDebug() << "Starting camera stream to" << m_ipAddress << ":" << m_port;

        // Create control socket for tracking commands
        if (!m_ctrlSocket) {
            m_ctrlSocket = new QUdpSocket(this);
            qDebug() << "Created control socket for tracking commands";
        }

        emit requestStartStream(m_ipAddress, m_port);
    }
}

// Add to stopStream() method:
void CameraViewModel::stopStream()
{
    if (m_streaming) {
        qDebug() << "Stopping camera stream";

        // Disable tracking when stopping stream
        if (m_trackingEnabled) {
            disableTracking();
        }

        // Close control socket
        if (m_ctrlSocket) {
            m_ctrlSocket->close();
            m_ctrlSocket->deleteLater();
            m_ctrlSocket = nullptr;
            qDebug() << "Closed control socket";
        }

        emit requestStopStream();
    }
}
void CameraViewModel::enableTracking()
{
    if (!m_streaming || !m_ctrlSocket) {
        qDebug() << "Cannot enable tracking: not streaming or no control socket";
        return;
    }

    if (m_trackingEnabled) {
        qDebug() << "Tracking already enabled";
        return;
    }

    // Send TRACK_ENABLE command
    QByteArray command = "TRACK_ENABLE";
    QHostAddress targetAddress(m_ipAddress);
    int ctrlPort = m_port + 100;

    qint64 sent = m_ctrlSocket->writeDatagram(command, targetAddress, ctrlPort);
    if (sent == command.size()) {
        m_trackingEnabled = true;
        emit trackingEnabledChanged();
        qDebug() << "Tracking enabled - sent command to" << m_ipAddress << ":" << ctrlPort;
    } else {
        qDebug() << "Failed to send TRACK_ENABLE command";
    }
}

void CameraViewModel::disableTracking()
{
    if (!m_trackingEnabled || !m_ctrlSocket) {
        qDebug() << "Tracking not enabled or no control socket";
        return;
    }

    // Send TRACK_DISABLE command
    QByteArray command = "TRACK_DISABLE";
    QHostAddress targetAddress(m_ipAddress);
    int ctrlPort = m_port + 100;

    qint64 sent = m_ctrlSocket->writeDatagram(command, targetAddress, ctrlPort);
    if (sent == command.size()) {
        m_trackingEnabled = false;
        emit trackingEnabledChanged();
        qDebug() << "Tracking disabled - sent command to" << m_ipAddress << ":" << ctrlPort;
    } else {
        qDebug() << "Failed to send TRACK_DISABLE command";
    }
}

void CameraViewModel::sendTarget(int x, int y, int w, int h)
{
    if (!m_trackingEnabled || !m_ctrlSocket) {
        qDebug() << "Cannot send target: tracking not enabled or no control socket";
        return;
    }

    // Send SET_TARGET command
    QByteArray command = QString("SET_TARGET %1 %2 %3 %4").arg(x).arg(y).arg(w).arg(h).toUtf8();
    QHostAddress targetAddress(m_ipAddress);
    int ctrlPort = m_port + 100;

    qint64 sent = m_ctrlSocket->writeDatagram(command, targetAddress, ctrlPort);
    if (sent == command.size()) {
        qDebug() << "Sent target:" << x << y << w << h << "to" << m_ipAddress << ":" << ctrlPort;
    } else {
        qDebug() << "Failed to send SET_TARGET command";
    }
}
void CameraViewModel::onStreamingStatusChanged(bool streaming)
{
    if (m_streaming != streaming) {
        m_streaming = streaming;
        emit streamingChanged();

        qDebug() << "Streaming status changed to:" << streaming;

        if (!streaming) {
            m_cameraStatus = "Disconnected";
            m_frameCount = 0;
            m_frameRate = 0.0;
            m_currentFrameUrl = "";
            emit cameraStatusChanged();
            emit frameCountChanged();
            emit frameRateChanged();
            emit frameChanged();
        }
    }
}

void CameraViewModel::onFrameReceived(const QByteArray &frameData)
{
    m_frameCount++;
    m_framesInLastSecond++;
    m_lastFrameTime = QDateTime::currentMSecsSinceEpoch();

    qDebug() << "Frame received, count:" << m_frameCount << "size:" << frameData.size();

    updateFrameUrl(frameData);

    emit frameCountChanged();
    emit frameChanged();

    if (m_frameCount == 1) {
        m_cameraStatus = "Receiving frames...";
        emit cameraStatusChanged();
    }
}

void CameraViewModel::updateFrameUrl(const QByteArray &frameData)
{
    // Update the image provider with new frame data
    if (g_imageProvider) {
        QString frameId = "camera_frame";
        g_imageProvider->updateFrame(frameId, frameData);

        // Create a unique URL to force QML to reload the image
        // Use the frame count instead of timestamp for simpler ID matching
        m_currentFrameUrl = QString("image://camera/%1?f=%2").arg(frameId).arg(m_frameCount);

        qDebug() << "Updated frame URL:" << m_currentFrameUrl;
    } else {
        qDebug() << "ERROR: Image provider not available!";
    }
}

void CameraViewModel::onCameraError(const QString &error)
{
    m_cameraStatus = "Error: " + error;
    emit cameraStatusChanged();
    qDebug() << "Camera error:" << error;
}

void CameraViewModel::onConnectionEstablished()
{
    m_cameraStatus = "Connected - Waiting for frames...";
    emit cameraStatusChanged();
    qDebug() << "Camera connection established";
}

void CameraViewModel::calculateFrameRate()
{
    m_frameRate = m_framesInLastSecond;
    m_framesInLastSecond = 0;
    emit frameRateChanged();

    if (m_frameRate > 0) {
        qDebug() << "Current FPS:" << m_frameRate;
    }
}

// CameraImageProvider implementation
CameraImageProvider::CameraImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap)
{
    g_imageProvider = this;
    qDebug() << "CameraImageProvider created";
}

QPixmap CameraImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    QMutexLocker locker(&m_mutex);

    // Extract the base ID (remove query parameters)
    QString baseId = id;
    int queryIndex = id.indexOf('?');
    if (queryIndex != -1) {
        baseId = id.left(queryIndex);
    }

    qDebug() << "Image provider requested pixmap for ID:" << id << "-> Base ID:" << baseId;

    if (!m_frameData.contains(baseId)) {
        // Return a placeholder pixmap if no data available
        QPixmap placeholder(320, 240);
        placeholder.fill(Qt::gray);

        // Draw text on placeholder
        QPainter painter(&placeholder);
        painter.setPen(Qt::white);
        painter.setFont(QFont("Arial", 12, QFont::Bold));
        painter.drawText(placeholder.rect(), Qt::AlignCenter, "No Frame Data");

        if (size) *size = placeholder.size();
        qDebug() << "No frame data available for base ID:" << baseId << ", returning gray placeholder";
        return placeholder;
    }

    QByteArray frameData = m_frameData[baseId];
    QPixmap pixmap;

    qDebug() << "Loading frame data for base ID:" << baseId << ", size:" << frameData.size() << "bytes";

    if (pixmap.loadFromData(frameData, "JPEG")) {
        if (size) *size = pixmap.size();

        qDebug() << "Successfully loaded pixmap, size:" << pixmap.size();

        if (!requestedSize.isEmpty()) {
            QPixmap scaled = pixmap.scaled(requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);
            qDebug() << "Scaled pixmap to:" << scaled.size();
            return scaled;
        }
        return pixmap;
    } else {
        // Return error pixmap if failed to load
        QPixmap errorPixmap(320, 240);
        errorPixmap.fill(Qt::red);

        // Draw error text
        QPainter painter(&errorPixmap);
        painter.setPen(Qt::white);
        painter.setFont(QFont("Arial", 12, QFont::Bold));
        painter.drawText(errorPixmap.rect(), Qt::AlignCenter, "JPEG Load Error");

        if (size) *size = errorPixmap.size();
        qDebug() << "Failed to load JPEG data for base ID:" << baseId << ", returning red error pixmap";
        return errorPixmap;
    }
}

void CameraImageProvider::updateFrame(const QString &id, const QByteArray &frameData)
{
    QMutexLocker locker(&m_mutex);
    m_frameData[id] = frameData;
    qDebug() << "Image provider updated frame data for ID:" << id << "size:" << frameData.size();
}
