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

    // Add JoystickReceiver
    JoystickReceiver {
        id: joystickReceiver

        Component.onCompleted: {
            // Start listening for UDP joystick data on port 12345
            joystickReceiver.startListening(12345)
            console.log("JoystickReceiver: Started listening on port 12345")
        }

        // When physical joystick data is received, update the software joystick
        onJoystickDataReceived: function(x, y) {
            // Only update if physical joystick is active and software joystick isn't being dragged
            if (joystickReceiver.physicalJoystickActive && !joystickMouseArea.drag.active) {
                updateSoftwareJoystickPosition(x, y)
                // Send to backend
                if (viewModel.connected) {
                    viewModel.sendSoftwareJoystickCommand(x, y)
                }
            }
        }

        onConnectedChanged: {
            console.log("Physical joystick connected:", joystickReceiver.connected)
        }

        onErrorOccurred: function(error) {
            console.log("Joystick receiver error:", error)
        }
    }

    // Helper function to update software joystick position from physical joystick
    function updateSoftwareJoystickPosition(physicalX, physicalY) {
        // Convert from 0-200 range to visual position
        var normalizedX = (physicalX - 100) / 100.0  // Changed from 127
        var normalizedY = (physicalY - 100) / 100.0  // Changed from 127

        // Convert to visual position
        var visualX = joystickKnob.centerX + normalizedX * joystickKnob.maxRadius
        var visualY = joystickKnob.centerY + normalizedY * joystickKnob.maxRadius

        // Update knob position smoothly
        joystickKnob.x = visualX
        joystickKnob.y = visualY
        joystickKnob.joystickX = physicalX
        joystickKnob.joystickY = physicalY
    }
    function updateJoystickValuesFromPosition() {
        // Calculate normalized position
        var normalizedX = (joystickKnob.x - joystickKnob.centerX) / joystickKnob.maxRadius
        var normalizedY = (joystickKnob.y - joystickKnob.centerY) / joystickKnob.maxRadius

        // Convert to joystick values (100 is center, 0-200 range)
        joystickKnob.joystickX = Math.round(100 + normalizedX * 100)  // Changed from 127
        joystickKnob.joystickY = Math.round(100 - normalizedY * 100)  // Changed from 127

        // Clamp values to 0-200 range
        joystickKnob.joystickX = Math.max(0, Math.min(200, joystickKnob.joystickX))  // Changed from 255
        joystickKnob.joystickY = Math.max(0, Math.min(200, joystickKnob.joystickY))  // Changed from 255

        // Send joystick command to backend
        if (viewModel.connected) {
            viewModel.sendSoftwareJoystickCommand(joystickKnob.joystickX, joystickKnob.joystickY)
        }
    }

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

            // Software Joystick Control Section - UPDATED
            Rectangle {
                width: parent.width
                height: 300  // Increased height for status indicator
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // Title with physical joystick status indicator
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10

                        Text {
                            text: "SOFTWARE JOYSTICK"
                            font.pixelSize: 14
                            font.bold: true
                            color: textColor
                        }

                        // Physical joystick status indicator
                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            color: joystickReceiver.connected ? successColor : "#666666"
                            anchors.verticalCenter: parent.verticalCenter

                            // Pulsing animation when connected
                            SequentialAnimation on opacity {
                                running: joystickReceiver.connected
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.5; duration: 1000 }
                                NumberAnimation { to: 1.0; duration: 1000 }
                            }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: joystickReceiver.connected ? "Physical" : "Manual Only"
                            font.pixelSize: 10
                            color: joystickReceiver.connected ? successColor : "#888888"
                            font.bold: true
                        }
                    }

                    // Software joystick area - UPDATED
                    Rectangle {
                        width: 200
                        height: 200
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: surfaceColor
                        border.color: borderColor
                        border.width: 2
                        radius: 100

                        // Outer circle - changes color based on control mode
                        Rectangle {
                            id: outerCircle
                            anchors.centerIn: parent
                            width: 180
                            height: 180
                            color: "transparent"
                            border.color: joystickReceiver.physicalJoystickActive ? successColor : primaryColor
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

                        // Draggable knob - UPDATED
                        Rectangle {
                            id: joystickKnob
                            width: 40
                            height: 40
                            radius: 20
                            color: joystickReceiver.physicalJoystickActive ? successColor : primaryColor
                            border.color: accentColor
                            border.width: 2
                            x: parent.width/2 - width/2
                            y: parent.height/2 - height/2

                            property real centerX: parent.width/2 - width/2
                            property real centerY: parent.height/2 - height/2
                            property real maxRadius: 70  // Maximum distance from center
                            property int joystickX: 100  // Start at center (0-255 range)
                            property int joystickY: 100  // Start at center (0-255 range)

                            // Inner highlight - changes based on control mode
                            Rectangle {
                                anchors.centerIn: parent
                                width: joystickReceiver.physicalJoystickActive ? 30 : 20
                                height: joystickReceiver.physicalJoystickActive ? 30 : 20
                                radius: width / 2
                                color: joystickReceiver.physicalJoystickActive ?
                                       Qt.lighter(successColor, 1.3) : Qt.lighter(primaryColor, 1.3)

                                // Pulsing animation when physical joystick is active
                                SequentialAnimation on opacity {
                                    running: joystickReceiver.physicalJoystickActive
                                    loops: Animation.Infinite
                                    NumberAnimation { to: 0.5; duration: 500 }
                                    NumberAnimation { to: 1.0; duration: 500 }
                                }
                            }

                            MouseArea {
                                id: joystickMouseArea
                                anchors.fill: parent
                                drag.target: parent
                                // Disable manual control when physical joystick is active
                                enabled: viewModel.connected && !joystickReceiver.physicalJoystickActive

                                property real startX: 0
                                property real startY: 0

                                onPressed: {
                                    startX = mouse.x
                                    startY = mouse.y
                                }

                                onPositionChanged: {
                                    if (drag.active && !joystickReceiver.physicalJoystickActive) {
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

                                        // Update joystick values and send to backend
                                        updateJoystickValuesFromPosition()
                                    }
                                }

                                onReleased: {
                                    if (!joystickReceiver.physicalJoystickActive) {
                                        // Return to center with animation only if not controlled by physical joystick
                                        returnAnimation.start()
                                    }
                                }
                            }

                            // Return to center animation - UPDATED
                            ParallelAnimation {
                                id: returnAnimation
                                running: false

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
                                    if (!joystickReceiver.physicalJoystickActive) {
                                        joystickKnob.joystickX = 100
                                        joystickKnob.joystickY = 100
                                        if (viewModel.connected) {
                                            viewModel.stopJoystickCommand()
                                        }
                                    }
                                }
                            }

                            // Function to calculate joystick values from visual position
                            function updateJoystickValuesFromPosition() {
                                // Calculate normalized position
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
                    }

                    // Value display overlay - UPDATED to show source and connection status
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 15

                        Text {
                            text: "X:" + joystickKnob.joystickX + " Y:" + joystickKnob.joystickY
                            font.pixelSize: 10
                            color: textColor
                            font.bold: true
                        }

                        Text {
                            text: joystickReceiver.physicalJoystickActive ? "PHYSICAL" : "MANUAL"
                            font.pixelSize: 9
                            color: joystickReceiver.physicalJoystickActive ? successColor : "#aaaaaa"
                            font.bold: true
                        }

                        Text {
                            text: joystickReceiver.connected ? "🎮" : "⚫"
                            font.pixelSize: 12
                            visible: true
                        }
                    }
                }
            }

            // Joystick Control Section
            Rectangle {
                width: parent.width
                height: 420  // Increased height for new button
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
                                color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : primaryColor
                                border.color: borderColor
                                border.width: 2
                                radius: 8
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

                        // Left and Right buttons (same as before but call updated methods)
                        // Replace the Left and Right buttons section (around line 277-342) with this:

                        // Left and Right buttons - FIXED to match up/down button sizes
                        Row {
                            anchors.centerIn: parent
                            spacing: 60

                            Button {
                                id: leftButton
                                text: "←"
                                width: 50  // Same as up/down buttons
                                height: 40 // Same as up/down buttons
                                enabled: viewModel.connected
                                background: Rectangle {
                                    color: leftButton.pressed ? Qt.darker(primaryColor, 1.2) : primaryColor
                                    border.color: borderColor
                                    border.width: 2
                                    radius: 8
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
                                width: 50  // Same as up/down buttons
                                height: 40 // Same as up/down buttons
                                enabled: viewModel.connected
                                background: Rectangle {
                                    color: rightButton.pressed ? Qt.darker(primaryColor, 1.2) : primaryColor
                                    border.color: borderColor
                                    border.width: 2
                                    radius: 8
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
                        } // Down button
                        Button {
                            id: downButton
                            text: "↓"
                            width: 50
                            height: 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: downButton.pressed ? Qt.darker(primaryColor, 1.2) : primaryColor
                                border.color: borderColor
                                border.width: 2
                                radius: 8
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

                    // Current values display with UPDATED ranges
                    RowLayout {
                        width: parent.width
                        spacing: 20

                        Column {
                            Text {
                                text: "Pitch Angle (-90° to 10°):"
                                font.pixelSize: 11
                                font.bold: true
                                color: textColor
                            }
                            SpinBox {
                                id: pitchSpin
                                width: 120
                                height: 30
                                from: -90
                                to: 10
                                stepSize: 1
                                value: Math.round(viewModel.pitchAngle)
                                enabled: viewModel.connected
                                editable: false          // keep it non-editable
                                leftPadding: 6
                                rightPadding: 28         // <-- reserve space for the up/down buttons

                                background: Rectangle {
                                    color: surfaceColor
                                    border.color: borderColor
                                    border.width: 1
                                    radius: 3
                                }

                                // Use Text for read-only display so no input steals clicks
                                contentItem: TextInput {
                                    text: pitchSpin.displayText
                                    readOnly: true           // important
                                    horizontalAlignment: Qt.AlignHCenter
                                    verticalAlignment: Qt.AlignVCenter
                                    color: textColor
                                }

                                onValueChanged: viewModel.pitchAngle = value
                            }

                        }

                        Column {
                            Text {
                                text: "Yaw Angle (-180° to 180°):"
                                font.pixelSize: 11
                                font.bold: true
                                color: textColor
                            }
                            SpinBox {
                                id: yawSpin
                                width: 120
                                height: 30
                                from: -180
                                to: 180
                                stepSize: 1
                                value: Math.round(viewModel.yawAngle)
                                enabled: viewModel.connected
                                editable: false      // keep it read-only
                                leftPadding: 6
                                rightPadding: 28     // <-- important: leave room for the arrows

                                background: Rectangle {
                                    color: surfaceColor
                                    border.color: borderColor
                                    border.width: 1
                                    radius: 3
                                }

                                // Use Text for read-only display (simpler, no input issues)
                                contentItem: TextInput {
                                    text: yawSpin.displayText
                                    readOnly: true
                                    color: textColor
                                    horizontalAlignment: Qt.AlignHCenter
                                    verticalAlignment: Qt.AlignVCenter
                                }


                                onValueChanged: viewModel.yawAngle = value
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

                    // NEW: Send Pitch/Yaw button (replaces auto-send behavior)
                    RowLayout {
                        width: parent.width
                        spacing: 15
                        anchors.horizontalCenter: parent.horizontalCenter

                        Button {
                            text: "Send Pitch/Yaw"
                            width: 130
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
                                viewModel.sendPitchYaw()
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                            hoverEnabled: false
                        }

                        Button {
                            text: viewModel.absolutePointingActive ? "Stop Pointing" : "Reset"
                            width: 120
                            height: 35
                            enabled: viewModel.connected

                            background: Rectangle {
                                color: viewModel.absolutePointingActive ? errorColor : primaryColor
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
                                    viewModel.pitchAngle = 0.0
                                    viewModel.yawAngle = 0.0
                                }
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
                              "⚪ INACTIVE - Click 'Send Pitch/Yaw' to transmit"
                        font.pixelSize: 10
                        color: viewModel.absolutePointingActive ? errorColor : "#aaaaaa"
                        wrapMode: Text.WordWrap
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            } // PID Gains Control Section
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
                                    Text { text: "Azimuth Kp:"; font.pixelSize: 11; font.bold: true; color: textColor }
                                    TextField {
                                            id: azKpField
                                            width: 80; height: 30
                                            text: (viewModel.azimuthKp / 1000.0).toString()
                                            validator: DoubleValidator { bottom: 0.0; top: 50.0; decimals: 3 }
                                            onEditingFinished: {
                                                var v = parseFloat(text)
                                                if (!isNaN(v) && v >= 0 && v <= 50) {
                                                    viewModel.azimuthKp = Math.round(v * 1000)
                                                }
                                                text = (viewModel.azimuthKp / 1000.0).toString()
                                            }
                                        }
                                }

                                Column {
                                    Text { text: "Azimuth Ki:"; font.pixelSize: 11; font.bold: true; color: textColor }
                                    TextField {
                                          id: azKiField
                                          width: 80; height: 30
                                          text: (viewModel.azimuthKi / 1000.0).toString()
                                          validator: DoubleValidator { bottom: 0.0; top: 50.0; decimals: 3 }
                                          onEditingFinished: {
                                              var v = parseFloat(text)
                                              if (!isNaN(v) && v >= 0 && v <= 50) {
                                                  viewModel.azimuthKi = Math.round(v * 1000)
                                              }
                                              text = (viewModel.azimuthKi / 1000.0).toString()
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
                                    Text { text: "Elevation Kp:"; font.pixelSize: 11; font.bold: true; color: textColor }
                                    TextField {
                                           id: elKpField
                                           width: 80; height: 30
                                           text: (viewModel.elevationKp / 1000.0).toString()
                                           validator: DoubleValidator { bottom: 0.0; top: 50.0; decimals: 3 }
                                           onEditingFinished: {
                                               var v = parseFloat(text)
                                               if (!isNaN(v) && v >= 0 && v <= 50) {
                                                   viewModel.elevationKp = Math.round(v * 1000)
                                               }
                                               text = (viewModel.elevationKp / 1000.0).toString()
                                           }

                                       }
                                }

                                Column {
                                    Text { text: "Elevation Ki:"; font.pixelSize: 11; font.bold: true; color: textColor }
                                    TextField {
                                            id: elKiField
                                            width: 80; height: 30
                                            text: (viewModel.elevationKi / 1000.0).toString()
                                            validator: DoubleValidator { bottom: 0.0; top: 50.0; decimals: 3 }
                                            onEditingFinished: {
                                                var v = parseFloat(text)
                                                if (!isNaN(v) && v >= 0 && v <= 50) {
                                                    viewModel.elevationKi = Math.round(v * 1000)
                                                }
                                                text = (viewModel.elevationKi / 1000.0).toString()
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

                            onClicked: {
                                       function isValid(tf) {
                                           var v = parseFloat(tf.text)
                                           return !isNaN(v) && v >= 0 && v <= 50
                                       }

                                       if (isValid(azKpField) && isValid(azKiField) &&
                                           isValid(elKpField) && isValid(elKiField)) {
                                           viewModel.sendPIDGains()
                                       } else {
                                           console.log("❌ PID Gains not sent: one or more fields out of range (0–50).")
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
                            stepSize: 1
                            value: viewModel.zoomLevel
                            enabled: viewModel.connected
                            leftPadding: 6
                            rightPadding: 28    // <-- leaves space for up/down buttons

                            background: Rectangle {
                                color: surfaceColor
                                border.color: borderColor
                                border.width: 1
                                radius: 3
                                implicitWidth: 80
                                implicitHeight: 30
                            }

                            // Use Text for clean, read-only display
                            contentItem: TextInput {
                                text: zoomSpinBox.displayText
                                readOnly: true
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
                height: 120  // Increased height for physical joystick status
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

                        Text {
                            text: "Physical:"
                            font.pixelSize: 10
                            color: textColor
                        }
                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: joystickReceiver.connected ? successColor : "gray"
                        }
                    }

                    // Physical joystick connection info
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: joystickReceiver.connected ?
                              "🎮 Physical joystick connected (UDP:12345)" :
                              "🎮 No physical joystick (Start Python bridge)"
                        font.pixelSize: 9
                        color: joystickReceiver.connected ? successColor : "#888888"
                        wrapMode: Text.WordWrap
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
