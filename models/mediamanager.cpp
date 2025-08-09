#include "MediaManager.h"
#include <QDateTime>
#include <QDir>
#include <QDebug>
#include <QApplication>
#include <QStandardPaths>
#include <QQuickWindow>
#include <QWindow>

MediaManager::MediaManager(QObject *parent)
    : QObject(parent)
    , m_screenCapture(nullptr)
    , m_captureSession(nullptr)
    , m_mediaRecorder(nullptr)
    , m_window(nullptr)
    , m_isRecording(false)
    , m_status("Ready")
{
    setupRecorder();
}

MediaManager::~MediaManager()
{
    if (m_isRecording) {
        stopRecording();
    }
}

void MediaManager::setWindow(QQuickWindow* window)
{
    m_window = window;

    // Update screen capture to use the window's screen
    if (m_screenCapture && window) {
        m_screenCapture->setScreen(window->screen());
        qDebug() << "Window set for MediaManager, screen updated";
    }
}

void MediaManager::setupRecorder()
{
    // Create screen capture
    m_screenCapture = new QScreenCapture(this);

    // Create capture session
    m_captureSession = new QMediaCaptureSession(this);
    m_captureSession->setScreenCapture(m_screenCapture);

    // Create media recorder
    m_mediaRecorder = new QMediaRecorder(this);
    m_captureSession->setRecorder(m_mediaRecorder);

    // Connect signals
    connect(m_mediaRecorder, &QMediaRecorder::recorderStateChanged,
            this, &MediaManager::onRecorderStateChanged);
    connect(m_mediaRecorder, &QMediaRecorder::errorOccurred,
            this, &MediaManager::onRecorderError);

    // Set up the primary screen for capture initially
    QScreen *primaryScreen = QApplication::primaryScreen();
    if (primaryScreen) {
        m_screenCapture->setScreen(primaryScreen);
    }

    m_status = "Screen recorder initialized";
    emit statusChanged();
}

bool MediaManager::isRecording() const
{
    return m_isRecording;
}

QString MediaManager::lastSnapshotPath() const
{
    return m_lastSnapshotPath;
}

QString MediaManager::status() const
{
    return m_status;
}

QString MediaManager::lastRecordingPath() const
{
    return m_lastRecordingPath;
}

QPixmap MediaManager::captureWindow()
{
    if (!m_window) {
        qWarning() << "No window set for capture";
        return QPixmap();
    }

    // Get the window's screen
    QScreen *screen = m_window->screen();
    if (!screen) {
        qWarning() << "No screen available for window";
        return QPixmap();
    }

    // Get window geometry
    QRect windowGeometry = m_window->geometry();

    qDebug() << "Capturing window at:" << windowGeometry;

    // Capture the specific window area from the screen
    QPixmap screenshot = screen->grabWindow(0,
                                            windowGeometry.x(),
                                            windowGeometry.y(),
                                            windowGeometry.width(),
                                            windowGeometry.height());

    return screenshot;
}

void MediaManager::startRecording(const QString &outputFolder)
{
    if (m_isRecording) {
        qWarning() << "Already recording!";
        return;
    }

    if (!m_window) {
        emit errorOccurred("No window set for recording");
        return;
    }

    // Note: For window-specific recording, we would need to implement a custom solution
    // as QScreenCapture records the entire screen. For now, we'll record the full screen
    // but in a real implementation, you might want to use platform-specific APIs
    // or crop the recorded video to the window area in post-processing.

    // Generate output file path
    m_lastRecordingPath = generateOutputPath(outputFolder, "mp4");

    // Set output location
    m_mediaRecorder->setOutputLocation(QUrl::fromLocalFile(m_lastRecordingPath));

    // Set quality settings
    m_mediaRecorder->setQuality(QMediaRecorder::HighQuality);

    // Make sure we're using the correct screen
    if (m_window && m_window->screen()) {
        m_screenCapture->setScreen(m_window->screen());
    }

    // Start screen capture
    m_screenCapture->start();

    // Start recording
    m_mediaRecorder->record();

    m_status = "Starting window recording...";
    emit statusChanged();

    qDebug() << "Starting screen recording to:" << m_lastRecordingPath;
}

void MediaManager::stopRecording()
{
    if (!m_isRecording) {
        qWarning() << "Not currently recording!";
        return;
    }

    // Stop recording
    m_mediaRecorder->stop();

    // Stop screen capture
    m_screenCapture->stop();

    m_status = "Stopping recording...";
    emit statusChanged();

    qDebug() << "Stopping screen recording";
}

void MediaManager::takeSnapshot(const QString &outputFolder)
{
    if (!m_window) {
        emit errorOccurred("No window set for snapshot");
        return;
    }

    // Generate snapshot path
    m_lastSnapshotPath = generateOutputPath(outputFolder, "png");

    // Capture only the window area
    QPixmap screenshot = captureWindow();

    if (screenshot.isNull()) {
        emit errorOccurred("Failed to capture window");
        return;
    }

    // Save the screenshot
    if (screenshot.save(m_lastSnapshotPath, "PNG")) {
        m_status = "Screenshot saved to: " + m_lastSnapshotPath;
        emit snapshotTaken(m_lastSnapshotPath);
        emit statusChanged();
        qDebug() << "Window snapshot saved to:" << m_lastSnapshotPath;
    } else {
        qWarning() << "Failed to save snapshot to:" << m_lastSnapshotPath;
        emit errorOccurred("Failed to save snapshot");
    }
}

void MediaManager::onRecorderStateChanged(QMediaRecorder::RecorderState state)
{
    switch (state) {
    case QMediaRecorder::RecordingState:
        m_isRecording = true;
        m_status = "Recording window...";
        emit recordingStarted();
        break;
    case QMediaRecorder::StoppedState:
        m_isRecording = false;
        m_status = "Recording stopped. Saved to: " + m_lastRecordingPath;
        emit recordingStopped();
        emit lastRecordingPathChanged();
        break;
    case QMediaRecorder::PausedState:
        m_status = "Recording paused";
        break;
    }

    emit recordingStateChanged();
    emit statusChanged();
}

void MediaManager::onRecorderError(QMediaRecorder::Error error, const QString &errorString)
{
    Q_UNUSED(error)

    m_isRecording = false;
    m_status = "Recording error: " + errorString;

    emit recordingStateChanged();
    emit statusChanged();
    emit errorOccurred(errorString);

    qWarning() << "Recording error:" << errorString;
}

QString MediaManager::generateOutputPath(const QString &outputFolder, const QString &fileType)
{
    QString outputDir = outputFolder;

    // Use default folder if none specified
    if (outputDir.isEmpty()) {
        outputDir = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
        if (outputDir.isEmpty()) {
            outputDir = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
        }
    }

    // Create directory if it doesn't exist
    QDir dir(outputDir);
    if (!dir.exists()) {
        dir.mkpath(outputDir);
    }

    // Generate filename with timestamp
    QString timestamp = QDateTime::currentDateTime().toString("yyyy-MM-dd_hh-mm-ss");
    QString filename;

    if (fileType == "mp4") {
        filename = QString("app_recording_%1.mp4").arg(timestamp);
    } else if (fileType == "png") {
        filename = QString("app_screenshot_%1.png").arg(timestamp);
    } else {
        filename = QString("app_capture_%1.%2").arg(timestamp, fileType);
    }

    return dir.filePath(filename);
}
