/****************************************************************************
** Meta object code from reading C++ file 'cameraviewmodel.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../viewmodels/cameraviewmodel.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'cameraviewmodel.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN15CameraViewModelE_t {};
} // unnamed namespace

template <> constexpr inline auto CameraViewModel::qt_create_metaobjectdata<qt_meta_tag_ZN15CameraViewModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "CameraViewModel",
        "ipAddressChanged",
        "",
        "portChanged",
        "streamingChanged",
        "cameraStatusChanged",
        "frameChanged",
        "frameCountChanged",
        "frameRateChanged",
        "trackingEnabledChanged",
        "frameIdChanged",
        "requestStartStream",
        "ipAddress",
        "port",
        "requestStopStream",
        "trackingRectChanged",
        "onStreamingStatusChanged",
        "streaming",
        "onFrameReceived",
        "frameData",
        "frameId",
        "onCameraError",
        "error",
        "onConnectionEstablished",
        "calculateFrameRate",
        "toggleStream",
        "startStream",
        "stopStream",
        "enableTracking",
        "disableTracking",
        "sendTarget",
        "x",
        "y",
        "w",
        "h",
        "updateTrackingRect",
        "show",
        "streamButtonText",
        "streamButtonColor",
        "cameraStatus",
        "trackingEnabled",
        "currentFrameUrl",
        "frameCount",
        "frameRate",
        "showTrackingRect",
        "trackingRectX",
        "trackingRectY",
        "currentFrameId"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'ipAddressChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'portChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'streamingChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'cameraStatusChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'frameChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'frameCountChanged'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'frameRateChanged'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'trackingEnabledChanged'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'frameIdChanged'
        QtMocHelpers::SignalData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'requestStartStream'
        QtMocHelpers::SignalData<void(const QString &, int)>(11, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 12 }, { QMetaType::Int, 13 },
        }}),
        // Signal 'requestStopStream'
        QtMocHelpers::SignalData<void()>(14, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'trackingRectChanged'
        QtMocHelpers::SignalData<void()>(15, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'onStreamingStatusChanged'
        QtMocHelpers::SlotData<void(bool)>(16, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Bool, 17 },
        }}),
        // Slot 'onFrameReceived'
        QtMocHelpers::SlotData<void(const QByteArray &, quint16)>(18, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QByteArray, 19 }, { QMetaType::UShort, 20 },
        }}),
        // Slot 'onCameraError'
        QtMocHelpers::SlotData<void(const QString &)>(21, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QString, 22 },
        }}),
        // Slot 'onConnectionEstablished'
        QtMocHelpers::SlotData<void()>(23, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'calculateFrameRate'
        QtMocHelpers::SlotData<void()>(24, 2, QMC::AccessPrivate, QMetaType::Void),
        // Method 'toggleStream'
        QtMocHelpers::MethodData<void()>(25, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'startStream'
        QtMocHelpers::MethodData<void()>(26, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'stopStream'
        QtMocHelpers::MethodData<void()>(27, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'enableTracking'
        QtMocHelpers::MethodData<void()>(28, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'disableTracking'
        QtMocHelpers::MethodData<void()>(29, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'sendTarget'
        QtMocHelpers::MethodData<void(int, int, int, int)>(30, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 31 }, { QMetaType::Int, 32 }, { QMetaType::Int, 33 }, { QMetaType::Int, 34 },
        }}),
        // Method 'updateTrackingRect'
        QtMocHelpers::MethodData<void(int, int, bool)>(35, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 31 }, { QMetaType::Int, 32 }, { QMetaType::Bool, 36 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'ipAddress'
        QtMocHelpers::PropertyData<QString>(12, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 0),
        // property 'port'
        QtMocHelpers::PropertyData<int>(13, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'streaming'
        QtMocHelpers::PropertyData<bool>(17, QMetaType::Bool, QMC::DefaultPropertyFlags, 2),
        // property 'streamButtonText'
        QtMocHelpers::PropertyData<QString>(37, QMetaType::QString, QMC::DefaultPropertyFlags, 2),
        // property 'streamButtonColor'
        QtMocHelpers::PropertyData<QString>(38, QMetaType::QString, QMC::DefaultPropertyFlags, 2),
        // property 'cameraStatus'
        QtMocHelpers::PropertyData<QString>(39, QMetaType::QString, QMC::DefaultPropertyFlags, 3),
        // property 'trackingEnabled'
        QtMocHelpers::PropertyData<bool>(40, QMetaType::Bool, QMC::DefaultPropertyFlags, 7),
        // property 'currentFrameUrl'
        QtMocHelpers::PropertyData<QString>(41, QMetaType::QString, QMC::DefaultPropertyFlags, 4),
        // property 'frameCount'
        QtMocHelpers::PropertyData<int>(42, QMetaType::Int, QMC::DefaultPropertyFlags, 5),
        // property 'frameRate'
        QtMocHelpers::PropertyData<double>(43, QMetaType::Double, QMC::DefaultPropertyFlags, 6),
        // property 'showTrackingRect'
        QtMocHelpers::PropertyData<bool>(44, QMetaType::Bool, QMC::DefaultPropertyFlags, 11),
        // property 'trackingRectX'
        QtMocHelpers::PropertyData<int>(45, QMetaType::Int, QMC::DefaultPropertyFlags, 11),
        // property 'trackingRectY'
        QtMocHelpers::PropertyData<int>(46, QMetaType::Int, QMC::DefaultPropertyFlags, 11),
        // property 'currentFrameId'
        QtMocHelpers::PropertyData<int>(47, QMetaType::Int, QMC::DefaultPropertyFlags, 8),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<CameraViewModel, qt_meta_tag_ZN15CameraViewModelE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject CameraViewModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15CameraViewModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15CameraViewModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN15CameraViewModelE_t>.metaTypes,
    nullptr
} };

void CameraViewModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<CameraViewModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->ipAddressChanged(); break;
        case 1: _t->portChanged(); break;
        case 2: _t->streamingChanged(); break;
        case 3: _t->cameraStatusChanged(); break;
        case 4: _t->frameChanged(); break;
        case 5: _t->frameCountChanged(); break;
        case 6: _t->frameRateChanged(); break;
        case 7: _t->trackingEnabledChanged(); break;
        case 8: _t->frameIdChanged(); break;
        case 9: _t->requestStartStream((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 10: _t->requestStopStream(); break;
        case 11: _t->trackingRectChanged(); break;
        case 12: _t->onStreamingStatusChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 13: _t->onFrameReceived((*reinterpret_cast< std::add_pointer_t<QByteArray>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint16>>(_a[2]))); break;
        case 14: _t->onCameraError((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 15: _t->onConnectionEstablished(); break;
        case 16: _t->calculateFrameRate(); break;
        case 17: _t->toggleStream(); break;
        case 18: _t->startStream(); break;
        case 19: _t->stopStream(); break;
        case 20: _t->enableTracking(); break;
        case 21: _t->disableTracking(); break;
        case 22: _t->sendTarget((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[4]))); break;
        case 23: _t->updateTrackingRect((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[3]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::ipAddressChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::portChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::streamingChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::cameraStatusChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::frameChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::frameCountChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::frameRateChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::trackingEnabledChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::frameIdChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)(const QString & , int )>(_a, &CameraViewModel::requestStartStream, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::requestStopStream, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraViewModel::*)()>(_a, &CameraViewModel::trackingRectChanged, 11))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QString*>(_v) = _t->ipAddress(); break;
        case 1: *reinterpret_cast<int*>(_v) = _t->port(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->streaming(); break;
        case 3: *reinterpret_cast<QString*>(_v) = _t->streamButtonText(); break;
        case 4: *reinterpret_cast<QString*>(_v) = _t->streamButtonColor(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->cameraStatus(); break;
        case 6: *reinterpret_cast<bool*>(_v) = _t->trackingEnabled(); break;
        case 7: *reinterpret_cast<QString*>(_v) = _t->currentFrameUrl(); break;
        case 8: *reinterpret_cast<int*>(_v) = _t->frameCount(); break;
        case 9: *reinterpret_cast<double*>(_v) = _t->frameRate(); break;
        case 10: *reinterpret_cast<bool*>(_v) = _t->showTrackingRect(); break;
        case 11: *reinterpret_cast<int*>(_v) = _t->trackingRectX(); break;
        case 12: *reinterpret_cast<int*>(_v) = _t->trackingRectY(); break;
        case 13: *reinterpret_cast<int*>(_v) = _t->currentFrameId(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setIpAddress(*reinterpret_cast<QString*>(_v)); break;
        case 1: _t->setPort(*reinterpret_cast<int*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *CameraViewModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *CameraViewModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15CameraViewModelE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int CameraViewModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 24)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 24;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 24)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 24;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 14;
    }
    return _id;
}

// SIGNAL 0
void CameraViewModel::ipAddressChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void CameraViewModel::portChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void CameraViewModel::streamingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void CameraViewModel::cameraStatusChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void CameraViewModel::frameChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void CameraViewModel::frameCountChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void CameraViewModel::frameRateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void CameraViewModel::trackingEnabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void CameraViewModel::frameIdChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}

// SIGNAL 9
void CameraViewModel::requestStartStream(const QString & _t1, int _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 9, nullptr, _t1, _t2);
}

// SIGNAL 10
void CameraViewModel::requestStopStream()
{
    QMetaObject::activate(this, &staticMetaObject, 10, nullptr);
}

// SIGNAL 11
void CameraViewModel::trackingRectChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 11, nullptr);
}
QT_WARNING_POP
