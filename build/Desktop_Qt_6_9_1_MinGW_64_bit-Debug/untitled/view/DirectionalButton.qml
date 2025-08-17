import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root
    width: 50
    height: 40

    background: Rectangle {
        color: root.pressed ? Qt.darker(Theme.primaryColor, 1.2) : (root.hovered ? Qt.lighter(Theme.primaryColor, 1.1) : Theme.primaryColor)
        border.color: root.pressed ? Qt.lighter(Theme.borderColor, 1.5) : Theme.borderColor
        border.width: 2
        radius: 8

        // Add subtle shadow effect
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 2
            color: "transparent"
            border.color: Qt.rgba(255, 255, 255, 0.1)
            border.width: 1
            radius: parent.radius
        }
    }

    contentItem: Text {
        text: root.text
        color: Theme.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }

    hoverEnabled: false
}
