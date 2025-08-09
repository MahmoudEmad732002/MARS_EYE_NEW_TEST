#include "mapviewmodel.h"
#include <QRandomGenerator>
#include <QtMath>

MapViewModel::MapViewModel(QObject *parent)
    : QObject(parent)
    , m_planeCoordinate(32.5518, 35.8500) // Irbid, Jordan
    , m_mapCenter(32.5518, 35.8500)
    , m_planeHeading(0.0)
    , m_hasGPSData(false)
    , m_latitudeText("No Data")
    , m_longitudeText("No Data")
    , m_altitudeText("No Data")
    , m_randomHeading(0.0)
    , m_randomSpeed(20.0) // 20 m/s for random movement
{
    // Setup random movement timer
    m_randomTimer = new QTimer(this);
    m_randomTimer->setInterval(1000); // Update every second
    connect(m_randomTimer, &QTimer::timeout, this, &MapViewModel::updateRandomMovement);

    // Start with random movement
    m_randomHeading = QRandomGenerator::global()->bounded(360);
    m_randomTimer->start();

    updateGPSDisplay();
}

void MapViewModel::updateGPSData(double latitude, double longitude, double altitude)
{
    // Check if we have valid GPS data
    bool hasValidGPS = (qAbs(latitude) > 0.001 || qAbs(longitude) > 0.001);

    if (hasValidGPS != m_hasGPSData) {
        m_hasGPSData = hasValidGPS;
        emit hasGPSDataChanged();
    }

    if (m_hasGPSData) {
        // Stop random movement when we have GPS data
        if (m_randomTimer->isActive()) {
            m_randomTimer->stop();
        }

        // Store previous coordinate for heading calculation
        m_previousCoordinate = m_planeCoordinate;

        // Update plane position
        QGeoCoordinate newCoordinate(latitude, longitude, altitude);
        m_planeCoordinate = newCoordinate;
        emit planeCoordinateChanged();

        // Update heading based on movement
        updatePlaneHeading();

        // Always center map on plane when GPS is active
        m_mapCenter = m_planeCoordinate;
        emit mapCenterChanged();
    } else {
        // Resume random movement if no GPS data
        if (!m_randomTimer->isActive()) {
            m_randomTimer->start();
        }
    }

    updateGPSDisplay();
}

void MapViewModel::updateRandomMovement()
{
    if (m_hasGPSData) {
        return; // Don't do random movement when we have GPS data
    }

    // Occasionally change direction (every 5-10 seconds)
    static int counter = 0;
    counter++;

    if (counter >= QRandomGenerator::global()->bounded(5, 11)) {
        // Change heading by ±30 degrees
        double headingChange = QRandomGenerator::global()->bounded(-30, 30);
        m_randomHeading = fmod(m_randomHeading + headingChange + 360.0, 360.0);
        counter = 0;
    }

    // Move the plane
    QGeoCoordinate newCoordinate = moveCoordinate(m_planeCoordinate, m_randomHeading, m_randomSpeed);
    m_planeCoordinate = newCoordinate;
    m_planeHeading = m_randomHeading;

    emit planeCoordinateChanged();
    emit planeHeadingChanged();

    // Always center map on plane during random movement
    m_mapCenter = m_planeCoordinate;
    emit mapCenterChanged();

    updateGPSDisplay();
}

void MapViewModel::updatePlaneHeading()
{
    if (m_previousCoordinate.isValid() && m_planeCoordinate.isValid()) {
        // Calculate bearing between previous and current position
        double heading = m_previousCoordinate.azimuthTo(m_planeCoordinate);
        m_planeHeading = heading;
        emit planeHeadingChanged();
    }
}

void MapViewModel::updateGPSDisplay()
{
    if (m_hasGPSData) {
        m_latitudeText = QString::number(m_planeCoordinate.latitude(), 'f', 6) + "°";
        m_longitudeText = QString::number(m_planeCoordinate.longitude(), 'f', 6) + "°";
        m_altitudeText = QString::number(m_planeCoordinate.altitude(), 'f', 1) + " m";
    } else {
        // Show random coordinates for random mode
        m_latitudeText = QString::number(m_planeCoordinate.latitude(), 'f', 6) + "° (Random)";
        m_longitudeText = QString::number(m_planeCoordinate.longitude(), 'f', 6) + "° (Random)";
        m_altitudeText = "Random Mode";
    }
    emit gpsDataChanged();
}

QGeoCoordinate MapViewModel::moveCoordinate(const QGeoCoordinate &start, double heading, double distanceMeters)
{
    // Convert to radians
    double lat1 = qDegreesToRadians(start.latitude());
    double lon1 = qDegreesToRadians(start.longitude());
    double bearingRad = qDegreesToRadians(heading);

    // Earth's radius in meters
    const double R = 6378137.0;

    // Calculate new position
    double lat2 = qAsin(qSin(lat1) * qCos(distanceMeters / R) +
                        qCos(lat1) * qSin(distanceMeters / R) * qCos(bearingRad));

    double lon2 = lon1 + qAtan2(qSin(bearingRad) * qSin(distanceMeters / R) * qCos(lat1),
                                qCos(distanceMeters / R) - qSin(lat1) * qSin(lat2));

    // Convert back to degrees
    return QGeoCoordinate(qRadiansToDegrees(lat2), qRadiansToDegrees(lon2));
}
