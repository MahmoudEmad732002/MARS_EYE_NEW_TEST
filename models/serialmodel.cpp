#include "serialmodel.h"

SerialModel::SerialModel(QObject *parent)
    : QObject(parent)
    , m_serialPort(new QSerialPort(this))
    , m_connected(false)
{
    connect(m_serialPort, &QSerialPort::readyRead, this, &SerialModel::readData);
    connect(m_serialPort, &QSerialPort::errorOccurred, this, &SerialModel::handleError);

}
SerialModel::~SerialModel()
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
    }

}

QStringList SerialModel::getAvailablePorts()
{
    QStringList ports;
    const auto serialPortInfos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &portInfo : serialPortInfos) {
        ports << portInfo.portName();
    }
    return ports;

}

QStringList SerialModel::getBaudRates()
{
    return {"9600", "19200", "38400", "57600", "115200"};

}

bool SerialModel::connectToPort(const QString &portName, int baudRate)
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
    }

    m_serialPort->setPortName(portName);
    m_serialPort->setBaudRate(baudRate);
    m_serialPort->setDataBits(QSerialPort::Data8);
    m_serialPort->setParity(QSerialPort::NoParity);
    m_serialPort->setStopBits(QSerialPort::OneStop);
    m_serialPort->setFlowControl(QSerialPort::NoFlowControl);

    if (m_serialPort->open(QIODevice::ReadWrite)) {
        m_connected = true;
        emit connectionStatusChanged(true);
        return true;
    } else {
        emit errorOccurred("Failed to connect: " + m_serialPort->errorString());
        return false;
    }

}

void SerialModel::disconnect()
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
    }
    m_connected = false;
    m_buffer.clear();
    emit connectionStatusChanged(false);

}

bool SerialModel::isConnected() const
{
    return m_connected && m_serialPort->isOpen();
}

void SerialModel::readData()
{
    QByteArray data = m_serialPort->readAll();
    m_buffer.append(data);
    processBuffer();



}

void SerialModel::processBuffer()
{

    while (m_buffer.size() >= TELEMETRY_MESSAGE_LENGTH) { // Minimum message size
        // Look for header
        int headerIndex = -1;
        for (int i = 0; i <= m_buffer.size() - 2; ++i) {
            quint16 header = (static_cast<quint8>(m_buffer[i]) << 8) | static_cast<quint8>(m_buffer[i + 1]);
            if (header == HEADER) {
                headerIndex = i;
                break;
            }
        }

        if (headerIndex == -1) {
            // No header found, clear buffer
            m_buffer.clear();
            break;
        }

        if (headerIndex > 0) {
            // Remove data before header
            m_buffer.remove(0, headerIndex);
        }

        if (m_buffer.size() < TELEMETRY_MESSAGE_LENGTH) {
            // Not enough data to read message ID
            break;
        }

        // Determine message length based on ID
        quint8 messageId = static_cast<quint8>(m_buffer[2]);
        int expectedLength;

        switch (messageId) {
        case TELEMETRY_MESSAGE_ID:
            expectedLength = TELEMETRY_MESSAGE_LENGTH;
            break;

        default:
            // Unknown message ID, skip this byte
            m_buffer.remove(0, 1);
            continue;
        }

        if (m_buffer.size() < expectedLength) {
            // Not enough data for complete message
            break;
        }

        // Extract message
        QByteArray message = m_buffer.left(expectedLength);

        // Process telemetry messages (we only receive these)
        if (messageId == TELEMETRY_MESSAGE_ID) {
            if (validateChecksum(message)) {
                TelemetryData data = parseMessage(message);
                emit telemetryDataReceived(data);
            }
        }

        // Remove processed message from buffer
        m_buffer.remove(0, expectedLength);
    }
}

bool SerialModel::validateChecksum(const QByteArray &data)
{

    quint16 calculatedChecksum = 0;
    for (int i = 0; i < data.size() - 2; ++i) {
        calculatedChecksum += static_cast<quint8>(data[i]);
    }

    quint16 receivedChecksum = (static_cast<quint8>(data[data.size() - 2]) << 8) |
                               static_cast<quint8>(data[data.size() - 1]);

    return calculatedChecksum == receivedChecksum;


}

SerialModel::TelemetryData SerialModel::parseMessage(const QByteArray &data)
{
    TelemetryData telemetry;
    int offset = 3; // Skip header and ID

    // Parse 2-byte values (roll, pitch, yaw, azimuth motor, elevation motor)
    telemetry.roll = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    telemetry.pitch = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    telemetry.yaw = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    telemetry.azimuthMotor = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    telemetry.elevationMotor = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse 4-byte values (lat, long, alt)
    telemetry.latitude = (static_cast<quint8>(data[offset]) << 24) |
                         (static_cast<quint8>(data[offset + 1]) << 16) |
                         (static_cast<quint8>(data[offset + 2]) << 8) |
                         static_cast<quint8>(data[offset + 3]);
    offset += 4;

    telemetry.longitude = (static_cast<quint8>(data[offset]) << 24) |
                          (static_cast<quint8>(data[offset + 1]) << 16) |
                          (static_cast<quint8>(data[offset + 2]) << 8) |
                          static_cast<quint8>(data[offset + 3]);
    offset += 4;

    telemetry.altitude = (static_cast<quint8>(data[offset]) << 24) |
                         (static_cast<quint8>(data[offset + 1]) << 16) |
                         (static_cast<quint8>(data[offset + 2]) << 8) |
                         static_cast<quint8>(data[offset + 3]);

    return telemetry;

}

void SerialModel::handleError(QSerialPort::SerialPortError error)
{
    if (error != QSerialPort::NoError) {
        emit errorOccurred("Serial port error: " + m_serialPort->errorString());
        if (m_connected) {
            disconnect();
        }
    }
    if(error!=QSerialPort::NoError){
        emit errorOccurred("error"+m_serialPort->errorString());
    }
}

// New methods for sending commands
bool SerialModel::sendJoystickCommand(quint8 pitch, quint8 yaw)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send joystick command: Not connected");
        return false;
    }

    QByteArray payload;
    payload.append(static_cast<char>(pitch));
    payload.append(static_cast<char>(yaw));

    QByteArray message = createMessage(JOYSTICK_MESSAGE_ID, payload);

    qint64 bytesWritten = m_serialPort->write(message);
    if (bytesWritten == message.size()) {
        emit messageSent("Joystick Command");
        return true;
    } else {
        emit errorOccurred("Failed to send joystick command");
        return false;
    }

}

bool SerialModel::sendPIDGains(const PIDGains &gains)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send PID gains: Not connected");
        return false;
    }

    QByteArray payload;
    payload.append(static_cast<char>(gains.azimuthKp));
    payload.append(static_cast<char>(gains.azimuthKi));
    payload.append(static_cast<char>(gains.azimuthKd));
    payload.append(static_cast<char>(gains.elevationKp));
    payload.append(static_cast<char>(gains.elevationKi));
    payload.append(static_cast<char>(gains.elevationKd));

    QByteArray message = createMessage(PID_GAINS_MESSAGE_ID, payload);

    qint64 bytesWritten = m_serialPort->write(message);
    if (bytesWritten == message.size()) {
        emit messageSent("PID Gains");
        return true;
    } else {
        emit errorOccurred("Failed to send PID gains");
        return false;
    }
}

bool SerialModel::sendZoomCommand(quint8 zoom)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send zoom command: Not connected");
        return false;
    }
    QByteArray payload;
    payload.append(static_cast<char>(zoom));
    QByteArray message = createMessage(ZOOM_MESSAGE_ID, payload);
    qint64 bytesWritten = m_serialPort->write(message);
    if (bytesWritten == message.size()) {
        emit messageSent("Zoom Command");
        return true;
    } else {
        emit errorOccurred("Failed to send zoom command");
        return false;
    }

}

bool SerialModel::sendTrackingCoordinates(quint16 x, quint16 y)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send tracking coordinates: Not connected");
        return false;
    }
    QByteArray payload;
    payload.append(static_cast<char>((x >> 8) & 0xFF));
    payload.append(static_cast<char>(x & 0xFF));
    payload.append(static_cast<char>((y >> 8) & 0xFF));
    payload.append(static_cast<char>(y & 0xFF));
    QByteArray message = createMessage(TRACKING_MESSAGE_ID, payload);
    qint64 bytesWritten = m_serialPort->write(message);
    if (bytesWritten == message.size()) {
        emit messageSent("Tracking Coordinates");
        return true;
    } else {
        emit errorOccurred("Failed to send tracking coordinates");
        return false;
    }
}
QByteArray SerialModel::createMessage(quint8 messageId, const QByteArray &payload)
{
    QByteArray message;

    // Add header
    message.append(static_cast<char>((HEADER >> 8) & 0xFF));
    message.append(static_cast<char>(HEADER & 0xFF));

    // Add message ID
    message.append(static_cast<char>(messageId));

    // Add payload
    message.append(payload);

    // Calculate and add checksum
    quint16 checksum = calculateChecksum(message);
    message.append(static_cast<char>((checksum >> 8) & 0xFF));
    message.append(static_cast<char>(checksum & 0xFF));

    return message;
}

quint16 SerialModel::calculateChecksum(const QByteArray &data)
{
    quint16 checksum = 0;
    for (int i = 0; i < data.size(); ++i) {
        checksum += static_cast<quint8>(data[i]);
    }
    return checksum;
}
