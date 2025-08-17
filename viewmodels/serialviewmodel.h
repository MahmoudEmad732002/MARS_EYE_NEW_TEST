#ifndef SERIALVIEWMODEL_H
#define SERIALVIEWMODEL_H

#include <QObject>
#include <QTimer>
#include "models/SerialModel.h"

class SerialViewModel : public QObject
{
    Q_OBJECT

    // Serial/connection properties
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY availablePortsChanged)
    Q_PROPERTY(QStringList baudRates READ baudRates CONSTANT)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QString connectButtonText READ connectButtonText NOTIFY connectedChanged)
    Q_PROPERTY(QString connectButtonColor READ connectButtonColor NOTIFY connectedChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)

    // Updated Telemetry properties (renamed fields)
    Q_PROPERTY(int gimbalRoll READ gimbalRoll NOTIFY telemetryChanged)
    Q_PROPERTY(int gimbalPitch READ gimbalPitch NOTIFY telemetryChanged)
    Q_PROPERTY(int gimbalYaw READ gimbalYaw NOTIFY telemetryChanged)
    Q_PROPERTY(int yawMotorPose READ yawMotorPose NOTIFY telemetryChanged)
    Q_PROPERTY(int pitchMotorPose READ pitchMotorPose NOTIFY telemetryChanged)
    Q_PROPERTY(double gimbalPoseLat READ gimbalPoseLat NOTIFY telemetryChanged)
    Q_PROPERTY(double gimbalPoseLon READ gimbalPoseLon NOTIFY telemetryChanged)
    Q_PROPERTY(double gimbalPoseAlt READ gimbalPoseAlt NOTIFY telemetryChanged)
    Q_PROPERTY(int battery READ battery NOTIFY telemetryChanged)
    Q_PROPERTY(int signalStrength READ signalStrength NOTIFY telemetryChanged)

    // Target GPS properties (updated names)
    Q_PROPERTY(double targetPoseLat READ targetPoseLat NOTIFY targetGPSChanged)
    Q_PROPERTY(double targetPoseLon READ targetPoseLon NOTIFY targetGPSChanged)
    Q_PROPERTY(double targetPoseAlt READ targetPoseAlt NOTIFY targetGPSChanged)

    // Tracked pose properties (updated names)
    Q_PROPERTY(int targetTrackedPoseXp READ targetTrackedPoseXp NOTIFY trackedPoseChanged)
    Q_PROPERTY(int targetTrackedPoseYp READ targetTrackedPoseYp NOTIFY trackedPoseChanged)

    // Zoom feedback properties
    Q_PROPERTY(int zoomFeedback READ zoomFeedback NOTIFY zoomFeedbackChanged)

    // Frame info properties
    Q_PROPERTY(int frameWidth READ frameWidth NOTIFY frameInfoChanged)
    Q_PROPERTY(int frameHeight READ frameHeight NOTIFY frameInfoChanged)
    Q_PROPERTY(int receivedAzKp READ receivedAzKp NOTIFY frameInfoChanged)
    Q_PROPERTY(int receivedAzKi READ receivedAzKi NOTIFY frameInfoChanged)
    Q_PROPERTY(int receivedElKp READ receivedElKp NOTIFY frameInfoChanged)
    Q_PROPERTY(int receivedElKi READ receivedElKi NOTIFY frameInfoChanged)

    // Acknowledgment properties
    Q_PROPERTY(int lastAcknowledgedMessageId READ lastAcknowledgedMessageId NOTIFY acknowledgmentChanged)

    // Joystick properties (updated)
    Q_PROPERTY(int joystickX READ joystickX WRITE setJoystickX NOTIFY joystickChanged)
    Q_PROPERTY(int joystickY READ joystickY WRITE setJoystickY NOTIFY joystickChanged)
    Q_PROPERTY(int joystickResetFlag READ joystickResetFlag WRITE setJoystickResetFlag NOTIFY joystickChanged)
    Q_PROPERTY(bool joystickActive READ joystickActive NOTIFY joystickActiveChanged)

    // PID Gain properties (no Kd)
    Q_PROPERTY(int azimuthKp READ azimuthKp WRITE setAzimuthKp NOTIFY pidGainsChanged)
    Q_PROPERTY(int azimuthKi READ azimuthKi WRITE setAzimuthKi NOTIFY pidGainsChanged)
    Q_PROPERTY(int elevationKp READ elevationKp WRITE setElevationKp NOTIFY pidGainsChanged)
    Q_PROPERTY(int elevationKi READ elevationKi WRITE setElevationKi NOTIFY pidGainsChanged)

    // Zoom properties (updated)
    Q_PROPERTY(int zoomLevel READ zoomLevel WRITE setZoomLevel NOTIFY zoomLevelChanged)
    Q_PROPERTY(int zoomResetFlag READ zoomResetFlag WRITE setZoomResetFlag NOTIFY zoomLevelChanged)

    // Target selection properties
    Q_PROPERTY(int targetX READ targetX WRITE setTargetX NOTIFY targetChanged)
    Q_PROPERTY(int targetY READ targetY WRITE setTargetY NOTIFY targetChanged)
    Q_PROPERTY(int frameNumber READ frameNumber WRITE setFrameNumber NOTIFY targetChanged)

    // Absolute pointing properties
    Q_PROPERTY(int pitchAngleCmd READ pitchAngleCmd WRITE setPitchAngleCmd NOTIFY absolutePointingChanged)
    Q_PROPERTY(int yawAngleCmd READ yawAngleCmd WRITE setYawAngleCmd NOTIFY absolutePointingChanged)
    Q_PROPERTY(int stabilizationFlag READ stabilizationFlag WRITE setStabilizationFlag NOTIFY absolutePointingChanged)
    Q_PROPERTY(bool absolutePointingActive READ absolutePointingActive NOTIFY absolutePointingActiveChanged)

public:
    explicit SerialViewModel(QObject *parent = nullptr);

    // Serial/connection getters
    QStringList availablePorts() const { return m_availablePorts; }
    QStringList baudRates() const { return m_serialModel->getBaudRates(); }
    bool connected() const { return m_connected; }
    QString connectButtonText() const { return m_connected ? "Disconnect" : "Connect"; }
    QString connectButtonColor() const { return m_connected ? "#FF4444" : "#44FF44"; }
    QString statusMessage() const { return m_statusMessage; }

    // Updated Telemetry getters
    int gimbalRoll() const { return m_telemetryData.gimbalRoll; }
    int gimbalPitch() const { return m_telemetryData.gimbalPitch; }
    int gimbalYaw() const { return m_telemetryData.gimbalYaw; }
    int yawMotorPose() const { return m_telemetryData.yawMotorPose; }
    int pitchMotorPose() const { return m_telemetryData.pitchMotorPose; }
    double gimbalPoseLat() const { return m_telemetryData.gimbalPoseLat; }
    double gimbalPoseLon() const { return m_telemetryData.gimbalPoseLon; }
    double gimbalPoseAlt() const { return m_telemetryData.gimbalPoseAlt; }
    int battery() const { return m_telemetryData.battery; }
    int signalStrength() const { return m_telemetryData.signalStrength; }

    // Target GPS getters (updated names)
    double targetPoseLat() const { return m_targetGPSData.targetPoseLat; }
    double targetPoseLon() const { return m_targetGPSData.targetPoseLon; }
    double targetPoseAlt() const { return m_targetGPSData.targetPoseAlt; }

    // Tracked pose getters (updated names)
    int targetTrackedPoseXp() const { return m_trackedPoseData.targetTrackedPoseXp; }
    int targetTrackedPoseYp() const { return m_trackedPoseData.targetTrackedPoseYp; }

    // Zoom feedback getters
    int zoomFeedback() const { return m_zoomFeedbackData.zoomFeedback; }

    // Frame info getters
    int frameWidth() const { return m_frameInfoData.frameWidth; }
    int frameHeight() const { return m_frameInfoData.frameHeight; }
    int receivedAzKp() const { return m_frameInfoData.azimuthKp; }
    int receivedAzKi() const { return m_frameInfoData.azimuthKi; }
    int receivedElKp() const { return m_frameInfoData.elevationKp; }
    int receivedElKi() const { return m_frameInfoData.elevationKi; }

    // Acknowledgment getters
    int lastAcknowledgedMessageId() const { return m_lastAckData.acknowledgedMessageId; }

    // Joystick getters/setters (updated)
    int joystickX() const { return m_joystickX; }
    void setJoystickX(int x);
    int joystickY() const { return m_joystickY; }
    void setJoystickY(int y);
    int joystickResetFlag() const { return m_joystickResetFlag; }
    void setJoystickResetFlag(int flag);
    bool joystickActive() const { return m_joystickActive; }

    // PID Gains getters/setters
    int azimuthKp() const { return m_pidGains.azimuthKp; }
    void setAzimuthKp(int kp);
    int azimuthKi() const { return m_pidGains.azimuthKi; }
    void setAzimuthKi(int ki);
    int elevationKp() const { return m_pidGains.elevationKp; }
    void setElevationKp(int kp);
    int elevationKi() const { return m_pidGains.elevationKi; }
    void setElevationKi(int ki);

    // Zoom getters/setters
    int zoomLevel() const { return m_zoomLevel; }
    void setZoomLevel(int level);
    int zoomResetFlag() const { return m_zoomResetFlag; }
    void setZoomResetFlag(int flag);

    // Target selection getters/setters
    int targetX() const { return m_targetX; }
    void setTargetX(int x);
    int targetY() const { return m_targetY; }
    void setTargetY(int y);
    int frameNumber() const { return m_frameNumber; }
    void setFrameNumber(int frameNum);

    // Absolute pointing getters/setters
    int pitchAngleCmd() const { return m_pitchAngleCmd; }
    void setPitchAngleCmd(int angle);
    int yawAngleCmd() const { return m_yawAngleCmd; }
    void setYawAngleCmd(int angle);
    int stabilizationFlag() const { return m_stabilizationFlag; }
    void setStabilizationFlag(int flag);
    bool absolutePointingActive() const { return m_absolutePointingActive; }

    // QML-callable slots
    Q_INVOKABLE void connectToSerial(const QString &portName, int baudRate);
    Q_INVOKABLE void refreshPorts();

    // Updated control methods
    Q_INVOKABLE void startJoystickCommand();
    Q_INVOKABLE void stopJoystickCommand();
    Q_INVOKABLE void sendSoftwareJoystickCommand(int x, int y);
    Q_INVOKABLE void sendJoystickUp();
    Q_INVOKABLE void sendJoystickDown();
    Q_INVOKABLE void sendJoystickLeft();
    Q_INVOKABLE void sendJoystickRight();

    Q_INVOKABLE void sendPIDGains();
    Q_INVOKABLE void sendZoomCommand();
    Q_INVOKABLE void sendSelectTarget();
    Q_INVOKABLE void startAbsolutePointing();
    Q_INVOKABLE void stopAbsolutePointing();
    Q_INVOKABLE void sendRequestGains();
    Q_INVOKABLE void sendFrameInfoAndGains(int frameW, int frameH);

signals:
    void availablePortsChanged();
    void connectedChanged();
    void telemetryChanged();
    void targetGPSChanged();
    void trackedPoseChanged();
    void zoomFeedbackChanged();
    void frameInfoChanged();
    void acknowledgmentChanged();
    void statusMessageChanged();
    void joystickChanged();
    void joystickActiveChanged();
    void pidGainsChanged();
    void zoomLevelChanged();
    void targetChanged();
    void absolutePointingChanged();
    void absolutePointingActiveChanged();

private slots:
    void onConnectionStatusChanged(bool connected);
    void onTelemetryDataReceived(const SerialModel::TelemetryData &data);
    void onTargetGPSReceived(const SerialModel::TargetGPSData &data);
    void onTrackedPoseReceived(const SerialModel::TrackedPoseData &data);
    void onZoomFeedbackReceived(const SerialModel::ZoomFeedbackData &data);
    void onFrameInfoReceived(const SerialModel::FrameInfoData &data);
    void onAcknowledgmentReceived(const SerialModel::AckData &data);
    void onErrorOccurred(const QString &error);
    void onMessageSent(const QString &messageType);

private:
    SerialModel *m_serialModel;
    QStringList m_availablePorts;
    bool m_connected;
    QString m_statusMessage;
    QTimer *m_refreshTimer;

    // Data structures
    SerialModel::TelemetryData m_telemetryData;
    SerialModel::TargetGPSData m_targetGPSData;
    SerialModel::TrackedPoseData m_trackedPoseData;
    SerialModel::ZoomFeedbackData m_zoomFeedbackData;
    SerialModel::FrameInfoData m_frameInfoData;
    SerialModel::AckData m_lastAckData;

    // Control variables
    int m_joystickX;
    int m_joystickY;
    int m_joystickResetFlag;
    bool m_joystickActive;
    SerialModel::PIDGains m_pidGains;
    int m_zoomLevel;
    int m_zoomResetFlag;
    int m_targetX;
    int m_targetY;
    int m_frameNumber;
    int m_pitchAngleCmd;
    int m_yawAngleCmd;
    int m_stabilizationFlag;
    bool m_absolutePointingActive;
};

#endif // SERIALVIEWMODEL_H
