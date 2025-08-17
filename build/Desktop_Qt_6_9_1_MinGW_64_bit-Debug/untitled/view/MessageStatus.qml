import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
 Rectangle {
    id: messageStatus

    // Public properties
    property var viewModel: null
    property ThemeProperties theme: ThemeProperties {}

    // Control styling - exact match from original
    height: 100
    color: theme.backgroundColor
    border.color: theme.borderColor
    border.width: theme.borderWidth
    radius: theme.controlRadius

    Column {
        anchors.fill: parent
        anchors.margins: theme.defaultSpacing
        spacing: theme.smallSpacing

        Text {
            text: "MESSAGE STATUS"
            font.pixelSize: theme.subHeaderFontSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: theme.textColor
        }

        Text {
            text: "Last Acknowledged: ID " + (viewModel ? viewModel.lastAcknowledgedMessageId : 0)
            font.pixelSize: theme.captionFontSize
            color: theme.successColor
            anchors.horizontalCenter: parent.horizontalCenter
            visible: viewModel ? (viewModel.lastAcknowledgedMessageId > 0) : false
        }

        RowLayout {
            width: parent.width
            spacing: theme.smallSpacing

            Text {
                text: "Joystick:"
                font.pixelSize: theme.smallFontSize
                color: theme.textColor
            }
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: viewModel ? (viewModel.joystickActive ? "green" : "gray") : "gray"
            }

            Text {
                text: "Abs.Point:"
                font.pixelSize: theme.smallFontSize
                color: theme.textColor
            }
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: viewModel ? (viewModel.absolutePointingActive ? "orange" : "gray") : "gray"
            }
        }
    }
}
