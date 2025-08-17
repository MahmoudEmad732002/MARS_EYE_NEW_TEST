import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: softwareJoystickControl

    // Public properties
    property var viewModel: null
    property ThemeProperties theme: ThemeProperties {}

    // Control styling - exact match from original
    height: 280
    color: theme.backgroundColor
    border.color: theme.borderColor
    border.width: theme.borderWidth
    radius: theme.controlRadius

    Column {
        anchors.fill: parent
        anchors.margins: theme.defaultSpacing
        spacing: theme.defaultSpacing

        Text {
            text: "SOFTWARE JOYSTICK"
            font.pixelSize: theme.subHeaderFontSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: theme.textColor
        }

        // Software joystick area
        Rectangle {
            width: theme.joystickOuterSize
            height: theme.joystickOuterSize
            anchors.horizontalCenter: parent.horizontalCenter
            color: theme.surfaceColor
            border.color: theme.borderColor
            border.width: theme.thickBorderWidth
            radius: theme.joystickOuterSize / 2

            // Outer circle
            Rectangle {
                id: outerCircle
                anchors.centerIn: parent
                width: theme.joystickInnerSize
                height: theme.joystickInnerSize
                color: "transparent"
                border.color: theme.primaryColor
                border.width: theme.thickBorderWidth
                radius: theme.joystickInnerSize / 2
            }

            // Center crosshair
            Rectangle {
                anchors.centerIn: parent
                width: 20
                height: 2
                color: theme.crosshairColor
            }
            Rectangle {
                anchors.centerIn: parent
                width: 2
                height: 20
                color: theme.crosshairColor
            }

            // Draggable knob
            Rectangle {
                id: joystickKnob
                width: theme.joystickKnobSize
                height: theme.joystickKnobSize
                radius: theme.joystickKnobSize / 2
                color: theme.primaryColor
                border.color: theme.accentColor
                border.width: theme.thickBorderWidth
                x: parent.width/2 - width/2
                y: parent.height/2 - height/2

                property real centerX: parent.width/2 - width/2
                property real centerY: parent.height/2 - height/2
                property real maxRadius: theme.joystickMaxRadius  // Maximum distance from center

                // Current joystick values (127 center, 0-255 range) - exact same as original
                property int joystickX: 127
                property int joystickY: 127

                // Inner highlight
                Rectangle {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    radius: 10
                    color: Qt.lighter(theme.primaryColor, 1.3)
                }

                MouseArea {
                    id: joystickMouseArea
                    anchors.fill: parent
                    drag.target: parent
                    enabled: viewModel ? viewModel.connected : false

                    property real startX: 0
                    property real startY: 0

                    onPressed: {
                        startX = mouse.x
                        startY = mouse.y
                    }

                    onPositionChanged: {
                        if (drag.active) {
                            // Calculate distance from center
                            var deltaX = joystickKnob.x - joystickKnob.centerX
                            var deltaY = joystickKnob.y - joystickKnob.centerY
                            var distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)

                            // Constrain to circle
                            if (distance > joystickKnob.maxRadius) {
                                var angle = Math.atan2(deltaY, deltaX)
                                joystickKnob.x = joystickKnob.centerX + joystickKnob.maxRadius * Math.cos(angle)
                                joystickKnob.y = joystickKnob.centerY + joystickKnob.maxRadius * Math.sin(angle)
                            }

                            // Update joystick values (convert to 0-255 range with 127 center)
                            var normalizedX = (joystickKnob.x - joystickKnob.centerX) / joystickKnob.maxRadius
                            var normalizedY = (joystickKnob.y - joystickKnob.centerY) / joystickKnob.maxRadius

                            // Convert to joystick values (127 is center, 0-255 range)
                            joystickKnob.joystickX = Math.round(127 + normalizedX * 127)
                            joystickKnob.joystickY = Math.round(127 - normalizedY * 127)  // Invert Y axis

                            // Clamp values to 0-255 range
                            joystickKnob.joystickX = Math.max(0, Math.min(255, joystickKnob.joystickX))
                            joystickKnob.joystickY = Math.max(0, Math.min(255, joystickKnob.joystickY))

                            // Send joystick command to backend
                            if (viewModel && viewModel.connected) {
                                viewModel.sendSoftwareJoystickCommand(joystickKnob.joystickX, joystickKnob.joystickY)
                            }
                        }
                    }

                    onReleased: {
                        // Return to center with animation
                        returnAnimation.start()

                        // Reset to center values and send
                        joystickKnob.joystickX = 127
                        joystickKnob.joystickY = 127
                        if (viewModel && viewModel.connected) {
                            viewModel.stopJoystickCommand()
                        }
                    }
                }

                // Return to center animation - exact same as original
                ParallelAnimation {
                    id: returnAnimation
                    NumberAnimation {
                        target: joystickKnob
                        property: "x"
                        to: joystickKnob.centerX
                        duration: theme.joystickReturnDuration
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        target: joystickKnob
                        property: "y"
                        to: joystickKnob.centerY
                        duration: theme.joystickReturnDuration
                        easing.type: Easing.OutQuad
                    }

                    onFinished: {
                        // Ensure center values are set after animation
                        joystickKnob.joystickX = 127
                        joystickKnob.joystickY = 127
                    }
                }
            }

            // Value display overlay - exact same as original
            Text {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: theme.tinySpacing
                text: "X:" + joystickKnob.joystickX + " Y:" + joystickKnob.joystickY
                font.pixelSize: theme.smallFontSize
                color: theme.textColor
                font.bold: true
            }
        }
    }
}
