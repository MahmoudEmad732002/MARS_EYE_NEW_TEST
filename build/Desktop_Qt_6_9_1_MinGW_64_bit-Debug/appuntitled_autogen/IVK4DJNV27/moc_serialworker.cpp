/****************************************************************************
** Meta object code from reading C++ file 'serialworker.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../models/serialworker.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'serialworker.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12SerialWorkerE_t {};
} // unnamed namespace

template <> constexpr inline auto SerialWorker::qt_create_metaobjectdata<qt_meta_tag_ZN12SerialWorkerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "SerialWorker",
        "connectionStatusChanged",
        "",
        "connected",
        "telemetryDataReceived",
        "TelemetryData",
        "data",
        "targetGPSReceived",
        "TargetGPSData",
        "trackedPoseReceived",
        "TrackedPoseData",
        "zoomFeedbackReceived",
        "ZoomFeedbackData",
        "frameInfoReceived",
        "FrameInfoData",
        "acknowledgmentReceived",
        "AckData",
        "errorOccurred",
        "error",
        "messageSent",
        "messageType",
        "availablePortsReady",
        "ports",
        "initializeSerial",
        "getAvailablePorts",
        "connectToPort",
        "portName",
        "baudRate",
        "disconnectFromPort",
        "sendJoystickCommand",
        "joyX",
        "joyY",
        "resetFlag",
        "stopJoystickCommand",
        "sendPIDGains",
        "PIDGains",
        "gains",
        "sendZoomCommand",
        "zoomCmd",
        "zoomResetFlag",
        "sendSelectTarget",
        "targetXp",
        "targetYp",
        "frameNumber",
        "sendAbsolutePointing",
        "pitchAngleCmd",
        "yawAngleCmd",
        "stabilizationFlag",
        "stopAbsolutePointing",
        "sendRequestGains",
        "sendFrameInfoAndGains",
        "frameW",
        "frameH",
        "readData",
        "handleError",
        "QSerialPort::SerialPortError",
        "sendContinuousMessage"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'connectionStatusChanged'
        QtMocHelpers::SignalData<void(bool)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 3 },
        }}),
        // Signal 'telemetryDataReceived'
        QtMocHelpers::SignalData<void(const TelemetryData &)>(4, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 5, 6 },
        }}),
        // Signal 'targetGPSReceived'
        QtMocHelpers::SignalData<void(const TargetGPSData &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 8, 6 },
        }}),
        // Signal 'trackedPoseReceived'
        QtMocHelpers::SignalData<void(const TrackedPoseData &)>(9, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 10, 6 },
        }}),
        // Signal 'zoomFeedbackReceived'
        QtMocHelpers::SignalData<void(const ZoomFeedbackData &)>(11, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 12, 6 },
        }}),
        // Signal 'frameInfoReceived'
        QtMocHelpers::SignalData<void(const FrameInfoData &)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 14, 6 },
        }}),
        // Signal 'acknowledgmentReceived'
        QtMocHelpers::SignalData<void(const AckData &)>(15, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 16, 6 },
        }}),
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(const QString &)>(17, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 18 },
        }}),
        // Signal 'messageSent'
        QtMocHelpers::SignalData<void(const QString &)>(19, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 20 },
        }}),
        // Signal 'availablePortsReady'
        QtMocHelpers::SignalData<void(const QStringList &)>(21, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QStringList, 22 },
        }}),
        // Slot 'initializeSerial'
        QtMocHelpers::SlotData<void()>(23, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'getAvailablePorts'
        QtMocHelpers::SlotData<void()>(24, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'connectToPort'
        QtMocHelpers::SlotData<void(const QString &, int)>(25, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 26 }, { QMetaType::Int, 27 },
        }}),
        // Slot 'disconnectFromPort'
        QtMocHelpers::SlotData<void()>(28, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'sendJoystickCommand'
        QtMocHelpers::SlotData<void(quint8, quint8, quint8)>(29, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::UChar, 30 }, { QMetaType::UChar, 31 }, { QMetaType::UChar, 32 },
        }}),
        // Slot 'stopJoystickCommand'
        QtMocHelpers::SlotData<void()>(33, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'sendPIDGains'
        QtMocHelpers::SlotData<void(const PIDGains &)>(34, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 35, 36 },
        }}),
        // Slot 'sendZoomCommand'
        QtMocHelpers::SlotData<void(quint8, quint8)>(37, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::UChar, 38 }, { QMetaType::UChar, 39 },
        }}),
        // Slot 'sendSelectTarget'
        QtMocHelpers::SlotData<void(quint16, quint16, quint16, quint8)>(40, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::UShort, 41 }, { QMetaType::UShort, 42 }, { QMetaType::UShort, 43 }, { QMetaType::UChar, 32 },
        }}),
        // Slot 'sendAbsolutePointing'
        QtMocHelpers::SlotData<void(quint16, quint16, quint8)>(44, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::UShort, 45 }, { QMetaType::UShort, 46 }, { QMetaType::UChar, 47 },
        }}),
        // Slot 'stopAbsolutePointing'
        QtMocHelpers::SlotData<void()>(48, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'sendRequestGains'
        QtMocHelpers::SlotData<void()>(49, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'sendFrameInfoAndGains'
        QtMocHelpers::SlotData<void(quint16, quint16, const PIDGains &)>(50, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::UShort, 51 }, { QMetaType::UShort, 52 }, { 0x80000000 | 35, 36 },
        }}),
        // Slot 'readData'
        QtMocHelpers::SlotData<void()>(53, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'handleError'
        QtMocHelpers::SlotData<void(QSerialPort::SerialPortError)>(54, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 55, 18 },
        }}),
        // Slot 'sendContinuousMessage'
        QtMocHelpers::SlotData<void()>(56, 2, QMC::AccessPrivate, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<SerialWorker, qt_meta_tag_ZN12SerialWorkerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject SerialWorker::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12SerialWorkerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12SerialWorkerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12SerialWorkerE_t>.metaTypes,
    nullptr
} };

void SerialWorker::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<SerialWorker *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->connectionStatusChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 1: _t->telemetryDataReceived((*reinterpret_cast< std::add_pointer_t<TelemetryData>>(_a[1]))); break;
        case 2: _t->targetGPSReceived((*reinterpret_cast< std::add_pointer_t<TargetGPSData>>(_a[1]))); break;
        case 3: _t->trackedPoseReceived((*reinterpret_cast< std::add_pointer_t<TrackedPoseData>>(_a[1]))); break;
        case 4: _t->zoomFeedbackReceived((*reinterpret_cast< std::add_pointer_t<ZoomFeedbackData>>(_a[1]))); break;
        case 5: _t->frameInfoReceived((*reinterpret_cast< std::add_pointer_t<FrameInfoData>>(_a[1]))); break;
        case 6: _t->acknowledgmentReceived((*reinterpret_cast< std::add_pointer_t<AckData>>(_a[1]))); break;
        case 7: _t->errorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 8: _t->messageSent((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 9: _t->availablePortsReady((*reinterpret_cast< std::add_pointer_t<QStringList>>(_a[1]))); break;
        case 10: _t->initializeSerial(); break;
        case 11: _t->getAvailablePorts(); break;
        case 12: _t->connectToPort((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 13: _t->disconnectFromPort(); break;
        case 14: _t->sendJoystickCommand((*reinterpret_cast< std::add_pointer_t<quint8>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint8>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<quint8>>(_a[3]))); break;
        case 15: _t->stopJoystickCommand(); break;
        case 16: _t->sendPIDGains((*reinterpret_cast< std::add_pointer_t<PIDGains>>(_a[1]))); break;
        case 17: _t->sendZoomCommand((*reinterpret_cast< std::add_pointer_t<quint8>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint8>>(_a[2]))); break;
        case 18: _t->sendSelectTarget((*reinterpret_cast< std::add_pointer_t<quint16>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint16>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<quint16>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<quint8>>(_a[4]))); break;
        case 19: _t->sendAbsolutePointing((*reinterpret_cast< std::add_pointer_t<quint16>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint16>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<quint8>>(_a[3]))); break;
        case 20: _t->stopAbsolutePointing(); break;
        case 21: _t->sendRequestGains(); break;
        case 22: _t->sendFrameInfoAndGains((*reinterpret_cast< std::add_pointer_t<quint16>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint16>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<PIDGains>>(_a[3]))); break;
        case 23: _t->readData(); break;
        case 24: _t->handleError((*reinterpret_cast< std::add_pointer_t<QSerialPort::SerialPortError>>(_a[1]))); break;
        case 25: _t->sendContinuousMessage(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(bool )>(_a, &SerialWorker::connectionStatusChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const TelemetryData & )>(_a, &SerialWorker::telemetryDataReceived, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const TargetGPSData & )>(_a, &SerialWorker::targetGPSReceived, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const TrackedPoseData & )>(_a, &SerialWorker::trackedPoseReceived, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const ZoomFeedbackData & )>(_a, &SerialWorker::zoomFeedbackReceived, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const FrameInfoData & )>(_a, &SerialWorker::frameInfoReceived, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const AckData & )>(_a, &SerialWorker::acknowledgmentReceived, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const QString & )>(_a, &SerialWorker::errorOccurred, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const QString & )>(_a, &SerialWorker::messageSent, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialWorker::*)(const QStringList & )>(_a, &SerialWorker::availablePortsReady, 9))
            return;
    }
}

const QMetaObject *SerialWorker::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SerialWorker::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12SerialWorkerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SerialWorker::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 26)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 26;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 26)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 26;
    }
    return _id;
}

// SIGNAL 0
void SerialWorker::connectionStatusChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void SerialWorker::telemetryDataReceived(const TelemetryData & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void SerialWorker::targetGPSReceived(const TargetGPSData & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void SerialWorker::trackedPoseReceived(const TrackedPoseData & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void SerialWorker::zoomFeedbackReceived(const ZoomFeedbackData & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1);
}

// SIGNAL 5
void SerialWorker::frameInfoReceived(const FrameInfoData & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1);
}

// SIGNAL 6
void SerialWorker::acknowledgmentReceived(const AckData & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void SerialWorker::errorOccurred(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}

// SIGNAL 8
void SerialWorker::messageSent(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1);
}

// SIGNAL 9
void SerialWorker::availablePortsReady(const QStringList & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 9, nullptr, _t1);
}
QT_WARNING_POP
