import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    height: 280
    color: Theme.backgroundColor
    border.color: Theme.borderColor
    border.width: 1
    radius: 8

    property var viewModel

    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        Text {
            text: "SOFTWARE JOYSTICK"
            font.pixelSize: 14
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.textColor
        }

        // Software joystick area
        Rectangle {
            width: 200
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.surfaceColor
            border.color: Theme.borderColor
            border.width: 2
            radius: 100

            // Outer circle
            Rectangle {
                id: outerCircle
                anchors.centerIn: parent
                width: 180
                height: 180
                color: "transparent"
                border.color: Theme.primaryColor
                border.width: 2
                radius: 90
            }

            // Center crosshair
            Rectangle {
                anchors.centerIn: parent
                width: 20
                height: 2
                color: "#666666"
            }
            Rectangle {
                anchors.centerIn: parent
                width: 2
                height: 20
                color: "#666666"
            }

            // Draggable knob
            Rectangle {
                id: joystickKnob
                width: 40
                height: 40
                radius: 20
                color: Theme.primaryColor
                border.color: Theme.accentColor
                border.width: 2
                x: parent.width/2 - width/2
                y: parent.height/2 - height/2

                property real centerX: parent.width/2 - width/2
                property real centerY: parent.height/2 - height/2
                property real maxRadius: 70

                // Current joystick values (0-200 range with 100,100 center)
                property int joystickX: 100
                property int joystickY: 100

                // Inner highlight
                Rectangle {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    radius: 10
                    color: Qt.lighter(Theme.primaryColor, 1.3)
                }

                MouseArea {
                    id: joystickMouseArea
                    anchors.fill: parent
                    drag.target: parent
                    enabled: viewModel.connected

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
                            if (viewModel.connected) {
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
                        if (viewModel.connected) {
                            viewModel.stopJoystickCommand()
                        }
                    }
                }

                // Return to center animation
                ParallelAnimation {
                    id: returnAnimation
                    NumberAnimation {
                        target: joystickKnob
                        property: "x"
                        to: joystickKnob.centerX
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        target: joystickKnob
                        property: "y"
                        to: joystickKnob.centerY
                        duration: 200
                        easing.type: Easing.OutQuad
                    }

                    onFinished: {
                        // Ensure center values are set after animation
                        joystickKnob.joystickX = 100
                        joystickKnob.joystickY = 100
                    }
                }
            }

            // Value display overlay
            Text {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 5
                text: "X:" + joystickKnob.joystickX + " Y:" + joystickKnob.joystickY
                font.pixelSize: 10
                color: Theme.textColor
                font.bold: true
            }
        }
    }
}
