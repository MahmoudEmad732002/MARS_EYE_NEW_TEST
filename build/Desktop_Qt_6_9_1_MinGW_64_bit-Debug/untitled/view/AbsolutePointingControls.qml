// AbsolutePointingControls.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: absolutePointingControls

    // Required properties
    property var theme
    property var viewModel

    // Styling - exactly as original
    color: theme.backgroundColor
    border.color: theme.borderColor
    border.width: 1
    radius: theme.buttonRadius

    Column {
        anchors.fill: parent
        anchors.margins: theme.standardSpacing
        spacing: theme.standardSpacing

        Text {
            text: "ABSOLUTE POINTING CONTROL"
            font.pixelSize: theme.largeFontSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: theme.textColor
        }

        // Joystick visual representation and controls - exactly as original
        Item {
            width: parent.width
            height: 180

            // Up button - exactly as original
            Button {
                id: upButton
                text: "↑"
                width: 50
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                enabled: viewModel.connected

                background: Rectangle {
                    color: upButton.pressed ? Qt.darker(theme.primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(theme.primaryColor, 1.1) : theme.primaryColor)
                    border.color: upButton.pressed ? Qt.lighter(theme.borderColor, 1.5) : theme.borderColor
                    border.width: 2
                    radius: theme.buttonRadius

                    // Add subtle shadow effect - exactly as original
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

                onClicked: viewModel.sendJoystickUp()
            }

            // Left and Right buttons - exactly as original
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
                        color: leftButton.pressed ? Qt.darker(theme.primaryColor, 1.2) : (leftButton.hovered ? Qt.lighter(theme.primaryColor, 1.1) : theme.primaryColor)
                        border.color: leftButton.pressed ? Qt.lighter(theme.borderColor, 1.5) : theme.borderColor
                        border.width: 2
                        radius: theme.buttonRadius

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
                        color: theme.textColor
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
                        color: rightButton.pressed ? Qt.darker(theme.primaryColor, 1.2) : (rightButton.hovered ? Qt.lighter(theme.primaryColor, 1.1) : theme.primaryColor)
                        border.color: rightButton.pressed ? Qt.lighter(theme.borderColor, 1.5) : theme.borderColor
                        border.width: 2
                        radius: theme.buttonRadius

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
                        color: theme.textColor
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

            // Down button - exactly as original
            Button {
                id: downButton
                text: "↓"
                width: 50
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                enabled: viewModel.connected

                background: Rectangle {
                    color: downButton.pressed ? Qt.darker(theme.primaryColor, 1.2) : (downButton.hovered ? Qt.lighter(theme.primaryColor, 1.1) : theme.primaryColor)
                    border.color: downButton.pressed ? Qt.lighter(theme.borderColor, 1.5) : theme.borderColor
                    border.width: 2
                    radius: theme.buttonRadius

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
                    color: theme.textColor
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

        // Current values display with text fields - exactly as original
        RowLayout {
            width: parent.width
            spacing: theme.largeMargin

            Column {
                Text {
                    text: "Pitch Angle:"
                    font.pixelSize: 11
                    font.bold: true
                    color: theme.textColor
                }
                TextField {
                    width: 80
                    height: 30
                    text: viewModel.pitchAngleCmd.toString()
                    enabled: viewModel.connected
                    color: theme.textColor
                    placeholderText: "0-65535"
                    placeholderTextColor: "#888888"
                    selectByMouse: true

                    background: Rectangle {
                        color: theme.surfaceColor
                        border.color: theme.borderColor
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
                    color: theme.textColor
                }
                TextField {
                    width: 80
                    height: 30
                    text: viewModel.yawAngleCmd.toString()
                    enabled: viewModel.connected
                    color: theme.textColor
                    placeholderText: "0-65535"
                    placeholderTextColor: "#888888"
                    selectByMouse: true

                    background: Rectangle {
                        color: theme.surfaceColor
                        border.color: theme.borderColor
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
                    color: theme.textColor
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

        // Control buttons - exactly as original
        RowLayout {
            width: parent.width
            spacing: theme.standardSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: viewModel.absolutePointingActive ? "Stop Pointing" : "Start Pointing"
                width: 120
                height: theme.largeButtonHeight
                enabled: viewModel.connected

                background: Rectangle {
                    color: viewModel.absolutePointingActive ? theme.errorColor : "green"
                    radius: theme.standardRadius
                    border.color: theme.borderColor
                    border.width: 1
                }

                contentItem: Text {
                    text: parent.text
                    color: theme.textColor
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
                height: theme.largeButtonHeight
                enabled: viewModel.connected

                background: Rectangle {
                    color: theme.primaryColor
                    radius: theme.standardRadius
                    border.color: theme.borderColor
                    border.width: 1
                }

                contentItem: Text {
                    text: parent.text
                    color: theme.textColor
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

        // Status text - exactly as original
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: viewModel.absolutePointingActive ?
                  "🔴 ACTIVE - Sending continuously until acknowledged" :
                  "⚪ INACTIVE - Click Start Pointing to begin"
            font.pixelSize: theme.smallFontSize
            color: viewModel.absolutePointingActive ? theme.errorColor : "#aaaaaa"
            wrapMode: Text.WordWrap
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
