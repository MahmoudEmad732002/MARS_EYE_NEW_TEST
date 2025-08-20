import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: cameraControlBar
    width: parent.width
    height: 60
    color: surfaceColor
    border.color: borderColor
    border.width: 1
    radius: 5

    // Theme properties - passed from parent
    property string surfaceColor: "#2d2d2d"
    property string borderColor: "#404040"
    property string textColor: "#ffffff"
    property string successColor: "#4CAF50"
    property string errorColor: "#F44336"

    // ViewModel references - passed from parent
    property var cameraViewModel
    property var serialViewModel  // ADD THIS - needed for serial connection check

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        Text {
            text: "Camera IP:"
            font.pixelSize: 12
            font.bold: true
            color: textColor
        }

        TextField {
            id: ipAddressField
            Layout.preferredWidth: 150
            text: cameraViewModel ? cameraViewModel.ipAddress : ""
            placeholderText: "192.168.1.100"
            enabled: cameraViewModel ? !cameraViewModel.streaming : true
            color: textColor
            placeholderTextColor: "#888888"

            background: Rectangle {
                color: surfaceColor
                border.color: borderColor
                border.width: 1
                radius: 3
            }

            onTextChanged: {
                if (cameraViewModel) {
                    cameraViewModel.ipAddress = text
                }
            }
        }

        Text {
            text: "Port:"
            font.pixelSize: 12
            font.bold: true
            color: textColor
        }
        SpinBox {
            id: portSpinBox
            Layout.preferredWidth: 100
            from: 1
            to: 65535
            value: cameraViewModel ? cameraViewModel.port : 8080
            enabled: cameraViewModel ? !cameraViewModel.streaming : true
            editable: true
            leftPadding: 6
            rightPadding: 28   // room for up/down buttons

            background: Rectangle {
                color: surfaceColor
                border.color: borderColor
                border.width: 1
                radius: 3
            }

            contentItem: TextInput {
                text: portSpinBox.displayText
                readOnly: !portSpinBox.editable
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                color: textColor
                validator: IntValidator { bottom: portSpinBox.from; top: portSpinBox.to }

                // Only when user presses Enter
                onAccepted: {
                    portSpinBox.value = portSpinBox.valueFromText(text, portSpinBox.locale)
                }
            }

            onValueChanged: if (cameraViewModel) cameraViewModel.port = value
        }
  Button {
            id: streamButton
            text: cameraViewModel ? cameraViewModel.streamButtonText : "Start Stream"
            Layout.preferredWidth: 120

            background: Rectangle {
                color: (cameraViewModel && cameraViewModel.streaming) ? errorColor : "green"
                radius: 5
                border.color: borderColor
                border.width: 1
            }

            contentItem: Text {
                text: streamButton.text
                color: textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: {
                if (cameraViewModel) {
                    cameraViewModel.toggleStream()
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
            hoverEnabled: false
        }

        Button {
            id: trackButton
            text: (cameraViewModel && cameraViewModel.trackingEnabled) ? "Disable Track" : "Track"
            Layout.preferredWidth: 120

            background: Rectangle {
                color: {
                    if (!parent.enabled) return "#666666"  // Disabled color
                    return (cameraViewModel && cameraViewModel.trackingEnabled) ? "#FFA500" : "#4CAF50"
                }
                radius: 5
                border.color: borderColor
                border.width: 1
            }

            contentItem: Text {
                text: trackButton.text
                color: parent.enabled ? textColor : "#999999"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            // CRITICAL: Enable only if BOTH camera is streaming AND serial is connected
            enabled: {
                var cameraOk = cameraViewModel && cameraViewModel.streaming
                var serialOk = serialViewModel && serialViewModel.connected
                return cameraOk && serialOk
            }

            onClicked: {
                if (cameraViewModel) {
                    if (cameraViewModel.trackingEnabled) {
                        cameraViewModel.disableTracking()
                    } else {
                        cameraViewModel.enableTracking()
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
            hoverEnabled: false
        }

        Item {
            Layout.fillWidth: true
        }

        // ENHANCED status and requirements display
        Column {
            spacing: 2

            Text {
                text: cameraViewModel ? cameraViewModel.cameraStatus : ""
                font.pixelSize: 10
                color: (cameraViewModel && cameraViewModel.streaming) ? successColor : errorColor
            }

            Text {
                text: (cameraViewModel && cameraViewModel.streaming) ?
                      "Frames: " + cameraViewModel.frameCount + " | FPS: " + cameraViewModel.frameRate.toFixed(1) : ""
                font.pixelSize: 9
                color: "#aaaaaa"
            }

            // TRACKING REQUIREMENTS STATUS
            Text {
                text: {
                    if (!cameraViewModel || !serialViewModel) {
                        return ""
                    }

                    var cameraOk = cameraViewModel.streaming
                    var serialOk = serialViewModel.connected

                    if (!cameraOk && !serialOk) {
                        return "Need: Camera stream + Serial connection"
                    } else if (!cameraOk) {
                        return "Need: Camera stream for tracking"
                    } else if (!serialOk) {
                        return "Need: Serial connection for tracking"
                    } else if (cameraViewModel.trackingEnabled) {
                        return "Tracking active - Click target to track"
                    } else {
                        return "Ready to enable tracking"
                    }
                }
                font.pixelSize: 9
                color: {
                    if (!cameraViewModel || !serialViewModel) return "#666666"

                    var cameraOk = cameraViewModel.streaming
                    var serialOk = serialViewModel.connected

                    if (cameraOk && serialOk) {
                        return cameraViewModel.trackingEnabled ? successColor : "#FFC107"
                    } else {
                        return errorColor
                    }
                }
                visible: text !== ""
            }
        }
    }
}
