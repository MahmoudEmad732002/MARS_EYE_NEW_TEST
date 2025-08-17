import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    height: 60
    color: Theme.surfaceColor
    border.color: Theme.borderColor
    border.width: 1
    radius: 5

    property var viewModel
    property var cameraViewModel

    signal visualizationClicked()
    signal controlsClicked()
    signal mapClicked()
    signal captureClicked()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        Text {
            text: "Port:"
            font.pixelSize: 12
            font.bold: true
            color: Theme.textColor
        }

        ComboBox {
            id: portComboBox
            Layout.preferredWidth: 120
            model: viewModel.availablePorts
            enabled: !viewModel.connected

            background: Rectangle {
                color: Theme.surfaceColor
                border.color: Theme.borderColor
                border.width: 1
                radius: 3
            }

            contentItem: Text {
                text: portComboBox.displayText
                color: Theme.textColor
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }
        }

        Text {
            text: "Baud Rate:"
            font.pixelSize: 12
            font.bold: true
            color: Theme.textColor
        }

        ComboBox {
            id: baudRateComboBox
            Layout.preferredWidth: 100
            model: viewModel.baudRates
            currentIndex: 4
            enabled: !viewModel.connected

            background: Rectangle {
                color: Theme.surfaceColor
                border.color: Theme.borderColor
                border.width: 1
                radius: 3
            }

            contentItem: Text {
                text: baudRateComboBox.displayText
                color: Theme.textColor
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }
        }

        ThemedButton {
            id: connectButton
            text: viewModel.connectButtonText
            Layout.preferredWidth: 100
            backgroundColor: viewModel.connected ? "red" : "green"

            onClicked: {
                if (portComboBox.currentText && baudRateComboBox.currentText) {
                    viewModel.connectToSerial(
                        portComboBox.currentText,
                        parseInt(baudRateComboBox.currentText)
                    )
                }
            }
        }

        ThemedButton {
            text: "Visualization"
            Layout.preferredWidth: 100
            backgroundColor: Theme.primaryColor
            onClicked: root.visualizationClicked()
        }

        ThemedButton {
            text: "Controls"
            Layout.preferredWidth: 80
            enabled: viewModel.connected
            backgroundColor: viewModel.connected ? Theme.primaryColor : "#353638"
            onClicked: root.controlsClicked()
        }

        ThemedButton {
            text: "Map"
            Layout.preferredWidth: 60
            backgroundColor: Theme.primaryColor
            onClicked: root.mapClicked()
        }

        ThemedButton {
            text: "Capture"
            Layout.preferredWidth: 80
            backgroundColor: Theme.primaryColor
            onClicked: root.captureClicked()
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: viewModel.statusMessage
            font.pixelSize: 11
            color: viewModel.connected ? Theme.successColor : Theme.errorColor
        }
    }
}
