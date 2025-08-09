#pragma once
#include <QObject>
#include <QString>
#include <QScreenCapture>
#include <QMediaCaptureSession>
#include <QMediaRecorder>
#include <QStandardPaths>
#include <QScreen>
#include <QPixmap>
#include <QQuickWindow>
#include <QPointer>

class MediaManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRecording READ isRecording NOTIFY recordingStateChanged)
    Q_PROPERTY(QString lastSnapshotPath READ lastSnapshotPath NOTIFY snapshotTaken)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString lastRecordingPath READ lastRecordingPath NOTIFY lastRecordingPathChanged)

public:
    explicit MediaManager(QObject *parent = nullptr);
    ~MediaManager();

    bool isRecording() const;
    QString lastSnapshotPath() const;
    QString status() const;
    QString lastRecordingPath() const;

    Q_INVOKABLE void startRecording(const QString &outputFolder = QString());
    Q_INVOKABLE void stopRecording();
    Q_INVOKABLE void takeSnapshot(const QString &outputFolder = QString());
    Q_INVOKABLE void setWindow(QQuickWindow* window);

signals:
    void recordingStateChanged();
    void recordingStarted();
    void recordingStopped();
    void snapshotTaken(const QString &filePath);
    void statusChanged();
    void lastRecordingPathChanged();
    void errorOccurred(const QString &error);

private slots:
    void onRecorderStateChanged(QMediaRecorder::RecorderState state);
    void onRecorderError(QMediaRecorder::Error error, const QString &errorString);

private:
    void setupRecorder();
    QString generateOutputPath(const QString &outputFolder, const QString &fileType);
    QPixmap captureWindow();

    QScreenCapture *m_screenCapture;
    QMediaCaptureSession *m_captureSession;
    QMediaRecorder *m_mediaRecorder;
    QPointer<QQuickWindow> m_window;
    bool m_isRecording;
    QString m_lastSnapshotPath;
    QString m_lastRecordingPath;
    QString m_status;
};
