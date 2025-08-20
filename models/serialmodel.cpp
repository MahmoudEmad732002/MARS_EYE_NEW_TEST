#include "serialmodel.h"

SerialModel::SerialModel(QObject *parent)
    : QObject(parent)
    , m_serialPort(new QSerialPort(this))
    , m_connected(false)
    , m_continuousTimer(new QTimer(this))
    , m_isJoystickActive(false)
    , m_lastJoyX(100)
    , m_lastJoyY(100)
    , m_lastJoyResetFlag(0)
{
    connect(m_serialPort, &QSerialPort::readyRead, this, &SerialModel::readData);
    connect(m_serialPort, &QSerialPort::errorOccurred, this, &SerialModel::handleError);
    connect(m_continuousTimer, &QTimer::timeout, this, &SerialModel::sendContinuousMessage);

    m_continuousTimer->setInterval(CONTINUOUS_SEND_INTERVAL);
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
    stopContinuousSending();  // Stop all continuous messages
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
    }
    m_connected = false;
    m_buffer.clear();
    m_isJoystickActive = false;
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
    while (m_buffer.size() >= 5) { // Minimum message size
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
            m_buffer.clear();
            break;
        }

        if (headerIndex > 0) {
            m_buffer.remove(0, headerIndex);
        }

        if (m_buffer.size() < 3) {
            break;
        }

        // Determine message length based on ID
        quint8 messageId = static_cast<quint8>(m_buffer[2]);
        int expectedLength;

        switch (messageId) {
        case TELEMETRY_MESSAGE_ID:
            expectedLength = TELEMETRY_MESSAGE_LENGTH;
            break;
        case TARGET_GPS_MESSAGE_ID:
            expectedLength = TARGET_GPS_MESSAGE_LENGTH;
            break;
        case TRACKED_POSE_MESSAGE_ID:
            expectedLength = TRACKED_POSE_MESSAGE_LENGTH;
            break;
        case ZOOM_FEEDBACK_MESSAGE_ID: // UPDATED: 0x11
            expectedLength = ZOOM_FEEDBACK_MESSAGE_LENGTH;
            break;
        case FRAME_INFO_MESSAGE_ID: // UPDATED: 0x10
            expectedLength = FRAME_INFO_MESSAGE_LENGTH;
            break;
        case ACK_MESSAGE_ID: // UPDATED: 0x12
            expectedLength = ACK_MESSAGE_LENGTH;
            break;
        default:
            m_buffer.remove(0, 1);
            continue;
        }

        if (m_buffer.size() < expectedLength) {
            break;
        }

        // Extract message
        QByteArray message = m_buffer.left(expectedLength);

        // Validate checksum and process message
        if (validateChecksum(message)) {
            switch (messageId) {
            case TELEMETRY_MESSAGE_ID: {
                TelemetryData data = parseTelemetryMessage(message);
                emit telemetryDataReceived(data);
                break;
            }
            case TARGET_GPS_MESSAGE_ID: {
                TargetGPSData data = parseTargetGPSMessage(message);
                emit targetGPSReceived(data);
                break;
            }
            case TRACKED_POSE_MESSAGE_ID: {
                TrackedPoseData data = parseTrackedPoseMessage(message);
                emit trackedPoseReceived(data);
                break;
            }
            case ZOOM_FEEDBACK_MESSAGE_ID: { // UPDATED: 0x11
                ZoomFeedbackData data = parseZoomFeedbackMessage(message);
                emit zoomFeedbackReceived(data);

                // UPDATED: Stop zoom command continuous sending when feedback is received
                stopContinuousSending(ZOOM_COMMAND_MESSAGE_ID);
                qDebug() << "Received zoom feedback, stopping zoom commands";
                break;
            }
            case FRAME_INFO_MESSAGE_ID: { // UPDATED: 0x10
                FrameInfoData data = parseFrameInfoMessage(message);
                emit frameInfoReceived(data);

                // UPDATED: Stop request gains continuous sending when frame info is received
                stopContinuousSending(REQUEST_GAINS_MESSAGE_ID);
                qDebug() << "Received frame info, stopping request gains";
                break;
            }
            case ACK_MESSAGE_ID: { // UPDATED: 0x12
                AckData data = parseAckMessage(message);
                emit acknowledgmentReceived(data);

                // Stop continuous sending for the specific acknowledged message ID
                stopContinuousSending(data.acknowledgedMessageId);
                qDebug() << "Received acknowledgment for message ID:" << data.acknowledgedMessageId;
                break;
            }
            }
        } else {
            qDebug() << "Checksum validation failed for message ID:" << messageId;
        }

        m_buffer.remove(0, expectedLength);
    }
}

bool SerialModel::validateChecksum(const QByteArray &data)
{
    if (data.size() < 3) return false;  // Changed from 4 to 3 (header + ID + 1 byte checksum)

    quint8 calculatedChecksum = 0;  // Changed from quint16 to quint8
    for (int i = 0; i < data.size() - 1; ++i) {  // Changed from -2 to -1
        calculatedChecksum += static_cast<quint8>(data[i]);
    }

    quint8 receivedChecksum = static_cast<quint8>(data[data.size() - 1]);  // Only last byte

    return calculatedChecksum == receivedChecksum;
}

// Parsing methods
SerialModel::TelemetryData SerialModel::parseTelemetryMessage(const QByteArray &data)
{
    TelemetryData telemetry;
    int offset = 3; // Skip header and ID

    // Parse Gimbal Roll (2B)
    telemetry.gimbalRoll = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Gimbal Pitch (2B)
    telemetry.gimbalPitch = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Gimbal Yaw (2B)
    telemetry.gimbalYaw = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Yaw Motor Pose (2B)
    telemetry.yawMotorPose = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Pitch Motor Pose (2B)
    telemetry.pitchMotorPose = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Gimbal Pose Lat (4B)
    telemetry.gimbalPoseLat = (static_cast<quint8>(data[offset]) << 24) |
                              (static_cast<quint8>(data[offset + 1]) << 16) |
                              (static_cast<quint8>(data[offset + 2]) << 8) |
                              static_cast<quint8>(data[offset + 3]);
    offset += 4;

    // Parse Gimbal Pose Lon (4B)
    telemetry.gimbalPoseLon = (static_cast<quint8>(data[offset]) << 24) |
                              (static_cast<quint8>(data[offset + 1]) << 16) |
                              (static_cast<quint8>(data[offset + 2]) << 8) |
                              static_cast<quint8>(data[offset + 3]);
    offset += 4;

    // Parse Gimbal Pose Alt (2B)
    telemetry.gimbalPoseAlt = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Battery (1B)
    telemetry.battery = static_cast<quint8>(data[offset]);
    offset += 1;

    // Parse Signal Strength (1B)
    telemetry.signalStrength = static_cast<quint8>(data[offset]);

    return telemetry;
}

SerialModel::TargetGPSData SerialModel::parseTargetGPSMessage(const QByteArray &data)
{
    TargetGPSData target;
    int offset = 3; // Skip header and ID

    // Parse Target Pose Lat (4B)
    target.targetPoseLat = (static_cast<quint8>(data[offset]) << 24) |
                           (static_cast<quint8>(data[offset + 1]) << 16) |
                           (static_cast<quint8>(data[offset + 2]) << 8) |
                           static_cast<quint8>(data[offset + 3]);
    offset += 4;

    // Parse Target Pose Lon (4B)
    target.targetPoseLon = (static_cast<quint8>(data[offset]) << 24) |
                           (static_cast<quint8>(data[offset + 1]) << 16) |
                           (static_cast<quint8>(data[offset + 2]) << 8) |
                           static_cast<quint8>(data[offset + 3]);
    offset += 4;

    // Parse Target Pose Alt (2B)
    target.targetPoseAlt = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);

    return target;
}

SerialModel::TrackedPoseData SerialModel::parseTrackedPoseMessage(const QByteArray &data)
{
    TrackedPoseData tracked;
    int offset = 3; // Skip header and ID

    // Parse Target Tracked Pose Xp (2B)
    tracked.targetTrackedPoseXp = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Target Tracked Pose Yp (2B)
    tracked.targetTrackedPoseYp = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);

    return tracked;
}

SerialModel::ZoomFeedbackData SerialModel::parseZoomFeedbackMessage(const QByteArray &data)
{
    ZoomFeedbackData zoom;
    int offset = 3; // Skip header and ID

    // Parse Zoom Feedback (1B)
    zoom.zoomFeedback = static_cast<quint8>(data[offset]);

    return zoom;
}

// UPDATED: Frame info parsing - PID gains now 2 bytes each
SerialModel::FrameInfoData SerialModel::parseFrameInfoMessage(const QByteArray &data)
{
    FrameInfoData frameInfo;
    int offset = 3; // Skip header and ID

    // Parse Frame Width (2B)
    frameInfo.frameWidth = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Frame Height (2B)
    frameInfo.frameHeight = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Azimuth Kp (2B) - UPDATED from 1B to 2B
    frameInfo.azimuthKp = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Azimuth Ki (2B) - UPDATED from 1B to 2B
    frameInfo.azimuthKi = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Elevation Kp (2B) - UPDATED from 1B to 2B
    frameInfo.elevationKp = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    // Parse Elevation Ki (2B) - UPDATED from 1B to 2B
    frameInfo.elevationKi = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);

    return frameInfo;
}

SerialModel::AckData SerialModel::parseAckMessage(const QByteArray &data)
{
    AckData ack;
    int offset = 3; // Skip header and ID

    // Parse Acknowledged Message ID (1B)
    ack.acknowledgedMessageId = static_cast<quint8>(data[offset]);

    return ack;
}

void SerialModel::handleError(QSerialPort::SerialPortError error)
{
    if (error != QSerialPort::NoError) {
        emit errorOccurred("Serial port error: " + m_serialPort->errorString());
        if (m_connected) {
            disconnect();
        }
    }
}

// Multiple continuous sending management
void SerialModel::startContinuousSending(quint8 messageId, const QByteArray &message)
{
    // Add or update the message for this ID
    m_continuousMessages[messageId] = message;
    m_activeContinuousMessages.insert(messageId);

    // Send immediately first time
    if (m_serialPort && m_serialPort->isOpen()) {
        m_serialPort->write(message);
    }

    // Start timer if not already running
    if (!m_continuousTimer->isActive()) {
        m_continuousTimer->start();
    }

    qDebug() << "Started continuous sending for message ID:" << messageId;
}

void SerialModel::stopContinuousSending()
{
    // Stop all continuous messages
    m_continuousMessages.clear();
    m_activeContinuousMessages.clear();
    m_continuousTimer->stop();
    qDebug() << "Stopped all continuous sending";
}

void SerialModel::stopContinuousSending(quint8 messageId)
{
    if (m_activeContinuousMessages.contains(messageId)) {
        m_continuousMessages.remove(messageId);
        m_activeContinuousMessages.remove(messageId);

        // Stop timer if no more continuous messages
        if (m_activeContinuousMessages.isEmpty()) {
            m_continuousTimer->stop();
        }

        qDebug() << "Stopped continuous sending for message ID:" << messageId;
    }
}

void SerialModel::sendContinuousMessage()
{
    if (!m_serialPort || !m_serialPort->isOpen()) {
        return;
    }

    // Send all active continuous messages
    for (auto it = m_continuousMessages.constBegin(); it != m_continuousMessages.constEnd(); ++it) {
        quint8 messageId = it.key();
        const QByteArray& message = it.value();

        if (m_activeContinuousMessages.contains(messageId)) {
            m_serialPort->write(message);
        }
    }

    // Handle joystick continuous sending separately
    if (m_isJoystickActive) {
        QByteArray payload;
        payload.append(static_cast<char>(m_lastJoyX));
        payload.append(static_cast<char>(m_lastJoyY));
        payload.append(static_cast<char>(m_lastJoyResetFlag));

        QByteArray message = createMessage(JOYSTICK_MESSAGE_ID, payload);
        m_serialPort->write(message);
    }
}

// Updated Tx Methods with multiple continuous sending
void SerialModel::sendJoystickCommand(quint8 joyX, quint8 joyY, quint8 resetFlag)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send joystick command: Not connected");
        return;
    }

    m_lastJoyX = joyX;
    m_lastJoyY = joyY;
    m_lastJoyResetFlag = resetFlag;

    // Joystick sends continuously while active (no acknowledgment needed)
    if (!m_isJoystickActive) {
        m_isJoystickActive = true;
        emit messageSent("Joystick Command Started");
    }
}

void SerialModel::stopJoystickCommand()
{
    if (m_isJoystickActive) {  // Only emit if it was actually active
        m_isJoystickActive = false;
        emit messageSent("Joystick Command Stopped");
    }
}

// UPDATED: PID gains now send 2 bytes per value
void SerialModel::sendPIDGains(const PIDGains &gains)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send PID gains: Not connected");
        return;
    }

    QByteArray payload;
    // Azimuth Kp (2B) - UPDATED from 1B to 2B
    payload.append(static_cast<char>((gains.azimuthKp >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.azimuthKp & 0xFF));

    // Azimuth Ki (2B) - UPDATED from 1B to 2B
    payload.append(static_cast<char>((gains.azimuthKi >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.azimuthKi & 0xFF));

    // Elevation Kp (2B) - UPDATED from 1B to 2B
    payload.append(static_cast<char>((gains.elevationKp >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.elevationKp & 0xFF));

    // Elevation Ki (2B) - UPDATED from 1B to 2B
    payload.append(static_cast<char>((gains.elevationKi >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.elevationKi & 0xFF));

    QByteArray message = createMessage(PID_GAINS_MESSAGE_ID, payload);

    // Send continuously until acknowledged
    startContinuousSending(PID_GAINS_MESSAGE_ID, message);
    emit messageSent("PID Gains (Continuous)");
}

void SerialModel::sendZoomCommand(quint8 zoomCmd, quint8 zoomResetFlag)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send zoom command: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>(zoomCmd));
    payload.append(static_cast<char>(zoomResetFlag));

    QByteArray message = createMessage(ZOOM_COMMAND_MESSAGE_ID, payload);

    // Send continuously until zoom feedback (ID 0x11) is received
    startContinuousSending(ZOOM_COMMAND_MESSAGE_ID, message);
    emit messageSent("Zoom Command (Continuous)");
}

// UPDATED: Select target with reset flag parameter
void SerialModel::sendSelectTarget(quint16 targetXp, quint16 targetYp, quint16 frameNumber, quint8 resetFlag)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send select target: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>((targetXp >> 8) & 0xFF));
    payload.append(static_cast<char>(targetXp & 0xFF));
    payload.append(static_cast<char>((targetYp >> 8) & 0xFF));
    payload.append(static_cast<char>(targetYp & 0xFF));
    payload.append(static_cast<char>((frameNumber >> 8) & 0xFF));
    payload.append(static_cast<char>(frameNumber & 0xFF));
    payload.append(static_cast<char>(resetFlag)); // NEW FIELD - Reset flag

    QByteArray message = createMessage(SELECT_TARGET_MESSAGE_ID, payload);

    // Send once (no continuous sending needed for target selection)
    qint64 bytesWritten = m_serialPort->write(message);
    if (bytesWritten == message.size()) {
        emit messageSent("Select Target");
    } else {
        emit errorOccurred("Failed to send select target");
    }
}

void SerialModel::sendAbsolutePointing(quint16 pitchAngleCmd, quint16 yawAngleCmd, quint8 stabilizationFlag)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send absolute pointing: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>((pitchAngleCmd >> 8) & 0xFF));
    payload.append(static_cast<char>(pitchAngleCmd & 0xFF));
    payload.append(static_cast<char>((yawAngleCmd >> 8) & 0xFF));
    payload.append(static_cast<char>(yawAngleCmd & 0xFF));
    payload.append(static_cast<char>(stabilizationFlag));

    QByteArray message = createMessage(ABSOLUTE_POINTING_MESSAGE_ID, payload);

    // Send continuously until acknowledged
    startContinuousSending(ABSOLUTE_POINTING_MESSAGE_ID, message);
    emit messageSent("Absolute Pointing (Continuous)");
}

void SerialModel::stopAbsolutePointing()
{
    if (m_activeContinuousMessages.contains(ABSOLUTE_POINTING_MESSAGE_ID)) {
        stopContinuousSending(ABSOLUTE_POINTING_MESSAGE_ID);
        emit messageSent("Absolute Pointing Stopped");
    }
}

void SerialModel::sendRequestGains()
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send request gains: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>(1)); // RequestFlag = 1

    QByteArray message = createMessage(REQUEST_GAINS_MESSAGE_ID, payload);

    // Send continuously until frame info (ID 0x10) is received
    startContinuousSending(REQUEST_GAINS_MESSAGE_ID, message);
    emit messageSent("Request Gains (Continuous)");
}

// UPDATED: Frame info and gains with 2-byte PID values
void SerialModel::sendFrameInfoAndGains(quint16 frameW, quint16 frameH, const PIDGains &gains)
{
    if (!isConnected()) {
        emit errorOccurred("Cannot send frame info and gains: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>((frameW >> 8) & 0xFF));
    payload.append(static_cast<char>(frameW & 0xFF));
    payload.append(static_cast<char>((frameH >> 8) & 0xFF));
    payload.append(static_cast<char>(frameH & 0xFF));

    // PID gains now 2 bytes each - UPDATED
    payload.append(static_cast<char>((gains.azimuthKp >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.azimuthKp & 0xFF));
    payload.append(static_cast<char>((gains.azimuthKi >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.azimuthKi & 0xFF));
    payload.append(static_cast<char>((gains.elevationKp >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.elevationKp & 0xFF));
    payload.append(static_cast<char>((gains.elevationKi >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.elevationKi & 0xFF));

    QByteArray message = createMessage(FRAME_INFO_MESSAGE_ID, payload);

    qint64 bytesWritten = m_serialPort->write(message);
    if (bytesWritten == message.size()) {
        emit messageSent("Frame Info and Gains");
    } else {
        emit errorOccurred("Failed to send frame info and gains");
    }
}

QByteArray SerialModel::createMessage(quint8 messageId, const QByteArray &payload)
{
    QByteArray message;

    // Add header (big-endian)
    message.append(static_cast<char>((HEADER >> 8) & 0xFF));
    message.append(static_cast<char>(HEADER & 0xFF));

    // Add message ID
    message.append(static_cast<char>(messageId));

    // Add payload
    message.append(payload);

    // Calculate and add checksum (single byte)
    quint8 checksum = calculateChecksum(message);  // Changed from quint16 to quint8
    message.append(static_cast<char>(checksum));   // Only append one byte

    return message;
}

quint8 SerialModel::calculateChecksum(const QByteArray &data)  // Changed return type from quint16 to quint8
{
    quint8 checksum = 0;  // Changed from quint16 to quint8
    for (int i = 0; i < data.size(); ++i) {
        checksum += static_cast<quint8>(data[i]);
    }
    return checksum;  // This automatically gives us the least significant byte
}
