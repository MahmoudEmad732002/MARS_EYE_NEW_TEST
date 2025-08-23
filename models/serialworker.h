#ifndef SERIALWORKER_H
#define SERIALWORKER_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QTimer>
#include <QDebug>
#include <QMap>
#include <QSet>

class SerialWorker : public QObject
{
    Q_OBJECT

public:
    explicit SerialWorker(QObject *parent = nullptr);
    ~SerialWorker();

    // Data structures (same as SerialModel)
    struct TelemetryData
    {
        quint16 gimbalRoll = 0;
        quint16 gimbalPitch = 0;
        quint16 gimbalYaw = 0;
        quint16 yawMotorPose = 0;
        quint16 pitchMotorPose = 0;
        quint32 gimbalPoseLat = 0;
        quint32 gimbalPoseLon = 0;
        quint16 gimbalPoseAlt = 0;
        quint8 battery = 0;
        quint8 signalStrength = 0;
    };

    struct TargetGPSData {
        quint32 targetPoseLat = 0;
        quint32 targetPoseLon = 0;
        quint16 targetPoseAlt = 0;
    };

    struct TrackedPoseData {
        quint16 targetTrackedPoseXp = 0;
        quint16 targetTrackedPoseYp = 0;
    };

    struct ZoomFeedbackData {
        quint8 zoomFeedback = 0;
    };

    struct FrameInfoData {
        quint16 frameWidth = 0;
        quint16 frameHeight = 0;
        quint16 azimuthKp = 0;
        quint16 azimuthKi = 0;
        quint16 elevationKp = 0;
        quint16 elevationKi = 0;
    };

    struct AckData {
        quint8 acknowledgedMessageId = 0;
    };

    struct PIDGains {
        quint16 azimuthKp = 0;
        quint16 azimuthKi = 0;
        quint16 elevationKp = 0;
        quint16 elevationKi = 0;
    };

public slots:
    void initializeSerial();
    void getAvailablePorts();
    void connectToPort(const QString &portName, int baudRate);
    void disconnectFromPort();

    // Control methods
    void sendJoystickCommand(quint8 joyX, quint8 joyY, quint8 resetFlag);
    void stopJoystickCommand();
    void sendPIDGains(const PIDGains &gains);
    void sendZoomCommand(quint8 zoomCmd, quint8 zoomResetFlag);
    void sendSelectTarget(quint16 targetXp, quint16 targetYp, quint16 frameNumber, quint8 resetFlag);
    void sendAbsolutePointing(quint16 pitchAngleCmd, quint16 yawAngleCmd, quint8 stabilizationFlag);
    void stopAbsolutePointing();
    void sendRequestGains();
    void sendFrameInfoAndGains(quint16 frameW, quint16 frameH, const PIDGains &gains);

signals:
    void connectionStatusChanged(bool connected);
    void telemetryDataReceived(const TelemetryData &data);
    void targetGPSReceived(const TargetGPSData &data);
    void trackedPoseReceived(const TrackedPoseData &data);
    void zoomFeedbackReceived(const ZoomFeedbackData &data);
    void frameInfoReceived(const FrameInfoData &data);
    void acknowledgmentReceived(const AckData &data);
    void errorOccurred(const QString &error);
    void messageSent(const QString &messageType);
    void availablePortsReady(const QStringList &ports);

private slots:
    void readData();
    void handleError(QSerialPort::SerialPortError error);
    void sendContinuousMessage();

private:
    void processBuffer();
    bool validateChecksum(const QByteArray &data);

    // Message parsing methods
    TelemetryData parseTelemetryMessage(const QByteArray &data);
    TargetGPSData parseTargetGPSMessage(const QByteArray &data);
    TrackedPoseData parseTrackedPoseMessage(const QByteArray &data);
    ZoomFeedbackData parseZoomFeedbackMessage(const QByteArray &data);
    FrameInfoData parseFrameInfoMessage(const QByteArray &data);
    AckData parseAckMessage(const QByteArray &data);

    // Message creation methods
    QByteArray createMessage(quint8 messageId, const QByteArray &payload);
    quint8 calculateChecksum(const QByteArray &data);

    // Multiple continuous sending management
    void startContinuousSending(quint8 messageId, const QByteArray &message);
    void stopContinuousSending();
    void stopContinuousSending(quint8 messageId);

    QSerialPort *m_serialPort;
    QByteArray m_buffer;
    bool m_connected;

    // Multiple continuous sending state
    QTimer *m_continuousTimer;
    QMap<quint8, QByteArray> m_continuousMessages;
    QSet<quint8> m_activeContinuousMessages;

    // Joystick continuous state
    bool m_isJoystickActive;
    quint8 m_lastJoyX;
    quint8 m_lastJoyY;
    quint8 m_lastJoyResetFlag;

    // Message constants
    static constexpr quint16 HEADER = 0xA1A4;

    // Rx Message IDs
    static constexpr quint8 TELEMETRY_MESSAGE_ID = 0x01;
    static constexpr quint8 TARGET_GPS_MESSAGE_ID = 0x07;
    static constexpr quint8 TRACKED_POSE_MESSAGE_ID = 0x08;
    static constexpr quint8 ZOOM_FEEDBACK_MESSAGE_ID = 0x11;
    static constexpr quint8 FRAME_INFO_MESSAGE_ID = 0x10;
    static constexpr quint8 ACK_MESSAGE_ID = 0x12;

    // Tx Message IDs
    static constexpr quint8 PID_GAINS_MESSAGE_ID = 0x02;
    static constexpr quint8 JOYSTICK_MESSAGE_ID = 0x03;
    static constexpr quint8 ZOOM_COMMAND_MESSAGE_ID = 0x04;
    static constexpr quint8 SELECT_TARGET_MESSAGE_ID = 0x05;
    static constexpr quint8 ABSOLUTE_POINTING_MESSAGE_ID = 0x06;
    static constexpr quint8 REQUEST_GAINS_MESSAGE_ID = 0x09;

    // Message lengths
    static constexpr int TELEMETRY_MESSAGE_LENGTH = 26;
    static constexpr int TARGET_GPS_MESSAGE_LENGTH = 14;
    static constexpr int TRACKED_POSE_MESSAGE_LENGTH = 8;
    static constexpr int ZOOM_FEEDBACK_MESSAGE_LENGTH = 5;
    static constexpr int FRAME_INFO_MESSAGE_LENGTH = 16;
    static constexpr int ACK_MESSAGE_LENGTH = 5;

    // Continuous sending interval (ms)
    static constexpr int CONTINUOUS_SEND_INTERVAL = 100;
};

#endif // SERIALWORKER_H
