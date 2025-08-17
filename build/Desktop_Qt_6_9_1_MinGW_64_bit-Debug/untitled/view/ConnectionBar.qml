import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SerialApp 1.0  // This is crucial for accessing ViewModel types

Rectangle {
    id: connectionBar

    // Public properties
    property var viewModel: null
    property ThemeProperties theme: null  // Will be passed from parent

    // Internal properties for ComboBox state management
    property string selectedPort: ""
    property string selectedBaudRate: ""

    // Debug component - add this to help diagnose the issue
    Component.onCompleted: {
        console.log("=== CONNECTION BAR DEBUG ===")
        console.log("ConnectionBar viewModel:", viewModel)
        if (viewModel) {
            console.log("  - availablePorts:", viewModel.availablePorts)
            console.log("  - availablePorts length:", viewModel.availablePorts ? viewModel.availablePorts.length : "undefined")
            console.log("  - availablePorts type:", typeof viewModel.availablePorts)

            console.log("  - baudRates:", viewModel.baudRates)
            console.log("  - baudRates length:", viewModel.baudRates ? viewModel.baudRates.length : "undefined")
            console.log("  - baudRates type:", typeof viewModel.baudRates)

            console.log("  - connected:", viewModel.connected)
            console.log("  - statusMessage:", viewModel.statusMessage)
            console.log("  - connectButtonText:", viewModel.connectButtonText)

            // Force refresh ports
            console.log("Calling refreshPorts()...")
            viewModel.refreshPorts()

            // Check again after refresh
            setTimeout(function() {
                console.log("After refresh - availablePorts:", viewModel.availablePorts)
                console.log("After refresh - baudRates:", viewModel.baudRates)
            }, 100)
        } else {
            console.log("  - viewModel is null!")
        }
    }

    // Signals for panel visibility
    signal visualizationClicked()
    signal controlsClicked()
    signal mapClicked()
    signal captureClicked()

    // Connection bar styling - exact match from original
    width: parent.width
    height: theme ? theme.connectionBarHeight : 60
    color: theme ? theme.surfaceColor : "#2d2d2d"
    border.color: theme ? theme.borderColor : "#404040"
    border.width: theme ? theme.borderWidth : 1
    radius: theme ? theme.buttonRadius : 5

    RowLayout {
        anchors.fill: parent
        anchors.margins: theme ? theme.smallSpacing : 10
        spacing: theme ? theme.defaultSpacing : 15

        Text {
            text: "Port:"
            font.pixelSize: theme ? theme.captionFontSize : 12
            font.bold: true
            color: theme ? theme.textColor : "#ffffff"
        }

        ComboBox {
            id: portComboBox
            Layout.preferredWidth: 120
            model: {
                // Test with fallback values
                if (viewModel && viewModel.availablePorts && viewModel.availablePorts.length > 0) {
                    return viewModel.availablePorts
                } else {
                    console.log("Using fallback ports - viewModel:", viewModel)
                    return ["COM1", "COM2", "COM3", "/dev/ttyUSB0"] // Fallback for testing
                }
            }
            enabled: viewModel ? !viewModel.connected : false
            currentIndex: -1

            // Debug the model
            onModelChanged: {
                console.log("Port ComboBox model changed:", model)
                console.log("Port ComboBox model length:", model ? model.length : "undefined")
            }

            background: Rectangle {
                color: theme ? theme.surfaceColor : "#2d2d2d"
                border.color: theme ? theme.borderColor : "#404040"
                border.width: theme ? theme.borderWidth : 1
                radius: theme ? theme.smallRadius : 3
            }

            contentItem: Text {
                text: portComboBox.displayText || "[No Ports]"
                color: theme ? theme.textColor : "#ffffff"
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }

            popup: Popup {
                y: portComboBox.height - 1
                width: portComboBox.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: portComboBox.popup.visible ? portComboBox.delegateModel : null
                    currentIndex: portComboBox.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    color: theme ? theme.surfaceColor : "#2d2d2d"
                    border.color: theme ? theme.borderColor : "#404040"
                    radius: theme ? theme.smallRadius : 3
                }
            }

            delegate: ItemDelegate {
                width: portComboBox.width
                contentItem: Text {
                    text: modelData
                    color: theme ? theme.textColor : "#ffffff"
                    font: portComboBox.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: portComboBox.highlightedIndex === index
                background: Rectangle {
                    color: highlighted ? (theme ? theme.primaryColor : "#FF4713") : "transparent"
                }
            }

            onCurrentTextChanged: {
                connectionBar.selectedPort = currentText
            }
        }

        Text {
            text: "Baud Rate:"
            font.pixelSize: theme ? theme.captionFontSize : 12
            font.bold: true
            color: theme ? theme.textColor : "#ffffff"
        }

        ComboBox {
            id: baudRateComboBox
            Layout.preferredWidth: 100
            model: {
                // Test with fallback values
                if (viewModel && viewModel.baudRates && viewModel.baudRates.length > 0) {
                    return viewModel.baudRates
                } else {
                    console.log("Using fallback baud rates - viewModel:", viewModel)
                    return ["9600", "19200", "38400", "57600", "115200"] // Fallback for testing
                }
            }
            currentIndex: 4  // Default to index 4 as in original
            enabled: viewModel ? !viewModel.connected : false

            // Debug the model
            onModelChanged: {
                console.log("BaudRate ComboBox model changed:", model)
                console.log("BaudRate ComboBox model length:", model ? model.length : "undefined")
            }

            background: Rectangle {
                color: theme ? theme.surfaceColor : "#2d2d2d"
                border.color: theme ? theme.borderColor : "#404040"
                border.width: theme ? theme.borderWidth : 1
                radius: theme ? theme.smallRadius : 3
            }

            contentItem: Text {
                text: baudRateComboBox.displayText || "[No Rates]"
                color: theme ? theme.textColor : "#ffffff"
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }

            popup: Popup {
                y: baudRateComboBox.height - 1
                width: baudRateComboBox.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: baudRateComboBox.popup.visible ? baudRateComboBox.delegateModel : null
                    currentIndex: baudRateComboBox.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    color: theme ? theme.surfaceColor : "#2d2d2d"
                    border.color: theme ? theme.borderColor : "#404040"
                    radius: theme ? theme.smallRadius : 3
                }
            }

            delegate: ItemDelegate {
                width: baudRateComboBox.width
                contentItem: Text {
                    text: modelData
                    color: theme ? theme.textColor : "#ffffff"
                    font: baudRateComboBox.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: baudRateComboBox.highlightedIndex === index
                background: Rectangle {
                    color: highlighted ? (theme ? theme.primaryColor : "#FF4713") : "transparent"
                }
            }

            onCurrentTextChanged: {
                connectionBar.selectedBaudRate = currentText
            }
        }

        Button {
            id: connectButton
            text: viewModel ? viewModel.connectButtonText : "Connect"
            Layout.preferredWidth: 100

            background: Rectangle {
                color: viewModel ? (viewModel.connected ? "red" : "green") : "green"
                radius: theme ? theme.buttonRadius : 5
                border.color: theme ? theme.borderColor : "#404040"
                border.width: theme ? theme.borderWidth : 1
            }

            contentItem: Text {
                text: connectButton.text
                color: theme ? theme.textColor : "#ffffff"
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
                color: theme ? theme.primaryColor : "#FF4713"
                radius: theme ? theme.buttonRadius : 5
                border.color: theme ? theme.borderColor : "#404040"
                border.width: theme ? theme.borderWidth : 1
            }

            contentItem: Text {
                text: visualizationButton.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: connectionBar.visualizationClicked()

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
                color: (viewModel && viewModel.connected) ? (theme ? theme.primaryColor : "#FF4713") : (theme ? theme.disabledColor : "#353638")
                radius: theme ? theme.buttonRadius : 5
                border.color: theme ? theme.borderColor : "#404040"
                border.width: theme ? theme.borderWidth : 1
            }

            contentItem: Text {
                text: controlsButton.text
                color: theme ? theme.textColor : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: connectionBar.controlsClicked()

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
                color: theme ? theme.primaryColor : "#FF4713"
                radius: theme ? theme.buttonRadius : 5
                border.color: theme ? theme.borderColor : "#404040"
                border.width: theme ? theme.borderWidth : 1
            }

            contentItem: Text {
                text: mapButton.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: connectionBar.mapClicked()

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
                color: theme ? theme.primaryColor : "#FF4713"
                radius: theme ? theme.buttonRadius : 5
                border.color: theme ? theme.borderColor : "#404040"
                border.width: theme ? theme.borderWidth : 1
            }

            contentItem: Text {
                text: captureButton.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            onClicked: connectionBar.captureClicked()

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
            text: viewModel ? viewModel.statusMessage : "[No ViewModel]"
            font.pixelSize: theme ? theme.captionFontSize : 11
            color: viewModel ? (theme ? theme.getStatusColor(viewModel.connected) : (viewModel.connected ? "#4CAF50" : "#F44336")) : "#F44336"

            // Debug the status message
            Component.onCompleted: {
                console.log("Status text binding - viewModel:", viewModel)
                console.log("Status text binding - statusMessage:", viewModel ? viewModel.statusMessage : "null")
            }
        }
    }
}
