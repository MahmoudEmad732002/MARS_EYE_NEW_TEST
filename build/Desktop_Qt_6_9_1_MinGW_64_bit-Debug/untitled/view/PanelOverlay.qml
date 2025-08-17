import QtQuick 2.15

Rectangle {
    id: root
    anchors.fill: parent
    color: "#000000"
    opacity: visible ? 0.3 : 0
    z: 999

    signal clicked()

    Behavior on opacity {
        NumberAnimation {
            duration: 300
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}

// ===================================

