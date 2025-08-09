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
        "statusMessageChanged",
        "joystickChanged",
        "pidGainsChanged",
        "zoomLevelChanged",
        "trackingChanged",
        "onConnectionStatusChanged",
        "connected",
        "onTelemetryDataReceived",
        "SerialModel::TelemetryData",
        "data",
        "onErrorOccurred",
        "error",
        "onMessageSent",
        "messageType",
        "connectToSerial",
        "portName",
        "baudRate",
        "refreshPorts",
        "sendJoystickUp",
        "sendJoystickDown",
        "sendJoystickLeft",
        "sendJoystickRight",
        "sendCurrentJoystickValues",
        "sendPIDGains",
        "sendZoom",
        "sendTrackingCoordinates",
        "availablePorts",
        "baudRates",
        "connectButtonText",
        "connectButtonColor",
        "statusMessage",
        "roll",
        "pitch",
        "yaw",
        "azimuthMotor",
        "elevationMotor",
        "latitude",
        "longitude",
        "altitude",
        "joystickPitch",
        "joystickYaw",
        "azimuthKp",
        "azimuthKi",
        "azimuthKd",
        "elevationKp",
        "elevationKi",
        "elevationKd",
        "zoomLevel",
        "trackingX",
        "trackingY"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'availablePortsChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'connectedChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'telemetryChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'statusMessageChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'joystickChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'pidGainsChanged'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'zoomLevelChanged'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'trackingChanged'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'onConnectionStatusChanged'
        QtMocHelpers::SlotData<void(bool)>(10, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Bool, 11 },
        }}),
        // Slot 'onTelemetryDataReceived'
        QtMocHelpers::SlotData<void(const SerialModel::TelemetryData &)>(12, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 13, 14 },
        }}),
        // Slot 'onErrorOccurred'
        QtMocHelpers::SlotData<void(const QString &)>(15, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QString, 16 },
        }}),
        // Slot 'onMessageSent'
        QtMocHelpers::SlotData<void(const QString &)>(17, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QString, 18 },
        }}),
        // Method 'connectToSerial'
        QtMocHelpers::MethodData<void(const QString &, int)>(19, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 20 }, { QMetaType::Int, 21 },
        }}),
        // Method 'refreshPorts'
        QtMocHelpers::MethodData<void()>(22, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendJoystickUp'
        QtMocHelpers::MethodData<void()>(23, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendJoystickDown'
        QtMocHelpers::MethodData<void()>(24, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendJoystickLeft'
        QtMocHelpers::MethodData<void()>(25, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendJoystickRight'
        QtMocHelpers::MethodData<void()>(26, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendCurrentJoystickValues'
        QtMocHelpers::MethodData<void()>(27, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendPIDGains'
        QtMocHelpers::MethodData<void()>(28, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendZoom'
        QtMocHelpers::MethodData<void()>(29, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendTrackingCoordinates'
        QtMocHelpers::MethodData<void()>(30, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'availablePorts'
        QtMocHelpers::PropertyData<QStringList>(31, QMetaType::QStringList, QMC::DefaultPropertyFlags, 0),
        // property 'baudRates'
        QtMocHelpers::PropertyData<QStringList>(32, QMetaType::QStringList, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'connected'
        QtMocHelpers::PropertyData<bool>(11, QMetaType::Bool, QMC::DefaultPropertyFlags, 1),
        // property 'connectButtonText'
        QtMocHelpers::PropertyData<QString>(33, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'connectButtonColor'
        QtMocHelpers::PropertyData<QString>(34, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'statusMessage'
        QtMocHelpers::PropertyData<QString>(35, QMetaType::QString, QMC::DefaultPropertyFlags, 3),
        // property 'roll'
        QtMocHelpers::PropertyData<int>(36, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'pitch'
        QtMocHelpers::PropertyData<int>(37, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'yaw'
        QtMocHelpers::PropertyData<int>(38, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'azimuthMotor'
        QtMocHelpers::PropertyData<int>(39, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'elevationMotor'
        QtMocHelpers::PropertyData<int>(40, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'latitude'
        QtMocHelpers::PropertyData<double>(41, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'longitude'
        QtMocHelpers::PropertyData<double>(42, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'altitude'
        QtMocHelpers::PropertyData<double>(43, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'joystickPitch'
        QtMocHelpers::PropertyData<int>(44, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 4),
        // property 'joystickYaw'
        QtMocHelpers::PropertyData<int>(45, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 4),
        // property 'azimuthKp'
        QtMocHelpers::PropertyData<int>(46, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'azimuthKi'
        QtMocHelpers::PropertyData<int>(47, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'azimuthKd'
        QtMocHelpers::PropertyData<int>(48, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'elevationKp'
        QtMocHelpers::PropertyData<int>(49, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'elevationKi'
        QtMocHelpers::PropertyData<int>(50, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'elevationKd'
        QtMocHelpers::PropertyData<int>(51, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'zoomLevel'
        QtMocHelpers::PropertyData<int>(52, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 6),
        // property 'trackingX'
        QtMocHelpers::PropertyData<int>(53, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 7),
        // property 'trackingY'
        QtMocHelpers::PropertyData<int>(54, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 7),
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
        case 3: _t->statusMessageChanged(); break;
        case 4: _t->joystickChanged(); break;
        case 5: _t->pidGainsChanged(); break;
        case 6: _t->zoomLevelChanged(); break;
        case 7: _t->trackingChanged(); break;
        case 8: _t->onConnectionStatusChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 9: _t->onTelemetryDataReceived((*reinterpret_cast< std::add_pointer_t<SerialModel::TelemetryData>>(_a[1]))); break;
        case 10: _t->onErrorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 11: _t->onMessageSent((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 12: _t->connectToSerial((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 13: _t->refreshPorts(); break;
        case 14: _t->sendJoystickUp(); break;
        case 15: _t->sendJoystickDown(); break;
        case 16: _t->sendJoystickLeft(); break;
        case 17: _t->sendJoystickRight(); break;
        case 18: _t->sendCurrentJoystickValues(); break;
        case 19: _t->sendPIDGains(); break;
        case 20: _t->sendZoom(); break;
        case 21: _t->sendTrackingCoordinates(); break;
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
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::statusMessageChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::joystickChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::pidGainsChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::zoomLevelChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialViewModel::*)()>(_a, &SerialViewModel::trackingChanged, 7))
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
        case 6: *reinterpret_cast<int*>(_v) = _t->roll(); break;
        case 7: *reinterpret_cast<int*>(_v) = _t->pitch(); break;
        case 8: *reinterpret_cast<int*>(_v) = _t->yaw(); break;
        case 9: *reinterpret_cast<int*>(_v) = _t->azimuthMotor(); break;
        case 10: *reinterpret_cast<int*>(_v) = _t->elevationMotor(); break;
        case 11: *reinterpret_cast<double*>(_v) = _t->latitude(); break;
        case 12: *reinterpret_cast<double*>(_v) = _t->longitude(); break;
        case 13: *reinterpret_cast<double*>(_v) = _t->altitude(); break;
        case 14: *reinterpret_cast<int*>(_v) = _t->joystickPitch(); break;
        case 15: *reinterpret_cast<int*>(_v) = _t->joystickYaw(); break;
        case 16: *reinterpret_cast<int*>(_v) = _t->azimuthKp(); break;
        case 17: *reinterpret_cast<int*>(_v) = _t->azimuthKi(); break;
        case 18: *reinterpret_cast<int*>(_v) = _t->azimuthKd(); break;
        case 19: *reinterpret_cast<int*>(_v) = _t->elevationKp(); break;
        case 20: *reinterpret_cast<int*>(_v) = _t->elevationKi(); break;
        case 21: *reinterpret_cast<int*>(_v) = _t->elevationKd(); break;
        case 22: *reinterpret_cast<int*>(_v) = _t->zoomLevel(); break;
        case 23: *reinterpret_cast<int*>(_v) = _t->trackingX(); break;
        case 24: *reinterpret_cast<int*>(_v) = _t->trackingY(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 14: _t->setJoystickPitch(*reinterpret_cast<int*>(_v)); break;
        case 15: _t->setJoystickYaw(*reinterpret_cast<int*>(_v)); break;
        case 16: _t->setAzimuthKp(*reinterpret_cast<int*>(_v)); break;
        case 17: _t->setAzimuthKi(*reinterpret_cast<int*>(_v)); break;
        case 18: _t->setAzimuthKd(*reinterpret_cast<int*>(_v)); break;
        case 19: _t->setElevationKp(*reinterpret_cast<int*>(_v)); break;
        case 20: _t->setElevationKi(*reinterpret_cast<int*>(_v)); break;
        case 21: _t->setElevationKd(*reinterpret_cast<int*>(_v)); break;
        case 22: _t->setZoomLevel(*reinterpret_cast<int*>(_v)); break;
        case 23: _t->setTrackingX(*reinterpret_cast<int*>(_v)); break;
        case 24: _t->setTrackingY(*reinterpret_cast<int*>(_v)); break;
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
        if (_id < 22)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 22;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 22)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 22;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 25;
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
void SerialViewModel::statusMessageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void SerialViewModel::joystickChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void SerialViewModel::pidGainsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void SerialViewModel::zoomLevelChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void SerialViewModel::trackingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}
QT_WARNING_POP
