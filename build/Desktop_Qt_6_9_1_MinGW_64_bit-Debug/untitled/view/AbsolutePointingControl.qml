import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: absolutePointingControl

    // Public properties
    property var viewModel: null
    property ThemeProperties theme: ThemeProperties {}

    // Control styling - exact match from original
    height: 370  // Increased height to accommodate reset button
    color: theme.backgroundColor
    border.color: theme.borderColor
    border.width: theme.borderWidth
    radius: theme.controlRadius

    Column {
        anchors.fill: parent
        anchors.margins: theme.defaultSpacing
        spacing: theme.defaultSpacing

        Text {
            text: "ABSOLUTE POINTING CONTROL"
            font.pixelSize: theme.subHeaderFontSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: theme.textColor
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
                height: theme.buttonHeight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                enabled: viewModel ? viewModel.connected : false

                background: Rectangle {
                    color: theme.getButtonColor(upButton.pressed, upButton.hovered, theme.primaryColor)
                    border.color: upButton.pressed ? Qt.lighter(theme.borderColor, 1.5) : theme.borderColor
                    border.width: theme.thickBorderWidth
                    radius: theme.controlRadius

                    // Add subtle shadow effect
                    Rectangle {
                        anchors.fill: parent
                        anchors.topMargin: 2
                        color: "transparent"
                        border.color: Qt.rgba(255, 255, 255, 0.1)
                        border.width: theme.borderWidth
                        radius: parent.radius
                    }
                }

                contentItem: Text {
                    text: upButton.text
                    color: theme.textColor
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

                onClicked: {
                    if (viewModel) {
                        viewModel.sendJoystickUp()
                    }
                }
            }

            // Left and Right buttons
            RowLayout {
                anchors.centerIn: parent
                spacing: 60

                Button {
                    id: leftButton
                    text: "←"
                    width: 50
                    height: theme.buttonHeight
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: theme.buttonHeight
                    enabled: viewModel ? viewModel.connected : false

                    background: Rectangle {
                        color: theme.getButtonColor(leftButton.pressed, leftButton.hovered, theme.primaryColor)
                        border.color: leftButton.pressed ? Qt.lighter(theme.borderColor, 1.5) : theme.borderColor
                        border.width: theme.thickBorderWidth
                        radius: theme.controlRadius

                        // Add subtle shadow effect
                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: 2
                            color: "transparent"
                            border.color: Qt.rgba(255, 255, 255, 0.1)
                            border.width: theme.borderWidth
                            radius: parent.radius
                        }
                    }

                    contentItem: Text {
                        text: leftButton.text
                        color: theme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }

                    onClicked: {
                        if (viewModel) {
                            viewModel.sendJoystickLeft()
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
                    id: rightButton
                    text: "→"
                    width: 50
                    height: theme.buttonHeight
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: theme.buttonHeight
                    enabled: viewModel ? viewModel.connected : false

                    background: Rectangle {
                        color: theme.getButtonColor(rightButton.pressed, rightButton.hovered, theme.primaryColor)
                        border.color: rightButton.pressed ? Qt.lighter(theme.borderColor, 1.5) : theme.borderColor
                        border.width: theme.thickBorderWidth
                        radius: theme.controlRadius

                        // Add subtle shadow effect
                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: 2
                            color: "transparent"
                            border.color: Qt.rgba(255, 255, 255, 0.1)
                            border.width: theme.borderWidth
                            radius: parent.radius
                        }
                    }

                    contentItem: Text {
                        text: rightButton.text
                        color: theme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }

                    onClicked: {
                        if (viewModel) {
                            viewModel.sendJoystickRight()
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

            // Down button
            Button {
                id: downButton
                text: "↓"
                width: 50
                height: theme.buttonHeight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                enabled: viewModel ? viewModel.connected : false

                background: Rectangle {
                    color: theme.getButtonColor(downButton.pressed, downButton.hovered, theme.primaryColor)
                    border.color: downButton.pressed ? Qt.lighter(theme.borderColor, 1.5) : theme.borderColor
                    border.width: theme.thickBorderWidth
                    radius: theme.controlRadius

                    // Add subtle shadow effect
                    Rectangle {
                        anchors.fill: parent
                        anchors.topMargin: 2
                        color: "transparent"
                        border.color: Qt.rgba(255, 255, 255, 0.1)
                        border.width: theme.borderWidth
                        radius: parent.radius
                    }
                }

                contentItem: Text {
                    text: downButton.text
                    color: theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }

                onClicked: {
                    if (viewModel) {
                        viewModel.sendJoystickDown()
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

        // Current values display with text fields - exact same as original
        RowLayout {
            width: parent.width
            spacing: theme.largeSpacing

            Column {
                Text {
                    text: "Pitch Angle:"
                    font.pixelSize: theme.captionFontSize
                    font.bold: true
                    color: theme.textColor
                }
                TextField {
                    width: 80
                    height: theme.textFieldHeight
                    text: viewModel ? viewModel.pitchAngleCmd.toString() : "32767"
                    enabled: viewModel ? viewModel.connected : false
                    color: theme.textColor
                    placeholderText: "0-65535"
                    placeholderTextColor: theme.placeholderTextColor
                    selectByMouse: true

                    background: Rectangle {
                        color: theme.surfaceColor
                        border.color: theme.borderColor
                        border.width: theme.borderWidth
                        radius: theme.smallRadius
                    }

                    validator: IntValidator {
                        bottom: 0
                        top: 65535
                    }

                    onTextChanged: {
                        var value = parseInt(text)
                        if (!isNaN(value) && value >= 0 && value <= 65535 && viewModel) {
                            viewModel.pitchAngleCmd = value
                        }
                    }

                    onEditingFinished: {
                        if (viewModel) {
                            text = viewModel.pitchAngleCmd.toString()
                        }
                    }
                }
            }

            Column {
                Text {
                    text: "Yaw Angle:"
                    font.pixelSize: theme.captionFontSize
                    font.bold: true
                    color: theme.textColor
                }
                TextField {
                    width: 80
                    height: theme.textFieldHeight
                    text: viewModel ? viewModel.yawAngleCmd.toString() : "32767"
                    enabled: viewModel ? viewModel.connected : false
                    color: theme.textColor
                    placeholderText: "0-65535"
                    placeholderTextColor: theme.placeholderTextColor
                    selectByMouse: true

                    background: Rectangle {
                        color: theme.surfaceColor
                        border.color: theme.borderColor
                        border.width: theme.borderWidth
                        radius: theme.smallRadius
                    }

                    validator: IntValidator {
                        bottom: 0
                        top: 65535
                    }

                    onTextChanged: {
                        var value = parseInt(text)
                        if (!isNaN(value) && value >= 0 && value <= 65535 && viewModel) {
                            viewModel.yawAngleCmd = value
                        }
                    }

                    onEditingFinished: {
                        if (viewModel) {
                            text = viewModel.yawAngleCmd.toString()
                        }
                    }
                }
            }

            Column {
                Text {
                    text: "Stabilization:"
                    font.pixelSize: theme.captionFontSize
                    font.bold: true
                    color: theme.textColor
                }
                CheckBox {
                    checked: viewModel ? viewModel.stabilizationFlag : false
                    enabled: viewModel ? viewModel.connected : false

                    onCheckedChanged: {
                        if (viewModel) {
                            viewModel.stabilizationFlag = checked ? 1 : 0
                        }
                    }
                }
            }
        }

        // Control buttons - exact same as original
        RowLayout {
            width: parent.width
            spacing: theme.defaultSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: viewModel ? (viewModel.absolutePointingActive ? "Stop Pointing" : "Start Pointing") : "Start Pointing"
                width: 120
                height: 35
                enabled: viewModel ? viewModel.connected : false

                background: Rectangle {
                    color: viewModel ? (viewModel.absolutePointingActive ? theme.errorColor : "green") : "green"
                    radius: theme.buttonRadius
                    border.color: theme.borderColor
                    border.width: theme.borderWidth
                }

                contentItem: Text {
                    text: parent.text
                    color: theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }

                onClicked: {
                    if (viewModel) {
                        if (viewModel.absolutePointingActive) {
                            viewModel.stopAbsolutePointing()
                        } else {
                            viewModel.startAbsolutePointing()
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

            Button {
                text: "Reset Center"
                width: 100
                height: 35
                enabled: viewModel ? viewModel.connected : false

                background: Rectangle {
                    color: theme.primaryColor
                    radius: theme.buttonRadius
                    border.color: theme.borderColor
                    border.width: theme.borderWidth
                }

                contentItem: Text {
                    text: parent.text
                    color: theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }

                onClicked: {
                    if (viewModel) {
                        viewModel.pitchAngleCmd = 32767
                        viewModel.yawAngleCmd = 32767
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
            text: viewModel ? (viewModel.absolutePointingActive ?
                  "🔴 ACTIVE - Sending continuously until acknowledged" :
                  "⚪ INACTIVE - Click Start Pointing to begin") :
                  "⚪ INACTIVE - Click Start Pointing to begin"
            font.pixelSize: theme.smallFontSize
            color: viewModel ? (viewModel.absolutePointingActive ? theme.errorColor : theme.secondaryTextColor) : theme.secondaryTextColor
            wrapMode: Text.WordWrap
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
