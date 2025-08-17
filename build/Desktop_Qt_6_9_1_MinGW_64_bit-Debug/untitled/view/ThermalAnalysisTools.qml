
// ThermalAnalysisTools.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: Theme.backgroundColor
    border.color: Theme.borderColor
    border.width: 1
    radius: 8

    property var cameraViewModel

    // Access the object detection info from the parent VisualizationPanel
    property var objectDetectionInfo: parent.parent.objectDetectionInfo

    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        Text {
            text: "DETECTED OBJECT"
            font.pixelSize: 14
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.textColor
        }

        // Object Detection Status
        Rectangle {
            width: parent.width
            height: 40
            color: Theme.surfaceColor
            border.color: Theme.borderColor
            radius: 5

            Row {
                anchors.centerIn: parent
                spacing: 10

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: {
                        if (!cameraViewModel.trackingEnabled) return "#666666"
                        if (objectDetectionInfo.status === "tracking") return "#00FF00"
                        if (objectDetectionInfo.status === "lost") return "#FF0000"
                        if (objectDetectionInfo.status === "waiting_for_target") return "#FFA500"
                        return "#666666"
                    }
                }

                Text {
                    text: {
                        if (!cameraViewModel.trackingEnabled) return "Tracking Disabled"
                        if (objectDetectionInfo.status === "tracking") return "TRACKING ACTIVE"
                        if (objectDetectionInfo.status === "lost") return "TARGET LOST"
                        if (objectDetectionInfo.status === "waiting_for_target") return "WAITING FOR TARGET"
                        return "READY"
                    }
                    font.pixelSize: 12
                    font.bold: true
                    color: Theme.textColor
                }
            }
        }

        // Object ROI Display
        Rectangle {
            width: parent.width
            height: 180
            color: Theme.surfaceColor
            border.color: objectDetectionInfo.status === "tracking" ? Theme.successColor : Theme.borderColor
            border.width: 2
            radius: 8

            Item {
                anchors.fill: parent
                anchors.margins: 10

                // ROI Image Display
                Image {
                    id: objectRoiImage
                    anchors.centerIn: parent
                    width: Math.min(150, parent.width - 20)
                    height: Math.min(150, parent.height - 40)
                    fillMode: Image.PreserveAspectFit
                    source: objectDetectionInfo.roiImageUrl || ""
                    cache: false
                    smooth: true
                    visible: objectDetectionInfo.status === "tracking" && objectDetectionInfo.roiImageUrl

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: Theme.successColor
                        border.width: 2
                        radius: 5
                    }

                    // Crosshair overlay
                    Rectangle {
                        anchors.centerIn: parent
                        width: 20
                        height: 2
                        color: "#FF0000"
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: 2
                        height: 20
                        color: "#FF0000"
                    }
                }

                // Placeholder text when no object
                Text {
                    anchors.centerIn: parent
                    text: {
                        if (!cameraViewModel.trackingEnabled) return "Enable tracking\nto detect objects"
                        if (objectDetectionInfo.status === "waiting_for_target") return "Click on video\nto select target"
                        if (objectDetectionInfo.status === "lost") return "Target lost\nSelect new target"
                        return "No object\nselected"
                    }
                    font.pixelSize: 12
                    color: "#888888"
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.3
                    visible: !objectRoiImage.visible
                }
            }
        }

        // Object Information Grid
        Rectangle {
            width: parent.width
            height: 80
            color: Theme.backgroundColor
            border.color: Theme.borderColor
            radius: 5
            visible: objectDetectionInfo.status === "tracking"

            GridLayout {
                anchors.fill: parent
                anchors.margins: 10
                columns: 2
                rowSpacing: 5
                columnSpacing: 15

                // Position
                Text {
                    text: "Position:"
                    font.pixelSize: 10
                    font.bold: true
                    color: Theme.textColor
                }
                Text {
                    text: objectDetectionInfo.centerX ?
                          "(" + objectDetectionInfo.centerX + ", " + objectDetectionInfo.centerY + ")" :
                          "N/A"
                    font.pixelSize: 10
                    color: Theme.successColor
                }

                // Size
                Text {
                    text: "Size:"
                    font.pixelSize: 10
                    font.bold: true
                    color: Theme.textColor
                }
                Text {
                    text: objectDetectionInfo.currentBboxWidth ?
                          objectDetectionInfo.currentBboxWidth + " × " + objectDetectionInfo.currentBboxHeight :
                          "N/A"
                    font.pixelSize: 10
                    color: Theme.successColor
                }

                // Area
                Text {
                    text: "Area:"
                    font.pixelSize: 10
                    font.bold: true
                    color: Theme.textColor
                }
                Text {
                    text: objectDetectionInfo.area ? objectDetectionInfo.area + " px²" : "N/A"
                    font.pixelSize: 10
                    color: Theme.successColor
                }

                // Confidence
                Text {
                    text: "Confidence:"
                    font.pixelSize: 10
                    font.bold: true
                    color: Theme.textColor
                }
                Text {
                    text: objectDetectionInfo.confidence ?
                          (objectDetectionInfo.confidence * 100).toFixed(1) + "%" :
                          "N/A"
                    font.pixelSize: 10
                    color: objectDetectionInfo.confidence > 0.7 ? Theme.successColor : Theme.warningColor
                }
            }
        }
    }
}
