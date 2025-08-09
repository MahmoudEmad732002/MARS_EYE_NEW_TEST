
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QTimer>
#include <QDebug>
#pragma once

// SerialModel.h



class SerialModel : public QObject
{
    Q_OBJECT

public:
    explicit SerialModel(QObject *parent = nullptr);
    ~SerialModel();

    struct TelemetryData {
        quint16 roll = 0;
        quint16 pitch = 0;
        quint16 yaw = 0;
        quint16 azimuthMotor = 0;
        quint16 elevationMotor = 0;
        quint32 latitude = 0;
        quint32 longitude = 0;
        quint32 altitude = 0;
    };



    struct PIDGains {
        quint8 azimuthKp = 0;
        quint8 azimuthKi = 0;
        quint8 azimuthKd = 0;
        quint8 elevationKp = 0;
        quint8 elevationKi = 0;
        quint8 elevationKd = 0;
    };

public slots:
    QStringList getAvailablePorts();//returns list of available serial ports
    QStringList getBaudRates();//return baud rates
    bool connectToPort(const QString &portName, int baudRate);// Connects to specified port at given baud rate
    void disconnect();//close connection
    bool isConnected() const;//check connection status

    // New control methods
    bool sendJoystickCommand(quint8 pitch, quint8 yaw);
    bool sendPIDGains(const PIDGains &gains);
    bool sendZoomCommand(quint8 zoom);
    bool sendTrackingCoordinates(quint16 x, quint16 y);
signals:
    void connectionStatusChanged(bool connected);//emit when the connection status changed
    void telemetryDataReceived(const TelemetryData &data);//emit when new telemetry data recieved
    void errorOccurred(const QString &error);          //emit when error occure
    void messageSent(const QString &messageType);// emit when message sent

private slots:
    void readData();//handle incoming data
    void handleError(QSerialPort::SerialPortError error);//handle error

private:
    void processBuffer();
    bool validateChecksum(const QByteArray &data);
    TelemetryData parseMessage(const QByteArray &data);
    QByteArray createMessage(quint8 messageId, const QByteArray &payload);
    quint16 calculateChecksum(const QByteArray &data);

    QSerialPort *m_serialPort;
    QByteArray m_buffer;
    bool m_connected;
    static const quint16 HEADER = 0xA1A4;
    static const quint8 TELEMETRY_MESSAGE_ID = 0x01;
    static const quint8 JOYSTICK_MESSAGE_ID = 0x03;
    static const quint8 PID_GAINS_MESSAGE_ID = 0x02;
    static const quint8 ZOOM_MESSAGE_ID=0x04;
    static const quint8 TRACKING_MESSAGE_ID=0x05;
    static const int TELEMETRY_MESSAGE_LENGTH = 25; // Header(2) + ID(1) + Data(20) + Checksum(2)
    static const int JOYSTICK_MESSAGE_LENGTH = 7;   // Header(2) + ID(1) + Data(2) + Checksum(2)
    static const int PID_MESSAGE_LENGTH = 11;       // Header(2) + ID(1) + Data(6) + Checksum(2)




};
