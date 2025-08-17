import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    height: 60
    color: surfaceColor
    border.color: borderColor
    border.width: 1
    radius: 5

    // Properties
    property var viewModel
    property string primaryColor: "#FF4713"
    property string surfaceColor: "#2d2d2d"
    property string borderColor: "#404040"
    property string textColor: "#ffffff"
    property string successColor: "#4CAF50"
    property string errorColor: "#F44336"

    // Signals
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
            color: textColor
        }

        ComboBox {
            id: portComboBox
            Layout.preferredWidth: 120
            model: viewModel.availablePorts
            enabled: !viewModel.connected

            background: Rectangle {
                color: surfaceColor
                border.color: borderColor
                border.width: 1
                radius: 3
            }

            contentItem: Text {
                text: portComboBox.displayText
                color: textColor
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }
        }

        Text {
            text: "Baud Rate:"
            font.pixelSize: 12
            font.bold: true
            color: textColor
        }

        ComboBox {
            id: baudRateComboBox
            Layout.preferredWidth: 100
            model: viewModel.baudRates
            currentIndex: 4
            enabled: !viewModel.connected

            background: Rectangle {
                color: surfaceColor
                border.color: borderColor
                border.width: 1
                radius: 3
            }

            contentItem: Text {
                text: baudRateComboBox.displayText
                color: textColor
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }
        }

        Button {
            id: connectButton
            text: viewModel.connectButtonText
            Layout.preferredWidth: 100

            background: Rectangle {
                color: viewModel.connected ? "red" : "green"
                radius: 5
                border.color: borderColor
                border.width: 1
            }
            contentItem: Text {
                text: connectButton.text
                color: textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }
            onClicked: {
                if (portComboBox.currentText && baudRateComboBox.currentText) {
                    viewModel.connectToSerial(
                        portComboBox.currentText,
                        parseInt(baudRateComboBox.currentText)
                    )
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
            id: visualizationButton
            text: "Visualization"
            Layout.preferredWidth: 100

            background: Rectangle {
                color: primaryColor
                radius: 5
                border.color: borderColor
                border.width: 1
            }

            contentItem: Text {
                text: visualizationButton.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: root.visualizationClicked()
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
            hoverEnabled: false
        }

        Button {
            id: controlsButton
            text: "Controls"
            Layout.preferredWidth: 80
            enabled: viewModel.connected

            background: Rectangle {
                color: viewModel.connected ? primaryColor : "#353638"
                radius: 5
                border.color: borderColor
                border.width: 1
            }

            contentItem: Text {
                text: controlsButton.text
                color: textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: root.controlsClicked()
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
            hoverEnabled: false
        }

        Button {
            id: mapButton
            text: "Map"
            Layout.preferredWidth: 60

            background: Rectangle {
                color: primaryColor
                radius: 5
                border.color: borderColor
                border.width: 1
            }

            contentItem: Text {
                text: mapButton.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: root.mapClicked()
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
            hoverEnabled: false
        }

        Button {
            id: captureButton
            text: "Capture"
            Layout.preferredWidth: 80

            background: Rectangle {
                color: primaryColor
                radius: 5
                border.color: borderColor
                border.width: 1
            }

            contentItem: Text {
                text: captureButton.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: root.captureClicked()
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
            hoverEnabled: false
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: viewModel.statusMessage
            font.pixelSize: 11
            color: viewModel.connected ? successColor : errorColor
        }
    }
}
