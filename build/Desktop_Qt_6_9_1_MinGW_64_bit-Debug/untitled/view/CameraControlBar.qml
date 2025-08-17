import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: cameraControlBar

    // Public properties
    property var cameraViewModel: null
    property ThemeProperties theme: ThemeProperties {}

    // Camera control bar styling - exact match from original
    width: parent.width
    height: theme.cameraControlBarHeight
    color: theme.surfaceColor
    border.color: theme.borderColor
    border.width: theme.borderWidth
    radius: theme.buttonRadius

    RowLayout {
        anchors.fill: parent
        anchors.margins: theme.smallSpacing
        spacing: theme.defaultSpacing

        Text {
            text: "Camera IP:"
            font.pixelSize: theme.captionFontSize
            font.bold: true
            color: theme.textColor
        }

        TextField {
            id: ipAddressField
            Layout.preferredWidth: 150
            text: cameraViewModel ? cameraViewModel.ipAddress : ""
            placeholderText: "192.168.1.100"
            enabled: cameraViewModel ? !cameraViewModel.streaming : true
            color: theme.textColor
            placeholderTextColor: theme.placeholderTextColor

            background: Rectangle {
                color: theme.surfaceColor
                border.color: theme.borderColor
                border.width: theme.borderWidth
                radius: theme.smallRadius
            }

            onTextChanged: {
                if (cameraViewModel) {
                    cameraViewModel.ipAddress = text
                }
            }
        }

        Text {
            text: "Port:"
            font.pixelSize: theme.captionFontSize
            font.bold: true
            color: theme.textColor
        }

        SpinBox {
            id: portSpinBox
            Layout.preferredWidth: 100
            from: 1
            to: 65535
            value: cameraViewModel ? cameraViewModel.port : 8080
            enabled: cameraViewModel ? !cameraViewModel.streaming : true

            background: Rectangle {
                color: theme.surfaceColor
                border.color: theme.borderColor
                border.width: theme.borderWidth
                radius: theme.smallRadius
            }

            contentItem: TextInput {
                text: portSpinBox.textFromValue(portSpinBox.value, portSpinBox.locale)
                color: theme.textColor
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                readOnly: !portSpinBox.editable
                validator: portSpinBox.validator
                inputMethodHints: Qt.ImhDigitsOnly
            }

            up.indicator: Rectangle {
                x: parent.width - width
                height: parent.height / 2
                implicitWidth: 20
                implicitHeight: 10
                color: parent.up.pressed ? Qt.darker(theme.surfaceColor, 1.2) : theme.surfaceColor
                border.color: theme.borderColor

                Text {
                    text: "+"
                    font.pixelSize: theme.smallFontSize
                    color: theme.textColor
                    anchors.centerIn: parent
                }
            }

            down.indicator: Rectangle {
                x: parent.width - width
                y: parent.height / 2
                height: parent.height / 2
                implicitWidth: 20
                implicitHeight: 10
                color: parent.down.pressed ? Qt.darker(theme.surfaceColor, 1.2) : theme.surfaceColor
                border.color: theme.borderColor

                Text {
                    text: "-"
                    font.pixelSize: theme.smallFontSize
                    color: theme.textColor
                    anchors.centerIn: parent
                }
            }

            onValueChanged: {
                if (cameraViewModel) {
                    cameraViewModel.port = value
                }
            }
        }

        Button {
            id: streamButton
            text: cameraViewModel ? cameraViewModel.streamButtonText : "Start Stream"
            Layout.preferredWidth: 120

            background: Rectangle {
                color: cameraViewModel ? (cameraViewModel.streaming ? theme.errorColor : "green") : "green"
                radius: theme.buttonRadius
                border.color: theme.borderColor
                border.width: theme.borderWidth
            }

            contentItem: Text {
                text: streamButton.text
                color: theme.textColor
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
            text: cameraViewModel ? (cameraViewModel.trackingEnabled ? "Disable Track" : "Track") : "Track"
            Layout.preferredWidth: 120

            background: Rectangle {
                color: cameraViewModel ? (cameraViewModel.trackingEnabled ? "#FFA500" : "#4CAF50") : "#4CAF50"
                radius: theme.buttonRadius
                border.color: theme.borderColor
                border.width: theme.borderWidth
            }

            contentItem: Text {
                text: trackButton.text
                color: theme.textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            enabled: cameraViewModel ? cameraViewModel.streaming : false

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

        // Camera status and frame info
        Column {
            spacing: 2

            Text {
                text: cameraViewModel ? cameraViewModel.cameraStatus : "Disconnected"
                font.pixelSize: theme.smallFontSize
                color: cameraViewModel ? theme.getStatusColor(cameraViewModel.streaming) : theme.errorColor
            }

            Text {
                text: (cameraViewModel && cameraViewModel.streaming) ?
                      "Frames: " + cameraViewModel.frameCount + " | FPS: " + cameraViewModel.frameRate.toFixed(1) : ""
                font.pixelSize: theme.tinyFontSize
                color: theme.secondaryTextColor
            }
        }
    }
}
