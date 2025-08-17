import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: Theme.backgroundColor
    border.color: Theme.borderColor
    border.width: 1
    radius: 5

    property var cameraViewModel
    property var thermalCameraViewModel
    property var viewModel
    property bool framesSwapped: false

    // Camera display area
    Item {
        id: cameraContainer
        anchors.fill: parent
        anchors.margins: 10

        // Calculate maximum size that maintains 16:9 aspect ratio
        property real targetAspect: 16.0 / 9.0
        property real availableWidth: width
        property real availableHeight: height

        // Calculate actual display size - fit the largest possible 16:9 rectangle
        property real displayWidth: {
            var widthBasedOnHeight = availableHeight * targetAspect
            var heightBasedOnWidth = availableWidth / targetAspect

            if (heightBasedOnWidth <= availableHeight) {
                // Width is the limiting factor
                return availableWidth
            } else {
                // Height is the limiting factor
                return widthBasedOnHeight
            }
        }

        property real displayHeight: displayWidth / targetAspect

        CameraImage {
            id: cameraImage
            anchors.centerIn: parent
            width: cameraContainer.displayWidth
            height: cameraContainer.displayHeight

            cameraViewModel: root.cameraViewModel
            thermalCameraViewModel: root.thermalCameraViewModel
            viewModel: root.viewModel
            framesSwapped: root.framesSwapped
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: cameraViewModel.cameraStatus.indexOf("Connecting") >= 0
            visible: running
        }
    }
}
