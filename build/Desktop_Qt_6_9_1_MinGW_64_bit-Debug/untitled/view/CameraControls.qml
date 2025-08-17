import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: cameraControls

    // Public properties
    property var viewModel: null
    property ThemeProperties theme: ThemeProperties {}

    // Control styling - exact match from original
    height: 120
    color: theme.backgroundColor
    border.color: theme.borderColor
    border.width: theme.borderWidth
    radius: theme.controlRadius

    Column {
        anchors.fill: parent
        anchors.margins: theme.defaultSpacing
        spacing: theme.defaultSpacing

        Text {
            text: "CAMERA CONTROLS"
            font.pixelSize: theme.subHeaderFontSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: theme.textColor
        }

        // Zoom Control - exact same as original
        RowLayout {
            width: parent.width
            spacing: theme.smallSpacing

            Text {
                text: "Zoom Level:"
                font.pixelSize: theme.captionFontSize
                font.bold: true
                color: theme.textColor
            }

            SpinBox {
                id: zoomSpinBox
                from: 0
                to: 255
                value: viewModel ? viewModel.zoomLevel : 0
                enabled: viewModel ? viewModel.connected : false

                background: Rectangle {
                    color: theme.surfaceColor
                    border.color: theme.borderColor
                    border.width: theme.borderWidth
                    radius: theme.smallRadius
                    implicitWidth: 80
                    implicitHeight: theme.spinBoxHeight
                }

                contentItem: TextInput {
                    text: parent.textFromValue(parent.value, parent.locale)
                    color: theme.textColor
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    readOnly: !parent.editable
                    validator: parent.validator
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
                    if (viewModel) {
                        viewModel.zoomLevel = value
                    }
                }
            }

            CheckBox {
                id: resetZoom
                checked: viewModel ? viewModel.zoomResetFlag : false
                enabled: viewModel ? viewModel.connected : false

                onCheckedChanged: {
                    if (viewModel) {
                        viewModel.zoomResetFlag = checked ? 1 : 0
                    }
                }
            }

            Text {
                id: resetZoomText
                color: "white"
                font.pixelSize: theme.subHeaderFontSize
                text: "Reset"
            }

            Button {
                text: "Send Zoom"
                enabled: viewModel ? viewModel.connected : false

                background: Rectangle {
                    color: theme.primaryColor
                    radius: theme.buttonRadius
                    border.color: theme.borderColor
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }

                onClicked: {
                    if (viewModel) {
                        viewModel.sendZoomCommand()
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
    }
}
