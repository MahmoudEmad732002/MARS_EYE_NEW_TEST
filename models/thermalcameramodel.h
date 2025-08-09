#ifndef THERMALCAMERAMODEL_H
#define THERMALCAMERAMODEL_H

#include <QObject>
#include <QUdpSocket>
#include <QTimer>
#include <QByteArray>
#include <QMutex>
#include <QNetworkDatagram>

class ThermalCameraModel : public QObject
{
    Q_OBJECT

public:
    explicit ThermalCameraModel(QObject *parent = nullptr);
    ~ThermalCameraModel();

    struct ThermalCameraSettings {
        QString ipAddress;
        int port;
    };

public slots:
    void startStreaming(const QString &ipAddress, int port);
    void stopStreaming();
    bool isStreaming() const;

signals:
    void streamingStatusChanged(bool streaming);
    void frameReceived(const QByteArray &frameData);
    void errorOccurred(const QString &error);
    void connectionEstablished();

private slots:
    void readPendingDatagrams();
    void onSocketError();
    void processBuffer();

private:
    QUdpSocket *m_udpSocket;
    QByteArray m_frameBuffer;
    QTimer *m_processTimer;
    bool m_streaming;
    ThermalCameraSettings m_settings;
    QMutex m_bufferMutex;

    // MJPEG parsing constants
    static const QByteArray JPEG_START_MARKER;
    static const QByteArray JPEG_END_MARKER;

    // Helper methods
    void extractFramesFromBuffer();
    bool isValidJpegFrame(const QByteArray &data);
    void clearBuffer();
};

#endif // THERMALCAMERAMODE
