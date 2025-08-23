#include "serialviewmodel.h"
#include <QtMath>

SerialViewModel::SerialViewModel(QObject *parent)
    : QObject(parent)
    , m_serialThread(new QThread(this))
    , m_serialWorker(new SerialWorker())
    , m_connected(false)
    , m_refreshTimer(new QTimer(this))
    , m_joystickX(100)
    , m_joystickY(100)
    , m_joystickResetFlag(0)
    , m_joystickActive(false)
    , m_zoomLevel(0)
    , m_zoomResetFlag(0)
    , m_targetX(0)
    , m_targetY(0)
    , m_frameNumber(0)
    , m_stabilizationFlag(1)
    , m_absolutePointingActive(false)
    , m_pitchAngle(0.0)
    , m_yawAngle(0.0)
{
    // Move worker to thread
    m_serialWorker->moveToThread(m_serialThread);

    // Connect thread lifecycle
    connect(m_serialThread, &QThread::started, m_serialWorker, &SerialWorker::initializeSerial);
    connect(m_serialThread, &QThread::finished, m_serialWorker, &QObject::deleteLater);

    // Connect all signals from SerialWorker with queued connections for thread safety
    connect(m_serialWorker, &SerialWorker::connectionStatusChanged,
            this, &SerialViewModel::onConnectionStatusChanged, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::telemetryDataReceived,
            this, &SerialViewModel::onTelemetryDataReceived, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::targetGPSReceived,
            this, &SerialViewModel::onTargetGPSReceived, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::trackedPoseReceived,
            this, &SerialViewModel::onTrackedPoseReceived, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::zoomFeedbackReceived,
            this, &SerialViewModel::onZoomFeedbackReceived, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::frameInfoReceived,
            this, &SerialViewModel::onFrameInfoReceived, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::acknowledgmentReceived,
            this, &SerialViewModel::onAcknowledgmentReceived, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::errorOccurred,
            this, &SerialViewModel::onErrorOccurred, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::messageSent,
            this, &SerialViewModel::onMessageSent, Qt::QueuedConnection);
    connect(m_serialWorker, &SerialWorker::availablePortsReady,
            this, &SerialViewModel::onAvailablePortsReady, Qt::QueuedConnection);

    // Start the worker thread
    m_serialThread->start();

    // Auto-refresh ports every 2 seconds
    m_refreshTimer->setInterval(2000);
    connect(m_refreshTimer, &QTimer::timeout, this, &SerialViewModel::refreshPorts);
    m_refreshTimer->start();

    // Initialize PID gains with default values
    m_pidGains.azimuthKp = 10;
    m_pidGains.azimuthKi = 10;
    m_pidGains.elevationKp = 10;
    m_pidGains.elevationKi = 10;

    refreshPorts();
}

SerialViewModel::~SerialViewModel()
{
    // Clean thread shutdown
    if (m_serialThread->isRunning()) {
        m_serialThread->quit();
        if (!m_serialThread->wait(3000)) {
            m_serialThread->terminate();
            m_serialThread->wait();
        }
    }
}

// Serial connection controls
void SerialViewModel::connectToSerial(const QString &portName, int baudRate)
{
    if (m_connected) {
        QMetaObject::invokeMethod(m_serialWorker, "disconnectFromPort", Qt::QueuedConnection);
    } else {
        QMetaObject::invokeMethod(m_serialWorker, "connectToPort", Qt::QueuedConnection,
                                  Q_ARG(QString, portName), Q_ARG(int, baudRate));
        m_statusMessage = "Connecting to " + portName + "...";
        emit statusMessageChanged();
    }
}

void SerialViewModel::refreshPorts()
{
    QMetaObject::invokeMethod(m_serialWorker, "getAvailablePorts", Qt::QueuedConnection);
}

// Signal handlers for received data
void SerialViewModel::onConnectionStatusChanged(bool connected)
{
    if (m_connected != connected) {
        m_connected = connected;
        emit connectedChanged();

        if (connected) {
            m_statusMessage = "Connected Successfully";
        } else {
            m_statusMessage = "Disconnected";
            // Reset active states when disconnected
            m_joystickActive = false;
            m_absolutePointingActive = false;
            emit joystickActiveChanged();
            emit absolutePointingActiveChanged();
        }
        emit statusMessageChanged();
    }
}

void SerialViewModel::onTelemetryDataReceived(const SerialWorker::TelemetryData &data)
{
    m_telemetryData = data;
    emit telemetryChanged();
    m_statusMessage = "Receiving telemetry data...";
    emit statusMessageChanged();
}

void SerialViewModel::onTargetGPSReceived(const SerialWorker::TargetGPSData &data)
{
    m_targetGPSData = data;
    emit targetGPSChanged();
    m_statusMessage = "Received target GPS data";
    emit statusMessageChanged();
}

void SerialViewModel::onTrackedPoseReceived(const SerialWorker::TrackedPoseData &data)
{
    m_trackedPoseData = data;
    emit trackedPoseChanged();
    m_statusMessage = "Received tracked pose data";
    emit statusMessageChanged();
}

void SerialViewModel::onZoomFeedbackReceived(const SerialWorker::ZoomFeedbackData &data)
{
    m_zoomFeedbackData = data;
    emit zoomFeedbackChanged();
    m_statusMessage = "Received zoom feedback: " + QString::number(data.zoomFeedback);
    emit statusMessageChanged();
}

void SerialViewModel::onFrameInfoReceived(const SerialWorker::FrameInfoData &data)
{
    m_frameInfoData = data;
    emit frameInfoChanged();

    // Sync editable PID gains with received values
    bool changed = false;
    if (m_pidGains.azimuthKp != data.azimuthKp) { m_pidGains.azimuthKp = data.azimuthKp; changed = true; }
    if (m_pidGains.azimuthKi != data.azimuthKi) { m_pidGains.azimuthKi = data.azimuthKi; changed = true; }
    if (m_pidGains.elevationKp != data.elevationKp) { m_pidGains.elevationKp = data.elevationKp; changed = true; }
    if (m_pidGains.elevationKi != data.elevationKi) { m_pidGains.elevationKi = data.elevationKi; changed = true; }
    if (changed) emit pidGainsChanged();

    m_statusMessage = QString("Received frame info: %1x%2").arg(data.frameWidth).arg(data.frameHeight);
    emit statusMessageChanged();
}

void SerialViewModel::onAcknowledgmentReceived(const SerialWorker::AckData &data)
{
    m_lastAckData = data;
    emit acknowledgmentChanged();

    // Update active states based on acknowledged message
    switch (data.acknowledgedMessageId) {
    case 2: // PID Gains
        m_statusMessage = "PID Gains acknowledged and applied";
        break;
    case 4: // Zoom Command
        m_statusMessage = "Zoom command acknowledged";
        break;
    case 6: // Absolute Pointing
        m_absolutePointingActive = false;
        emit absolutePointingActiveChanged();
        m_statusMessage = "Absolute pointing command acknowledged";
        break;
    case 9: // Request Gains
        m_statusMessage = "Gains request acknowledged";
        break;
    default:
        m_statusMessage = "Acknowledged message ID: " + QString::number(data.acknowledgedMessageId);
        break;
    }
    emit statusMessageChanged();
}

void SerialViewModel::onErrorOccurred(const QString &error)
{
    m_statusMessage = "Error: " + error;
    emit statusMessageChanged();
}

void SerialViewModel::onMessageSent(const QString &messageType)
{
    m_statusMessage = messageType;
    emit statusMessageChanged();
}

void SerialViewModel::onAvailablePortsReady(const QStringList &ports)
{
    if (ports != m_availablePorts) {
        m_availablePorts = ports;
        emit availablePortsChanged();
    }
}

// Joystick control setters and methods
void SerialViewModel::setJoystickX(int x)
{
    if (m_joystickX != x) {
        m_joystickX = x;
        emit joystickChanged();
    }
}

void SerialViewModel::setJoystickY(int y)
{
    if (m_joystickY != y) {
        m_joystickY = y;
        emit joystickChanged();
    }
}

void SerialViewModel::setJoystickResetFlag(int flag)
{
    if (m_joystickResetFlag != flag) {
        m_joystickResetFlag = flag;
        emit joystickChanged();
    }
}

void SerialViewModel::startJoystickCommand()
{
    if (m_connected && !m_joystickActive) {
        QMetaObject::invokeMethod(m_serialWorker, "sendJoystickCommand", Qt::QueuedConnection,
                                  Q_ARG(quint8, static_cast<quint8>(m_joystickX)),
                                  Q_ARG(quint8, static_cast<quint8>(m_joystickY)),
                                  Q_ARG(quint8, static_cast<quint8>(m_joystickResetFlag)));
        m_joystickActive = true;
        emit joystickActiveChanged();
    }
}

void SerialViewModel::stopJoystickCommand()
{
    if (m_joystickActive) {
        QMetaObject::invokeMethod(m_serialWorker, "stopJoystickCommand", Qt::QueuedConnection);
        m_joystickActive = false;
        emit joystickActiveChanged();
    }
}

void SerialViewModel::sendSoftwareJoystickCommand(int x, int y)
{
    if (m_connected) {
        setJoystickX(x);
        setJoystickY(y);

        QMetaObject::invokeMethod(m_serialWorker, "sendJoystickCommand", Qt::QueuedConnection,
                                  Q_ARG(quint8, static_cast<quint8>(x)),
                                  Q_ARG(quint8, static_cast<quint8>(y)),
                                  Q_ARG(quint8, static_cast<quint8>(m_joystickResetFlag)));

        if (!m_joystickActive) {
            m_joystickActive = true;
            emit joystickActiveChanged();
        }
    }
}

void SerialViewModel::setPitchAngle(double angle)
{
    angle = qMax(-90.0, qMin(10.0, angle));
    if (qAbs(m_pitchAngle - angle) > 0.001) {
        m_pitchAngle = angle;
        emit absolutePointingChanged();
    }
}

void SerialViewModel::setYawAngle(double angle)
{
    angle = qMax(-180.0, qMin(180.0, angle));
    if (qAbs(m_yawAngle - angle) > 0.001) {
        m_yawAngle = angle;
        emit absolutePointingChanged();
    }
}

void SerialViewModel::sendPitchYaw()
{
    if (m_connected) {
        quint16 pitchCmd = static_cast<quint16>((m_pitchAngle + 180) * 100);
        quint16 yawCmd = static_cast<quint16>((m_yawAngle + 180) * 100);

        QMetaObject::invokeMethod(m_serialWorker, "sendAbsolutePointing", Qt::QueuedConnection,
                                  Q_ARG(quint16, pitchCmd),
                                  Q_ARG(quint16, yawCmd),
                                  Q_ARG(quint8, static_cast<quint8>(m_stabilizationFlag)));

        if (!m_absolutePointingActive) {
            m_absolutePointingActive = true;
            emit absolutePointingActiveChanged();
        }
    } else {
        m_statusMessage = "Cannot send pitch/yaw: Not connected";
        emit statusMessageChanged();
    }
}

void SerialViewModel::sendJoystickUp()
{
    double newPitch = qMin(10.0, m_pitchAngle + 1.0);
    setPitchAngle(newPitch);
}

void SerialViewModel::sendJoystickDown()
{
    double newPitch = qMax(-90.0, m_pitchAngle - 1.0);
    setPitchAngle(newPitch);
}

void SerialViewModel::sendJoystickLeft()
{
    double newYaw = qMax(-180.0, m_yawAngle - 1.0);
    setYawAngle(newYaw);
}

void SerialViewModel::sendJoystickRight()
{
    double newYaw = qMin(180.0, m_yawAngle + 1.0);
    setYawAngle(newYaw);
}

// PID gains control
void SerialViewModel::setAzimuthKp(int kp)
{
    if (m_pidGains.azimuthKp != kp) {
        m_pidGains.azimuthKp = kp;
        emit pidGainsChanged();
    }
}

void SerialViewModel::setAzimuthKi(int ki)
{
    if (m_pidGains.azimuthKi != ki) {
        m_pidGains.azimuthKi = ki;
        emit pidGainsChanged();
    }
}

void SerialViewModel::setElevationKp(int kp)
{
    if (m_pidGains.elevationKp != kp) {
        m_pidGains.elevationKp = kp;
        emit pidGainsChanged();
    }
}

void SerialViewModel::setElevationKi(int ki)
{
    if (m_pidGains.elevationKi != ki) {
        m_pidGains.elevationKi = ki;
        emit pidGainsChanged();
    }
}

void SerialViewModel::sendPIDGains()
{
    if (m_connected) {
        QMetaObject::invokeMethod(m_serialWorker, "sendPIDGains", Qt::QueuedConnection,
                                  Q_ARG(SerialWorker::PIDGains, m_pidGains));
    } else {
        m_statusMessage = "Cannot send PID gains: Not connected";
        emit statusMessageChanged();
    }
}

// Zoom control
void SerialViewModel::setZoomLevel(int level)
{
    if (m_zoomLevel != level) {
        m_zoomLevel = level;
        emit zoomLevelChanged();
    }
}

void SerialViewModel::setZoomResetFlag(int flag)
{
    if (m_zoomResetFlag != flag) {
        m_zoomResetFlag = flag;
        emit zoomLevelChanged();
    }
}

void SerialViewModel::sendZoomCommand()
{
    if (m_connected) {
        QMetaObject::invokeMethod(m_serialWorker, "sendZoomCommand", Qt::QueuedConnection,
                                  Q_ARG(quint8, static_cast<quint8>(m_zoomLevel)),
                                  Q_ARG(quint8, static_cast<quint8>(m_zoomResetFlag)));
    } else {
        m_statusMessage = "Cannot send zoom command: Not connected";
        emit statusMessageChanged();
    }
}

// Target selection control
void SerialViewModel::setTargetX(int x)
{
    if (m_targetX != x) {
        m_targetX = x;
        emit targetChanged();
    }
}

void SerialViewModel::setTargetY(int y)
{
    if (m_targetY != y) {
        m_targetY = y;
        emit targetChanged();
    }
}

void SerialViewModel::setFrameNumber(int frameNum)
{
    if (m_frameNumber != frameNum) {
        m_frameNumber = frameNum;
        emit targetChanged();
    }
}

void SerialViewModel::sendSelectTarget()
{
    if (m_connected) {
        QMetaObject::invokeMethod(m_serialWorker, "sendSelectTarget", Qt::QueuedConnection,
                                  Q_ARG(quint16, static_cast<quint16>(m_targetX)),
                                  Q_ARG(quint16, static_cast<quint16>(m_targetY)),
                                  Q_ARG(quint16, static_cast<quint16>(m_frameNumber)),
                                  Q_ARG(quint8, 0));
    } else {
        m_statusMessage = "Cannot send select target: Not connected";
        emit statusMessageChanged();
    }
}

void SerialViewModel::sendSelectTarget(int x, int y, int frameNum)
{
    if (m_connected) {
        setTargetX(x);
        setTargetY(y);
        setFrameNumber(frameNum);
        sendSelectTarget();
    } else {
        m_statusMessage = "Cannot send select target: Not connected";
        emit statusMessageChanged();
    }
}

void SerialViewModel::updateSoftwareJoystick(int x, int y)
{
    if (m_connected && m_joystickActive) {
        setJoystickX(x);
        setJoystickY(y);

        QMetaObject::invokeMethod(m_serialWorker, "sendJoystickCommand", Qt::QueuedConnection,
                                  Q_ARG(quint8, static_cast<quint8>(x)),
                                  Q_ARG(quint8, static_cast<quint8>(y)),
                                  Q_ARG(quint8, static_cast<quint8>(m_joystickResetFlag)));
    }
}

void SerialViewModel::setStabilizationFlag(int flag)
{
    if (m_stabilizationFlag != flag) {
        m_stabilizationFlag = flag;
        emit absolutePointingChanged();
    }
}

void SerialViewModel::startAbsolutePointing()
{
    if (m_connected) {
        quint16 pitchCmd = static_cast<quint16>((m_pitchAngle + 180) * 100);
        quint16 yawCmd = static_cast<quint16>((m_yawAngle + 180) * 100);

        QMetaObject::invokeMethod(m_serialWorker, "sendAbsolutePointing", Qt::QueuedConnection,
                                  Q_ARG(quint16, pitchCmd),
                                  Q_ARG(quint16, yawCmd),
                                  Q_ARG(quint8, static_cast<quint8>(m_stabilizationFlag)));

        if (!m_absolutePointingActive) {
            m_absolutePointingActive = true;
            emit absolutePointingActiveChanged();
        }
    } else {
        m_statusMessage = "Cannot send absolute pointing: Not connected";
        emit statusMessageChanged();
    }
}

void SerialViewModel::stopAbsolutePointing()
{
    if (m_absolutePointingActive) {
        QMetaObject::invokeMethod(m_serialWorker, "stopAbsolutePointing", Qt::QueuedConnection);
        m_absolutePointingActive = false;
        emit absolutePointingActiveChanged();
    }
}

void SerialViewModel::sendRequestGains()
{
    if (m_connected) {
        QMetaObject::invokeMethod(m_serialWorker, "sendRequestGains", Qt::QueuedConnection);
    } else {
        m_statusMessage = "Cannot send request gains: Not connected";
        emit statusMessageChanged();
    }
}

void SerialViewModel::sendFrameInfoAndGains(int frameW, int frameH)
{
    if (m_connected) {
        QMetaObject::invokeMethod(m_serialWorker, "sendFrameInfoAndGains", Qt::QueuedConnection,
                                  Q_ARG(quint16, static_cast<quint16>(frameW)),
                                  Q_ARG(quint16, static_cast<quint16>(frameH)),
                                  Q_ARG(SerialWorker::PIDGains, m_pidGains));
    } else {
        m_statusMessage = "Cannot send frame info and gains: Not connected";
        emit statusMessageChanged();
    }
}
