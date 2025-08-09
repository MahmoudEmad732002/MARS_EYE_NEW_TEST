#pragma once
#include <QObject>
#include <QString>
#include <QPointer>
#include "models/MediaManager.h"

class QQuickWindow;

class MediaManagerViewModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRecording READ isRecording NOTIFY recordingStateChanged)
    Q_PROPERTY(QString lastSnapshotPath READ lastSnapshotPath NOTIFY snapshotTaken)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString lastRecordingPath READ lastRecordingPath NOTIFY lastRecordingPathChanged)

public:
    explicit MediaManagerViewModel(QObject *parent = nullptr);

    Q_INVOKABLE void startOrStopRecording(const QString &outputFolder);
    Q_INVOKABLE void takeSnapshot(const QString &outputFolder);
    Q_INVOKABLE void setWindow(QQuickWindow* window);

    bool isRecording() const;
    QString lastSnapshotPath() const;
    QString status() const;
    QString lastRecordingPath() const;

signals:
    void recordingStateChanged();
    void snapshotTaken(const QString &filePath);
    void statusChanged();
    void lastRecordingPathChanged();
    void errorOccurred(const QString &error);

private slots:
    void onRecordingStarted();
    void onRecordingStopped();
    void onSnapshotTaken(const QString &filePath);
    void onStatusChanged();
    void onErrorOccurred(const QString &error);

private:
    MediaManager m_mediaManager;
    QPointer<QQuickWindow> m_window;
};
