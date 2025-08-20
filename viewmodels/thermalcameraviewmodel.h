#ifndef THERMALCAMERAVIEWMODEL_H
#define THERMALCAMERAVIEWMODEL_H

#include <QObject>
#include <QThread>
#include <QTimer>
#include <QQuickImageProvider>
#include <QPixmap>
#include <QMutex>
#include "models/ThermalCameraModel.h"

class ThermalCameraViewModel : public QObject
{
    Q_OBJECT

    // Thermal camera connection properties
    Q_PROPERTY(QString thermalIpAddress READ thermalIpAddress WRITE setThermalIpAddress NOTIFY thermalIpAddressChanged)
    Q_PROPERTY(int thermalPort READ thermalPort WRITE setThermalPort NOTIFY thermalPortChanged)
    Q_PROPERTY(bool thermalStreaming READ thermalStreaming NOTIFY thermalStreamingChanged)
    Q_PROPERTY(QString thermalStreamButtonText READ thermalStreamButtonText NOTIFY thermalStreamingChanged)
    Q_PROPERTY(QString thermalStreamButtonColor READ thermalStreamButtonColor NOTIFY thermalStreamingChanged)
    Q_PROPERTY(QString thermalCameraStatus READ thermalCameraStatus NOTIFY thermalCameraStatusChanged)

    // Thermal frame properties
    Q_PROPERTY(QString currentThermalFrameUrl READ currentThermalFrameUrl NOTIFY thermalFrameChanged)
    Q_PROPERTY(int thermalFrameCount READ thermalFrameCount NOTIFY thermalFrameCountChanged)
    Q_PROPERTY(double thermalFrameRate READ thermalFrameRate NOTIFY thermalFrameRateChanged)

public:
    explicit ThermalCameraViewModel(QObject *parent = nullptr);
    ~ThermalCameraViewModel();

    // Property getters
    QString thermalIpAddress() const { return m_thermalIpAddress; }
    int thermalPort() const { return m_thermalPort; }
    bool thermalStreaming() const { return m_thermalStreaming; }
    QString thermalStreamButtonText() const { return m_thermalStreaming ? "Stop" : "Start"; }
    QString thermalStreamButtonColor() const { return m_thermalStreaming ? "#FF4444" : "#44BB44"; }
    QString thermalCameraStatus() const { return m_thermalCameraStatus; }
    QString currentThermalFrameUrl() const { return m_currentThermalFrameUrl; }
    int thermalFrameCount() const { return m_thermalFrameCount; }
    double thermalFrameRate() const { return m_thermalFrameRate; }

    // Property setters
    void setThermalIpAddress(const QString &ipAddress);
    void setThermalPort(int port);

    // QML-callable methods
    Q_INVOKABLE void toggleThermalStream();
    Q_INVOKABLE void startThermalStream();
    Q_INVOKABLE void stopThermalStream();

signals:
    void thermalIpAddressChanged();
    void thermalPortChanged();
    void thermalStreamingChanged();
    void thermalCameraStatusChanged();
    void thermalFrameChanged();
    void thermalFrameCountChanged();
    void thermalFrameRateChanged();

    // Internal signals for thread communication
    void requestStartThermalStream(const QString &ipAddress, int port);
    void requestStopThermalStream();

private slots:
    void onThermalStreamingStatusChanged(bool streaming);
    void onThermalFrameReceived(const QByteArray &frameData);
    void onThermalCameraError(const QString &error);
    void onThermalConnectionEstablished();
    void calculateThermalFrameRate();

private:
    // Thermal camera thread and model
    QThread *m_thermalCameraThread;
    ThermalCameraModel *m_thermalCameraModel;

    // Properties
    QString m_thermalIpAddress;
    int m_thermalPort;
    bool m_thermalStreaming;
    QString m_thermalCameraStatus;
    QString m_currentThermalFrameUrl;
    int m_thermalFrameCount;
    double m_thermalFrameRate;

    // Frame rate calculation
    QTimer *m_thermalFrameRateTimer;
    int m_thermalFramesInLastSecond;
    qint64 m_lastThermalFrameTime;

    void setupThermalThread();
    void updateThermalFrameUrl(const QByteArray &frameData);
};

// Custom image provider for displaying thermal camera frames
class ThermalImageProvider : public QQuickImageProvider
{
public:
    ThermalImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;
    void updateFrame(const QString &id, const QByteArray &frameData);

private:
    QMap<QString, QByteArray> m_frameData;
    QMutex m_mutex;
};

#endif // THERMALCAMERAVIEWMODEL_H
