import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    height: 100
    color: backgroundColor
    border.color: borderColor
    border.width: 1
    radius: 8

    // Properties
    property var viewModel
    property string primaryColor: "#FF4713"
    property string surfaceColor: "#2d2d2d"
    property string borderColor: "#404040"
    property string textColor: "#ffffff"
    property string backgroundColor: "#1a1a1a"
    property string successColor: "#4CAF50"

    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Text {
            text: "MESSAGE STATUS"
            font.pixelSize: 14
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: textColor
        }

        Text {
            text: "Last Acknowledged: ID " + viewModel.lastAcknowledgedMessageId
            font.pixelSize: 11
            color: successColor
            anchors.horizontalCenter: parent.horizontalCenter
            visible: viewModel.lastAcknowledgedMessageId > 0
        }

        RowLayout {
            width: parent.width
            spacing: 10

            Text {
                text: "Joystick:"
                font.pixelSize: 10
                color: textColor
            }
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: viewModel.joystickActive ? "green" : "gray"
            }

            Text {
                text: "Abs.Point:"
                font.pixelSize: 10
                color: textColor
            }
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: viewModel.absolutePointingActive ? "orange" : "gray"
            }
        }
    }
}
