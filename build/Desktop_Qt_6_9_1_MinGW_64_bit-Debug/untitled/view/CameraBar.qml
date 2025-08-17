import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: cameraBar
    width: parent ? parent.width : 1200
    height: 56
    color: surfaceColor
    radius: 5
    border.color: borderColor
    border.width: 1

    // === Required inputs ===
    required property var cameraVM
    required property color surfaceColor
    required property color borderColor
    required property color textColor
    required property color primaryColor

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        // IP label
        Text {
            text: "IP:"
            font.pixelSize: 12
            font.bold: true
            color: textColor
        }

        // IP input (two-way bind like your current Main.qml)
        TextField {
            id: ipField
            Layout.preferredWidth: 160
            text: cameraVM.ipAddress
            onEditingFinished: cameraVM.ipAddress = text

            background: Rectangle {
                color: surfaceColor
                border.color: borderColor
                border.width: 1
                radius: 3
            }
            color: textColor
            placeholderText: "0.0.0.0"
        }

        // Port label
        Text {
            text: "Port:"
            font.pixelSize: 12
            font.bold: true
            color: textColor
        }

        // Port input
        TextField {
            id: portField
            Layout.preferredWidth: 100
            text: String(cameraVM.port)
            validator: IntValidator { bottom: 1; top: 65535 }
            onEditingFinished: cameraVM.port = parseInt(text)

            background: Rectangle {
                color: surfaceColor
                border.color: borderColor
                border.width: 1
                radius: 3
            }
            color: textColor
            placeholderText: "5001"
        }

        // Stream button preserves toggle text from cameraVM
        Button {
            id: streamBtn
            Layout.preferredWidth: 110
            text: cameraVM.streamButtonText
            enabled: !cameraVM.busy

            background: Rectangle {
                color: primaryColor
                radius: 5
                border.color: borderColor
                border.width: 1
            }
            contentItem: Text {
                text: streamBtn.text
                color: "white"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: cameraVM.toggleStream()

            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; acceptedButtons: Qt.NoButton }
        }

        // Track toggle button (keeps same enable/disable logic)
        Button {
            id: trackBtn
            Layout.preferredWidth: 100
            text: cameraVM.trackingEnabled ? "Tracking: ON" : "Tracking: OFF"
            enabled: cameraVM.streaming

            background: Rectangle {
                color: cameraVM.trackingEnabled ? "#2e7d32" : primaryColor
                radius: 5
                border.color: borderColor
                border.width: 1
            }
            contentItem: Text {
                text: trackBtn.text
                color: "white"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                if (cameraVM.trackingEnabled) cameraVM.disableTracking();
                else cameraVM.enableTracking();
            }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; acceptedButtons: Qt.NoButton }
        }

        // Spacer
        Item { Layout.fillWidth: true }

        // Frame rate / count quick readout (names align with your VM)
        Text {
            text: `FPS: ${cameraVM.frameRate}   Frames: ${cameraVM.frameCount}`
            font.pixelSize: 12
            color: textColor
            horizontalAlignment: Text.AlignRight
        }
    }
}
