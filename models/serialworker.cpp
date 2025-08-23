#include "SerialWorker.h"
#include<QThread>
SerialWorker::SerialWorker(QObject *parent)
    : QObject(parent)
    , m_serialPort(nullptr)
    , m_connected(false)
    , m_continuousTimer(nullptr)
    , m_isJoystickActive(false)
    , m_lastJoyX(100)
    , m_lastJoyY(100)
    , m_lastJoyResetFlag(0)
{
    // Note: QSerialPort and QTimer will be created in initializeSerial()
    // to ensure they belong to the worker thread
}

SerialWorker::~SerialWorker()
{
    if (m_serialPort && m_serialPort->isOpen()) {
        m_serialPort->close();
    }
}

void SerialWorker::initializeSerial()
{
    // Create serial port and timer in the worker thread
    m_serialPort = new QSerialPort(this);
    m_continuousTimer = new QTimer(this);

    connect(m_serialPort, &QSerialPort::readyRead, this, &SerialWorker::readData);
    connect(m_serialPort, &QSerialPort::errorOccurred, this, &SerialWorker::handleError);
    connect(m_continuousTimer, &QTimer::timeout, this, &SerialWorker::sendContinuousMessage);

    m_continuousTimer->setInterval(CONTINUOUS_SEND_INTERVAL);

    qDebug() << "SerialWorker initialized in thread:" << QThread::currentThread();
}

void SerialWorker::getAvailablePorts()
{
    QStringList ports;
    const auto serialPortInfos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &portInfo : serialPortInfos) {
        ports << portInfo.portName();
    }
    emit availablePortsReady(ports);
}

void SerialWorker::connectToPort(const QString &portName, int baudRate)
{
    if (!m_serialPort) {
        emit errorOccurred("SerialWorker not initialized");
        return;
    }

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
        sendRequestGains();
    } else {
        emit errorOccurred("Failed to connect: " + m_serialPort->errorString());
    }
}

void SerialWorker::disconnectFromPort()
{
    stopContinuousSending();
    if (m_serialPort && m_serialPort->isOpen()) {
        m_serialPort->close();
    }
    m_connected = false;
    m_buffer.clear();
    m_isJoystickActive = false;
    emit connectionStatusChanged(false);
}

void SerialWorker::readData()
{
    if (!m_serialPort) return;

    QByteArray data = m_serialPort->readAll();
    m_buffer.append(data);
    processBuffer();
}

void SerialWorker::processBuffer()
{
    while (m_buffer.size() >= 5) {
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
        case ZOOM_FEEDBACK_MESSAGE_ID:
            expectedLength = ZOOM_FEEDBACK_MESSAGE_LENGTH;
            break;
        case FRAME_INFO_MESSAGE_ID:
            expectedLength = FRAME_INFO_MESSAGE_LENGTH;
            break;
        case ACK_MESSAGE_ID:
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
            case ZOOM_FEEDBACK_MESSAGE_ID: {
                ZoomFeedbackData data = parseZoomFeedbackMessage(message);
                emit zoomFeedbackReceived(data);
                stopContinuousSending(ZOOM_COMMAND_MESSAGE_ID);
                qDebug() << "Received zoom feedback, stopping zoom commands";
                break;
            }
            case FRAME_INFO_MESSAGE_ID: {
                FrameInfoData data = parseFrameInfoMessage(message);
                emit frameInfoReceived(data);
                stopContinuousSending(REQUEST_GAINS_MESSAGE_ID);
                qDebug() << "Received frame info, stopping request gains";
                break;
            }
            case ACK_MESSAGE_ID: {
                AckData data = parseAckMessage(message);
                emit acknowledgmentReceived(data);
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

bool SerialWorker::validateChecksum(const QByteArray &data)
{
    if (data.size() < 3) return false;

    quint8 calculatedChecksum = 0;
    for (int i = 0; i < data.size() - 1; ++i) {
        calculatedChecksum += static_cast<quint8>(data[i]);
    }

    quint8 receivedChecksum = static_cast<quint8>(data[data.size() - 1]);
    return calculatedChecksum == receivedChecksum;
}

SerialWorker::TelemetryData SerialWorker::parseTelemetryMessage(const QByteArray &data)
{
    TelemetryData telemetry;
    int offset = 3;

    telemetry.gimbalRoll = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    telemetry.gimbalPitch = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    telemetry.gimbalYaw = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    telemetry.yawMotorPose = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    telemetry.pitchMotorPose = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;

    telemetry.gimbalPoseLat = (static_cast<quint8>(data[offset]) << 24) |
                              (static_cast<quint8>(data[offset + 1]) << 16) |
                              (static_cast<quint8>(data[offset + 2]) << 8) |
                              static_cast<quint8>(data[offset + 3]);
    offset += 4;

    telemetry.gimbalPoseLon = (static_cast<quint8>(data[offset]) << 24) |
                              (static_cast<quint8>(data[offset + 1]) << 16) |
                              (static_cast<quint8>(data[offset + 2]) << 8) |
                              static_cast<quint8>(data[offset + 3]);
    offset += 4;

    telemetry.gimbalPoseAlt = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    telemetry.battery = static_cast<quint8>(data[offset]);
    offset += 1;
    telemetry.signalStrength = static_cast<quint8>(data[offset]);

    return telemetry;
}

SerialWorker::TargetGPSData SerialWorker::parseTargetGPSMessage(const QByteArray &data)
{
    TargetGPSData target;
    int offset = 3;

    target.targetPoseLat = (static_cast<quint8>(data[offset]) << 24) |
                           (static_cast<quint8>(data[offset + 1]) << 16) |
                           (static_cast<quint8>(data[offset + 2]) << 8) |
                           static_cast<quint8>(data[offset + 3]);
    offset += 4;

    target.targetPoseLon = (static_cast<quint8>(data[offset]) << 24) |
                           (static_cast<quint8>(data[offset + 1]) << 16) |
                           (static_cast<quint8>(data[offset + 2]) << 8) |
                           static_cast<quint8>(data[offset + 3]);
    offset += 4;

    target.targetPoseAlt = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);

    return target;
}

SerialWorker::TrackedPoseData SerialWorker::parseTrackedPoseMessage(const QByteArray &data)
{
    TrackedPoseData tracked;
    int offset = 3;

    tracked.targetTrackedPoseXp = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    tracked.targetTrackedPoseYp = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);

    return tracked;
}

SerialWorker::ZoomFeedbackData SerialWorker::parseZoomFeedbackMessage(const QByteArray &data)
{
    ZoomFeedbackData zoom;
    int offset = 3;
    zoom.zoomFeedback = static_cast<quint8>(data[offset]);
    return zoom;
}

SerialWorker::FrameInfoData SerialWorker::parseFrameInfoMessage(const QByteArray &data)
{
    FrameInfoData frameInfo;
    int offset = 3;

    frameInfo.frameWidth = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    frameInfo.frameHeight = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    frameInfo.azimuthKp = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    frameInfo.azimuthKi = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    frameInfo.elevationKp = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);
    offset += 2;
    frameInfo.elevationKi = (static_cast<quint8>(data[offset]) << 8) | static_cast<quint8>(data[offset + 1]);

    return frameInfo;
}

SerialWorker::AckData SerialWorker::parseAckMessage(const QByteArray &data)
{
    AckData ack;
    int offset = 3;
    ack.acknowledgedMessageId = static_cast<quint8>(data[offset]);
    return ack;
}

void SerialWorker::handleError(QSerialPort::SerialPortError error)
{
    if (error != QSerialPort::NoError) {
        emit errorOccurred("Serial port error: " + m_serialPort->errorString());
        if (m_connected) {
            disconnectFromPort();
        }
    }
}

void SerialWorker::startContinuousSending(quint8 messageId, const QByteArray &message)
{
    m_continuousMessages[messageId] = message;
    m_activeContinuousMessages.insert(messageId);

    if (m_serialPort && m_serialPort->isOpen()) {
        m_serialPort->write(message);
    }

    if (!m_continuousTimer->isActive()) {
        m_continuousTimer->start();
    }

    qDebug() << "Started continuous sending for message ID:" << messageId;
}

void SerialWorker::stopContinuousSending()
{
    m_continuousMessages.clear();
    m_activeContinuousMessages.clear();
    if (m_continuousTimer) {
        m_continuousTimer->stop();
    }
    qDebug() << "Stopped all continuous sending";
}

void SerialWorker::stopContinuousSending(quint8 messageId)
{
    if (m_activeContinuousMessages.contains(messageId)) {
        m_continuousMessages.remove(messageId);
        m_activeContinuousMessages.remove(messageId);

        if (m_activeContinuousMessages.isEmpty() && m_continuousTimer) {
            m_continuousTimer->stop();
        }

        qDebug() << "Stopped continuous sending for message ID:" << messageId;
    }
}

void SerialWorker::sendContinuousMessage()
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

void SerialWorker::sendJoystickCommand(quint8 joyX, quint8 joyY, quint8 resetFlag)
{
    if (!m_connected || !m_serialPort) {
        emit errorOccurred("Cannot send joystick command: Not connected");
        return;
    }

    m_lastJoyX = joyX;
    m_lastJoyY = joyY;
    m_lastJoyResetFlag = resetFlag;

    if (!m_isJoystickActive) {
        m_isJoystickActive = true;

        if (!m_continuousTimer->isActive()) {
            m_continuousTimer->start();
        }

        emit messageSent("Joystick Command Started");
    }

    QByteArray payload;
    payload.append(static_cast<char>(joyX));
    payload.append(static_cast<char>(joyY));
    payload.append(static_cast<char>(resetFlag));

    QByteArray message = createMessage(JOYSTICK_MESSAGE_ID, payload);
    m_serialPort->write(message);
}

void SerialWorker::stopJoystickCommand()
{
    if (m_isJoystickActive) {
        m_isJoystickActive = false;
        emit messageSent("Joystick Command Stopped");
    }
}

void SerialWorker::sendPIDGains(const PIDGains &gains)
{
    if (!m_connected || !m_serialPort) {
        emit errorOccurred("Cannot send PID gains: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>((gains.azimuthKp >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.azimuthKp & 0xFF));
    payload.append(static_cast<char>((gains.azimuthKi >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.azimuthKi & 0xFF));
    payload.append(static_cast<char>((gains.elevationKp >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.elevationKp & 0xFF));
    payload.append(static_cast<char>((gains.elevationKi >> 8) & 0xFF));
    payload.append(static_cast<char>(gains.elevationKi & 0xFF));

    QByteArray message = createMessage(PID_GAINS_MESSAGE_ID, payload);
    startContinuousSending(PID_GAINS_MESSAGE_ID, message);
    emit messageSent("PID Gains (Continuous)");
}

void SerialWorker::sendZoomCommand(quint8 zoomCmd, quint8 zoomResetFlag)
{
    if (!m_connected || !m_serialPort) {
        emit errorOccurred("Cannot send zoom command: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>(zoomCmd));
    payload.append(static_cast<char>(zoomResetFlag));

    QByteArray message = createMessage(ZOOM_COMMAND_MESSAGE_ID, payload);
    startContinuousSending(ZOOM_COMMAND_MESSAGE_ID, message);
    emit messageSent("Zoom Command (Continuous)");
}

void SerialWorker::sendSelectTarget(quint16 targetXp, quint16 targetYp, quint16 frameNumber, quint8 resetFlag)
{
    if (!m_connected || !m_serialPort) {
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
    payload.append(static_cast<char>(resetFlag));

    QByteArray message = createMessage(SELECT_TARGET_MESSAGE_ID, payload);

    qint64 bytesWritten = m_serialPort->write(message);
    if (bytesWritten == message.size()) {
        emit messageSent("Select Target");
    } else {
        emit errorOccurred("Failed to send select target");
    }
}

void SerialWorker::sendAbsolutePointing(quint16 pitchAngleCmd, quint16 yawAngleCmd, quint8 stabilizationFlag)
{
    if (!m_connected || !m_serialPort) {
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
    startContinuousSending(ABSOLUTE_POINTING_MESSAGE_ID, message);
    emit messageSent("Absolute Pointing (Continuous)");
}

void SerialWorker::stopAbsolutePointing()
{
    if (m_activeContinuousMessages.contains(ABSOLUTE_POINTING_MESSAGE_ID)) {
        stopContinuousSending(ABSOLUTE_POINTING_MESSAGE_ID);
        emit messageSent("Absolute Pointing Stopped");
    }
}

void SerialWorker::sendRequestGains()
{
    if (!m_connected || !m_serialPort) {
        emit errorOccurred("Cannot send request gains: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>(1)); // RequestFlag = 1

    QByteArray message = createMessage(REQUEST_GAINS_MESSAGE_ID, payload);
    startContinuousSending(REQUEST_GAINS_MESSAGE_ID, message);
    emit messageSent("Request Gains (Continuous)");
}

void SerialWorker::sendFrameInfoAndGains(quint16 frameW, quint16 frameH, const PIDGains &gains)
{
    if (!m_connected || !m_serialPort) {
        emit errorOccurred("Cannot send frame info and gains: Not connected");
        return;
    }

    QByteArray payload;
    payload.append(static_cast<char>((frameW >> 8) & 0xFF));
    payload.append(static_cast<char>(frameW & 0xFF));
    payload.append(static_cast<char>((frameH >> 8) & 0xFF));
    payload.append(static_cast<char>(frameH & 0xFF));

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

QByteArray SerialWorker::createMessage(quint8 messageId, const QByteArray &payload)
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
    quint8 checksum = calculateChecksum(message);
    message.append(static_cast<char>(checksum));

    return message;
}

quint8 SerialWorker::calculateChecksum(const QByteArray &data)
{
    quint8 checksum = 0;
    for (int i = 0; i < data.size(); ++i) {
        checksum += static_cast<quint8>(data[i]);
    }
    return checksum;
}
