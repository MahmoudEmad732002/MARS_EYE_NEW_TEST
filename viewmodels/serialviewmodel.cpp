#include "serialviewmodel.h"
#include <QtMath>

SerialViewModel::SerialViewModel(QObject *parent)
    : QObject(parent)
    , m_serialModel(new SerialModel(this))
    , m_connected(false)
    , m_refreshTimer(new QTimer(this))
    , m_joystickX(127)
    , m_joystickY(127)
    , m_joystickResetFlag(0)
    , m_joystickActive(false)
    , m_zoomLevel(0)
    , m_zoomResetFlag(0)
    , m_targetX(0)
    , m_targetY(0)
    , m_frameNumber(0)
    , m_pitchAngleCmd(32767)
    , m_yawAngleCmd(32767)
    , m_stabilizationFlag(1)
    , m_absolutePointingActive(false)
{
    // Connect all signals from SerialModel
    connect(m_serialModel, &SerialModel::connectionStatusChanged,
            this, &SerialViewModel::onConnectionStatusChanged);
    connect(m_serialModel, &SerialModel::telemetryDataReceived,
            this, &SerialViewModel::onTelemetryDataReceived);
    connect(m_serialModel, &SerialModel::targetGPSReceived,
            this, &SerialViewModel::onTargetGPSReceived);
    connect(m_serialModel, &SerialModel::trackedPoseReceived,
            this, &SerialViewModel::onTrackedPoseReceived);
    connect(m_serialModel, &SerialModel::zoomFeedbackReceived,
            this, &SerialViewModel::onZoomFeedbackReceived);
    connect(m_serialModel, &SerialModel::frameInfoReceived,
            this, &SerialViewModel::onFrameInfoReceived);
    connect(m_serialModel, &SerialModel::acknowledgmentReceived,
            this, &SerialViewModel::onAcknowledgmentReceived);
    connect(m_serialModel, &SerialModel::errorOccurred,
            this, &SerialViewModel::onErrorOccurred);
    connect(m_serialModel, &SerialModel::messageSent,
            this, &SerialViewModel::onMessageSent);

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

// Serial connection controls
void SerialViewModel::connectToSerial(const QString &portName, int baudRate)
{
    if (m_connected) {
        m_serialModel->disconnect();
    } else {
        if (m_serialModel->connectToPort(portName, baudRate)) {
            m_statusMessage = "Connected to " + portName;
        } else {
            m_statusMessage = "Failed to connect to " + portName;
        }
        emit statusMessageChanged();
    }
}

void SerialViewModel::refreshPorts()
{
    QStringList newPorts = m_serialModel->getAvailablePorts();
    if (newPorts != m_availablePorts) {
        m_availablePorts = newPorts;
        emit availablePortsChanged();
    }
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

void SerialViewModel::onTelemetryDataReceived(const SerialModel::TelemetryData &data)
{
    m_telemetryData = data;
    emit telemetryChanged();
    m_statusMessage = "Receiving telemetry data...";
    emit statusMessageChanged();
}

void SerialViewModel::onTargetGPSReceived(const SerialModel::TargetGPSData &data)
{
    m_targetGPSData = data;
    emit targetGPSChanged();
    m_statusMessage = "Received target GPS data";
    emit statusMessageChanged();
}

void SerialViewModel::onTrackedPoseReceived(const SerialModel::TrackedPoseData &data)
{
    m_trackedPoseData = data;
    emit trackedPoseChanged();
    m_statusMessage = "Received tracked pose data";
    emit statusMessageChanged();
}

void SerialViewModel::onZoomFeedbackReceived(const SerialModel::ZoomFeedbackData &data)
{
    m_zoomFeedbackData = data;
    emit zoomFeedbackChanged();
    m_statusMessage = "Received zoom feedback: " + QString::number(data.zoomFeedback);
    emit statusMessageChanged();
}

void SerialViewModel::onFrameInfoReceived(const SerialModel::FrameInfoData &data)
{
    m_frameInfoData = data;
    emit frameInfoChanged();
    m_statusMessage = QString("Received frame info: %1x%2")
                          .arg(data.frameWidth)
                          .arg(data.frameHeight);
    emit statusMessageChanged();
}

void SerialViewModel::onAcknowledgmentReceived(const SerialModel::AckData &data)
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
        m_serialModel->sendJoystickCommand(
            static_cast<quint8>(m_joystickX),
            static_cast<quint8>(m_joystickY),
            static_cast<quint8>(m_joystickResetFlag)
            );
        m_joystickActive = true;
        emit joystickActiveChanged();
    }
}

void SerialViewModel::stopJoystickCommand()
{
    if (m_joystickActive) {
        m_serialModel->stopJoystickCommand();
        m_joystickActive = false;
        emit joystickActiveChanged();
    }
}

void SerialViewModel::sendSoftwareJoystickCommand(int x, int y)
{
    if (m_connected) {
        setJoystickX(x);
        setJoystickY(y);
        m_serialModel->sendJoystickCommand(
            static_cast<quint8>(x),
            static_cast<quint8>(y),
            static_cast<quint8>(m_joystickResetFlag)
            );
        // Update ViewModel joystick state to match SerialModel state
        if (!m_joystickActive) {
            m_joystickActive = true;
            emit joystickActiveChanged();
        }
    }
}

void SerialViewModel::sendJoystickUp()
{
    // Decrease pitch angle (up movement)
    int newPitch = qMax(0, m_pitchAngleCmd + 100);
    setPitchAngleCmd(newPitch);
    startAbsolutePointing();
}

void SerialViewModel::sendJoystickDown()
{
    // Increase pitch angle (down movement)
    int newPitch = qMin(65535, m_pitchAngleCmd - 100);
    setPitchAngleCmd(newPitch);
    startAbsolutePointing();
}

void SerialViewModel::sendJoystickLeft()
{
    // Decrease yaw angle (left movement)
    int newYaw = qMax(0, m_yawAngleCmd - 100);
    setYawAngleCmd(newYaw);
    startAbsolutePointing();
}

void SerialViewModel::sendJoystickRight()
{
    // Increase yaw angle (right movement)
    int newYaw = qMin(65535, m_yawAngleCmd + 100);
    setYawAngleCmd(newYaw);
    startAbsolutePointing();
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
        m_serialModel->sendPIDGains(m_pidGains);
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
        m_serialModel->sendZoomCommand(
            static_cast<quint8>(m_zoomLevel),
            static_cast<quint8>(m_zoomResetFlag)
            );
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
        m_serialModel->sendSelectTarget(
            static_cast<quint16>(m_targetX),
            static_cast<quint16>(m_targetY),
            static_cast<quint16>(m_frameNumber)
            );
    } else {
        m_statusMessage = "Cannot send select target: Not connected";
        emit statusMessageChanged();
    }
}

// Absolute pointing control
void SerialViewModel::setPitchAngleCmd(int angle)
{
    if (m_pitchAngleCmd != angle) {
        m_pitchAngleCmd = angle;
        emit absolutePointingChanged();
    }
}

void SerialViewModel::setYawAngleCmd(int angle)
{
    if (m_yawAngleCmd != angle) {
        m_yawAngleCmd = angle;
        emit absolutePointingChanged();
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
        m_serialModel->sendAbsolutePointing(
            static_cast<quint16>(m_pitchAngleCmd),
            static_cast<quint16>(m_yawAngleCmd),
            static_cast<quint8>(m_stabilizationFlag)
            );
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
        m_serialModel->stopAbsolutePointing();
        m_absolutePointingActive = false;
        emit absolutePointingActiveChanged();
    }
}

// Request gains
void SerialViewModel::sendRequestGains()
{
    if (m_connected) {
        m_serialModel->sendRequestGains();
    } else {
        m_statusMessage = "Cannot send request gains: Not connected";
        emit statusMessageChanged();
    }
}

// Send frame info and gains
void SerialViewModel::sendFrameInfoAndGains(int frameW, int frameH)
{
    if (m_connected) {
        m_serialModel->sendFrameInfoAndGains(
            static_cast<quint16>(frameW),
            static_cast<quint16>(frameH),
            m_pidGains
            );
    } else {
        m_statusMessage = "Cannot send frame info and gains: Not connected";
        emit statusMessageChanged();
    }
}
