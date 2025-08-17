#include "thermalcameraviewmodel.h"
#include <QTimer>
#include <QDateTime>
#include <QQmlEngine>
#include <QDebug>
#include <QMutex>
#include <QPainter>

// Global thermal image provider instance
static ThermalImageProvider* g_thermalImageProvider = nullptr;

ThermalCameraViewModel::ThermalCameraViewModel(QObject *parent)
    : QObject(parent)
    , m_thermalCameraThread(new QThread(this))
    , m_thermalCameraModel(nullptr)
    , m_thermalIpAddress("127.0.0.1")
    , m_thermalPort(5001)
    , m_thermalStreaming(false)
    , m_thermalCameraStatus("Disconnected")
    , m_thermalFrameCount(0)
    , m_thermalFrameRate(0.0)
    , m_thermalFrameRateTimer(new QTimer(this))
    , m_thermalFramesInLastSecond(0)
    , m_lastThermalFrameTime(0)
{
    setupThermalThread();

    // Setup frame rate calculation timer
    m_thermalFrameRateTimer->setInterval(1000); // Update every second
    connect(m_thermalFrameRateTimer, &QTimer::timeout, this, &ThermalCameraViewModel::calculateThermalFrameRate);
    m_thermalFrameRateTimer->start();
}

ThermalCameraViewModel::~ThermalCameraViewModel()
{
    if (m_thermalStreaming) {
        stopThermalStream();
    }

    // Clean up thread
    m_thermalCameraThread->quit();
    m_thermalCameraThread->wait(3000);
}

void ThermalCameraViewModel::setupThermalThread()
{
    // Create thermal camera model and move to thread
    m_thermalCameraModel = new ThermalCameraModel();
    m_thermalCameraModel->moveToThread(m_thermalCameraThread);

    // Connect signals for thread communication
    connect(this, &ThermalCameraViewModel::requestStartThermalStream,
            m_thermalCameraModel, &ThermalCameraModel::startStreaming);
    connect(this, &ThermalCameraViewModel::requestStopThermalStream,
            m_thermalCameraModel, &ThermalCameraModel::stopStreaming);

    // Connect thermal camera model signals
    connect(m_thermalCameraModel, &ThermalCameraModel::streamingStatusChanged,
            this, &ThermalCameraViewModel::onThermalStreamingStatusChanged);
    connect(m_thermalCameraModel, &ThermalCameraModel::frameReceived,
            this, &ThermalCameraViewModel::onThermalFrameReceived);
    connect(m_thermalCameraModel, &ThermalCameraModel::errorOccurred,
            this, &ThermalCameraViewModel::onThermalCameraError);
    connect(m_thermalCameraModel, &ThermalCameraModel::connectionEstablished,
            this, &ThermalCameraViewModel::onThermalConnectionEstablished);

    // Cleanup when thread finishes
    connect(m_thermalCameraThread, &QThread::finished, m_thermalCameraModel, &QObject::deleteLater);

    // Start the thread
    m_thermalCameraThread->start();
}

void ThermalCameraViewModel::setThermalIpAddress(const QString &ipAddress)
{
    if (m_thermalIpAddress != ipAddress) {
        m_thermalIpAddress = ipAddress;
        emit thermalIpAddressChanged();
    }
}

void ThermalCameraViewModel::setThermalPort(int port)
{
    if (m_thermalPort != port) {
        m_thermalPort = port;
        emit thermalPortChanged();
    }
}

void ThermalCameraViewModel::toggleThermalStream()
{
    if (m_thermalStreaming)
    {
        stopThermalStream();
    } else {
        startThermalStream();
    }
}

void ThermalCameraViewModel::startThermalStream()
{
    if (!m_thermalStreaming) {
        m_thermalCameraStatus = "Connecting...";
        emit thermalCameraStatusChanged();
        qDebug() << "Starting thermal camera stream to" << m_thermalIpAddress << ":" << m_thermalPort;
        emit requestStartThermalStream(m_thermalIpAddress, m_thermalPort);
    }
}

void ThermalCameraViewModel::stopThermalStream()
{
    if (m_thermalStreaming) {
        qDebug() << "Stopping thermal camera stream";
        emit requestStopThermalStream();
    }
}

void ThermalCameraViewModel::onThermalStreamingStatusChanged(bool streaming)
{
    if (m_thermalStreaming != streaming) {
        m_thermalStreaming = streaming;
        emit thermalStreamingChanged();

        qDebug() << "Thermal streaming status changed to:" << streaming;

        if (!streaming) {
            m_thermalCameraStatus = "Disconnected";
            m_thermalFrameCount = 0;
            m_thermalFrameRate = 0.0;
            m_currentThermalFrameUrl = "";
            emit thermalCameraStatusChanged();
            emit thermalFrameCountChanged();
            emit thermalFrameRateChanged();
            emit thermalFrameChanged();
        }
    }
}

void ThermalCameraViewModel::onThermalFrameReceived(const QByteArray &frameData)
{
    m_thermalFrameCount++;
    m_thermalFramesInLastSecond++;
    m_lastThermalFrameTime = QDateTime::currentMSecsSinceEpoch();

    qDebug() << "Thermal frame received, count:" << m_thermalFrameCount << "size:" << frameData.size();

    updateThermalFrameUrl(frameData);

    emit thermalFrameCountChanged();
    emit thermalFrameChanged();

    if (m_thermalFrameCount == 1)
    {
        m_thermalCameraStatus = "Receiving thermal frames...";
        emit thermalCameraStatusChanged();
    }
}

void ThermalCameraViewModel::updateThermalFrameUrl(const QByteArray &frameData)
{
    // Update the thermal image provider with new frame data
    if (g_thermalImageProvider) {
        QString frameId = "thermal_frame";
        g_thermalImageProvider->updateFrame(frameId, frameData);

        // Create a unique URL to force QML to reload the image
        m_currentThermalFrameUrl = QString("image://thermal/%1?f=%2").arg(frameId).arg(m_thermalFrameCount);

        qDebug() << "Updated thermal frame URL:" << m_currentThermalFrameUrl;
    } else {
        qDebug() << "ERROR: Thermal image provider not available!";
    }
}

void ThermalCameraViewModel::onThermalCameraError(const QString &error)
{
    m_thermalCameraStatus = "Error: " + error;
    emit thermalCameraStatusChanged();
    qDebug() << "Thermal camera error:" << error;
}

void ThermalCameraViewModel::onThermalConnectionEstablished()
{
    m_thermalCameraStatus = "Connected - Waiting for thermal frames...";
    emit thermalCameraStatusChanged();
    qDebug() << "Thermal camera connection established";
}

void ThermalCameraViewModel::calculateThermalFrameRate()
{
    m_thermalFrameRate = m_thermalFramesInLastSecond;
    m_thermalFramesInLastSecond = 0;
    emit thermalFrameRateChanged();

    if (m_thermalFrameRate > 0) {
        qDebug() << "Current Thermal FPS:" << m_thermalFrameRate;
    }
}

// ThermalImageProvider implementation
ThermalImageProvider::ThermalImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap)
{
    g_thermalImageProvider = this;
    qDebug() << "ThermalImageProvider created";
}

QPixmap ThermalImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    QMutexLocker locker(&m_mutex);

    // Extract the base ID (remove query parameters)
    QString baseId = id;
    int queryIndex = id.indexOf('?');
    if (queryIndex != -1) {
        baseId = id.left(queryIndex);
    }

    qDebug() << "Thermal image provider requested pixmap for ID:" << id << "-> Base ID:" << baseId;

    if (!m_frameData.contains(baseId)) {
        // Return a placeholder pixmap if no data available
        QPixmap placeholder(320, 240);
        placeholder.fill(Qt::darkBlue);

        // Draw text on placeholder
        QPainter painter(&placeholder);
        painter.setPen(Qt::white);
        painter.setFont(QFont("Arial", 12, QFont::Bold));
        painter.drawText(placeholder.rect(), Qt::AlignCenter, "No Thermal Data");

        if (size) *size = placeholder.size();
        qDebug() << "No thermal frame data available for base ID:" << baseId << ", returning placeholder";
        return placeholder;
    }

    QByteArray frameData = m_frameData[baseId];
    QPixmap pixmap;

    qDebug() << "Loading thermal frame data for base ID:" << baseId << ", size:" << frameData.size() << "bytes";

    if (pixmap.loadFromData(frameData, "JPEG")) {
        if (size) *size = pixmap.size();

        qDebug() << "Successfully loaded thermal pixmap, size:" << pixmap.size();

        if (!requestedSize.isEmpty()) {
            QPixmap scaled = pixmap.scaled(requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);
            qDebug() << "Scaled thermal pixmap to:" << scaled.size();
            return scaled;
        }
        return pixmap;
    } else {
        // Return error pixmap if failed to load
        QPixmap errorPixmap(320, 240);
        errorPixmap.fill(Qt::darkRed);

        // Draw error text
        QPainter painter(&errorPixmap);
        painter.setPen(Qt::white);
        painter.setFont(QFont("Arial", 12, QFont::Bold));
        painter.drawText(errorPixmap.rect(), Qt::AlignCenter, "Thermal Load Error");

        if (size) *size = errorPixmap.size();
        qDebug() << "Failed to load thermal JPEG data for base ID:" << baseId << ", returning error pixmap";
        return errorPixmap;
    }
}

void ThermalImageProvider::updateFrame(const QString &id, const QByteArray &frameData)
{
    QMutexLocker locker(&m_mutex);
    m_frameData[id] = frameData;
    qDebug() << "Thermal image provider updated frame data for ID:" << id << "size:" << frameData.size();
}
