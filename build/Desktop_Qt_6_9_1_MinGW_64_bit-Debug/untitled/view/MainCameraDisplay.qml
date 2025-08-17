import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: backgroundColor
    border.color: borderColor
    border.width: 1
    radius: 5

    // Properties
    property var cameraViewModel
    property var thermalCameraViewModel
    property var viewModel
    property bool framesSwapped: false
    property string backgroundColor: "#1a1a1a"
    property string borderColor: "#404040"
    property string primaryColor: "#FF4713"

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

        Image {
            id: cameraImage
            anchors.centerIn: parent
            width: cameraContainer.displayWidth
            height: cameraContainer.displayHeight
            fillMode: Image.PreserveAspectFit
            source: root.framesSwapped ? thermalCameraViewModel.currentThermalFrameUrl : cameraViewModel.currentFrameUrl
            cache: false
            smooth: true

            // Constants for source frame dimensions
            readonly property int sourceFrameWidth: 1920
            readonly property int sourceFrameHeight: 1080

            // Calculate the actual rendered image dimensions within the Image component
            readonly property real imageAspectRatio: sourceFrameWidth / sourceFrameHeight
            readonly property real componentAspectRatio: width / height

            // Determine actual rendered image size based on aspect ratio fitting
            readonly property real renderedImageWidth: {
                if (componentAspectRatio > imageAspectRatio) {
                    // Component is wider than image - height constrained
                    return height * imageAspectRatio
                } else {
                    // Component is taller than image - width constrained
                    return width
                }
            }

            readonly property real renderedImageHeight: {
                if (componentAspectRatio > imageAspectRatio) {
                    // Component is wider than image - height constrained
                    return height
                } else {
                    // Component is taller than image - width constrained
                    return width / imageAspectRatio
                }
            }

            // Calculate offsets of the rendered image within the component
            readonly property real renderedImageX: (width - renderedImageWidth) / 2
            readonly property real renderedImageY: (height - renderedImageHeight) / 2

            // Function to convert UI coordinates to source frame coordinates
            function uiToSourceCoordinates(uiX, uiY) {
                // Check if click is within the rendered image bounds
                if (uiX < renderedImageX || uiX > renderedImageX + renderedImageWidth ||
                    uiY < renderedImageY || uiY > renderedImageY + renderedImageHeight) {
                    console.log("Click outside rendered image bounds")
                    return null
                }

                // Convert to rendered image coordinates (0,0 at top-left of actual image)
                var imageX = uiX - renderedImageX
                var imageY = uiY - renderedImageY

                // Scale to source frame coordinates
                var sourceX = Math.round((imageX / renderedImageWidth) * sourceFrameWidth)
                var sourceY = Math.round((imageY / renderedImageHeight) * sourceFrameHeight)

                // Clamp to valid range
                sourceX = Math.max(0, Math.min(sourceFrameWidth - 1, sourceX))
                sourceY = Math.max(0, Math.min(sourceFrameHeight - 1, sourceY))

                return {
                    x: sourceX,
                    y: sourceY
                }
            }

            // Tracking selection overlay rectangle
            Rectangle {
                id: selectionOverlay
                visible: false
                color: "transparent"
                border.color: "#00FF00"
                border.width: 2
                z: 10
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: cameraViewModel.streaming ? primaryColor : borderColor
                border.width: 2
                radius: 5
                visible: cameraViewModel.streaming
            }

            // Mouse handling for tracking target selection
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                enabled: cameraViewModel.streaming && cameraViewModel.trackingEnabled

                property real pressX: 0
                property real pressY: 0
                property bool isDragging: false

                onPressed: {
                    if (mouse.button === Qt.LeftButton) {
                        pressX = mouse.x
                        pressY = mouse.y
                        isDragging = false

                        // Convert to source coordinates to validate click
                        var sourceCoords = cameraImage.uiToSourceCoordinates(mouse.x, mouse.y)
                        if (!sourceCoords) {
                            return // Click outside image
                        }

                        // Show selection overlay at click point (default 120x120 box in UI coordinates)
                        var defaultUISize = 120
                        selectionOverlay.x = Math.max(cameraImage.renderedImageX,
                                                    Math.min(cameraImage.renderedImageX + cameraImage.renderedImageWidth - defaultUISize,
                                                           mouse.x - defaultUISize/2))
                        selectionOverlay.y = Math.max(cameraImage.renderedImageY,
                                                    Math.min(cameraImage.renderedImageY + cameraImage.renderedImageHeight - defaultUISize,
                                                           mouse.y - defaultUISize/2))
                        selectionOverlay.width = defaultUISize
                        selectionOverlay.height = defaultUISize
                        selectionOverlay.visible = true
                    }
                }

                onReleased: {
                    if (mouse.button === Qt.LeftButton && selectionOverlay.visible) {
                        console.log("=== TARGET SELECTION DEBUG ===")
                        console.log("UI Click at:", mouse.x, mouse.y)
                        console.log("Image component size:", cameraImage.width, "x", cameraImage.height)
                        console.log("Rendered image size:", cameraImage.renderedImageWidth, "x", cameraImage.renderedImageHeight)
                        console.log("Rendered image offset:", cameraImage.renderedImageX, cameraImage.renderedImageY)
                        console.log("Selection overlay:", selectionOverlay.x, selectionOverlay.y, selectionOverlay.width, selectionOverlay.height)

                        // Convert selection overlay to source coordinates
                        var topLeftSource = cameraImage.uiToSourceCoordinates(selectionOverlay.x, selectionOverlay.y)
                        var bottomRightSource = cameraImage.uiToSourceCoordinates(
                            selectionOverlay.x + selectionOverlay.width,
                            selectionOverlay.y + selectionOverlay.height
                        )

                        if (!topLeftSource || !bottomRightSource) {
                            console.log("ERROR: Selection outside image bounds")
                            return
                        }

                        var sourceX = topLeftSource.x
                        var sourceY = topLeftSource.y
                        var sourceW = bottomRightSource.x - topLeftSource.x
                        var sourceH = bottomRightSource.y - topLeftSource.y

                        // Ensure minimum size
                        sourceW = Math.max(20, sourceW)
                        sourceH = Math.max(20, sourceH)

                        // Ensure within bounds
                        sourceX = Math.max(0, Math.min(cameraImage.sourceFrameWidth - sourceW, sourceX))
                        sourceY = Math.max(0, Math.min(cameraImage.sourceFrameHeight - sourceH, sourceY))

                        console.log("Final source coordinates:", sourceX, sourceY, sourceW, sourceH)

                        // Get current frame ID from camera view model
                        var frameId = cameraViewModel.currentFrameId

                        console.log("Sending target with frame ID:", frameId)

                        // Send to serial model via view model
                        viewModel.sendSelectTarget(sourceX, sourceY, frameId)
                        cameraViewModel.sendTarget(sourceX, sourceY, sourceW, sourceH)

                        // Hide selection overlay after a short delay
                        hideSelectionTimer.start()
                    }
                }
            }

            // Timer to hide selection overlay
            Timer {
                id: hideSelectionTimer
                interval: 1000
                repeat: false
                onTriggered: {
                    selectionOverlay.visible = false
                }
            }
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: cameraViewModel.cameraStatus.indexOf("Connecting") >= 0
            visible: running
        }
    }
}
