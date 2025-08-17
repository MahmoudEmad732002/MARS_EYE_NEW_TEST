// CameraControlsSection.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    height: 120
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
            text: "CAMERA CONTROLS"
            font.pixelSize: 14
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.textColor
        }

        // Zoom Control
        RowLayout {
            width: parent.width
            spacing: 10

            Text {
                text: "Zoom Level:"
                font.pixelSize: 12
                font.bold: true
                color: Theme.textColor
            }

            SpinBox {
                id: zoomSpinBox
                from: 0
                to: 255
                value: viewModel.zoomLevel
                enabled: viewModel.connected

                background: Rectangle {
                    color: Theme.surfaceColor
                    border.color: Theme.borderColor
                    border.width: 1
                    radius: 3
                    implicitWidth: 80
                    implicitHeight: 30
                }

                contentItem: TextInput {
                    text: parent.textFromValue(parent.value, parent.locale)
                    color: Theme.textColor
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

            ThemedButton {
                text: "Send Zoom"
                enabled: viewModel.connected
                onClicked: viewModel.sendZoomCommand()
            }
        }
    }
}
