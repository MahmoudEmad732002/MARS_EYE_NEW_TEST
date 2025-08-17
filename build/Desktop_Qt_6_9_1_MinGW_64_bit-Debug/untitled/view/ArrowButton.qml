import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: arrowButton

    // Public properties
    property ThemeProperties theme: ThemeProperties {}

    // Arrow button styling - exact match from original
    width: theme.arrowButtonSize
    height: theme.arrowButtonSize

    // Animation for position changes - exact same as original
    Behavior on x {
        NumberAnimation {
            duration: theme.panelAnimationDuration
            easing.type: Easing.OutCubic
        }
    }

    background: Rectangle {
        color: theme.primaryColor
        radius: theme.arrowButtonSize / 2
        border.color: theme.borderColor
        border.width: theme.thickBorderWidth
    }

    contentItem: Text {
        text: arrowButton.text
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pixelSize: theme.labelFontSize
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
    }
    hoverEnabled: false
}
