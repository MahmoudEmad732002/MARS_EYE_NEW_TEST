import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: pidGainsControl

    // Public properties
    property var viewModel: null
    property ThemeProperties theme: ThemeProperties {}

    // Control styling - exact match from original
    height: 300
    color: theme.backgroundColor
    border.color: theme.borderColor
    border.width: theme.borderWidth
    radius: theme.controlRadius

    Column {
        anchors.fill: parent
        anchors.margins: theme.defaultSpacing
        spacing: theme.smallSpacing

        Text {
            text: "PID GAINS CONTROL"
            font.pixelSize: theme.subHeaderFontSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: theme.textColor
        }

        // Azimuth PID gains
        Rectangle {
            width: parent.width
            height: 90
            color: theme.surfaceColor
            border.color: theme.borderColor
            radius: theme.buttonRadius

            Column {
                anchors.fill: parent
                anchors.margins: theme.smallSpacing
                spacing: theme.controlRadius

                Text {
                    text: "Azimuth Motor PID"
                    font.pixelSize: theme.captionFontSize
                    font.bold: true
                    color: theme.textColor
                }

                RowLayout {
                    width: parent.width
                    spacing: theme.smallSpacing

                    Column {
                        Text {
                            text: "Kp:"
                            font.pixelSize: theme.smallFontSize
                            color: theme.textColor
                        }
                        TextField {
                            width: 80
                            height: theme.textFieldHeight
                            text: viewModel ? viewModel.azimuthKp.toString() : "0"
                            enabled: viewModel ? viewModel.connected : false
                            color: theme.textColor
                            placeholderText: "Enter value"
                            placeholderTextColor: theme.placeholderTextColor
                            selectByMouse: true

                            background: Rectangle {
                                color: theme.backgroundColor
                                border.color: theme.borderColor
                                border.width: theme.borderWidth
                                radius: theme.smallRadius
                            }

                            validator: IntValidator {
                                bottom: -2147483648
                                top: 2147483647
                            }

                            onTextChanged: {
                                var value = parseInt(text)
                                if (!isNaN(value) && viewModel) {
                                    viewModel.azimuthKp = value
                                }
                            }

                            onEditingFinished: {
                                // Ensure the field shows the actual value in case of invalid input
                                if (viewModel) {
                                    text = viewModel.azimuthKp.toString()
                                }
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
                            height: theme.textFieldHeight
                            text: viewModel ? viewModel.azimuthKi.toString() : "0"
                            enabled: viewModel ? viewModel.connected : false
                            color: theme.textColor
                            placeholderText: "Enter value"
                            placeholderTextColor: theme.placeholderTextColor
                            selectByMouse: true

                            background: Rectangle {
                                color: theme.backgroundColor
                                border.color: theme.borderColor
                                border.width: theme.borderWidth
                                radius: theme.smallRadius
                            }

                            validator: IntValidator {
                                bottom: -2147483648
                                top: 2147483647
                            }

                            onTextChanged: {
                                var value = parseInt(text)
                                if (!isNaN(value) && viewModel) {
                                    viewModel.azimuthKi = value
                                }
                            }

                            onEditingFinished: {
                                // Ensure the field shows the actual value in case of invalid input
                                if (viewModel) {
                                    text = viewModel.azimuthKi.toString()
                                }
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
            color: theme.surfaceColor
            border.color: theme.borderColor
            radius: theme.buttonRadius

            Column {
                anchors.fill: parent
                anchors.margins: theme.smallSpacing
                spacing: theme.controlRadius

                Text {
                    text: "Elevation Motor PID"
                    font.pixelSize: theme.captionFontSize
                    font.bold: true
                    color: theme.textColor
                }

                RowLayout {
                    width: parent.width
                    spacing: theme.smallSpacing

                    Column {
                        Text {
                            text: "Kp:"
                            font.pixelSize: theme.smallFontSize
                            color: theme.textColor
                        }
                        TextField {
                            width: 80
                            height: theme.textFieldHeight
                            text: viewModel ? viewModel.elevationKp.toString() : "0"
                            enabled: viewModel ? viewModel.connected : false
                            color: theme.textColor
                            placeholderText: "Enter value"
                            placeholderTextColor: theme.placeholderTextColor
                            selectByMouse: true

                            background: Rectangle {
                                color: theme.backgroundColor
                                border.color: theme.borderColor
                                border.width: theme.borderWidth
                                radius: theme.smallRadius
                            }

                            validator: IntValidator {
                                bottom: -2147483648
                                top: 2147483647
                            }

                            onTextChanged: {
                                var value = parseInt(text)
                                if (!isNaN(value) && viewModel) {
                                    viewModel.elevationKp = value
                                }
                            }

                            onEditingFinished: {
                                // Ensure the field shows the actual value in case of invalid input
                                if (viewModel) {
                                    text = viewModel.elevationKp.toString()
                                }
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
                            height: theme.textFieldHeight
                            text: viewModel ? viewModel.elevationKi.toString() : "0"
                            enabled: viewModel ? viewModel.connected : false
                            color: theme.textColor
                            placeholderText: "Enter value"
                            placeholderTextColor: theme.placeholderTextColor
                            selectByMouse: true

                            background: Rectangle {
                                color: theme.backgroundColor
                                border.color: theme.borderColor
                                border.width: theme.borderWidth
                                radius: theme.smallRadius
                            }

                            validator: IntValidator {
                                bottom: -2147483648
                                top: 2147483647
                            }

                            onTextChanged: {
                                var value = parseInt(text)
                                if (!isNaN(value) && viewModel) {
                                    viewModel.elevationKi = value
                                }
                            }

                            onEditingFinished: {
                                // Ensure the field shows the actual value in case of invalid input
                                if (viewModel) {
                                    text = viewModel.elevationKi.toString()
                                }
                            }
                        }
                    }
                }
            }
        }

        // PID gains buttons
        RowLayout {
            width: parent.width
            spacing: theme.defaultSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Send PID Gains"
                Layout.preferredWidth: 150
                height: 35
                enabled: viewModel ? viewModel.connected : false

                background: Rectangle {
                    color: theme.primaryColor
                    radius: theme.buttonRadius
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
                    if (viewModel) {
                        viewModel.sendPIDGains()
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
                enabled: viewModel ? viewModel.connected : false

                background: Rectangle {
                    color: theme.primaryColor
                    radius: theme.buttonRadius
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
                    // Reset PID gains functionality - to be connected with viewModel later
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
