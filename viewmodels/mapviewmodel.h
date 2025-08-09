#ifndef MAPVIEWMODEL_H
#define MAPVIEWMODEL_H

#include <QObject>
#include <QTimer>
#include <QGeoCoordinate>
#include <QtMath>

class MapViewModel : public QObject
{
    Q_OBJECT

    // Map properties
    Q_PROPERTY(QGeoCoordinate planeCoordinate READ planeCoordinate NOTIFY planeCoordinateChanged)
    Q_PROPERTY(QGeoCoordinate mapCenter READ mapCenter NOTIFY mapCenterChanged)
    Q_PROPERTY(double planeHeading READ planeHeading NOTIFY planeHeadingChanged)
    Q_PROPERTY(bool hasGPSData READ hasGPSData NOTIFY hasGPSDataChanged)
    Q_PROPERTY(QString latitudeText READ latitudeText NOTIFY gpsDataChanged)
    Q_PROPERTY(QString longitudeText READ longitudeText NOTIFY gpsDataChanged)
    Q_PROPERTY(QString altitudeText READ altitudeText NOTIFY gpsDataChanged)

public:
    explicit MapViewModel(QObject *parent = nullptr);

    // Getters
    QGeoCoordinate planeCoordinate() const { return m_planeCoordinate; }
    QGeoCoordinate mapCenter() const { return m_mapCenter; }
    double planeHeading() const { return m_planeHeading; }
    bool hasGPSData() const { return m_hasGPSData; }
    QString latitudeText() const { return m_latitudeText; }
    QString longitudeText() const { return m_longitudeText; }
    QString altitudeText() const { return m_altitudeText; }

    // Public methods
    Q_INVOKABLE void updateGPSData(double latitude, double longitude, double altitude);

signals:
    void planeCoordinateChanged();
    void mapCenterChanged();
    void planeHeadingChanged();
    void hasGPSDataChanged();
    void gpsDataChanged();

private slots:
    void updateRandomMovement();

private:
    // Current plane state
    QGeoCoordinate m_planeCoordinate;
    QGeoCoordinate m_mapCenter;
    double m_planeHeading;
    bool m_hasGPSData;
    QString m_latitudeText;
    QString m_longitudeText;
    QString m_altitudeText;

    // GPS tracking
    QGeoCoordinate m_previousCoordinate;

    // Random movement for no-GPS mode
    QTimer *m_randomTimer;
    double m_randomHeading;
    double m_randomSpeed; // in meters per second

    // Helper methods
    void updatePlaneHeading();
    void updateGPSDisplay();
    QGeoCoordinate moveCoordinate(const QGeoCoordinate &start, double heading, double distanceMeters);
};

#endif // MAPVIEWMODEL_H
