
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "viewmodels/serialviewmodel.h"
#include "viewmodels/cameraviewmodel.h"
#include "viewmodels/mediamanagerviewmodel.h"
#include "viewmodels/mapviewmodel.h"
#include "viewmodels/thermalcameraviewmodel.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<SerialViewModel>("SerialApp", 1, 0, "SerialViewModel");
    qmlRegisterType<CameraViewModel>("SerialApp", 1, 0, "CameraViewModel");
    qmlRegisterType<MediaManagerViewModel>("SerialApp", 1, 0, "MediaManagerViewModel");
    qmlRegisterType<MapViewModel>("SerialApp", 1, 0, "MapViewModel");
    qmlRegisterType<ThermalCameraViewModel>("SerialApp", 1, 0, "ThermalCameraViewModel");

    QQmlApplicationEngine engine;

    // Add these lines with the other qmlRegisterType calls:

    // Update the engine.addImageProvider line to include thermal provider:
    // Register both image providers
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
