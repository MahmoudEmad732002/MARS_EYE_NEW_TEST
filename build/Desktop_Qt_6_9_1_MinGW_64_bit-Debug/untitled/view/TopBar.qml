import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    // External API
    property var serialViewModel   // bind to your C++ SerialViewModel
    property alias selectedPort: portCombo.currentText
    property alias selectedBaud: baudCombo.currentText
    property int  barHeight: 56

    // Theme passthrough (match your app colors 1:1)
    property color primaryColor
    property color backgroundColor
    property color surfaceColor
    property color borderColor
    property color textColor
    property color successColor
    property color warningColor
    property color errorColor

    height: barHeight
    width: parent ? parent.width : implicitWidth

    Rectangle {
        anchors.fill: parent
        color: surfaceColor
        border.color: borderColor
        border.width: 1
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Title / hint (optional—remove if you didn’t have it)
        Text {
            text: "Serial"
            font.pixelSize: 14
            font.bold: true
            color: textColor
            Layout.alignment: Qt.AlignVCenter
            visible: true
        }

        // Ports
        ComboBox {
            id: portCombo
            Layout.preferredWidth: 180
            Layout.alignment: Qt.AlignVCenter
            model: serialViewModel ? serialViewModel.availablePorts : []
            editable: false

            background: Rectangle {
                radius: 8
                color: backgroundColor
                border.color: borderColor
            }
            contentItem: Text {
                text: portCombo.displayText
                color: textColor
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            // Pick first port if nothing selected when list appears
            onModelChanged: if (count > 0 && currentIndex < 0) currentIndex = 0
        }

        // Baud
        ComboBox {
            id: baudCombo
            Layout.preferredWidth: 120
            Layout.alignment: Qt.AlignVCenter
            model: serialViewModel ? serialViewModel.baudRates : []
            editable: false

            background: Rectangle {
                radius: 8
                color: backgroundColor
                border.color: borderColor
            }
            contentItem: Text {
                text: baudCombo.displayText
                color: textColor
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            onModelChanged: if (count > 0 && currentIndex < 0) currentIndex = 0
        }

        // Refresh ports
        Button {
            id: refreshBtn
            text: "Refresh"
            Layout.preferredWidth: 96
            Layout.alignment: Qt.AlignVCenter

            background: Rectangle {
                radius: 10
                color: primaryColor
                border.color: borderColor
            }
            contentItem: Text {
                text: refreshBtn.text
                color: "white"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            onClicked: if (serialViewModel && serialViewModel.refreshPorts) serialViewModel.refreshPorts()
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; acceptedButtons: Qt.NoButton }
            hoverEnabled: false
        }

        // Connect / Disconnect
        Button {
            id: connectBtn
            Layout.preferredWidth: 148
            Layout.alignment: Qt.AlignVCenter
            text: serialViewModel ? serialViewModel.connectButtonText : "Connect"

            background: Rectangle {
                radius: 10
                color: serialViewModel ? serialViewModel.connectButtonColor : successColor
                border.color: borderColor
            }
            contentItem: Text {
                text: connectBtn.text
                color: textColor
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            onClicked: {
                if (!serialViewModel) return
                // Prefer your existing method names; these two common ones are supported:
                if (serialViewModel.connectOrDisconnect) {
                    serialViewModel.connectOrDisconnect(portCombo.currentText, parseInt(baudCombo.currentText))
                } else if (serialViewModel.toggleConnection) {
                    serialViewModel.toggleConnection(portCombo.currentText, parseInt(baudCombo.currentText))
                }
            }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; acceptedButtons: Qt.NoButton }
            hoverEnabled: false
        }

        // Status text
        Text {
            id: statusText
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            text: serialViewModel ? serialViewModel.statusMessage : ""
            color: serialViewModel && serialViewModel.connected ? successColor : textColor
            elide: Text.ElideRight
        }
    }
}
