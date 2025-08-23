#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "viewmodels/serialviewmodel.h"
#include "viewmodels/cameraviewmodel.h"
#include "viewmodels/mediamanagerviewmodel.h"
#include "viewmodels/mapviewmodel.h"
#include "viewmodels/thermalcameraviewmodel.h"
#include "models/joystickreceiver.h"
#include "models/serialworker.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Register SerialWorker data structures for queued connections
    qRegisterMetaType<SerialWorker::TelemetryData>("SerialWorker::TelemetryData");
    qRegisterMetaType<SerialWorker::TargetGPSData>("SerialWorker::TargetGPSData");
    qRegisterMetaType<SerialWorker::TrackedPoseData>("SerialWorker::TrackedPoseData");
    qRegisterMetaType<SerialWorker::ZoomFeedbackData>("SerialWorker::ZoomFeedbackData");
    qRegisterMetaType<SerialWorker::FrameInfoData>("SerialWorker::FrameInfoData");
    qRegisterMetaType<SerialWorker::AckData>("SerialWorker::AckData");
    qRegisterMetaType<SerialWorker::PIDGains>("SerialWorker::PIDGains");

    // Register QML types
    qmlRegisterType<SerialViewModel>("SerialApp", 1, 0, "SerialViewModel");
    qmlRegisterType<CameraViewModel>("SerialApp", 1, 0, "CameraViewModel");
    qmlRegisterType<MediaManagerViewModel>("SerialApp", 1, 0, "MediaManagerViewModel");
    qmlRegisterType<MapViewModel>("SerialApp", 1, 0, "MapViewModel");
    qmlRegisterType<ThermalCameraViewModel>("SerialApp", 1, 0, "ThermalCameraViewModel");
    qmlRegisterType<JoystickReceiver>("SerialApp", 1, 0, "JoystickReceiver");

    QQmlApplicationEngine engine;

    // Register image providers
    engine.addImageProvider("camera", new CameraImageProvider());
    engine.addImageProvider("thermal", new ThermalImageProvider());

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("untitled", "Main");

    return app.exec();
}
