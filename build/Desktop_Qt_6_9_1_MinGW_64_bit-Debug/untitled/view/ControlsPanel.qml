import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SerialApp 1.0

Rectangle {
    id: controlsPanel
    width: 400
    height: parent.height - 40
    color: surfaceColor
    border.color: borderColor
    border.width: 2
    radius: 10
    opacity: 0.95

    // Theme properties that need to be set from parent
    required property string primaryColor
    required property string backgroundColor
    required property string surfaceColor
    required property string borderColor
    required property string textColor
    required property string accentColor
    required property string successColor
    required property string warningColor
    required property string errorColor

    // ViewModel reference
    required property var viewModel

    // Panel header
    Rectangle {
        id: panelHeader
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
                text: "CONTROLS PANEL"
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
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.NoButton
                }
                hoverEnabled: false
                onClicked: controlsPanel.visible = false
            }
        }
    }

    // Panel content
    ScrollView {
        anchors.top: panelHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15

        Column {
            width: controlsPanel.width - 30
            spacing: 20

            // Software Joystick Control Section
            Rectangle {
                width: parent.width
                height: 280
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Text {
                        text: "SOFTWARE JOYSTICK"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: textColor
                    }

                    // Software joystick area
                    Rectangle {
                        width: 200
                        height: 200
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: surfaceColor
                        border.color: borderColor
                        border.width: 2
                        radius: 100

                        // Outer circle
                        Rectangle {
                            id: outerCircle
                            anchors.centerIn: parent
                            width: 180
                            height: 180
                            color: "transparent"
                            border.color: primaryColor
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
                            color: primaryColor
                            border.color: accentColor
                            border.width: 2
                            x: parent.width/2 - width/2
                            y: parent.height/2 - height/2

                            property real centerX: parent.width/2 - width/2
                            property real centerY: parent.height/2 - height/2
                            property real maxRadius: 70  // Maximum distance from center
                            property int joystickX: 100
                            property int joystickY: 100

                            // Inner highlight
                            Rectangle {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                radius: 10
                                color: Qt.lighter(primaryColor, 1.3)
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
                    }

                    // Value display overlay - Updated to show 0-200 range
                    Text {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 5
                        text: "X:" + joystickKnob.joystickX + " Y:" + joystickKnob.joystickY
                        font.pixelSize: 10
                        color: textColor
                        font.bold: true
                    }
                }
            }

            // Joystick Control Section
            Rectangle {
                width: parent.width
                height: 370
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Text {
                        text: "ABSOLUTE POINTING CONTROL"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: textColor
                    }

                    // Joystick visual representation and controls
                    Item {
                        width: parent.width
                        height: 180

                        // Up button
                        Button {
                            id: upButton
                            text: "↑"
                            width: 50
                            height: 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor)
                                border.color: upButton.pressed ? Qt.lighter(borderColor, 1.5) : borderColor
                                border.width: 2
                                radius: 8

                                // Add subtle shadow effect
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 2
                                    color: "transparent"
                                    border.color: Qt.rgba(255, 255, 255, 0.1)
                                    border.width: 1
                                    radius: parent.radius
                                }
                            }

                            contentItem: Text {
                                text: upButton.text
                                color: textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            onClicked: viewModel.sendJoystickUp()
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                            hoverEnabled: false
                        }

                        // Left and Right buttons
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 60

                            Button {
                                id: leftButton
                                text: "←"
                                width: 50
                                height: 40
                                Layout.preferredWidth: 50
                                Layout.preferredHeight: 40
                                enabled: viewModel.connected

                                background: Rectangle {
                                    color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor)
                                    border.color: upButton.pressed ? Qt.lighter(borderColor, 1.5) : borderColor
                                    border.width: 2
                                    radius: 8

                                    // Add subtle shadow effect
                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.topMargin: 2
                                        color: "transparent"
                                        border.color: Qt.rgba(255, 255, 255, 0.1)
                                        border.width: 1
                                        radius: parent.radius
                                    }
                                }

                                contentItem: Text {
                                    text: leftButton.text
                                    color: textColor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.bold: true
                                }

                                onClicked: viewModel.sendJoystickLeft()
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    acceptedButtons: Qt.NoButton
                                }
                                hoverEnabled: false
                            }

                            Button {
                                id: rightButton
                                text: "→"
                                width: 50
                                height: 40
                                Layout.preferredWidth: 50
                                Layout.preferredHeight: 40
                                enabled: viewModel.connected

                                background: Rectangle {
                                    color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor)
                                    border.color: upButton.pressed ? Qt.lighter(borderColor, 1.5) : borderColor
                                    border.width: 2
                                    radius: 8

                                    // Add subtle shadow effect
                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.topMargin: 2
                                        color: "transparent"
                                        border.color: Qt.rgba(255, 255, 255, 0.1)
                                        border.width: 1
                                        radius: parent.radius
                                    }
                                }

                                contentItem: Text {
                                    text: rightButton.text
                                    color: textColor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.bold: true
                                }

                                onClicked: viewModel.sendJoystickRight()
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    acceptedButtons: Qt.NoButton
                                }
                                hoverEnabled: false
                            }
                        }

                        // Down button
                        Button {
                            id: downButton
                            text: "↓"
                            width: 50
                            height: 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor)
                                border.color: upButton.pressed ? Qt.lighter(borderColor, 1.5) : borderColor
                                border.width: 2
                                radius: 8

                                // Add subtle shadow effect
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 2
                                    color: "transparent"
                                    border.color: Qt.rgba(255, 255, 255, 0.1)
                                    border.width: 1
                                    radius: parent.radius
                                }
                            }
                            contentItem: Text {
                                text: downButton.text
                                color: textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            onClicked: viewModel.sendJoystickDown()
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                            hoverEnabled: false
                        }
                    }

                    // Current values display with text fields instead of spinboxes
                    RowLayout {
                        width: parent.width
                        spacing: 20

                        Column {
                            Text {
                                text: "Pitch Angle:"
                                font.pixelSize: 11
                                font.bold: true
                                color: textColor
                            }
                            TextField {
                                width: 80
                                height: 30
                                text: viewModel.pitchAngleCmd.toString()
                                enabled: viewModel.connected
                                color: textColor
                                placeholderText: "0-65535"
                                placeholderTextColor: "#888888"
                                selectByMouse: true

                                background: Rectangle {
                                    color: surfaceColor
                                    border.color: borderColor
                                    border.width: 1
                                    radius: 3
                                }

                                validator: IntValidator {
                                    bottom: 0
                                    top: 65535
                                }

                                onTextChanged: {
                                    var value = parseInt(text)
                                    if (!isNaN(value) && value >= 0 && value <= 65535) {
                                        viewModel.pitchAngleCmd = value
                                    }
                                }

                                onEditingFinished: {
                                    text = viewModel.pitchAngleCmd.toString()
                                }
                            }
                        }

                        Column {
                            Text {
                                text: "Yaw Angle:"
                                font.pixelSize: 11
                                font.bold: true
                                color: textColor
                            }
                            TextField {
                                width: 80
                                height: 30
                                text: viewModel.yawAngleCmd.toString()
                                enabled: viewModel.connected
                                color: textColor
                                placeholderText: "0-65535"
                                placeholderTextColor: "#888888"
                                selectByMouse: true

                                background: Rectangle {
                                    color: surfaceColor
                                    border.color: borderColor
                                    border.width: 1
                                    radius: 3
                                }

                                validator: IntValidator {
                                    bottom: 0
                                    top: 65535
                                }

                                onTextChanged: {
                                    var value = parseInt(text)
                                    if (!isNaN(value) && value >= 0 && value <= 65535) {
                                        viewModel.yawAngleCmd = value
                                    }
                                }

                                onEditingFinished: {
                                    text = viewModel.yawAngleCmd.toString()
                                }
                            }
                        }

                        Column {
                            Text {
                                text: "Stabilization:"
                                font.pixelSize: 11
                                font.bold: true
                                color: textColor
                            }
                            CheckBox {
                                checked: viewModel.stabilizationFlag
                                enabled: viewModel.connected

                                onCheckedChanged: {
                                    viewModel.stabilizationFlag = checked ? 1 : 0
                                }
                            }
                        }
                    }

                    // Reset button
                    RowLayout {
                        width: parent.width
                        spacing: 15
                        anchors.horizontalCenter: parent.horizontalCenter

                        Button {
                            text: viewModel.absolutePointingActive ? "Stop Pointing" : "Start Pointing"
                            width: 120
                            height: 35
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: viewModel.absolutePointingActive ? errorColor : "green"
                                radius: 5
                                border.color: borderColor
                                border.width: 1
                            }

                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            onClicked: {
                                if (viewModel.absolutePointingActive) {
                                    viewModel.stopAbsolutePointing()
                                } else {
                                    viewModel.startAbsolutePointing()
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
                            text: "Reset Center"
                            width: 100
                            height: 35
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: primaryColor
                                radius: 5
                                border.color: borderColor
                                border.width: 1
                            }

                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            onClicked: {
                                viewModel.pitchAngleCmd = 32767
                                viewModel.yawAngleCmd = 32767
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                            hoverEnabled: false
                        }
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: viewModel.absolutePointingActive ?
                              "🔴 ACTIVE - Sending continuously until acknowledged" :
                              "⚪ INACTIVE - Click Start Pointing to begin"
                        font.pixelSize: 10
                        color: viewModel.absolutePointingActive ? errorColor : "#aaaaaa"
                        wrapMode: Text.WordWrap
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            // PID Gains Control Section
            Rectangle {
                width: parent.width
                height: 300
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    Text {
                        text: "PID GAINS CONTROL"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: textColor
                    }

                    // Azimuth PID gains
                    Rectangle {
                        width: parent.width
                        height: 90
                        color: surfaceColor
                        border.color: borderColor
                        radius: 5

                        Column {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            Text {
                                text: "Azimuth Motor PID"
                                font.pixelSize: 12
                                font.bold: true
                                color: textColor
                            }

                            RowLayout {
                                width: parent.width
                                spacing: 10

                                Column {
                                    Text {
                                        text: "Kp:"
                                        font.pixelSize: 10
                                        color: textColor
                                    }
                                    TextField {
                                        width: 80
                                        height: 30
                                        text: viewModel.azimuthKp.toString()
                                        enabled: viewModel.connected
                                        color: textColor
                                        placeholderText: "Enter value"
                                        placeholderTextColor: "#888888"
                                        selectByMouse: true

                                        background: Rectangle {
                                            color: backgroundColor
                                            border.color: borderColor
                                            border.width: 1
                                            radius: 3
                                        }

                                        validator: IntValidator {
                                            bottom: -2147483648
                                            top: 2147483647
                                        }

                                        onTextChanged: {
                                            var value = parseInt(text)
                                            if (!isNaN(value)) {
                                                viewModel.azimuthKp = value
                                            }
                                        }

                                        onEditingFinished: {
                                            text = viewModel.azimuthKp.toString()
                                        }
                                    }
                                }

                                Column {
                                    Text {
                                        text: "Ki:"
                                        font.pixelSize: 10
                                        color: textColor
                                    }
                                    TextField {
                                        width: 80
                                        height: 30
                                        text: viewModel.azimuthKi.toString()
                                        enabled: viewModel.connected
                                        color: textColor
                                        placeholderText: "Enter value"
                                        placeholderTextColor: "#888888"
                                        selectByMouse: true

                                        background: Rectangle {
                                            color: backgroundColor
                                            border.color: borderColor
                                            border.width: 1
                                            radius: 3
                                        }

                                        validator: IntValidator {
                                            bottom: -2147483648
                                            top: 2147483647
                                        }

                                        onTextChanged: {
                                            var value = parseInt(text)
                                            if (!isNaN(value)) {
                                                viewModel.azimuthKi = value
                                            }
                                        }

                                        onEditingFinished: {
                                            text = viewModel.azimuthKi.toString()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Elevation PID gains
                    Rectangle {
                        width: parent.width
                        height: 90
                        color: surfaceColor
                        border.color: borderColor
                        radius: 5

                        Column {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            Text {
                                text: "Elevation Motor PID"
                                font.pixelSize: 12
                                font.bold: true
                                color: textColor
                            }

                            RowLayout {
                                width: parent.width
                                spacing: 10

                                Column {
                                    Text {
                                        text: "Kp:"
                                        font.pixelSize: 10
                                        color: textColor
                                    }
                                    TextField {
                                        width: 80
                                        height: 30
                                        text: viewModel.elevationKp.toString()
                                        enabled: viewModel.connected
                                        color: textColor
                                        placeholderText: "Enter value"
                                        placeholderTextColor: "#888888"
                                        selectByMouse: true

                                        background: Rectangle {
                                            color: backgroundColor
                                            border.color: borderColor
                                            border.width: 1
                                            radius: 3
                                        }

                                        validator: IntValidator {
                                            bottom: -2147483648
                                            top: 2147483647
                                        }

                                        onTextChanged: {
                                            var value = parseInt(text)
                                            if (!isNaN(value)) {
                                                viewModel.elevationKp = value
                                            }
                                        }

                                        onEditingFinished: {
                                            text = viewModel.elevationKp.toString()
                                        }
                                    }
                                }

                                Column {
                                    Text {
                                        text: "Ki:"
                                        font.pixelSize: 10
                                        color: textColor
                                    }
                                    TextField {
                                        width: 80
                                        height: 30
                                        text: viewModel.elevationKi.toString()
                                        enabled: viewModel.connected
                                        color: textColor
                                        placeholderText: "Enter value"
                                        placeholderTextColor: "#888888"
                                        selectByMouse: true

                                        background: Rectangle {
                                            color: backgroundColor
                                            border.color: borderColor
                                            border.width: 1
                                            radius: 3
                                        }

                                        validator: IntValidator {
                                            bottom: -2147483648
                                            top: 2147483647
                                        }

                                        onTextChanged: {
                                            var value = parseInt(text)
                                            if (!isNaN(value)) {
                                                viewModel.elevationKi = value
                                            }
                                        }

                                        onEditingFinished: {
                                            text = viewModel.elevationKi.toString()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // PID gains buttons
                    RowLayout {
                        width: parent.width
                        spacing: 15
                        anchors.horizontalCenter: parent.horizontalCenter

                        Button {
                            text: "Send PID Gains"
                            Layout.preferredWidth: 150
                            height: 35
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: primaryColor
                                radius: 5
                                border.color: borderColor
                            }

                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            onClicked: viewModel.sendPIDGains()
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                            hoverEnabled: false
                        }

                        Button {
                            text: "Reset Gains"
                            Layout.preferredWidth: 120
                            height: 35
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: primaryColor
                                radius: 5
                                border.color: borderColor
                            }

                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            onClicked: {
                                console.log("Reset Gains button clicked - viewModel connection pending")
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                            hoverEnabled: false
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 120
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Text {
                        text: "CAMERA CONTROLS"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: textColor
                    }

                    // Zoom Control
                    RowLayout {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Zoom Level:"
                            font.pixelSize: 12
                            font.bold: true
                            color: textColor
                        }

                        SpinBox {
                            id: zoomSpinBox
                            from: 0
                            to: 255
                            value: viewModel.zoomLevel
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: surfaceColor
                                border.color: borderColor
                                border.width: 1
                                radius: 3
                                implicitWidth: 80
                                implicitHeight: 30
                            }

                            contentItem: TextInput {
                                text: parent.textFromValue(parent.value, parent.locale)
                                color: textColor
                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter
                            }

                            onValueChanged: viewModel.zoomLevel = value
                        }

                        CheckBox {
                            id: resetZoom
                            checked: viewModel.zoomResetFlag
                            enabled: viewModel.connected

                            onCheckedChanged: {
                                viewModel.zoomResetFlag = checked ? 1 : 0
                            }
                        }
                        Text {
                            id: resetZoomText
                            color: "white"
                            font.pixelSize: 14
                            text: "Reset"
                        }

                        Button {
                            text: "Send Zoom"
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: primaryColor
                                radius: 5
                                border.color: borderColor
                            }

                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            onClicked: viewModel.sendZoomCommand()
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                            hoverEnabled: false
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 100
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    Text {
                        text: "MESSAGE STATUS"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: textColor
                    }

                    Text {
                        text: "Last Acknowledged: ID " + viewModel.lastAcknowledgedMessageId
                        font.pixelSize: 11
                        color: successColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: viewModel.lastAcknowledgedMessageId > 0
                    }

                    RowLayout {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Joystick:"
                            font.pixelSize: 10
                            color: textColor
                        }
                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: viewModel.joystickActive ? "green" : "gray"
                        }

                        Text {
                            text: "Abs.Point:"
                            font.pixelSize: 10
                            color: textColor
                        }
                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: viewModel.absolutePointingActive ? "orange" : "gray"
                        }
                    }
                }
            }
        }
    }
}
