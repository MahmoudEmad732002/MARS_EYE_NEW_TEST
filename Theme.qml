// Theme.qml
import QtQuick 2.15

QtObject {
    id: theme

    // Color Properties - Exact same values from original
    readonly property string primaryColor: "#FF4713"
    readonly property string backgroundColor: "#1a1a1a"
    readonly property string surfaceColor: "#2d2d2d"
    readonly property string borderColor: "#404040"
    readonly property string textColor: "#ffffff"
    readonly property string accentColor: "#FF6B35"
    readonly property string successColor: "#4CAF50"
    readonly property string warningColor: "#FFC107"
    readonly property string errorColor: "#F44336"

    // Typography Properties
    readonly property int standardFontSize: 12
    readonly property int headerFontSize: 16
    readonly property int smallFontSize: 10
    readonly property int largeFontSize: 14
    readonly property int buttonFontSize: 13

    // Layout Properties
    readonly property int standardMargin: 15
    readonly property int smallMargin: 10
    readonly property int largeMargin: 20
    readonly property int standardSpacing: 15
    readonly property int smallSpacing: 10
    readonly property int standardRadius: 5
    readonly property int largeRadius: 10
    readonly property int buttonRadius: 8

    // Button Properties
    readonly property int standardButtonWidth: 100
    readonly property int standardButtonHeight: 40
    readonly property int smallButtonWidth: 80
    readonly property int smallButtonHeight: 30
    readonly property int largeButtonWidth: 120
    readonly property int largeButtonHeight: 35

    // Panel Properties
    readonly property int panelHeaderHeight: 50
    readonly property int topBarHeight: 60
    readonly property real panelOpacity: 0.95
    readonly property int panelBorderWidth: 2

    // Animation Properties
    readonly property int standardAnimationDuration: 300
    readonly property int fastAnimationDuration: 200
    readonly property int slowAnimationDuration: 500
}
