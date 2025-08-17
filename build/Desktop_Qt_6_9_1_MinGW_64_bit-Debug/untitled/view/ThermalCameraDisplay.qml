// ThermalCameraDisplay.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: Theme.backgroundColor
    border.color: Theme.borderColor
    border.width: 2
    radius: 8

    property var thermalCameraViewModel
    property var cameraViewModel
    property bool framesSwapped: false

    signal swapRequested()

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Status and frame info
        Row {
            width: parent.width
            spacing: 20

            Text {
                text: thermalCameraViewModel.thermalCameraStatus
                font.pixelSize: 12
                color: thermalCameraViewModel.thermalStreaming ? Theme.successColor : Theme.errorColor
            }

            Text {
                text: thermalCameraViewModel.thermalStreaming ?
                      "Frames: " + thermalCameraViewModel.thermalFrameCount + " | FPS: " + thermalCameraViewModel.thermalFrameRate.toFixed(1) : ""
                font.pixelSize: 10
                color: "#aaaaaa"
            }
        }

        // Thermal video display
        Item {
            id: thermalContainer
            width: parent.width
            height: parent.height - 40

            // Calculate maximum size that maintains 16:9 aspect ratio
            property real targetAspect: 16.0 / 9.0
            property real availableWidth: width - 20
            property real availableHeight: height - 20

            property real displayWidth: {
                var widthBasedOnHeight = availableHeight * targetAspect
                var heightBasedOnWidth = availableWidth / targetAspect

                if (heightBasedOnWidth <= availableHeight) {
                    return availableWidth
                } else {
                    return widthBasedOnHeight
                }
            }

            property real displayHeight: displayWidth / targetAspect

            Image {
                id: thermalImage
                anchors.centerIn: parent
                width: thermalContainer.displayWidth
                height: thermalContainer.displayHeight
                fillMode: Image.PreserveAspectFit
                source: root.framesSwapped ? cameraViewModel.currentFrameUrl : thermalCameraViewModel.currentThermalFrameUrl
                cache: false
                smooth: true

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: thermalCameraViewModel.thermalStreaming ? "#FF6B35" : Theme.borderColor
                    border.width: 2
                    radius: 5
                    visible: thermalCameraViewModel.thermalStreaming
                }

                Text {
                    anchors.centerIn: parent
                    text: thermalCameraViewModel.thermalStreaming ? "" : "Thermal Camera Display\n\nConfigure IP and Port above,\nthen click 'Start Thermal'"
                    font.pixelSize: 14
                    color: "#888888"
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.5
                    visible: !thermalCameraViewModel.thermalStreaming
                }

                // Add click functionality to swap frames
                MouseArea {
                    anchors.fill: parent
                    enabled: thermalCameraViewModel.thermalStreaming && cameraViewModel.streaming
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: root.swapRequested()
                }

                // Visual indicator for swap state
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 10
                    width: 80
                    height: 25
                    color: Qt.rgba(0, 0, 0, 0.7)
                    radius: 12
                    visible: thermalCameraViewModel.thermalStreaming && cameraViewModel.streaming

                    Text {
                        anchors.centerIn: parent
                        text: root.framesSwapped ? "OPTICAL" : "THERMAL"
                        font.pixelSize: 10
                        font.bold: true
                        color: root.framesSwapped ? "#00FF00" : "#FF6B35"
                    }
                }
            }

            BusyIndicator {
                anchors.centerIn: parent
                running: thermalCameraViewModel.thermalCameraStatus.indexOf("Connecting") >= 0
                visible: running
            }
        }
    }
}
