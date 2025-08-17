import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root

    property string backgroundColor: Theme.primaryColor
    property string textColor: "white"
    property bool showCursor: true

    background: Rectangle {
        color: root.backgroundColor
        radius: 5
        border.color: Theme.borderColor
        border.width: 1
    }

    contentItem: Text {
        text: root.text
        color: root.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: root.showCursor ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.NoButton
    }

    hoverEnabled: false
}
