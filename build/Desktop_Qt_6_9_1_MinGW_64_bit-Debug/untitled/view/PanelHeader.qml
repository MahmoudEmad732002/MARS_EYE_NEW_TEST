import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: header

    // Public properties
    property string title: "PANEL HEADER"
    property ThemeProperties theme: ThemeProperties {}

    // Signals
    signal closeClicked()

    // Panel header styling - exact match from original
    width: parent.width
    height: theme.panelHeaderHeight
    color: theme.primaryColor
    border.color: theme.borderColor
    border.width: theme.borderWidth
    radius: theme.panelRadius

    RowLayout {
        anchors.fill: parent
        anchors.margins: theme.smallSpacing
        spacing: theme.defaultSpacing

        Text {
            text: header.title
            font.pixelSize: theme.headerFontSize
            font.bold: true
            Layout.fillWidth: true
            color: theme.textColor
        }

        Button {
            id: closeButton
            text: "✕"
            width: theme.closeButtonSize
            height: theme.closeButtonSize

            background: Rectangle {
                color: closeButton.pressed ? Qt.darker(theme.errorColor, 1.2) : theme.errorColor
                radius: theme.closeButtonSize / 2
                border.color: theme.borderColor
                border.width: theme.borderWidth
            }

            contentItem: Text {
                text: closeButton.text
                color: theme.textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                font.pixelSize: theme.captionFontSize
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
            hoverEnabled: false

            onClicked: header.closeClicked()
        }
    }
}
