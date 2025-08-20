#ifndef SERIALMODEL_H
#define SERIALMODEL_H

#include <QSerialPort>
#include <QSerialPortInfo>
#include <QTimer>
#include <QDebug>
#include <QMap>
#include <QSet>
#include <QObject>

class SerialModel : public QObject
{
    Q_OBJECT

public:
    explicit SerialModel(QObject *parent = nullptr);
    ~SerialModel();

    // Updated Telemetry Data (ID=1) - 22B body
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

    // Target GPS Data (ID=7) - 10B body
    struct TargetGPSData {
        quint32 targetPoseLat = 0;
        quint32 targetPoseLon = 0;
        quint16 targetPoseAlt = 0;
    };

    // Tracked Pose Data (ID=8) - 4B body
    struct TrackedPoseData {
        quint16 targetTrackedPoseXp = 0;
        quint16 targetTrackedPoseYp = 0;
    };

    // Zoom Feedback Data (ID=11) - 1B body
    struct ZoomFeedbackData {
        quint8 zoomFeedback = 0;
    };

    // Frame Info + Gains Data (ID=10) - 12B body (UPDATED: PID gains now 2B each)
    struct FrameInfoData {
        quint16 frameWidth = 0;
        quint16 frameHeight = 0;
        quint16 azimuthKp = 0;    // UPDATED: Changed from quint8 to quint16 (2B)
        quint16 azimuthKi = 0;    // UPDATED: Changed from quint8 to quint16 (2B)
        quint16 elevationKp = 0;  // UPDATED: Changed from quint8 to quint16 (2B)
        quint16 elevationKi = 0;  // UPDATED: Changed from quint8 to quint16 (2B)
    };

    // Acknowledgment Data (ID=12) - 1B body
    struct AckData {
        quint8 acknowledgedMessageId = 0;
    };

    // PID Gains (UPDATED: now 2B each) - 8B body
    struct PIDGains {
        quint16 azimuthKp = 0;    // UPDATED: Changed from quint8 to quint16 (2B)
        quint16 azimuthKi = 0;    // UPDATED: Changed from quint8 to quint16 (2B)
        quint16 elevationKp = 0;  // UPDATED: Changed from quint8 to quint16 (2B)
        quint16 elevationKi = 0;  // UPDATED: Changed from quint8 to quint16 (2B)
    };

public slots:
    QStringList getAvailablePorts();
    QStringList getBaudRates();
    bool connectToPort(const QString &portName, int baudRate);
    void disconnect();
    bool isConnected() const;

    // Updated control methods with continuous sending
    void sendJoystickCommand(quint8 joyX, quint8 joyY, quint8 resetFlag = 0);
    void stopJoystickCommand();
    void sendPIDGains(const PIDGains &gains);
    void sendZoomCommand(quint8 zoomCmd, quint8 zoomResetFlag = 0);
    void sendSelectTarget(quint16 targetXp, quint16 targetYp, quint16 frameNumber, quint8 resetFlag = 0); // UPDATED: Added resetFlag
    void sendAbsolutePointing(quint16 pitchAngleCmd, quint16 yawAngleCmd, quint8 stabilizationFlag = 1);
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
    quint8  calculateChecksum(const QByteArray &data);

    // Multiple continuous sending management
    void startContinuousSending(quint8 messageId, const QByteArray &message);
    void stopContinuousSending();                    // Stop all
    void stopContinuousSending(quint8 messageId);    // Stop specific message ID

    QSerialPort *m_serialPort;
    QByteArray m_buffer;
    bool m_connected;

    // Multiple continuous sending state
    QTimer *m_continuousTimer;
    QMap<quint8, QByteArray> m_continuousMessages;   // messageId -> message data
    QSet<quint8> m_activeContinuousMessages;         // Set of active message IDs

    // Joystick continuous state (separate from other messages)
    bool m_isJoystickActive;
    quint8 m_lastJoyX;
    quint8 m_lastJoyY;
    quint8 m_lastJoyResetFlag;

    // Message constants
    static constexpr quint16 HEADER = 0xA1A4;

    // Rx Message IDs (UPDATED: New message IDs)
    static constexpr quint8 TELEMETRY_MESSAGE_ID = 0x01;
    static constexpr quint8 TARGET_GPS_MESSAGE_ID = 0x07;
    static constexpr quint8 TRACKED_POSE_MESSAGE_ID = 0x08;
    static constexpr quint8 ZOOM_FEEDBACK_MESSAGE_ID = 0x11;     // UPDATED: Changed from 0x0B
    static constexpr quint8 FRAME_INFO_MESSAGE_ID = 0x10;        // UPDATED: Changed from 0x0A
    static constexpr quint8 ACK_MESSAGE_ID = 0x12;               // UPDATED: Changed from 0x0C

    // Tx Message IDs
    static constexpr quint8 PID_GAINS_MESSAGE_ID = 0x02;
    static constexpr quint8 JOYSTICK_MESSAGE_ID = 0x03;
    static constexpr quint8 ZOOM_COMMAND_MESSAGE_ID = 0x04;
    static constexpr quint8 SELECT_TARGET_MESSAGE_ID = 0x05;
    static constexpr quint8 ABSOLUTE_POINTING_MESSAGE_ID = 0x06;
    static constexpr quint8 REQUEST_GAINS_MESSAGE_ID = 0x09;

    static constexpr int TELEMETRY_MESSAGE_LENGTH = 26;        // 2+1+22+1 (was 27)
    static constexpr int TARGET_GPS_MESSAGE_LENGTH = 14;       // 2+1+10+1 (was 15)
    static constexpr int TRACKED_POSE_MESSAGE_LENGTH = 8;      // 2+1+4+1 (was 9)
    static constexpr int ZOOM_FEEDBACK_MESSAGE_LENGTH = 5;     // 2+1+1+1 (was 6)
    static constexpr int FRAME_INFO_MESSAGE_LENGTH = 16;       // 2+1+12+1 (was 17)
    static constexpr int ACK_MESSAGE_LENGTH = 5;               // 2+1+1+1 (was 6)

    // Tx message lengths - UPDATED with 1-byte checksum
    static constexpr int PID_GAINS_TX_LENGTH = 12;             // 2+1+8+1 (was 13)
    static constexpr int JOYSTICK_TX_LENGTH = 7;               // 2+1+3+1 (was 8)
    static constexpr int ZOOM_COMMAND_TX_LENGTH = 6;           // 2+1+2+1 (was 7)
    static constexpr int SELECT_TARGET_TX_LENGTH = 11;         // 2+1+7+1 (was 12)
    static constexpr int ABSOLUTE_POINTING_TX_LENGTH = 9;      // 2+1+5+1 (was 10)
    static constexpr int REQUEST_GAINS_TX_LENGTH = 5;         // 2+1+1+1 (was 6)
    // Continuous sending interval (ms)
    static constexpr int CONTINUOUS_SEND_INTERVAL = 100;
};

#endif // SERIALMODEL_H
