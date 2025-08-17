// GPSDataDisplay.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    height: 150
    color: Theme.backgroundColor
    border.color: mapViewModel.hasGPSData ? Theme.successColor : Theme.warningColor
    border.width: 2
    radius: 8

    property var mapViewModel

    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 12

        Text {
            text: mapViewModel.hasGPSData ? "GPS DATA" : "RANDOM MODE"
            font.pixelSize: 14
            font.bold: true
            color: mapViewModel.hasGPSData ? Theme.successColor : Theme.warningColor
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Latitude
        Row {
            width: parent.width
            spacing: 10

            Text {
                text: "Latitude:"
                font.pixelSize: 12
                font.bold: true
                color: Theme.textColor
                width: 70
            }

            Text {
                text: mapViewModel.latitudeText
                font.pixelSize: 12
                color: mapViewModel.hasGPSData ? Theme.successColor : Theme.warningColor
                font.bold: true
            }
        }

        // Longitude
        Row {
            width: parent.width
            spacing: 10

            Text {
                text: "Longitude:"
                font.pixelSize: 12
                font.bold: true
                color: Theme.textColor
                width: 70
            }

            Text {
                text: mapViewModel.longitudeText
                font.pixelSize: 12
                color: mapViewModel.hasGPSData ? Theme.successColor : Theme.warningColor
                font.bold: true
            }
        }

        // Altitude
        Row {
            width: parent.width
            spacing: 10

            Text {
                text: "Altitude:"
                font.pixelSize: 12
                font.bold: true
                color: Theme.textColor
                width: 70
            }

            Text {
                text: mapViewModel.altitudeText
                font.pixelSize: 12
                color: mapViewModel.hasGPSData ? Theme.successColor : Theme.warningColor
                font.bold: true
            }
        }
    }
}
