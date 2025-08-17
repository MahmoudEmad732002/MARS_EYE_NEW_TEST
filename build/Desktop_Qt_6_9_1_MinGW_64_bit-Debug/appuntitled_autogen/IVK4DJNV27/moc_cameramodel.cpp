/****************************************************************************
** Meta object code from reading C++ file 'cameramodel.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../models/cameramodel.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'cameramodel.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN11CameraModelE_t {};
} // unnamed namespace

template <> constexpr inline auto CameraModel::qt_create_metaobjectdata<qt_meta_tag_ZN11CameraModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "CameraModel",
        "streamingStatusChanged",
        "",
        "streaming",
        "frameReceived",
        "frameData",
        "frameId",
        "errorOccurred",
        "error",
        "connectionEstablished",
        "startStreaming",
        "ipAddress",
        "port",
        "stopStreaming",
        "isStreaming",
        "readPendingDatagrams",
        "onSocketError",
        "processBuffer",
        "cleanupIncompleteFrames"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'streamingStatusChanged'
        QtMocHelpers::SignalData<void(bool)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 3 },
        }}),
        // Signal 'frameReceived'
        QtMocHelpers::SignalData<void(const QByteArray &, quint16)>(4, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QByteArray, 5 }, { QMetaType::UShort, 6 },
        }}),
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(const QString &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 8 },
        }}),
        // Signal 'connectionEstablished'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'startStreaming'
        QtMocHelpers::SlotData<void(const QString &, int)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 11 }, { QMetaType::Int, 12 },
        }}),
        // Slot 'stopStreaming'
        QtMocHelpers::SlotData<void()>(13, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'isStreaming'
        QtMocHelpers::SlotData<bool() const>(14, 2, QMC::AccessPublic, QMetaType::Bool),
        // Slot 'readPendingDatagrams'
        QtMocHelpers::SlotData<void()>(15, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'onSocketError'
        QtMocHelpers::SlotData<void()>(16, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'processBuffer'
        QtMocHelpers::SlotData<void()>(17, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'cleanupIncompleteFrames'
        QtMocHelpers::SlotData<void()>(18, 2, QMC::AccessPrivate, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<CameraModel, qt_meta_tag_ZN11CameraModelE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject CameraModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11CameraModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11CameraModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN11CameraModelE_t>.metaTypes,
    nullptr
} };

void CameraModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<CameraModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->streamingStatusChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 1: _t->frameReceived((*reinterpret_cast< std::add_pointer_t<QByteArray>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<quint16>>(_a[2]))); break;
        case 2: _t->errorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 3: _t->connectionEstablished(); break;
        case 4: _t->startStreaming((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 5: _t->stopStreaming(); break;
        case 6: { bool _r = _t->isStreaming();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 7: _t->readPendingDatagrams(); break;
        case 8: _t->onSocketError(); break;
        case 9: _t->processBuffer(); break;
        case 10: _t->cleanupIncompleteFrames(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (CameraModel::*)(bool )>(_a, &CameraModel::streamingStatusChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraModel::*)(const QByteArray & , quint16 )>(_a, &CameraModel::frameReceived, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraModel::*)(const QString & )>(_a, &CameraModel::errorOccurred, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (CameraModel::*)()>(_a, &CameraModel::connectionEstablished, 3))
            return;
    }
}

const QMetaObject *CameraModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *CameraModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11CameraModelE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int CameraModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 11)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 11;
    }
    return _id;
}

// SIGNAL 0
void CameraModel::streamingStatusChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void CameraModel::frameReceived(const QByteArray & _t1, quint16 _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1, _t2);
}

// SIGNAL 2
void CameraModel::errorOccurred(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void CameraModel::connectionEstablished()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}
QT_WARNING_POP
