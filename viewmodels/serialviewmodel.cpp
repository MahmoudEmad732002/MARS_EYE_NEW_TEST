#include "serialviewmodel.h"
#include <QtMath>

// Constructor
SerialViewModel::SerialViewModel(QObject *parent)
    : QObject(parent)
    , m_serialModel(new SerialModel(this))
    , m_connected(false)
    , m_refreshTimer(new QTimer(this))
    , m_joystickPitch(100)
    , m_joystickYaw(100)
    , m_zoomLevel(0)
    , m_trackingX(0)
    , m_trackingY(0)
{
    connect(m_serialModel, &SerialModel::connectionStatusChanged,
            this, &SerialViewModel::onConnectionStatusChanged);
    connect(m_serialModel, &SerialModel::telemetryDataReceived,
            this, &SerialViewModel::onTelemetryDataReceived);
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
    m_pidGains.azimuthKd = 5;
    m_pidGains.elevationKp = 10;
    m_pidGains.elevationKi = 10;
    m_pidGains.elevationKd = 5;

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

// Serial slots (internal)
void SerialViewModel::onConnectionStatusChanged(bool connected)
{
    if (m_connected != connected) {
        m_connected = connected;
        emit connectedChanged();

        if (connected) {
            m_statusMessage = "Connected Successfully";
        } else {
            m_statusMessage = "Disconnected";
        }
        emit statusMessageChanged();
    }
}

void SerialViewModel::onTelemetryDataReceived(const SerialModel::TelemetryData &data)
{
    m_telemetryData = data;
    emit telemetryChanged();

    // Optionally: updateMapWithGPSData();
    m_statusMessage = "Receiving data...";
    emit statusMessageChanged();
}

void SerialViewModel::updateMapWithGPSData()
{
    // Convert GPS data and update map
    double lat = latitude();
    double lon = longitude();
    double alt = altitude();
    // Add your map update logic here if needed.
}

void SerialViewModel::onErrorOccurred(const QString &error)
{
    m_statusMessage = "Error: " + error;
    emit statusMessageChanged();
}

void SerialViewModel::onMessageSent(const QString &messageType)
{
    m_statusMessage = messageType + " sent successfully";
    emit statusMessageChanged();
}

// Joystick control logic
void SerialViewModel::setJoystickPitch(int pitch)
{

    if (m_joystickPitch != pitch) {
        m_joystickPitch = pitch;
        emit joystickChanged();
        sendCurrentJoystickValues();
    }
}

void SerialViewModel::setJoystickYaw(int yaw)
{

    if (m_joystickYaw != yaw) {
        m_joystickYaw = yaw;
        emit joystickChanged();
        sendCurrentJoystickValues();
    }
}

void SerialViewModel::sendJoystickUp()
{
    setJoystickPitch( m_joystickPitch + 10);
}
void SerialViewModel::sendJoystickDown()
{
    setJoystickPitch(m_joystickPitch - 10);
}
void SerialViewModel::sendJoystickLeft()
{
    setJoystickYaw(  m_joystickYaw - 10 );
}
void SerialViewModel::sendJoystickRight()
{
    setJoystickYaw(  m_joystickYaw + 10 );
}

void SerialViewModel::sendCurrentJoystickValues()
{
    if (m_connected) {
        m_serialModel->sendJoystickCommand(
            static_cast<quint8>(m_joystickPitch),
            static_cast<quint8>(m_joystickYaw)
            );
    }
}

// PID gains logic
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
void SerialViewModel::setAzimuthKd(int kd)
{
    if (m_pidGains.azimuthKd != kd) {
        m_pidGains.azimuthKd = kd;
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
void SerialViewModel::setElevationKd(int kd)
{
    if (m_pidGains.elevationKd != kd) {
        m_pidGains.elevationKd = kd;
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

// --- Zoom support
int SerialViewModel::zoomLevel() const { return m_zoomLevel; }
void SerialViewModel::setZoomLevel(int z)
{

    if (m_zoomLevel != z) {
        m_zoomLevel = z;
        emit zoomLevelChanged();
    }
}
void SerialViewModel::sendZoom()
{
    if (m_connected) {
        m_serialModel->sendZoomCommand(static_cast<quint8>(m_zoomLevel));
    } else {
        m_statusMessage = "Cannot send zoom: Not connected";
        emit statusMessageChanged();
    }
}

// --- Tracking coordinate support
int SerialViewModel::trackingX() const { return m_trackingX; }
void SerialViewModel::setTrackingX(int x)
{

    if (m_trackingX != x) {
        m_trackingX = x;
        emit trackingChanged();
    }
}
int SerialViewModel::trackingY() const { return m_trackingY; }
void SerialViewModel::setTrackingY(int y)
{

    if (m_trackingY != y) {
        m_trackingY = y;
        emit trackingChanged();
    }
}
void SerialViewModel::sendTrackingCoordinates()
{
    if (m_connected) {
        m_serialModel->sendTrackingCoordinates(
            static_cast<quint16>(m_trackingX),
            static_cast<quint16>(m_trackingY)
            );
    } else {
        m_statusMessage = "Cannot send tracking: Not connected";
        emit statusMessageChanged();
    }
}
