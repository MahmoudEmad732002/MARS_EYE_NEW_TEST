// PIDGainsControls.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: pidGainsControls

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
        spacing: theme.smallMargin

        Text {
            text: "PID GAINS CONTROL"
            font.pixelSize: theme.largeFontSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: theme.textColor
        }

        // Azimuth PID gains - exactly as original
        Rectangle {
            width: parent.width
            height: 90
            color: theme.surfaceColor
            border.color: theme.borderColor
            radius: theme.standardRadius

            Column {
                anchors.fill: parent
                anchors.margins: theme.smallMargin
                spacing: 8

                Text {
                    text: "Azimuth Motor PID"
                    font.pixelSize: theme.standardFontSize
                    font.bold: true
                    color: theme.textColor
                }

                RowLayout {
                    width: parent.width
                    spacing: theme.smallMargin

                    Column {
                        Text {
                            text: "Kp:"
                            font.pixelSize: theme.smallFontSize
                            color: theme.textColor
                        }
                        TextField {
                            width: 80
                            height: 30
                            text: viewModel.azimuthKp.toString()
                            enabled: viewModel.connected
                            color: theme.textColor
                            placeholderText: "Enter value"
                            placeholderTextColor: "#888888"
                            selectByMouse: true

                            background: Rectangle {
                                color: theme.backgroundColor
                                border.color: theme.borderColor
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
                                // Ensure the field shows the actual value in case of invalid input
                                text = viewModel.azimuthKp.toString()
                            }
                        }
                    }

                    Column {
                        Text {
                            text: "Ki:"
                            font.pixelSize: theme.smallFontSize
                            color: theme.textColor
                        }
                        TextField {
                            width: 80
                            height: 30
                            text: viewModel.azimuthKi.toString()
                            enabled: viewModel.connected
                            color: theme.textColor
                            placeholderText: "Enter value"
                            placeholderTextColor: "#888888"
                            selectByMouse: true

                            background: Rectangle {
                                color: theme.backgroundColor
                                border.color: theme.borderColor
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
                                // Ensure the field shows the actual value in case of invalid input
                                text = viewModel.azimuthKi.toString()
                            }
                        }
                    }
                }
            }
        }

        // Elevation PID gains - exactly as original
        Rectangle {
            width: parent.width
            height: 90
            color: theme.surfaceColor
            border.color: theme.borderColor
            radius: theme.standardRadius

            Column {
                anchors.fill: parent
                anchors.margins: theme.smallMargin
                spacing: 8

                Text {
                    text: "Elevation Motor PID"
                    font.pixelSize: theme.standardFontSize
                    font.bold: true
                    color: theme.textColor
                }

                RowLayout {
                    width: parent.width
                    spacing: theme.smallMargin

                    Column {
                        Text {
                            text: "Kp:"
                            font.pixelSize: theme.smallFontSize
                            color: theme.textColor
                        }
                        TextField {
                            width: 80
                            height: 30
                            text: viewModel.elevationKp.toString()
                            enabled: viewModel.connected
                            color: theme.textColor
                            placeholderText: "Enter value"
                            placeholderTextColor: "#888888"
                            selectByMouse: true

                            background: Rectangle {
                                color: theme.backgroundColor
                                border.color: theme.borderColor
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
                                // Ensure the field shows the actual value in case of invalid input
                                text = viewModel.elevationKp.toString()
                            }
                        }
                    }

                    Column {
                        Text {
                            text: "Ki:"
                            font.pixelSize: theme.smallFontSize
                            color: theme.textColor
                        }
                        TextField {
                            width: 80
                            height: 30
                            text: viewModel.elevationKi.toString()
                            enabled: viewModel.connected
                            color: theme.textColor
                            placeholderText: "Enter value"
                            placeholderTextColor: "#888888"
                            selectByMouse: true

                            background: Rectangle {
                                color: theme.backgroundColor
                                border.color: theme.borderColor
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
                                // Ensure the field shows the actual value in case of invalid input
                                text = viewModel.elevationKi.toString()
                            }
                        }
                    }
                }
            }
        }

        // PID gains buttons - exactly as original
        RowLayout {
            width: parent.width
            spacing: theme.standardSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Send PID Gains"
                Layout.preferredWidth: 150
                height: theme.largeButtonHeight
                enabled: viewModel.connected

                background: Rectangle {
                    color: theme.primaryColor
                    radius: theme.standardRadius
                    border.color: theme.borderColor
                }

                contentItem: Text {
                    text: parent.text
                    color: theme.textColor
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
                height: theme.largeButtonHeight
                enabled: viewModel.connected

                background: Rectangle {
                    color: theme.primaryColor
                    radius: theme.standardRadius
                    border.color: theme.borderColor
                }

                contentItem: Text {
                    text: parent.text
                    color: theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }

                onClicked: {
                    // Reset PID gains functionality - exactly as original comment
                    console.log("Reset Gains button clicked - viewModel connection pending")
                    // Future: viewModel.resetPIDGains() or similar
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
