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

    // Telemetry properties
    Q_PROPERTY(int roll READ roll NOTIFY telemetryChanged)
    Q_PROPERTY(int pitch READ pitch NOTIFY telemetryChanged)
    Q_PROPERTY(int yaw READ yaw NOTIFY telemetryChanged)
    Q_PROPERTY(int azimuthMotor READ azimuthMotor NOTIFY telemetryChanged)
    Q_PROPERTY(int elevationMotor READ elevationMotor NOTIFY telemetryChanged)
    Q_PROPERTY(double latitude READ latitude NOTIFY telemetryChanged)
    Q_PROPERTY(double longitude READ longitude NOTIFY telemetryChanged)
    Q_PROPERTY(double altitude READ altitude NOTIFY telemetryChanged)

    // Joystick properties
    Q_PROPERTY(int joystickPitch READ joystickPitch WRITE setJoystickPitch NOTIFY joystickChanged)
    Q_PROPERTY(int joystickYaw READ joystickYaw WRITE setJoystickYaw NOTIFY joystickChanged)

    // PID Gain properties
    Q_PROPERTY(int azimuthKp READ azimuthKp WRITE setAzimuthKp NOTIFY pidGainsChanged)
    Q_PROPERTY(int azimuthKi READ azimuthKi WRITE setAzimuthKi NOTIFY pidGainsChanged)
    Q_PROPERTY(int azimuthKd READ azimuthKd WRITE setAzimuthKd NOTIFY pidGainsChanged)
    Q_PROPERTY(int elevationKp READ elevationKp WRITE setElevationKp NOTIFY pidGainsChanged)
    Q_PROPERTY(int elevationKi READ elevationKi WRITE setElevationKi NOTIFY pidGainsChanged)
    Q_PROPERTY(int elevationKd READ elevationKd WRITE setElevationKd NOTIFY pidGainsChanged)

    // Zoom property
    Q_PROPERTY(int zoomLevel READ zoomLevel WRITE setZoomLevel NOTIFY zoomLevelChanged)

    // Tracking coordinates properties
    Q_PROPERTY(int trackingX READ trackingX WRITE setTrackingX NOTIFY trackingChanged)
    Q_PROPERTY(int trackingY READ trackingY WRITE setTrackingY NOTIFY trackingChanged)

    // Map integration property (optional, if you use it)
    // Q_PROPERTY(MapViewModel* mapViewModel READ mapViewModel CONSTANT)

public:
    explicit SerialViewModel(QObject *parent = nullptr);

    // Serial/connection getters
    QStringList availablePorts() const { return m_availablePorts; }
    QStringList baudRates() const { return m_serialModel->getBaudRates(); }
    bool connected() const { return m_connected; }
    QString connectButtonText() const { return m_connected ? "Disconnect" : "Connect"; }
    QString connectButtonColor() const { return m_connected ? "#FF4444" : "#44FF44"; }
    QString statusMessage() const { return m_statusMessage; }

    // Telemetry getters
    int roll() const { return m_telemetryData.roll; }
    int pitch() const { return m_telemetryData.pitch; }
    int yaw() const { return m_telemetryData.yaw; }
    int azimuthMotor() const { return m_telemetryData.azimuthMotor; }
    int elevationMotor() const { return m_telemetryData.elevationMotor; }
    double latitude() const { return m_telemetryData.latitude  ; }
    double longitude() const { return m_telemetryData.longitude ; }
    double altitude() const { return m_telemetryData.altitude  ; }

    // Joystick getters/setters
    int joystickPitch() const { return m_joystickPitch; }
    void setJoystickPitch(int pitch);
    int joystickYaw() const { return m_joystickYaw; }
    void setJoystickYaw(int yaw);

    // PID Gains getters/setters
    int azimuthKp() const { return m_pidGains.azimuthKp; }
    void setAzimuthKp(int kp);
    int azimuthKi() const { return m_pidGains.azimuthKi; }
    void setAzimuthKi(int ki);
    int azimuthKd() const { return m_pidGains.azimuthKd; }
    void setAzimuthKd(int kd);
    int elevationKp() const { return m_pidGains.elevationKp; }
    void setElevationKp(int kp);
    int elevationKi() const { return m_pidGains.elevationKi; }
    void setElevationKi(int ki);
    int elevationKd() const { return m_pidGains.elevationKd; }
    void setElevationKd(int kd);

    // Zoom getter/setter
    int zoomLevel() const;
    void setZoomLevel(int z);

    // Tracking coordinates getter/setter
    int trackingX() const;
    void setTrackingX(int x);
    int trackingY() const;
    void setTrackingY(int y);

    // QML-callable slots
    Q_INVOKABLE void connectToSerial(const QString &portName, int baudRate);
    Q_INVOKABLE void refreshPorts();

    // Joystick controls
    Q_INVOKABLE void sendJoystickUp();
    Q_INVOKABLE void sendJoystickDown();
    Q_INVOKABLE void sendJoystickLeft();
    Q_INVOKABLE void sendJoystickRight();
    Q_INVOKABLE void sendCurrentJoystickValues();

    // PID Gain
    Q_INVOKABLE void sendPIDGains();
    // Zoom & Tracking
    Q_INVOKABLE void sendZoom();
    Q_INVOKABLE void sendTrackingCoordinates();

signals:
    void availablePortsChanged();
    void connectedChanged();
    void telemetryChanged();
    void statusMessageChanged();
    void joystickChanged();
    void pidGainsChanged();
    void zoomLevelChanged();
    void trackingChanged();

private slots:
    void onConnectionStatusChanged(bool connected);
    void onTelemetryDataReceived(const SerialModel::TelemetryData &data);
    void onErrorOccurred(const QString &error);
    void onMessageSent(const QString &messageType);

private:
    SerialModel *m_serialModel;
    QStringList m_availablePorts;
    bool m_connected;
    SerialModel::TelemetryData m_telemetryData;
    QString m_statusMessage;
    QTimer *m_refreshTimer;

    // Joystick/PID
    int m_joystickPitch;
    int m_joystickYaw;
    SerialModel::PIDGains m_pidGains;

    // Zoom & tracking
    int m_zoomLevel;
    int m_trackingX;
    int m_trackingY;

    void updateMapWithGPSData(); // (optional)
};

#endif // SERIALVIEWMODEL_H
