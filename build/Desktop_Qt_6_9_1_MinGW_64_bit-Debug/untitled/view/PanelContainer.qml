// PanelContainer.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import "."

Item {
    id: panelContainer

    // Required properties
    property var theme
    property var viewModel
    property var mediaViewModel
    property var thermalCameraViewModel
    property var cameraViewModel
    property var mapViewModel

    // Panel visibility properties with two-way binding
    property bool mapPanelVisible: false
    property bool controlsPanelVisible: false
    property bool telemetryPanelVisible: false
    property bool testPanelVisible: false
    property bool capturePanelVisible: false
    property bool visualizationPanelVisible: false
    property bool framesSwapped: false

    // Left Arrow Button for Telemetry Panel - exactly as original
    Button {
        id: telemetryArrowButton
        width: 40
        height: 40

        x: panelContainer.telemetryPanelVisible ? 330 : 20
        y: 200
        z: 1001
        text: panelContainer.telemetryPanelVisible ? "◀" : "▶"

        background: Rectangle {
            color: theme.primaryColor
            radius: 20
            border.color: theme.borderColor
            border.width: 2
        }

        contentItem: Text {
            text: telemetryArrowButton.text
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
        }

        Behavior on x {
            NumberAnimation {
                duration: theme.standardAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        onClicked: {
            panelContainer.telemetryPanelVisible = !panelContainer.telemetryPanelVisible
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }
        hoverEnabled: false
    }

    // Floating Telemetry Side Panel (Left) - will be implemented as separate component
    TelemetryPanel {
        id: telemetryPanel
        width: 300
        height: parent.height - 300
        x: panelContainer.telemetryPanelVisible ? 20 : -width
        y: 105
        z: 1000
        visible: panelContainer.telemetryPanelVisible

        theme: panelContainer.theme
        viewModel: panelContainer.viewModel

        Behavior on x {
            NumberAnimation {
                duration: theme.standardAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        onCloseClicked: panelContainer.telemetryPanelVisible = false
    }

    // Floating Controls Side Panel (Right) - will be implemented as separate component
    ControlsPanel {
        id: controlsPanel
        width: 400
        height: parent.height - 40
        x: panelContainer.controlsPanelVisible ? parent.width - width - 20 : parent.width
        y: 20
        z: 1000
        visible: panelContainer.controlsPanelVisible

        theme: panelContainer.theme
        viewModel: panelContainer.viewModel

        Behavior on x {
            NumberAnimation {
                duration: theme.standardAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        onCloseClicked: panelContainer.controlsPanelVisible = false
    }

    // Map Panel - will be implemented as separate component
    MapPanel {
        id: mapPanel
        width: 400
        height: parent.height - 40
        x: panelContainer.mapPanelVisible ? parent.width - width - 20 : parent.width
        y: 20
        z: 1000
        visible: panelContainer.mapPanelVisible

        theme: panelContainer.theme
        mapViewModel: panelContainer.mapViewModel
        viewModel: panelContainer.viewModel

        Behavior on x {
            NumberAnimation {
                duration: theme.standardAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        onCloseClicked: panelContainer.mapPanelVisible = false
    }

    // Visualization Panel - will be implemented as separate component
    VisualizationPanel {
        id: visualizationPanel
        width: 450
        height: parent.height - 40
        x: panelContainer.visualizationPanelVisible ? parent.width - width - 20 : parent.width
        y: 20
        z: 1000
        visible: panelContainer.visualizationPanelVisible

        theme: panelContainer.theme
        thermalCameraViewModel: panelContainer.thermalCameraViewModel
        cameraViewModel: panelContainer.cameraViewModel
        framesSwapped: panelContainer.framesSwapped

        Behavior on x {
            NumberAnimation {
                duration: theme.standardAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        onCloseClicked: panelContainer.visualizationPanelVisible = false
        onFramesSwappedChanged: panelContainer.framesSwapped = framesSwapped
    }

    // Capture Panel (Center popup) - will be implemented as separate component
    CapturePanel {
        id: capturePanel
        width: 300
        height: 250
        x: panelContainer.capturePanelVisible ? (parent.width - width) / 2 : parent.width
        y: panelContainer.capturePanelVisible ? (parent.height - height) / 2 : -height
        z: 1003
        visible: panelContainer.capturePanelVisible

        theme: panelContainer.theme
        mediaViewModel: panelContainer.mediaViewModel

        Behavior on x {
            NumberAnimation {
                duration: theme.standardAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: theme.standardAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        onCloseClicked: panelContainer.capturePanelVisible = false
    }

    // Background overlay when panels are visible - exactly as original
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: (panelContainer.controlsPanelVisible || panelContainer.telemetryPanelVisible ||
                 panelContainer.testPanelVisible || panelContainer.capturePanelVisible ||
                 panelContainer.mapPanelVisible || panelContainer.visualizationPanelVisible) ? 0.3 : 0
        z: 999
        visible: panelContainer.controlsPanelVisible || panelContainer.telemetryPanelVisible ||
                panelContainer.testPanelVisible || panelContainer.capturePanelVisible ||
                panelContainer.mapPanelVisible || panelContainer.visualizationPanelVisible

        Behavior on opacity {
            NumberAnimation {
                duration: theme.standardAnimationDuration
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                panelContainer.controlsPanelVisible = false
                panelContainer.telemetryPanelVisible = false
                panelContainer.testPanelVisible = false
                panelContainer.capturePanelVisible = false
                panelContainer.mapPanelVisible = false
                panelContainer.visualizationPanelVisible = false
            }
        }
    }

    // Flash effect for screenshot - exactly as original
    Rectangle {
        id: flashEffect
        anchors.fill: parent
        color: "white"
        opacity: 0
        z: 2000
        visible: false

        PropertyAnimation {
            id: flashAnimation
            target: flashEffect
            property: "opacity"
            from: 0.8
            to: 0
            duration: theme.fastAnimationDuration

            onStarted: {
                flashEffect.visible = true
            }

            onFinished: {
                flashEffect.visible = false
            }
        }
    }

    // Expose flash animation for capture panel
    function triggerFlash() {
        flashAnimation.start()
    }
}
