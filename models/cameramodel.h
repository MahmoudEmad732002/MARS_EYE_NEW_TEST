#ifndef CAMERAMODEL_H
#define CAMERAMODEL_H

#include <QObject>
#include <QUdpSocket>
#include <QTimer>
#include <QThread>
#include <QMutex>
#include <QBuffer>
#include <QPixmap>
#include <QDateTime>
#include <QMap>
#include <QVector>

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

    // Structure for frame reassembly
    struct FrameAssembly {
        quint32 totalFragments;
        quint32 receivedFragments;
        QVector<QByteArray> fragments;
        qint64 timestamp;
    };

public slots:
    void startStreaming(const QString &ipAddress, int port);
    void stopStreaming();
    bool isStreaming() const;

private slots:
    void readPendingDatagrams();
    void onSocketError();
    void processBuffer();
    void cleanupIncompleteFrames();

signals:
    void streamingStatusChanged(bool streaming);
    void frameReceived(const QByteArray &frameData, quint16 frameId);  // Added frameId parameter
    void errorOccurred(const QString &error);
    void connectionEstablished();

private:
    QUdpSocket *m_udpSocket;
    QByteArray m_frameBuffer;
    QTimer *m_processTimer;
    QTimer *m_cleanupTimer;
    bool m_streaming;
    CameraSettings m_settings;
    QMutex m_bufferMutex;

    // Fragment reassembly
    QMap<quint16, FrameAssembly> m_incompleteFrames;
    qint64 m_fragmentTimeout;

    // MJPEG parsing constants
    static const QByteArray JPEG_START_MARKER;
    static const QByteArray JPEG_END_MARKER;

    // Helper methods
    void processFragmentedPacket(const QByteArray &packet);
    void extractFramesFromBuffer();
    bool isValidJpegFrame(const QByteArray &data);
    void clearBuffer();
    void clearIncompleteFrames();
};

#endif // CAMERAMODEL_H
