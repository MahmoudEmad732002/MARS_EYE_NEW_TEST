/****************************************************************************
** Meta object code from reading C++ file 'thermalcameraviewmodel.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../viewmodels/thermalcameraviewmodel.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'thermalcameraviewmodel.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN22ThermalCameraViewModelE_t {};
} // unnamed namespace

template <> constexpr inline auto ThermalCameraViewModel::qt_create_metaobjectdata<qt_meta_tag_ZN22ThermalCameraViewModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "ThermalCameraViewModel",
        "thermalIpAddressChanged",
        "",
        "thermalPortChanged",
        "thermalStreamingChanged",
        "thermalCameraStatusChanged",
        "thermalFrameChanged",
        "thermalFrameCountChanged",
        "thermalFrameRateChanged",
        "requestStartThermalStream",
        "ipAddress",
        "port",
        "requestStopThermalStream",
        "onThermalStreamingStatusChanged",
        "streaming",
        "onThermalFrameReceived",
        "frameData",
        "onThermalCameraError",
        "error",
        "onThermalConnectionEstablished",
        "calculateThermalFrameRate",
        "toggleThermalStream",
        "startThermalStream",
        "stopThermalStream",
        "thermalIpAddress",
        "thermalPort",
        "thermalStreaming",
        "thermalStreamButtonText",
        "thermalStreamButtonColor",
        "thermalCameraStatus",
        "currentThermalFrameUrl",
        "thermalFrameCount",
        "thermalFrameRate"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'thermalIpAddressChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'thermalPortChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'thermalStreamingChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'thermalCameraStatusChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'thermalFrameChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'thermalFrameCountChanged'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'thermalFrameRateChanged'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'requestStartThermalStream'
        QtMocHelpers::SignalData<void(const QString &, int)>(9, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 10 }, { QMetaType::Int, 11 },
        }}),
        // Signal 'requestStopThermalStream'
        QtMocHelpers::SignalData<void()>(12, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'onThermalStreamingStatusChanged'
        QtMocHelpers::SlotData<void(bool)>(13, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Bool, 14 },
        }}),
        // Slot 'onThermalFrameReceived'
        QtMocHelpers::SlotData<void(const QByteArray &)>(15, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QByteArray, 16 },
        }}),
        // Slot 'onThermalCameraError'
        QtMocHelpers::SlotData<void(const QString &)>(17, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QString, 18 },
        }}),
        // Slot 'onThermalConnectionEstablished'
        QtMocHelpers::SlotData<void()>(19, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'calculateThermalFrameRate'
        QtMocHelpers::SlotData<void()>(20, 2, QMC::AccessPrivate, QMetaType::Void),
        // Method 'toggleThermalStream'
        QtMocHelpers::MethodData<void()>(21, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'startThermalStream'
        QtMocHelpers::MethodData<void()>(22, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'stopThermalStream'
        QtMocHelpers::MethodData<void()>(23, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'thermalIpAddress'
        QtMocHelpers::PropertyData<QString>(24, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 0),
        // property 'thermalPort'
        QtMocHelpers::PropertyData<int>(25, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'thermalStreaming'
        QtMocHelpers::PropertyData<bool>(26, QMetaType::Bool, QMC::DefaultPropertyFlags, 2),
        // property 'thermalStreamButtonText'
        QtMocHelpers::PropertyData<QString>(27, QMetaType::QString, QMC::DefaultPropertyFlags, 2),
        // property 'thermalStreamButtonColor'
        QtMocHelpers::PropertyData<QString>(28, QMetaType::QString, QMC::DefaultPropertyFlags, 2),
        // property 'thermalCameraStatus'
        QtMocHelpers::PropertyData<QString>(29, QMetaType::QString, QMC::DefaultPropertyFlags, 3),
        // property 'currentThermalFrameUrl'
        QtMocHelpers::PropertyData<QString>(30, QMetaType::QString, QMC::DefaultPropertyFlags, 4),
        // property 'thermalFrameCount'
        QtMocHelpers::PropertyData<int>(31, QMetaType::Int, QMC::DefaultPropertyFlags, 5),
        // property 'thermalFrameRate'
        QtMocHelpers::PropertyData<double>(32, QMetaType::Double, QMC::DefaultPropertyFlags, 6),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<ThermalCameraViewModel, qt_meta_tag_ZN22ThermalCameraViewModelE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject ThermalCameraViewModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN22ThermalCameraViewModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN22ThermalCameraViewModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN22ThermalCameraViewModelE_t>.metaTypes,
    nullptr
} };

void ThermalCameraViewModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<ThermalCameraViewModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->thermalIpAddressChanged(); break;
        case 1: _t->thermalPortChanged(); break;
        case 2: _t->thermalStreamingChanged(); break;
        case 3: _t->thermalCameraStatusChanged(); break;
        case 4: _t->thermalFrameChanged(); break;
        case 5: _t->thermalFrameCountChanged(); break;
        case 6: _t->thermalFrameRateChanged(); break;
        case 7: _t->requestStartThermalStream((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 8: _t->requestStopThermalStream(); break;
        case 9: _t->onThermalStreamingStatusChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 10: _t->onThermalFrameReceived((*reinterpret_cast< std::add_pointer_t<QByteArray>>(_a[1]))); break;
        case 11: _t->onThermalCameraError((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 12: _t->onThermalConnectionEstablished(); break;
        case 13: _t->calculateThermalFrameRate(); break;
        case 14: _t->toggleThermalStream(); break;
        case 15: _t->startThermalStream(); break;
        case 16: _t->stopThermalStream(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)()>(_a, &ThermalCameraViewModel::thermalIpAddressChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)()>(_a, &ThermalCameraViewModel::thermalPortChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)()>(_a, &ThermalCameraViewModel::thermalStreamingChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)()>(_a, &ThermalCameraViewModel::thermalCameraStatusChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)()>(_a, &ThermalCameraViewModel::thermalFrameChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)()>(_a, &ThermalCameraViewModel::thermalFrameCountChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)()>(_a, &ThermalCameraViewModel::thermalFrameRateChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)(const QString & , int )>(_a, &ThermalCameraViewModel::requestStartThermalStream, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (ThermalCameraViewModel::*)()>(_a, &ThermalCameraViewModel::requestStopThermalStream, 8))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QString*>(_v) = _t->thermalIpAddress(); break;
        case 1: *reinterpret_cast<int*>(_v) = _t->thermalPort(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->thermalStreaming(); break;
        case 3: *reinterpret_cast<QString*>(_v) = _t->thermalStreamButtonText(); break;
        case 4: *reinterpret_cast<QString*>(_v) = _t->thermalStreamButtonColor(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->thermalCameraStatus(); break;
        case 6: *reinterpret_cast<QString*>(_v) = _t->currentThermalFrameUrl(); break;
        case 7: *reinterpret_cast<int*>(_v) = _t->thermalFrameCount(); break;
        case 8: *reinterpret_cast<double*>(_v) = _t->thermalFrameRate(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setThermalIpAddress(*reinterpret_cast<QString*>(_v)); break;
        case 1: _t->setThermalPort(*reinterpret_cast<int*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *ThermalCameraViewModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ThermalCameraViewModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN22ThermalCameraViewModelE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ThermalCameraViewModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 17)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 17;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 17)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 17;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    }
    return _id;
}

// SIGNAL 0
void ThermalCameraViewModel::thermalIpAddressChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void ThermalCameraViewModel::thermalPortChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void ThermalCameraViewModel::thermalStreamingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void ThermalCameraViewModel::thermalCameraStatusChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void ThermalCameraViewModel::thermalFrameChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void ThermalCameraViewModel::thermalFrameCountChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void ThermalCameraViewModel::thermalFrameRateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void ThermalCameraViewModel::requestStartThermalStream(const QString & _t1, int _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1, _t2);
}

// SIGNAL 8
void ThermalCameraViewModel::requestStopThermalStream()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}
QT_WARNING_POP
