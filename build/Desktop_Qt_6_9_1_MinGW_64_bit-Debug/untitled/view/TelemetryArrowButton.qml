// TelemetryArrowButton.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root
    width: 40
    height: 40
    x: telemetryPanelVisible ? 330 : 20
    y: 200
    z: 1001

    property bool telemetryPanelVisible: false

    text: telemetryPanelVisible ? "◀" : "▶"

    background: Rectangle {
        color: Theme.primaryColor
        radius: 20
        border.color: Theme.borderColor
        border.width: 2
    }

    contentItem: Text {
        text: root.text
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
    }

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }

    hoverEnabled: false
}
