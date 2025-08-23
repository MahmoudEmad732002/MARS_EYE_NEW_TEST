/****************************************************************************
** Meta object code from reading C++ file 'serialviewmodel.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../viewmodels/serialviewmodel.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'serialviewmodel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN15SerialViewModelE_t {};
} // unnamed namespace

template <> constexpr inline auto SerialViewModel::qt_create_metaobjectdata<qt_meta_tag_ZN15SerialViewModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "SerialViewModel",
        "availablePortsChanged",
        "",
        "connectedChanged",
        "telemetryChanged",
        "targetGPSChanged",
        "trackedPoseChanged",
        "zoomFeedbackChanged",
        "frameInfoChanged",
        "acknowledgmentChanged",
        "statusMessageChanged",
        "joystickChanged",
        "joystickActiveChanged",
        "pidGainsChanged",
        "zoomLevelChanged",
        "targetChanged",
        "absolutePointingChanged",
        "absolutePointingActiveChanged",
        "onConnectionStatusChanged",
        "connected",
        "onTelemetryDataReceived",
        "SerialWorker::TelemetryData",
        "data",
        "onTargetGPSReceived",
        "SerialWorker::TargetGPSData",
        "onTrackedPoseReceived",
        "SerialWorker::TrackedPoseData",
        "onZoomFeedbackReceived",
        "SerialWorker::ZoomFeedbackData",
        "onFrameInfoReceived",
        "SerialWorker::FrameInfoData",
        "onAcknowledgmentReceived",
        "SerialWorker::AckData",
        "onErrorOccurred",
        "error",
        "onMessageSent",
        "messageType",
        "onAvailablePortsReady",
        "ports",
        "connectToSerial",
        "portName",
        "baudRate",
        "refreshPorts",
        "sendPitchYaw",
        "startJoystickCommand",
        "stopJoystickCommand",
        "sendSoftwareJoystickCommand",
        "x",
        "y",
        "sendJoystickUp",
        "sendJoystickDown",
        "sendJoystickLeft",
        "sendJoystickRight",
        "sendPIDGains",
        "sendZoomCommand",
        "sendSelectTarget",
        "startAbsolutePointing",
        "stopAbsolutePointing",
        "sendRequestGains",
        "sendFrameInfoAndGains",
        "frameW",
        "frameH",
        "frameNum",
        "updateSoftwareJoystick",
        "availablePorts",
        "baudRates",
        "connectButtonText",
        "connectButtonColor",
        "statusMessage",
        "gimbalRoll",
        "gimbalPitch",
        "gimbalYaw",
        "yawMotorPose",
        "pitchMotorPose",
        "gimbalPoseLat",
        "gimbalPoseLon",
        "gimbalPoseAlt",
        "battery",
        "signalStrength",
        "targetPoseLat",
        "targetPoseLon",
        "targetPoseAlt",
        "targetTrackedPoseXp",
        "targetTrackedPoseYp",
        "zoomFeedback",
        "frameWidth",
        "frameHeight",
        "receivedAzKp",
        "receivedAzKi",
        "receivedElKp",
        "receivedElKi",
        "lastAcknowledgedMessageId",
        "joystickX",
        "joystickY",
        "joystickResetFlag",
        "joystickActive",
        "azimuthKp",
        "azimuthKi",
        "elevationKp",
        "elevationKi",
        "zoomLevel",
        "zoomResetFlag",
        "targetX",
        "targetY",
        "frameNumber",
        "pitchAngle",
        "yawAngle",
        "stabilizationFlag",
        "absolutePointingActive"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'availablePortsChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'connectedChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'telemetryChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'targetGPSChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'trackedPoseChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'zoomFeedbackChanged'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'frameInfoChanged'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'acknowledgmentChanged'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'statusMessageChanged'
        QtMocHelpers::SignalData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'joystickChanged'
        QtMocHelpers::SignalData<void()>(11, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'joystickActiveChanged'
        QtMocHelpers::SignalData<void()>(12, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'pidGainsChanged'
        QtMocHelpers::SignalData<void()>(13, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'zoomLevelChanged'
        QtMocHelpers::SignalData<void()>(14, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'targetChanged'
        QtMocHelpers::SignalData<void()>(15, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'absolutePointingChanged'
        QtMocHelpers::SignalData<void()>(16, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'absolutePointingActiveChanged'
        QtMocHelpers::SignalData<void()>(17, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'onConnectionStatusChanged'
        QtMocHelpers::SlotData<void(bool)>(18, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Bool, 19 },
        }}),
        // Slot 'onTelemetryDataReceived'
        QtMocHelpers::SlotData<void(const SerialWorker::TelemetryData &)>(20, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 21, 22 },
        }}),
        // Slot 'onTargetGPSReceived'
        QtMocHelpers::SlotData<void(const SerialWorker::TargetGPSData &)>(23, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 24, 22 },
        }}),
        // Slot 'onTrackedPoseReceived'
        QtMocHelpers::SlotData<void(const SerialWorker::TrackedPoseData &)>(25, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 26, 22 },
        }}),
        // Slot 'onZoomFeedbackReceived'
        QtMocHelpers::SlotData<void(const SerialWorker::ZoomFeedbackData &)>(27, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 28, 22 },
        }}),
        // Slot 'onFrameInfoReceived'
        QtMocHelpers::SlotData<void(const SerialWorker::FrameInfoData &)>(29, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 30, 22 },
        }}),
        // Slot 'onAcknowledgmentReceived'
        QtMocHelpers::SlotData<void(const SerialWorker::AckData &)>(31, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 32, 22 },
        }}),
        // Slot 'onErrorOccurred'
        QtMocHelpers::SlotData<void(const QString &)>(33, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QString, 34 },
        }}),
        // Slot 'onMessageSent'
        QtMocHelpers::SlotData<void(const QString &)>(35, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QString, 36 },
        }}),
        // Slot 'onAvailablePortsReady'
        QtMocHelpers::SlotData<void(const QStringList &)>(37, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QStringList, 38 },
        }}),
        // Method 'connectToSerial'
        QtMocHelpers::MethodData<void(const QString &, int)>(39, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 40 }, { QMetaType::Int, 41 },
        }}),
        // Method 'refreshPorts'
        QtMocHelpers::MethodData<void()>(42, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendPitchYaw'
        QtMocHelpers::MethodData<void()>(43, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'startJoystickCommand'
        QtMocHelpers::MethodData<void()>(44, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'stopJoystickCommand'
        QtMocHelpers::MethodData<void()>(45, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendSoftwareJoystickCommand'
        QtMocHelpers::MethodData<void(int, int)>(46, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 47 }, { QMetaType::Int, 48 },
        }}),
        // Method 'sendJoystickUp'
        QtMocHelpers::MethodData<void()>(49, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendJoystickDown'
        QtMocHelpers::MethodData<void()>(50, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendJoystickLeft'
        QtMocHelpers::MethodData<void()>(51, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendJoystickRight'
        QtMocHelpers::MethodData<void()>(52, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendPIDGains'
        QtMocHelpers::MethodData<void()>(53, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendZoomCommand'
        QtMocHelpers::MethodData<void()>(54, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendSelectTarget'
        QtMocHelpers::MethodData<void()>(55, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'startAbsolutePointing'
        QtMocHelpers::MethodData<void()>(56, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'stopAbsolutePointing'
        QtMocHelpers::MethodData<void()>(57, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendRequestGains'
        QtMocHelpers::MethodData<void()>(58, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendFrameInfoAndGains'
        QtMocHelpers::MethodData<void(int, int)>(59, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 60 }, { QMetaType::Int, 61 },
        }}),
        // Method 'sendSelectTarget'
        QtMocHelpers::MethodData<void(int, int, int)>(55, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 47 }, { QMetaType::Int, 48 }, { QMetaType::Int, 62 },
        }}),
        // Method 'updateSoftwareJoystick'
        QtMocHelpers::MethodData<void(int, int)>(63, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 47 }, { QMetaType::Int, 48 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'availablePorts'
        QtMocHelpers::PropertyData<QStringList>(64, QMetaType::QStringList, QMC::DefaultPropertyFlags, 0),
        // property 'baudRates'
        QtMocHelpers::PropertyData<QStringList>(65, QMetaType::QStringList, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'connected'
        QtMocHelpers::PropertyData<bool>(19, QMetaType::Bool, QMC::DefaultPropertyFlags, 1),
        // property 'connectButtonText'
        QtMocHelpers::PropertyData<QString>(66, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'connectButtonColor'
        QtMocHelpers::PropertyData<QString>(67, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'statusMessage'
        QtMocHelpers::PropertyData<QString>(68, QMetaType::QString, QMC::DefaultPropertyFlags, 8),
        // property 'gimbalRoll'
        QtMocHelpers::PropertyData<int>(69, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'gimbalPitch'
        QtMocHelpers::PropertyData<int>(70, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'gimbalYaw'
        QtMocHelpers::PropertyData<int>(71, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'yawMotorPose'
        QtMocHelpers::PropertyData<int>(72, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'pitchMotorPose'
        QtMocHelpers::PropertyData<int>(73, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'gimbalPoseLat'
        QtMocHelpers::PropertyData<double>(74, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'gimbalPoseLon'
        QtMocHelpers::PropertyData<double>(75, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'gimbalPoseAlt'
        QtMocHelpers::PropertyData<double>(76, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'battery'
        QtMocHelpers::PropertyData<int>(77, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'signalStrength'
        QtMocHelpers::PropertyData<int>(78, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'targetPoseLat'
        QtMocHelpers::PropertyData<double>(79, QMetaType::Double, QMC::DefaultPropertyFlags, 3),
        // property 'targetPoseLon'
        QtMocHelpers::PropertyData<double>(80, QMetaType::Double, QMC::DefaultPropertyFlags, 3),
        // property 'targetPoseAlt'
        QtMocHelpers::PropertyData<double>(81, QMetaType::Double, QMC::DefaultPropertyFlags, 3),
        // property 'targetTrackedPoseXp'
        QtMocHelpers::PropertyData<int>(82, QMetaType::Int, QMC::DefaultPropertyFlags, 4),
        // property 'targetTrackedPoseYp'
        QtMocHelpers::PropertyData<int>(83, QMetaType::Int, QMC::DefaultPropertyFlags, 4),
        // property 'zoomFeedback'
        QtMocHelpers::PropertyData<int>(84, QMetaType::Int, QMC::DefaultPropertyFlags, 5),
        // property 'frameWidth'
        QtMocHelpers::PropertyData<int>(85, QMetaType::Int, QMC::DefaultPropertyFlags, 6),
        // property 'frameHeight'
        QtMocHelpers::PropertyData<int>(86, QMetaType::Int, QMC::DefaultPropertyFlags, 6),
        // property 'receivedAzKp'
        QtMocHelpers::PropertyData<int>(87, QMetaType::Int, QMC::DefaultPropertyFlags, 6),
        // property 'receivedAzKi'
        QtMocHelpers::PropertyData<int>(88, QMetaType::Int, QMC::DefaultPropertyFlags, 6),
        // property 'receivedElKp'
        QtMocHelpers::PropertyData<int>(89, QMetaType::Int, QMC::DefaultPropertyFlags, 6),
        // property 'receivedElKi'
        QtMocHelpers::PropertyData<int>(90, QMetaType::Int, QMC::DefaultPropertyFlags, 6),
        // property 'lastAcknowledgedMessageId'
        QtMocHelpers::PropertyData<int>(91, QMetaType::Int, QMC::DefaultPropertyFlags, 7),
        // property 'joystickX'
        QtMocHelpers::PropertyData<int>(92, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 9),
        // property 'joystickY'
        QtMocHelpers::PropertyData<int>(93, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 9),
        // property 'joystickResetFlag'
        QtMocHelpers::PropertyData<int>(94, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 9),
        // property 'joystickActive'
        QtMocHelpers::PropertyData<bool>(95, QMetaType::Bool, QMC::DefaultPropertyFlags, 10),
        // property 'azimuthKp'
        QtMocHelpers::PropertyData<int>(96, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 11),
        // property 'azimuthKi'
        QtMocHelpers::PropertyData<int>(97, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 11),
        // property 'elevationKp'
        QtMocHelpers::PropertyData<int>(98, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 11),
        // property 'elevationKi'
        QtMocHelpers::PropertyData<int>(99, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 11),
        // property 'zoomLevel'
        QtMocHelpers::PropertyData<int>(100, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 12),
        // property 'zoomResetFlag'
        QtMocHelpers::PropertyData<int>(101, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 12),
        // property 'targetX'
        QtMocHelpers::PropertyData<int>(102, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 13),
        // property 'targetY'
        QtMocHelpers::PropertyData<int>(103, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 13),
        // property 'frameNumber'
        QtMocHelpers::PropertyData<int>(104, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 13),
        // property 'pitchAngle'
        QtMocHelpers::PropertyData<double>(105, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 14),
        // property 'yawAngle'
        QtMocHelpers::PropertyData<double>(106, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 14),
        // property 'stabilizationFlag'
        QtMocHelpers::PropertyData<int>(107, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 14),
        // property 'absolutePointingActive'
        QtMocHelpers::PropertyData<bool>(108, QMetaType::Bool, QMC::DefaultPropertyFlags, 15),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<SerialViewModel, qt_meta_tag_ZN15SerialViewModelE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject SerialViewModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15SerialViewModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15SerialViewModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN15SerialViewModelE_t>.metaTypes,
    nullptr
} };

void SerialViewModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<SerialViewModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->availablePortsChanged(); break;
        case 1: _t->connectedChanged(); break;
        case 2: _t->telemetryChanged(); break;
        case 3: _t->targetGPSChanged(); break;
        case 4: _t->trackedPoseChanged(); break;
        case 5: _t->zoomFeedbackChanged(); break;
        case 6: _t->frameInfoChanged(); break;
        case 7: _t->acknowledgmentChanged(); break;
        case 8: _t->statusMessageChanged(); break;
        case 9: _t->joystickChanged(); break;
        case 10: _t->joystickActiveChanged(); break;
        case 11: _t->pidGainsChanged(); break;
        case 12: _t->zoomLevelChanged(); break;
        case 13: _t->targetChanged(); break;
        case 14: _t->absolutePointingChanged(); break;
        case 15: _t->absolutePointingActiveChanged(); break;
        case 16: _t->onConnectionStatusChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 17: _t->onTelemetryDataReceived((*reinterpret_cast< std::add_pointer_t<SerialWorker::TelemetryData>>(_a[1]))); break;
        case 18: _t->onTargetGPSReceived((*reinterpret_cast< std::add_pointer_t<SerialWorker::TargetGPSData>>(_a[1]))); break;
        case 19: _t->onTrackedPoseReceived((*reinterpret_cast< std::add_pointer_t<SerialWorker::TrackedPoseData>>(_a[1]))); break;
        case 20: _t->onZoomFeedbackReceived((*reinterpret_cast< std::add_pointer_t<SerialWorker::ZoomFeedbackData>>(_a[1]))); break;
        case 21: _t->onFrameInfoReceived((*reinterpret_cast< std::add_pointer_t<SerialWorker::FrameInfoData>>(_a[1]))); break;
        case 22: _t->onAcknowledgmentReceived((*reinterpret_cast< std::add_pointer_t<SerialWorker::AckData>>(_a[1]))); break;
        case 23: _t->onErrorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 24: _t->onMessageSent((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 25: _t->onAvailablePortsReady((*reinterpret_cast< std::add_pointer_t<QStringList>>(_a[1]))); break;
        case 26: _t->connectToSerial((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 27: _t->refreshPorts(); break;
        case 28: _t->sendPitchYaw(); break;
        case 29: _t->startJoystickCommand(); break;
        case 30: _t->stopJoystickCommand(); break;
        case 31: _t->sendSoftwareJoystickCommand((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 32: _t->sendJoystickUp(); break;
        case 33: _t->sendJoystickDown(); break;
        case 34: _t->sendJoystickLeft(); break;
        case 35: _t->sendJoystickRight(); break;
        case 36: _t->sendPIDGains(); break;
        case 37: _t->sendZoomCommand(); break;
        case 38: _t->sendSelectTarget(); break;
        case 39: _t->startAbsolutePointing(); break;
        case 40: _t->stopAbsolutePointing(); break;
        case 41: _t->sendRequestGains(); break;
        case 42: _t->sendFrameInfoAndGains((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 43: _t->sendSelectTarget((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[3]))); break;
        case 44: _t->updateSoftwareJoystick((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::availablePortsChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::connectedChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::telemetryChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::targetGPSChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::trackedPoseChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::zoomFeedbackChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::frameInfoChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::acknowledgmentChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::statusMessageChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::joystickChanged, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::joystickActiveChanged, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::pidGainsChanged, 11))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::zoomLevelChanged, 12))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::targetChanged, 13))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::absolutePointingChanged, 14))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::absolutePointingActiveChanged, 15))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QStringList*>(_v) = _t->availablePorts(); break;
        case 1: *reinterpret_cast<QStringList*>(_v) = _t->baudRates(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->connected(); break;
        case 3: *reinterpret_cast<QString*>(_v) = _t->connectButtonText(); break;
        case 4: *reinterpret_cast<QString*>(_v) = _t->connectButtonColor(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->statusMessage(); break;
        case 6: *reinterpret_cast<int*>(_v) = _t->gimbalRoll(); break;
        case 7: *reinterpret_cast<int*>(_v) = _t->gimbalPitch(); break;
        case 8: *reinterpret_cast<int*>(_v) = _t->gimbalYaw(); break;
        case 9: *reinterpret_cast<int*>(_v) = _t->yawMotorPose(); break;
        case 10: *reinterpret_cast<int*>(_v) = _t->pitchMotorPose(); break;
        case 11: *reinterpret_cast<double*>(_v) = _t->gimbalPoseLat(); break;
        case 12: *reinterpret_cast<double*>(_v) = _t->gimbalPoseLon(); break;
        case 13: *reinterpret_cast<double*>(_v) = _t->gimbalPoseAlt(); break;
        case 14: *reinterpret_cast<int*>(_v) = _t->battery(); break;
        case 15: *reinterpret_cast<int*>(_v) = _t->signalStrength(); break;
        case 16: *reinterpret_cast<double*>(_v) = _t->targetPoseLat(); break;
        case 17: *reinterpret_cast<double*>(_v) = _t->targetPoseLon(); break;
        case 18: *reinterpret_cast<double*>(_v) = _t->targetPoseAlt(); break;
        case 19: *reinterpret_cast<int*>(_v) = _t->targetTrackedPoseXp(); break;
        case 20: *reinterpret_cast<int*>(_v) = _t->targetTrackedPoseYp(); break;
        case 21: *reinterpret_cast<int*>(_v) = _t->zoomFeedback(); break;
        case 22: *reinterpret_cast<int*>(_v) = _t->frameWidth(); break;
        case 23: *reinterpret_cast<int*>(_v) = _t->frameHeight(); break;
        case 24: *reinterpret_cast<int*>(_v) = _t->receivedAzKp(); break;
        case 25: *reinterpret_cast<int*>(_v) = _t->receivedAzKi(); break;
        case 26: *reinterpret_cast<int*>(_v) = _t->receivedElKp(); break;
        case 27: *reinterpret_cast<int*>(_v) = _t->receivedElKi(); break;
        case 28: *reinterpret_cast<int*>(_v) = _t->lastAcknowledgedMessageId(); break;
        case 29: *reinterpret_cast<int*>(_v) = _t->joystickX(); break;
        case 30: *reinterpret_cast<int*>(_v) = _t->joystickY(); break;
        case 31: *reinterpret_cast<int*>(_v) = _t->joystickResetFlag(); break;
        case 32: *reinterpret_cast<bool*>(_v) = _t->joystickActive(); break;
        case 33: *reinterpret_cast<int*>(_v) = _t->azimuthKp(); break;
        case 34: *reinterpret_cast<int*>(_v) = _t->azimuthKi(); break;
        case 35: *reinterpret_cast<int*>(_v) = _t->elevationKp(); break;
        case 36: *reinterpret_cast<int*>(_v) = _t->elevationKi(); break;
        case 37: *reinterpret_cast<int*>(_v) = _t->zoomLevel(); break;
        case 38: *reinterpret_cast<int*>(_v) = _t->zoomResetFlag(); break;
        case 39: *reinterpret_cast<int*>(_v) = _t->targetX(); break;
        case 40: *reinterpret_cast<int*>(_v) = _t->targetY(); break;
        case 41: *reinterpret_cast<int*>(_v) = _t->frameNumber(); break;
        case 42: *reinterpret_cast<double*>(_v) = _t->pitchAngle(); break;
        case 43: *reinterpret_cast<double*>(_v) = _t->yawAngle(); break;
        case 44: *reinterpret_cast<int*>(_v) = _t->stabilizationFlag(); break;
        case 45: *reinterpret_cast<bool*>(_v) = _t->absolutePointingActive(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 29: _t->setJoystickX(*reinterpret_cast<int*>(_v)); break;
        case 30: _t->setJoystickY(*reinterpret_cast<int*>(_v)); break;
        case 31: _t->setJoystickResetFlag(*reinterpret_cast<int*>(_v)); break;
        case 33: _t->setAzimuthKp(*reinterpret_cast<int*>(_v)); break;
        case 34: _t->setAzimuthKi(*reinterpret_cast<int*>(_v)); break;
        case 35: _t->setElevationKp(*reinterpret_cast<int*>(_v)); break;
        case 36: _t->setElevationKi(*reinterpret_cast<int*>(_v)); break;
        case 37: _t->setZoomLevel(*reinterpret_cast<int*>(_v)); break;
        case 38: _t->setZoomResetFlag(*reinterpret_cast<int*>(_v)); break;
        case 39: _t->setTargetX(*reinterpret_cast<int*>(_v)); break;
        case 40: _t->setTargetY(*reinterpret_cast<int*>(_v)); break;
        case 41: _t->setFrameNumber(*reinterpret_cast<int*>(_v)); break;
        case 42: _t->setPitchAngle(*reinterpret_cast<double*>(_v)); break;
        case 43: _t->setYawAngle(*reinterpret_cast<double*>(_v)); break;
        case 44: _t->setStabilizationFlag(*reinterpret_cast<int*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *SerialViewModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SerialViewModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15SerialViewModelE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SerialViewModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 45)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 45;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 45)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 45;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 46;
    }
    return _id;
}

// SIGNAL 0
void SerialViewModel::availablePortsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void SerialViewModel::connectedChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void SerialViewModel::telemetryChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void SerialViewModel::targetGPSChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void SerialViewModel::trackedPoseChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void SerialViewModel::zoomFeedbackChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void SerialViewModel::frameInfoChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void SerialViewModel::acknowledgmentChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void SerialViewModel::statusMessageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}

// SIGNAL 9
void SerialViewModel::joystickChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void SerialViewModel::joystickActiveChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 10, nullptr);
}

// SIGNAL 11
void SerialViewModel::pidGainsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 11, nullptr);
}

// SIGNAL 12
void SerialViewModel::zoomLevelChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 12, nullptr);
}

// SIGNAL 13
void SerialViewModel::targetChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 13, nullptr);
}

// SIGNAL 14
void SerialViewModel::absolutePointingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 14, nullptr);
}

// SIGNAL 15
void SerialViewModel::absolutePointingActiveChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 15, nullptr);
}
QT_WARNING_POP
