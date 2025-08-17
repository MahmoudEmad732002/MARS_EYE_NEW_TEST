import QtQuick 2.15

Rectangle {
    id: flashEffect

    // Public properties
    property ThemeProperties theme: ThemeProperties {}

    // Public functions
    function startFlash() {
        flashAnimation.start()
    }

    // Flash effect styling - exact same as original
    color: "white"
    opacity: 0
    visible: false

    PropertyAnimation {
        id: flashAnimation
        target: flashEffect
        property: "opacity"
        from: 0.8
        to: 0
        duration: theme.flashAnimationDuration

        onStarted: {
            flashEffect.visible = true
        }

        onFinished: {
            flashEffect.visible = false
        }
    }
}
