// ThermalCameraControls.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: Theme.backgroundColor
    border.color: Theme.borderColor
    border.width: 1
    radius: 8

    property var thermalCameraViewModel

    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Text {
            text: "THERMAL CAMERA CONTROLS"
            font.pixelSize: 14
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.textColor
        }

        RowLayout {
            width: parent.width
            spacing: 10

            Text {
                text: "Thermal IP:"
                font.pixelSize: 12
                font.bold: true
                color: Theme.textColor
            }

            TextField {
                Layout.preferredWidth: 120
                text: thermalCameraViewModel.thermalIpAddress
                enabled: !thermalCameraViewModel.thermalStreaming
                color: Theme.textColor

                background: Rectangle {
                    color: Theme.surfaceColor
                    border.color: Theme.borderColor
                    border.width: 1
                    radius: 3
                }

                onTextChanged: {
                    thermalCameraViewModel.thermalIpAddress = text
                }
            }

            Text {
                text: "Port:"
                font.pixelSize: 12
                font.bold: true
                color: Theme.textColor
            }

            SpinBox {
                Layout.preferredWidth: 80
                from: 1
                to: 65535
                value: thermalCameraViewModel.thermalPort
                enabled: !thermalCameraViewModel.thermalStreaming

                background: Rectangle {
                    color: Theme.surfaceColor
                    border.color: Theme.borderColor
                    border.width: 1
                    radius: 3
                }

                contentItem: TextInput {
                    text: parent.textFromValue(parent.value, parent.locale)
                    color: Theme.textColor
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }

                onValueChanged: {
                    thermalCameraViewModel.thermalPort = value
                }
            }

            ThemedButton {
                text: thermalCameraViewModel.thermalStreamButtonText
                Layout.preferredWidth: 100
                backgroundColor: thermalCameraViewModel.thermalStreaming ? Theme.errorColor : "green"
                onClicked: thermalCameraViewModel.toggleThermalStream()
            }
        }
    }
}
