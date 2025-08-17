import QtQuick 2.15

QtObject {
    id: theme

    // Primary theme colors - exact match from original
    readonly property string primaryColor: "#FF4713"
    readonly property string backgroundColor: "#1a1a1a"
    readonly property string surfaceColor: "#2d2d2d"
    readonly property string borderColor: "#404040"
    readonly property string textColor: "#ffffff"
    readonly property string accentColor: "#FF6B35"
    readonly property string successColor: "#4CAF50"
    readonly property string warningColor: "#FFC107"
    readonly property string errorColor: "#F44336"

    // Additional semantic colors used throughout the app
    readonly property string disabledColor: "#353638"
    readonly property string placeholderTextColor: "#888888"
    readonly property string secondaryTextColor: "#aaaaaa"
    readonly property string crosshairColor: "#666666"

    // Typography settings
    readonly property int headerFontSize: 16
    readonly property int subHeaderFontSize: 14
    readonly property int bodyFontSize: 13
    readonly property int labelFontSize: 12
    readonly property int captionFontSize: 11
    readonly property int smallFontSize: 10
    readonly property int tinyFontSize: 9

    // Layout constants
    readonly property int panelRadius: 10
    readonly property int controlRadius: 8
    readonly property int buttonRadius: 5
    readonly property int smallRadius: 3
    readonly property int borderWidth: 1
    readonly property int thickBorderWidth: 2

    // Panel dimensions
    readonly property int telemetryPanelWidth: 300
    readonly property int controlsPanelWidth: 400
    readonly property int mapPanelWidth: 400
    readonly property int visualizationPanelWidth: 450
    readonly property int capturePanelWidth: 300
    readonly property int capturePanelHeight: 250

    readonly property int panelHeaderHeight: 50
    readonly property int connectionBarHeight: 60
    readonly property int cameraControlBarHeight: 60

    // Animation settings
    readonly property int panelAnimationDuration: 300
    readonly property int flashAnimationDuration: 200
    readonly property int joystickReturnDuration: 200

    // Spacing
    readonly property int defaultSpacing: 15
    readonly property int smallSpacing: 10
    readonly property int tinySpacing: 5
    readonly property int largeSpacing: 20

    // Component sizes
    readonly property int arrowButtonSize: 40
    readonly property int closeButtonSize: 30
    readonly property int joystickOuterSize: 200
    readonly property int joystickInnerSize: 180
    readonly property int joystickKnobSize: 40
    readonly property int joystickMaxRadius: 70

    // Input field dimensions
    readonly property int textFieldHeight: 30
    readonly property int buttonHeight: 40
    readonly property int spinBoxHeight: 30

    // Camera settings
    readonly property real cameraAspectRatio: 16.0 / 9.0
    readonly property int sourceFrameWidth: 1920
    readonly property int sourceFrameHeight: 1080

    // Helper functions for consistent styling
    function getButtonColor(isPressed, isHovered, baseColor) {
        if (isPressed) return Qt.darker(baseColor, 1.2)
        if (isHovered) return Qt.lighter(baseColor, 1.1)
        return baseColor
    }

    function getStatusColor(isConnected) {
        return isConnected ? successColor : errorColor
    }

    function getBatteryColor(batteryLevel) {
        return batteryLevel > 20 ? successColor : errorColor
    }

    function getSignalColor(signalStrength) {
        return signalStrength > 50 ? successColor : warningColor
    }
}
