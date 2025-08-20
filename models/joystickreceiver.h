#ifndef JOYSTICKRECEIVER_H
#define JOYSTICKRECEIVER_H

#include <QObject>
#include <QUdpSocket>
#include <QTimer>
#include <QJsonDocument>
#include <QJsonObject>
#include <QHostAddress>

class JoystickReceiver : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(int joystickX READ joystickX NOTIFY joystickValuesChanged)
    Q_PROPERTY(int joystickY READ joystickY NOTIFY joystickValuesChanged)
    Q_PROPERTY(bool physicalJoystickActive READ physicalJoystickActive NOTIFY physicalJoystickActiveChanged)

public:
    explicit JoystickReceiver(QObject *parent = nullptr);
    ~JoystickReceiver();

    // Property getters
    bool connected() const { return m_connected; }
    int joystickX() const { return m_joystickX; }
    int joystickY() const { return m_joystickY; }
    bool physicalJoystickActive() const { return m_physicalJoystickActive; }

    // Configuration
    Q_INVOKABLE void startListening(int port = 12345);
    Q_INVOKABLE void stopListening();
    Q_INVOKABLE void setConnectionTimeout(int timeoutMs);

signals:
    void connectedChanged();
    void joystickValuesChanged();
    void physicalJoystickActiveChanged();
    void joystickDataReceived(int x, int y);  // For direct connection to ViewModel
    void errorOccurred(const QString &error);

private slots:
    void onDataReceived();
    void onConnectionTimeout();

private:
    void updateConnectionStatus(bool connected);
    void processJoystickData(const QJsonObject &data);

    QUdpSocket *m_udpSocket;
    QTimer *m_connectionTimer;

    bool m_connected;
    bool m_physicalJoystickActive;
    int m_joystickX;
    int m_joystickY;
    int m_port;
    int m_connectionTimeoutMs;
    qint64 m_lastDataTime;
};

#endif // JOYSTICKRECEIVER_H
