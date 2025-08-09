#include "MediaManagerViewModel.h"
#include <QDebug>
#include <QDir>
#include <QDateTime>
#include <QImage>
#include <QQuickWindow>


MediaManagerViewModel::MediaManagerViewModel(QObject *parent)
    : QObject(parent)
{
    // Connect MediaManager signals to ViewModel slots
    connect(&m_mediaManager, &MediaManager::recordingStarted,
            this, &MediaManagerViewModel::onRecordingStarted);
    connect(&m_mediaManager, &MediaManager::recordingStopped,
            this, &MediaManagerViewModel::onRecordingStopped);
    connect(&m_mediaManager, &MediaManager::snapshotTaken,
            this, &MediaManagerViewModel::onSnapshotTaken);
    connect(&m_mediaManager, &MediaManager::recordingStateChanged,
            this, &MediaManagerViewModel::recordingStateChanged);
    connect(&m_mediaManager, &MediaManager::statusChanged,
            this, &MediaManagerViewModel::onStatusChanged);
    connect(&m_mediaManager, &MediaManager::lastRecordingPathChanged,
            this, &MediaManagerViewModel::lastRecordingPathChanged);
    connect(&m_mediaManager, &MediaManager::errorOccurred,
            this, &MediaManagerViewModel::onErrorOccurred);
}

void MediaManagerViewModel::setWindow(QQuickWindow* window)
{
    m_window = window;
    m_mediaManager.setWindow(window);
    qDebug() << "Window set for MediaManagerViewModel";
}

void MediaManagerViewModel::startOrStopRecording(const QString &outputFolder)
{
    if (m_mediaManager.isRecording()) {
        qDebug() << "Stopping screen recording...";
        m_mediaManager.stopRecording();
    } else {
        qDebug() << "Starting screen recording to folder:" << outputFolder;
        m_mediaManager.startRecording(outputFolder);
    }
}

void MediaManagerViewModel::takeSnapshot(const QString &outputFolder)
{
    qDebug() << "Taking screenshot to folder:" << outputFolder;
    m_mediaManager.takeSnapshot(outputFolder);
}



bool MediaManagerViewModel::isRecording() const
{
    return m_mediaManager.isRecording();
}

QString MediaManagerViewModel::lastSnapshotPath() const
{
    return m_mediaManager.lastSnapshotPath();
}

QString MediaManagerViewModel::status() const
{
    return m_mediaManager.status();
}

QString MediaManagerViewModel::lastRecordingPath() const
{
    return m_mediaManager.lastRecordingPath();
}

// Slot implementations
void MediaManagerViewModel::onRecordingStarted()
{
    qDebug() << "ViewModel: Recording started";
}

void MediaManagerViewModel::onRecordingStopped()
{
    qDebug() << "ViewModel: Recording stopped";
    qDebug() << "Recording saved to:" << m_mediaManager.lastRecordingPath();
}

void MediaManagerViewModel::onSnapshotTaken(const QString &filePath)
{
    qDebug() << "ViewModel: Snapshot taken at:" << filePath;
    emit snapshotTaken(filePath);
}

void MediaManagerViewModel::onStatusChanged()
{
    emit statusChanged();
}

void MediaManagerViewModel::onErrorOccurred(const QString &error)
{
    qWarning() << "ViewModel: Error occurred:" << error;
    emit errorOccurred(error);
}
