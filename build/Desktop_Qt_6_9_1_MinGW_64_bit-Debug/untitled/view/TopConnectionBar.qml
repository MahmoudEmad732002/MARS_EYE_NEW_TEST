import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    height: 60
    color: parent ? parent.surfaceColor || "#2d2d2d" : "#2d2d2d"
    border.color: parent ? parent.borderColor || "#404040" : "#404040"
    border.width: 1
    radius: 5

    // Properties for theming
    property string primaryColor: parent ? parent.primaryColor || "#FF4713" : "#FF4713"
    property string surfaceColor: parent ? parent.surfaceColor || "#2d2d2d" : "#2d2d2d"
    property string borderColor: parent ? parent.borderColor || "#404040" : "#404040"
    property string textColor: parent ? parent.textColor || "#ffffff" : "#ffffff"
    property string successColor: parent ? parent.successColor || "#4CAF50" : "#4CAF50"
    property string errorColor: parent ? parent.errorColor || "#F44336" : "#F44336"

    // Required properties
    property var viewModel

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
            color: root.textColor
        }

        ComboBox {
            id: portComboBox
            Layout.preferredWidth: 120
            model: viewModel.availablePorts
            enabled: !viewModel.connected

            background: Rectangle {
                color: root.surfaceColor
                border.color: root.borderColor
                border.width: 1
                radius: 3
            }

            contentItem: Text {
                text: portComboBox.displayText
                color: root.textColor
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }
        }

        Text {
            text: "Baud Rate:"
            font.pixelSize: 12
            font.bold: true
            color: root.textColor
        }

        ComboBox {
            id: baudRateComboBox
            Layout.preferredWidth: 100
            model: viewModel.baudRates
            currentIndex: 4
            enabled: !viewModel.connected

            background: Rectangle {
                color: root.surfaceColor
                border.color: root.borderColor
                border.width: 1
                radius: 3
            }

            contentItem: Text {
                text: baudRateComboBox.displayText
                color: root.textColor
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
                border.color: root.borderColor
                border.width: 1
            }

            contentItem: Text {
                text: connectButton.text
                color: root.textColor
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

        // Visualization button
        Button {
            id: visualizationButton
            text: "Visualization"
            Layout.preferredWidth: 100

            background: Rectangle {
                color: root.primaryColor
                radius: 5
                border.color: root.borderColor
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
                color: viewModel.connected ? root.primaryColor : "#353638"
                radius: 5
                border.color: root.borderColor
                border.width: 1
            }

            contentItem: Text {
                text: controlsButton.text
                color: root.textColor
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
                color: root.primaryColor
                radius: 5
                border.color: root.borderColor
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
                color: root.primaryColor
                radius: 5
                border.color: root.borderColor
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
            color: viewModel.connected ? root.successColor : root.errorColor
        }
    }
}
