// MainContent.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "."

Item {
    id: mainContent

    // Required properties - passed from Main.qml
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

    Column {
        anchors.fill: parent
        spacing: theme.standardSpacing

        // Connection control bar
        ConnectionBar {
            id: connectionBar
            width: parent.width
            height: theme.topBarHeight

            theme: mainContent.theme
            viewModel: mainContent.viewModel

            // Panel visibility controls
            onVisualizationClicked: mainContent.visualizationPanelVisible = !mainContent.visualizationPanelVisible
            onControlsClicked: mainContent.controlsPanelVisible = !mainContent.controlsPanelVisible
            onMapClicked: mainContent.mapPanelVisible = !mainContent.mapPanelVisible
            onCaptureClicked: mainContent.capturePanelVisible = !mainContent.capturePanelVisible
        }

        // Camera control bar
        CameraControlBar {
            id: cameraControlBar
            width: parent.width
            height: theme.topBarHeight

            theme: mainContent.theme
            cameraViewModel: mainContent.cameraViewModel
        }

        // Main camera display area - takes remaining height
        Rectangle {
            width: parent.width
            height: parent.parent.height - connectionBar.height - cameraControlBar.height - (theme.standardSpacing * 2)
            color: theme.backgroundColor
            border.color: theme.borderColor
            border.width: 1
            radius: theme.standardRadius

            CameraDisplay {
                anchors.fill: parent
                anchors.margins: theme.smallMargin

                theme: mainContent.theme
                cameraViewModel: mainContent.cameraViewModel
                thermalCameraViewModel: mainContent.thermalCameraViewModel
                viewModel: mainContent.viewModel
                framesSwapped: mainContent.framesSwapped
            }
        }
    }

    // All floating panels and overlays
    PanelContainer {
        anchors.fill: parent

        theme: mainContent.theme
        viewModel: mainContent.viewModel
        mediaViewModel: mainContent.mediaViewModel
        thermalCameraViewModel: mainContent.thermalCameraViewModel
        cameraViewModel: mainContent.cameraViewModel
        mapViewModel: mainContent.mapViewModel

        // Panel visibility states
        mapPanelVisible: mainContent.mapPanelVisible
        controlsPanelVisible: mainContent.controlsPanelVisible
        telemetryPanelVisible: mainContent.telemetryPanelVisible
        testPanelVisible: mainContent.testPanelVisible
        capturePanelVisible: mainContent.capturePanelVisible
        visualizationPanelVisible: mainContent.visualizationPanelVisible
        framesSwapped: mainContent.framesSwapped

        // Two-way bindings for panel visibility
        onMapPanelVisibleChanged: mainContent.mapPanelVisible = mapPanelVisible
        onControlsPanelVisibleChanged: mainContent.controlsPanelVisible = controlsPanelVisible
        onTelemetryPanelVisibleChanged: mainContent.telemetryPanelVisible = telemetryPanelVisible
        onTestPanelVisibleChanged: mainContent.testPanelVisible = testPanelVisible
        onCapturePanelVisibleChanged: mainContent.capturePanelVisible = capturePanelVisible
        onVisualizationPanelVisibleChanged: mainContent.visualizationPanelVisible = visualizationPanelVisible
        onFramesSwappedChanged: mainContent.framesSwapped = framesSwapped
    }
}
