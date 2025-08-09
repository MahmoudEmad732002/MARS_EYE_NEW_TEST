/****************************************************************************
** Meta object code from reading C++ file 'serialmodel.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../models/serialmodel.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'serialmodel.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN11SerialModelE_t {};
} // unnamed namespace

template <> constexpr inline auto SerialModel::qt_create_metaobjectdata<qt_meta_tag_ZN11SerialModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "SerialModel",
        "connectionStatusChanged",
        "",
        "connected",
        "telemetryDataReceived",
        "TelemetryData",
        "data",
        "errorOccurred",
        "error",
        "messageSent",
        "messageType",
        "getAvailablePorts",
        "getBaudRates",
        "connectToPort",
        "portName",
        "baudRate",
        "disconnect",
        "isConnected",
        "sendJoystickCommand",
        "pitch",
        "yaw",
        "sendPIDGains",
        "PIDGains",
        "gains",
        "sendZoomCommand",
        "zoom",
        "sendTrackingCoordinates",
        "x",
        "y",
        "readData",
        "handleError",
        "QSerialPort::SerialPortError"
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
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(const QString &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 8 },
        }}),
        // Signal 'messageSent'
        QtMocHelpers::SignalData<void(const QString &)>(9, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 10 },
        }}),
        // Slot 'getAvailablePorts'
        QtMocHelpers::SlotData<QStringList()>(11, 2, QMC::AccessPublic, QMetaType::QStringList),
        // Slot 'getBaudRates'
        QtMocHelpers::SlotData<QStringList()>(12, 2, QMC::AccessPublic, QMetaType::QStringList),
        // Slot 'connectToPort'
        QtMocHelpers::SlotData<bool(const QString &, int)>(13, 2, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::QString, 14 }, { QMetaType::Int, 15 },
        }}),
        // Slot 'disconnect'
        QtMocHelpers::SlotData<void()>(16, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'isConnected'
        QtMocHelpers::SlotData<bool() const>(17, 2, QMC::AccessPublic, QMetaType::Bool),
        // Slot 'sendJoystickCommand'
        QtMocHelpers::SlotData<bool(quint8, quint8)>(18, 2, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::UChar, 19 }, { QMetaType::UChar, 20 },
        }}),
        // Slot 'sendPIDGains'
        QtMocHelpers::SlotData<bool(const PIDGains &)>(21, 2, QMC::AccessPublic, QMetaType::Bool, {{
            { 0x80000000 | 22, 23 },
        }}),
        // Slot 'sendZoomCommand'
        QtMocHelpers::SlotData<bool(quint8)>(24, 2, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::UChar, 25 },
        }}),
        // Slot 'sendTrackingCoordinates'
        QtMocHelpers::SlotData<bool(quint16, quint16)>(26, 2, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::UShort, 27 }, { QMetaType::UShort, 28 },
        }}),
        // Slot 'readData'
        QtMocHelpers::SlotData<void()>(29, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'handleError'
        QtMocHelpers::SlotData<void(QSerialPort::SerialPortError)>(30, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 31, 8 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<SerialModel, qt_meta_tag_ZN11SerialModelE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject SerialModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11SerialModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11SerialModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN11SerialModelE_t>.metaTypes,
    nullptr
} };

void SerialModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<SerialModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->connectionStatusChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 1: _t->telemetryDataReceived((*reinterpret_cast< std::add_pointer_t<TelemetryData>>(_a[1]))); break;
        case 2: _t->errorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 3: _t->messageSent((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 4: { QStringList _r = _t->getAvailablePorts();
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 5: { QStringList _r = _t->getBaudRates();
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 6: { bool _r = _t->connectToPort((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 7: _t->disconnect(); break;
        case 8: { bool _r = _t->isConnected();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 9: { bool _r = _t->sendJoystickCommand((*reinterpret_cast< std::add_pointer_t<quint8>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint8>>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 10: { bool _r = _t->sendPIDGains((*reinterpret_cast< std::add_pointer_t<PIDGains>>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 11: { bool _r = _t->sendZoomCommand((*reinterpret_cast< std::add_pointer_t<quint8>>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 12: { bool _r = _t->sendTrackingCoordinates((*reinterpret_cast< std::add_pointer_t<quint16>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint16>>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 13: _t->readData(); break;
        case 14: _t->handleError((*reinterpret_cast< std::add_pointer_t<QSerialPort::SerialPortError>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (SerialModel::*)(bool )>(_a, &SerialModel::connectionStatusChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialModel::*)(const TelemetryData & )>(_a, &SerialModel::telemetryDataReceived, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialModel::*)(const QString & )>(_a, &SerialModel::errorOccurred, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (SerialModel::*)(const QString & )>(_a, &SerialModel::messageSent, 3))
            return;
    }
}

const QMetaObject *SerialModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SerialModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11SerialModelE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SerialModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 15)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 15;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 15)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 15;
    }
    return _id;
}

// SIGNAL 0
void SerialModel::connectionStatusChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void SerialModel::telemetryDataReceived(const TelemetryData & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void SerialModel::errorOccurred(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void SerialModel::messageSent(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}
QT_WARNING_POP
