import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    // External API (bind these from Main.qml)
    property bool panelVisible: false
    property var  mediaViewModel: null

    // Theme properties (pass-through to preserve appearance)
    property color primaryColor
    property color backgroundColor
    property color surfaceColor
    property color borderColor
    property color textColor
    property color successColor
    property color warningColor
    property color errorColor

    // Signals back to Main to keep single source of truth
    signal closeRequested()
    signal requestFlash()

    // Size of the popup (same as original)
    width: 300
    height: 250

    // Position + visibility (same math & animations as original)
    x: panelVisible ? (parent ? (parent.width  - width)  / 2 : 0) : (parent ? parent.width : 0)
    y: panelVisible ? (parent ? (parent.height - height) / 2 : 0) : -(height)
    visible: panelVisible
    z: 1003

    // Animate entrance/exit exactly like before
    Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

    // Panel container (identical visuals)
    Rectangle {
        anchors.fill: parent
        color: surfaceColor
        border.color: borderColor
        border.width: 2
        radius: 15
        opacity: 0.98

        // Header (unchanged)
        Rectangle {
            id: captureHeader
            width: parent.width
            height: 50
            color: primaryColor
            border.color: borderColor
            radius: 15
            anchors.top: parent.top

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "CAPTURE OPTIONS"
                    font.pixelSize: 16
                    font.bold: true
                    Layout.fillWidth: true
                    color: "white"
                }

                Button {
                    text: "✕"
                    width: 30
                    height: 30

                    background: Rectangle {
                        color: parent.pressed ? Qt.darker(errorColor, 1.2) : errorColor
                        radius: 15
                        border.color: borderColor
                    }

                    contentItem: Text {
                        text: parent.text
                        color: textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }

                    onClicked: root.closeRequested()
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.NoButton
                    }
                    hoverEnabled: false
                }
            }
        }

        // Content (unchanged)
        Column {
            anchors.top: captureHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            spacing: 20

            // Recording Section (unchanged)
            Rectangle {
                width: parent.width
                height: 80
                color: backgroundColor
                border.color: borderColor
                radius: 8

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Button {
                        text: mediaViewModel && mediaViewModel.isRecording ? "Stop Recording" : "Start Recording"
                        width: 200
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter

                        background: Rectangle {
                            color: mediaViewModel && mediaViewModel.isRecording ? errorColor : "green"
                            radius: 8
                            border.color: borderColor
                            border.width: 1
                        }

                        contentItem: Text {
                            text: parent.text
                            color: textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }

                        onClicked: {
                            root.closeRequested()
                            if (mediaViewModel) mediaViewModel.startOrStopRecording("")
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                        hoverEnabled: false
                    }
                }
            }

            // Screenshot Section (unchanged)
            Rectangle {
                width: parent.width
                height: 60
                color: backgroundColor
                border.color: borderColor
                radius: 8

                Button {
                    text: "Take Screenshot"
                    width: 200
                    height: 40
                    anchors.centerIn: parent

                    background: Rectangle {
                        color: "green"
                        radius: 8
                        border.color: borderColor
                        border.width: 1
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }

                    onClicked: {
                        root.closeRequested()
                        screenshotTimer.start()
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.NoButton
                    }
                    hoverEnabled: false
                }
            }
        }
    }

    // Timer for delayed screenshot (unchanged behavior)
    Timer {
        id: screenshotTimer
        interval: 350
        repeat: false
        onTriggered: {
            root.requestFlash()                 // ask Main to run flash animation
            if (mediaViewModel) mediaViewModel.takeSnapshot("")
        }
    }
}
