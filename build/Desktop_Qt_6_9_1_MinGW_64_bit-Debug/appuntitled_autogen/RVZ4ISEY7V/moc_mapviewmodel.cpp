/****************************************************************************
** Meta object code from reading C++ file 'mapviewmodel.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../viewmodels/mapviewmodel.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mapviewmodel.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12MapViewModelE_t {};
} // unnamed namespace

template <> constexpr inline auto MapViewModel::qt_create_metaobjectdata<qt_meta_tag_ZN12MapViewModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "MapViewModel",
        "planeCoordinateChanged",
        "",
        "mapCenterChanged",
        "planeHeadingChanged",
        "hasGPSDataChanged",
        "gpsDataChanged",
        "updateRandomMovement",
        "updateGPSData",
        "latitude",
        "longitude",
        "altitude",
        "planeCoordinate",
        "QGeoCoordinate",
        "mapCenter",
        "planeHeading",
        "hasGPSData",
        "latitudeText",
        "longitudeText",
        "altitudeText"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'planeCoordinateChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'mapCenterChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'planeHeadingChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'hasGPSDataChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'gpsDataChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'updateRandomMovement'
        QtMocHelpers::SlotData<void()>(7, 2, QMC::AccessPrivate, QMetaType::Void),
        // Method 'updateGPSData'
        QtMocHelpers::MethodData<void(double, double, double)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Double, 9 }, { QMetaType::Double, 10 }, { QMetaType::Double, 11 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'planeCoordinate'
        QtMocHelpers::PropertyData<QGeoCoordinate>(12, 0x80000000 | 13, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'mapCenter'
        QtMocHelpers::PropertyData<QGeoCoordinate>(14, 0x80000000 | 13, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 1),
        // property 'planeHeading'
        QtMocHelpers::PropertyData<double>(15, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'hasGPSData'
        QtMocHelpers::PropertyData<bool>(16, QMetaType::Bool, QMC::DefaultPropertyFlags, 3),
        // property 'latitudeText'
        QtMocHelpers::PropertyData<QString>(17, QMetaType::QString, QMC::DefaultPropertyFlags, 4),
        // property 'longitudeText'
        QtMocHelpers::PropertyData<QString>(18, QMetaType::QString, QMC::DefaultPropertyFlags, 4),
        // property 'altitudeText'
        QtMocHelpers::PropertyData<QString>(19, QMetaType::QString, QMC::DefaultPropertyFlags, 4),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<MapViewModel, qt_meta_tag_ZN12MapViewModelE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject MapViewModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12MapViewModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12MapViewModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12MapViewModelE_t>.metaTypes,
    nullptr
} };

void MapViewModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<MapViewModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->planeCoordinateChanged(); break;
        case 1: _t->mapCenterChanged(); break;
        case 2: _t->planeHeadingChanged(); break;
        case 3: _t->hasGPSDataChanged(); break;
        case 4: _t->gpsDataChanged(); break;
        case 5: _t->updateRandomMovement(); break;
        case 6: _t->updateGPSData((*reinterpret_cast< std::add_pointer_t<double>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<double>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<double>>(_a[3]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (MapViewModel::*)()>(_a, &MapViewModel::planeCoordinateChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (MapViewModel::*)()>(_a, &MapViewModel::mapCenterChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (MapViewModel::*)()>(_a, &MapViewModel::planeHeadingChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (MapViewModel::*)()>(_a, &MapViewModel::hasGPSDataChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (MapViewModel::*)()>(_a, &MapViewModel::gpsDataChanged, 4))
            return;
    }
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 1:
        case 0:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QGeoCoordinate >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QGeoCoordinate*>(_v) = _t->planeCoordinate(); break;
        case 1: *reinterpret_cast<QGeoCoordinate*>(_v) = _t->mapCenter(); break;
        case 2: *reinterpret_cast<double*>(_v) = _t->planeHeading(); break;
        case 3: *reinterpret_cast<bool*>(_v) = _t->hasGPSData(); break;
        case 4: *reinterpret_cast<QString*>(_v) = _t->latitudeText(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->longitudeText(); break;
        case 6: *reinterpret_cast<QString*>(_v) = _t->altitudeText(); break;
        default: break;
        }
    }
}

const QMetaObject *MapViewModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MapViewModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12MapViewModelE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int MapViewModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 7;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
    return _id;
}

// SIGNAL 0
void MapViewModel::planeCoordinateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void MapViewModel::mapCenterChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void MapViewModel::planeHeadingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void MapViewModel::hasGPSDataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void MapViewModel::gpsDataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}
QT_WARNING_POP
