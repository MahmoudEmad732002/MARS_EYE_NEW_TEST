cmake_minimum_required(VERSION 3.16)

project(untitled VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia)
find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS SerialPort)
find_package(Qt6 REQUIRED COMPONENTS Positioning)
find_package(Qt6 REQUIRED COMPONENTS Multimedia)
find_package(Qt6 REQUIRED COMPONENTS Core Quick Widgets SerialPort Multimedia MultimediaWidgets Location Positioning)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appuntitled
    main.cpp
)

qt_add_qml_module(appuntitled
    URI untitled
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES models/cameramodel.h models/cameramodel.cpp
        SOURCES models/mediamanager.h models/mediamanager.cpp
        SOURCES models/serialmodel.h models/serialmodel.cpp
        SOURCES models/thermalcameramodel.h models/thermalcameramodel.cpp
        SOURCES viewmodels/cameraviewmodel.h viewmodels/cameraviewmodel.cpp
        SOURCES viewmodels/mapviewmodel.h viewmodels/mapviewmodel.cpp
        SOURCES viewmodels/mediamanagerviewmodel.h viewmodels/mediamanagerviewmodel.cpp
        SOURCES viewmodels/serialviewmodel.h viewmodels/serialviewmodel.cpp
        SOURCES viewmodels/thermalcameraviewmodel.h viewmodels/thermalcameraviewmodel.cpp

        QML_FILES view/TelemetryPanel.qml
        QML_FILES view/ControlsPanel.qml
        QML_FILES view/MapPanel.qml
         QML_FILES view/CapturePanel.qml

        QML_FILES view/TelemetryPanel.qml
        QML_FILES view/TopBar.qml
        QML_FILES
        QML_FILES view/CameraControlBar.qml
        SOURCES
        SOURCES models/joystickreceiver.h models/joystickreceiver.cpp
        SOURCES models/serialworker.h models/serialworker.cpp


)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appuntitled PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appuntitled
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appuntitled
    PRIVATE Qt6::Quick
            PRIVATE     Qt6::Widgets
                Qt6::SerialPort
                Qt6::Multimedia
                Qt6::MultimediaWidgets
  Qt6::Multimedia
                   Qt6::Gui
                Qt6::Location
                Qt6::Positioning
)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)
target_link_libraries(appuntitled PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS appuntitled
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
