#ifndef CAMERAMODEL_H
#define CAMERAMODEL_H

#include <QObject>
#include <QUdpSocket>
#include <QTimer>
#include <QThread>
#include <QMutex>
#include <QBuffer>
#include <QPixmap>

class CameraModel : public QObject
{
    Q_OBJECT

public:
    explicit CameraModel(QObject *parent = nullptr);
    ~CameraModel();

    struct CameraSettings {
        QString ipAddress;
        int port;
    };

public slots:
    void startStreaming(const QString &ipAddress, int port);
    void stopStreaming();
    bool isStreaming() const;

private slots:
    void readPendingDatagrams();
    void onSocketError();
    void processBuffer();

signals:
    void streamingStatusChanged(bool streaming);
    void frameReceived(const QByteArray &frameData);
    void errorOccurred(const QString &error);
    void connectionEstablished();

private:
    QUdpSocket *m_udpSocket;
    QByteArray m_frameBuffer;
    QTimer *m_processTimer;
    bool m_streaming;
    CameraSettings m_settings;
    QMutex m_bufferMutex;

    // MJPEG parsing constants
    static const QByteArray JPEG_START_MARKER;
    static const QByteArray JPEG_END_MARKER;

    // Helper methods
    void extractFramesFromBuffer();
    bool isValidJpegFrame(const QByteArray &data);
    void clearBuffer();
};

#endif // CAMERAMODEL_H
