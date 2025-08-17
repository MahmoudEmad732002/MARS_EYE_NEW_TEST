#ifndef CAMERAVIEWMODEL_H
#define CAMERAVIEWMODEL_H

#include <QObject>
#include <QThread>
#include <QPixmap>
#include <QQuickImageProvider>
#include "models/CameraModel.h"

class CameraViewModel : public QObject
{
    Q_OBJECT

    // Camera connection properties
    Q_PROPERTY(QString ipAddress READ ipAddress WRITE setIpAddress NOTIFY ipAddressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(bool streaming READ streaming NOTIFY streamingChanged)
    Q_PROPERTY(QString streamButtonText READ streamButtonText NOTIFY streamingChanged)
    Q_PROPERTY(QString streamButtonColor READ streamButtonColor NOTIFY streamingChanged)
    Q_PROPERTY(QString cameraStatus READ cameraStatus NOTIFY cameraStatusChanged)
    Q_PROPERTY(bool trackingEnabled READ trackingEnabled NOTIFY trackingEnabledChanged)

    // Frame properties
    Q_PROPERTY(QString currentFrameUrl READ currentFrameUrl NOTIFY frameChanged)
    Q_PROPERTY(int frameCount READ frameCount NOTIFY frameCountChanged)
    Q_PROPERTY(double frameRate READ frameRate NOTIFY frameRateChanged)
    // Add to Q_PROPERTY section:
    Q_PROPERTY(bool showTrackingRect READ showTrackingRect NOTIFY trackingRectChanged)
    Q_PROPERTY(int trackingRectX READ trackingRectX NOTIFY trackingRectChanged)
    Q_PROPERTY(int trackingRectY READ trackingRectY NOTIFY trackingRectChanged)

    Q_PROPERTY(int currentFrameId READ currentFrameId NOTIFY frameIdChanged)

public:
    explicit CameraViewModel(QObject *parent = nullptr);
    ~CameraViewModel();
    bool trackingEnabled() const { return m_trackingEnabled; }

    // Property getters
    QString ipAddress() const { return m_ipAddress; }
    int port() const { return m_port; }
    bool streaming() const { return m_streaming; }
    QString streamButtonText() const { return m_streaming ? "Stop Stream" : "Start Stream"; }
    QString streamButtonColor() const { return m_streaming ? "#FF4444" : "#44BB44"; }
    QString cameraStatus() const { return m_cameraStatus; }
    QString currentFrameUrl() const { return m_currentFrameUrl; }
    int frameCount() const { return m_frameCount; }
    double frameRate() const { return m_frameRate; }

    // Property setters
    void setIpAddress(const QString &ipAddress);
    void setPort(int port);

    //// Add to public getters:
    bool showTrackingRect() const { return m_showTrackingRect; }
    int trackingRectX() const { return m_trackingRectX; }
    int trackingRectY() const { return m_trackingRectY; }
    int currentFrameId() const { return m_currentFrameId; }

    Q_INVOKABLE void toggleStream();
    Q_INVOKABLE void startStream();
    Q_INVOKABLE void stopStream();
    Q_INVOKABLE void enableTracking();
    Q_INVOKABLE void disableTracking();
    Q_INVOKABLE void sendTarget(int x, int y, int w, int h);
    // Add this new method:
    Q_INVOKABLE void updateTrackingRect(int x, int y, bool show) {
        if (m_trackingRectX != x || m_trackingRectY != y || m_showTrackingRect != show) {
            m_trackingRectX = x;
            m_trackingRectY = y;
            m_showTrackingRect = show;
            emit trackingRectChanged();
        }
    }
signals:
    void ipAddressChanged();
    void portChanged();
    void streamingChanged();
    void cameraStatusChanged();
    void frameChanged();
    void frameCountChanged();
    void frameRateChanged();
    void trackingEnabledChanged();
    void frameIdChanged();

    // Internal signals for thread communication
    void requestStartStream(const QString &ipAddress, int port);
    void requestStopStream();
    // Add to signals:
    void trackingRectChanged();
private slots:
    void onStreamingStatusChanged(bool streaming);
    void onFrameReceived(const QByteArray &frameData, quint16 frameId);
    void onCameraError(const QString &error);
    void onConnectionEstablished();
    void calculateFrameRate();

private:
    // Camera thread and model
    QThread *m_cameraThread;
    CameraModel *m_cameraModel;

    // Properties
    QString m_ipAddress;
    int m_port;
    bool m_streaming;
    QString m_cameraStatus;
    QString m_currentFrameUrl;
    int m_frameCount;
    double m_frameRate;
    // Add to private members:
    bool m_showTrackingRect = false;
    int m_trackingRectX = 0;
    int m_trackingRectY = 0;
    // Frame rate calculation
    QTimer *m_frameRateTimer;
    int m_framesInLastSecond;
    qint64 m_lastFrameTime;
    int m_currentFrameId = 0;

    QUdpSocket *m_ctrlSocket;
    bool m_trackingEnabled;
    void setupThread();
    void updateFrameUrl(const QByteArray &frameData);
};

// Custom image provider for displaying camera frames
class CameraImageProvider : public QQuickImageProvider
{
public:
    CameraImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;
    void updateFrame(const QString &id, const QByteArray &frameData);

private:
    QMap<QString, QByteArray> m_frameData;
    QMutex m_mutex;
};

#endif // CAMERAVIEWMODEL_H
