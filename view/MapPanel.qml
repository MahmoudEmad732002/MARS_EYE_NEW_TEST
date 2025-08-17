// view/MapPanel.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick.Layouts
Rectangle {
    id: mapPanel
    width: 400
    height: parent.height - 40
    color: surfaceColor
    border.color: borderColor
    border.width: 2
    radius: 10
    opacity: 0.95

    // Required properties from parent
    required property var mapViewModel
    required property string surfaceColor
    required property string borderColor
    required property string primaryColor
    required property string textColor
    required property string successColor
    required property string warningColor
    required property string errorColor

    // Panel header
    Rectangle {
        id: mapHeader
        width: parent.width
        height: 50
        color: primaryColor
        border.color: borderColor
        radius: 10
        anchors.top: parent.top

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Text {
                text: "MAP VIEW"
                font.pixelSize: 16
                font.bold: true
                Layout.fillWidth: true
                color: textColor
            }

            Button {
                text: "✕"
                width: 30
                height: 30

                background: Rectangle {
                    color: parent.pressed ? Qt.darker(errorColor, 1.2) : errorColor
                    radius: 15
                    border.color: borderColor
                }

                contentItem: Text {
                    text: parent.text
                    color: textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }

                onClicked: mapPanel.visible = false
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.NoButton
                }
                hoverEnabled: false
            }
        }
    }

    // Panel content
    Column {
        anchors.top: mapHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15
        spacing: 15

        // Map View
        Rectangle {
            width: parent.width
            height: 450
            color: backgroundColor
            border.color: borderColor
            border.width: 2
            radius: 8
            clip: true

            Map {
                id: map
                anchors.fill: parent
                anchors.margins: 2

                // Map plugin - OpenStreetMap (free)
                plugin: Plugin {
                    name: "osm"
                }

                center: mapViewModel.mapCenter
                zoomLevel: 12

                // Plane marker
                MapQuickItem {
                    id: planeMarker
                    coordinate: mapViewModel.planeCoordinate
                    anchorPoint.x: planeIcon.width / 2
                    anchorPoint.y: planeIcon.height / 2

                    sourceItem: Rectangle {
                        id: planeIcon
                        width: 32
                        height: 32
                        color: "transparent"

                        rotation: mapViewModel.planeHeading

                        // Plane shape
                        Canvas {
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.clearRect(0, 0, width, height);

                                // Set plane color based on GPS status
                                ctx.fillStyle = mapViewModel.hasGPSData ? "#00FF00" : "#FFAA00";
                                ctx.strokeStyle = "#FFFFFF";
                                ctx.lineWidth = 2;

                                // Draw plane shape
                                ctx.beginPath();
                                // Nose
                                ctx.moveTo(width/2, 2);
                                // Right wing
                                ctx.lineTo(width/2 + 10, height/2 + 5);
                                ctx.lineTo(width/2 + 8, height/2 + 8);
                                // Right tail
                                ctx.lineTo(width/2 + 3, height - 2);
                                ctx.lineTo(width/2 + 1, height - 2);
                                ctx.lineTo(width/2 + 1, height/2 + 8);
                                // Body
                                ctx.lineTo(width/2, height/2 + 6);
                                ctx.lineTo(width/2 - 1, height/2 + 8);
                                ctx.lineTo(width/2 - 1, height - 2);
                                ctx.lineTo(width/2 - 3, height - 2);
                                // Left tail
                                ctx.lineTo(width/2 - 8, height/2 + 8);
                                ctx.lineTo(width/2 - 10, height/2 + 5);
                                // Left wing
                                ctx.closePath();

                                ctx.fill();
                                ctx.stroke();
                            }
                        }

                        // Pulsing effect for GPS mode
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width + 10
                            height: parent.height + 10
                            color: "transparent"
                            border.color: mapViewModel.hasGPSData ? "#00FF00" : "#FFAA00"
                            border.width: 2
                            radius: width / 2
                            opacity: 0.3

                            SequentialAnimation on scale {
                                running: true
                                loops: Animation.Infinite
                                NumberAnimation { from: 1.0; to: 1.3; duration: 1000 }
                                NumberAnimation { from: 1.3; to: 1.0; duration: 1000 }
                            }
                        }
                    }
                }
            }
        }

        // GPS Data Display Rectangle
        Rectangle {
            width: parent.width
            height: 150
            color: backgroundColor
            border.color: mapViewModel.hasGPSData ? successColor : warningColor
            border.width: 2
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 12

                Text {
                    text: mapViewModel.hasGPSData ? "GPS DATA" : "RANDOM MODE"
                    font.pixelSize: 14
                    font.bold: true
                    color: mapViewModel.hasGPSData ? successColor : warningColor
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
                        color: textColor
                        width: 70
                    }

                    Text {
                        text: mapViewModel.latitudeText
                        font.pixelSize: 12
                        color: mapViewModel.hasGPSData ? successColor : warningColor
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
                        color: textColor
                        width: 70
                    }

                    Text {
                        text: mapViewModel.longitudeText
                        font.pixelSize: 12
                        color: mapViewModel.hasGPSData ? successColor : warningColor
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
                        color: textColor
                        width: 70
                    }

                    Text {
                        text: mapViewModel.altitudeText
                        font.pixelSize: 12
                        color: mapViewModel.hasGPSData ? successColor : warningColor
                        font.bold: true
                    }
                }
            }
        }
    }
}
