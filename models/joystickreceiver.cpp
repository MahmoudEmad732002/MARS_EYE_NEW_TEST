#include "joystickreceiver.h"
#include <QDebug>
#include <QDateTime>
#include <QNetworkDatagram>

JoystickReceiver::JoystickReceiver(QObject *parent)
    : QObject(parent)
    , m_udpSocket(nullptr)
    , m_connectionTimer(new QTimer(this))
    , m_connected(false)
    , m_physicalJoystickActive(false)
    , m_joystickX(100)
    , m_joystickY(100)
    , m_port(12345)
    , m_connectionTimeoutMs(2000)  // 2 seconds timeout
    , m_lastDataTime(0)
{
    // Setup connection timeout timer
    m_connectionTimer->setSingleShot(true);
    connect(m_connectionTimer, &QTimer::timeout, this, &JoystickReceiver::onConnectionTimeout);
}

JoystickReceiver::~JoystickReceiver()
{
    stopListening();
}

void JoystickReceiver::startListening(int port)
{
    if (m_udpSocket) {
        stopListening();
    }

    m_port = port;
    m_udpSocket = new QUdpSocket(this);

    if (m_udpSocket->bind(QHostAddress::Any, m_port)) {
        connect(m_udpSocket, &QUdpSocket::readyRead, this, &JoystickReceiver::onDataReceived);
        qDebug() << "JoystickReceiver: Listening on port" << m_port;

        // Start connection timeout
        m_connectionTimer->start(m_connectionTimeoutMs);

    } else {
        emit errorOccurred(QString("Failed to bind to port %1").arg(m_port));
        delete m_udpSocket;
        m_udpSocket = nullptr;
    }
}

void JoystickReceiver::stopListening()
{
    if (m_udpSocket) {
        m_udpSocket->close();
        delete m_udpSocket;
        m_udpSocket = nullptr;
    }

    m_connectionTimer->stop();
    updateConnectionStatus(false);
}

void JoystickReceiver::setConnectionTimeout(int timeoutMs)
{
    m_connectionTimeoutMs = timeoutMs;
}

void JoystickReceiver::onDataReceived()
{
    if (!m_udpSocket) {
        return;
    }

    while (m_udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_udpSocket->receiveDatagram();
        QByteArray data = datagram.data();

        // Parse JSON
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(data, &error);

        if (error.error != QJsonParseError::NoError) {
            qWarning() << "JoystickReceiver: JSON parse error:" << error.errorString();
            continue;
        }

        if (!doc.isObject()) {
            qWarning() << "JoystickReceiver: Received data is not a JSON object";
            continue;
        }

        QJsonObject obj = doc.object();

        // Check message type
        if (obj["type"].toString() != "joystick_data") {
            qDebug() << "JoystickReceiver: Unknown message type:" << obj["type"].toString();
            continue;
        }

        // Process joystick data
        processJoystickData(obj);

        // Update last data time and reset timeout
        m_lastDataTime = QDateTime::currentMSecsSinceEpoch();
        m_connectionTimer->start(m_connectionTimeoutMs);

        // Update connection status
        bool wasConnected = m_connected;
        updateConnectionStatus(obj["connected"].toBool(true));

        if (!wasConnected && m_connected) {
            qDebug() << "JoystickReceiver: Physical joystick connected";
        }
    }
}

void JoystickReceiver::onConnectionTimeout()
{
    qDebug() << "JoystickReceiver: Connection timeout - no data received";
    updateConnectionStatus(false);

    // Return joystick to center position
    if (m_joystickX != 100 || m_joystickY != 100) {
        m_joystickX = 100;
        m_joystickY = 100;
        emit joystickValuesChanged();
        emit joystickDataReceived(m_joystickX, m_joystickY);
    }
}

void JoystickReceiver::processJoystickData(const QJsonObject &data)
{
    bool connected = data["connected"].toBool(true);
    int x = data["x"].toInt(100);
    int y = data["y"].toInt(100);

    // Validate ranges
    x = qBound(0, x, 200);
    y = qBound(0, y, 200);

    // Update values if changed
    bool valuesChanged = false;

    if (m_joystickX != x) {
        m_joystickX = x;
        valuesChanged = true;
    }

    if (m_joystickY != y) {
        m_joystickY = y;
        valuesChanged = true;
    }

    if (valuesChanged) {
        emit joystickValuesChanged();
        emit joystickDataReceived(m_joystickX, m_joystickY);

        qDebug() << QString("JoystickReceiver: X=%1, Y=%2 (Center offset: X=%3, Y=%4)")
                        .arg(m_joystickX).arg(m_joystickY)
                        .arg(m_joystickX - 100, +4).arg(m_joystickY - 100, +4);
    }

    // Update physical joystick active state
    bool physicalActive = connected && (x != 100 || y != 100);
    if (m_physicalJoystickActive != physicalActive) {
        m_physicalJoystickActive = physicalActive;
        emit physicalJoystickActiveChanged();
    }
}

void JoystickReceiver::updateConnectionStatus(bool connected)
{
    if (m_connected != connected) {
        m_connected = connected;
        emit connectedChanged();

        if (!connected) {
            // Reset physical joystick active state
            if (m_physicalJoystickActive) {
                m_physicalJoystickActive = false;
                emit physicalJoystickActiveChanged();
            }
        }
    }
}
