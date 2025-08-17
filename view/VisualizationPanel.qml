// view/VisualizationPanel.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: panel
    // ---- API (match Main.qml) ----
    property bool panelVisible: false

    // theme
    property color primaryColor
    property color backgroundColor
    property color surfaceColor
    property color borderColor
    property color textColor
    property color successColor
    property color warningColor
    property color errorColor

    // view models & state used inside the panel
    property var thermalCameraViewModel    // required
    property var cameraViewModel           // required
    property bool framesSwapped: false

    signal closeRequested()

    // ---- Right slide-in placement (same behavior) ----
    width: 450
    height: parent ? parent.height - 40 : 0
    x: panelVisible ? (parent ? parent.width - width - 20 : 0) : (parent ? parent.width : 0)
    y: 20
    z: 1000
    visible: panelVisible

    Behavior on x {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    // Panel frame
    Rectangle {
        anchors.fill: parent
        color: surfaceColor
        border.color: borderColor
        border.width: 2
        radius: 10
        opacity: 0.95

        // Header
        Rectangle {
            id: header
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
                    text: "THERMAL VISUALIZATION"
                    font.pixelSize: 16
                    font.bold: true
                    Layout.fillWidth: true
                    color: textColor
                }

                Button {
                    text: "✕"
                    width: 30; height: 30
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
                    onClicked: panel.closeRequested()
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; acceptedButtons: Qt.NoButton }
                    hoverEnabled: false
                }
            }
        }

        // Content
        ColumnLayout {
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15
            spacing: 20

            // Thermal Camera Controls
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    Text {
                        text: "THERMAL CAMERA CONTROLS"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: textColor
                    }

                    RowLayout {
                        width: parent.width
                        spacing: 10

                        Text { text: "Thermal IP:"; font.pixelSize: 12; font.bold: true; color: textColor }

                        TextField {
                            Layout.preferredWidth: 120
                            text: thermalCameraViewModel.thermalIpAddress
                            enabled: !thermalCameraViewModel.thermalStreaming
                            color: textColor
                            background: Rectangle {
                                color: surfaceColor; border.color: borderColor; border.width: 1; radius: 3
                            }
                            onTextChanged: thermalCameraViewModel.thermalIpAddress = text
                        }

                        Text { text: "Port:"; font.pixelSize: 12; font.bold: true; color: textColor }

                        SpinBox {
                            Layout.preferredWidth: 80
                            from: 1; to: 65535
                            value: thermalCameraViewModel.thermalPort
                            enabled: !thermalCameraViewModel.thermalStreaming
                            background: Rectangle {
                                color: surfaceColor; border.color: borderColor; border.width: 1; radius: 3
                            }
                            contentItem: TextInput {
                                text: parent.textFromValue(parent.value, parent.locale)
                                color: textColor
                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter
                            }
                            onValueChanged: thermalCameraViewModel.thermalPort = value
                        }

                        Button {
                            text: thermalCameraViewModel.thermalStreamButtonText
                            Layout.preferredWidth: 100
                            background: Rectangle {
                                color: thermalCameraViewModel.thermalStreaming ? errorColor : "green"
                                radius: 5
                                border.color: borderColor
                                border.width: 1
                            }
                            contentItem: Text {
                                text: parent.text; color: textColor; font.bold: true
                                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: thermalCameraViewModel.toggleThermalStream()
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; acceptedButtons: Qt.NoButton }
                            hoverEnabled: false
                        }
                    }
                }
            }

            // Thermal Camera Display
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 300
                color: backgroundColor
                border.color: borderColor
                border.width: 2
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    // Status + FPS
                    Row {
                        width: parent.width
                        spacing: 20
                        Text {
                            text: thermalCameraViewModel.thermalCameraStatus
                            font.pixelSize: 12
                            color: thermalCameraViewModel.thermalStreaming ? successColor : errorColor
                        }
                        Text {
                            text: thermalCameraViewModel.thermalStreaming
                                  ? "Frames: " + thermalCameraViewModel.thermalFrameCount + " | FPS: " + thermalCameraViewModel.thermalFrameRate.toFixed(1)
                                  : ""
                            font.pixelSize: 10; color: "#aaaaaa"
                        }
                    }

                    // Display area with 16:9 sizing math
                    Item {
                        id: thermalContainer
                        width: parent.width
                        height: parent.height - 40

                        property real targetAspect: 16.0 / 9.0
                        property real availableWidth: width - 20
                        property real availableHeight: height - 20
                        property real displayWidth: {
                            var wbh = availableHeight * targetAspect
                            var hbw = availableWidth / targetAspect
                            return (hbw <= availableHeight) ? availableWidth : wbh
                        }
                        property real displayHeight: displayWidth / targetAspect

                        Image {
                            id: thermalImage
                            anchors.centerIn: parent
                            width: thermalContainer.displayWidth
                            height: thermalContainer.displayHeight
                            fillMode: Image.PreserveAspectFit
                            // Same swap behavior as in Main.qml
                            source: framesSwapped ? cameraViewModel.currentFrameUrl : thermalCameraViewModel.currentThermalFrameUrl
                            cache: false
                            smooth: true

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                border.color: thermalCameraViewModel.thermalStreaming ? "#FF6B35" : borderColor
                                border.width: 2
                                radius: 5
                                visible: thermalCameraViewModel.thermalStreaming
                            }

                            Text {
                                anchors.centerIn: parent
                                text: thermalCameraViewModel.thermalStreaming ? "" :
                                      "Thermal Camera Display\n\nConfigure IP and Port above,\nthen click 'Start Thermal'"
                                font.pixelSize: 14
                                color: "#888888"
                                horizontalAlignment: Text.AlignHCenter
                                lineHeight: 1.5
                                visible: !thermalCameraViewModel.thermalStreaming
                            }
                        }
                    }
                }
            }
        }
    }
}
