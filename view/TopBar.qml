import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: topBar
    width: parent.width
    height: 60
    color: surfaceColor
    border.color: borderColor
    border.width: 1
    radius: 5

    // Theme properties - passed from parent
    property string primaryColor: "#FF4713"
    property string backgroundColor: "#1a1a1a"
    property string surfaceColor: "#2d2d2d"
    property string borderColor: "#404040"
    property string textColor: "#ffffff"
    property string successColor: "#4CAF50"
    property string errorColor: "#F44336"

    // ViewModel reference - passed from parent
    property var viewModel

    // Panel visibility properties - passed from parent
    property bool visualizationPanelVisible: false
    property bool controlsPanelVisible: false
    property bool mapPanelVisible: false
    property bool capturePanelVisible: false

    // Signals for panel visibility changes
    signal visualizationPanelToggled()
    signal controlsPanelToggled()
    signal mapPanelToggled()
    signal capturePanelToggled()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        Image {
            id: logo
            source: "qrc:/images/Variant3.png"   // <-- remove the stray space after qrc:/
            Layout.preferredWidth: 100
            Layout.preferredHeight: 40
            fillMode: Image.PreserveAspectFit
        }

        Text {
            text: "Port:"
            font.pixelSize: 12
            font.bold: true
            color: textColor
        }

        ComboBox {
            id: portComboBox
            Layout.preferredWidth: 80
            model: viewModel ? viewModel.availablePorts : []
            enabled: viewModel ? !viewModel.connected : false

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
            model: viewModel ? viewModel.baudRates : []
            currentIndex: 4
            enabled: viewModel ? !viewModel.connected : false

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
            text: viewModel ? viewModel.connectButtonText : "Connect"
            Layout.preferredWidth: 100

            background: Rectangle {
                color: (viewModel && viewModel.connected) ? "red" : "green"
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
                if (viewModel && portComboBox.currentText && baudRateComboBox.currentText) {
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

            onClicked: {
                visualizationPanelToggled()
            }

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
            enabled: viewModel ? viewModel.connected : false

            background: Rectangle {
                color: (viewModel && viewModel.connected) ? primaryColor : "#353638"
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

            onClicked: {
                controlsPanelToggled()
            }

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

            onClicked: {
                mapPanelToggled()
            }

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

            onClicked: {
                capturePanelToggled()
            }

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
            text: viewModel ? viewModel.statusMessage : ""
            font.pixelSize: 11
            color: (viewModel && viewModel.connected) ? successColor : errorColor
        }
    }
}
