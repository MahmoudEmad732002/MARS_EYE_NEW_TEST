import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SerialApp 1.0
import QtLocation 5.15
import QtPositioning 5.15
import "view"
ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 900
    title: "Serial MVVM Application with Camera Test"
    color: backgroundColor

    // Theme Properties
    property string primaryColor: "#FF4713"
    property string backgroundColor: "#1a1a1a"
    property string surfaceColor: "#2d2d2d"
    property string borderColor: "#404040"
    property string textColor: "#ffffff"
    property string accentColor: "#FF6B35"
    property string successColor: "#4CAF50"
    property string warningColor: "#FFC107"
    property string errorColor: "#F44336"
    property bool mapPanelVisible: false
    property bool controlsPanelVisible: false
    property bool telemetryPanelVisible: false
    property bool testPanelVisible: false
    property bool capturePanelVisible: false
    property bool visualizationPanelVisible: false
    property bool framesSwapped: false

    SerialViewModel {
        id: viewModel
    }
    MediaManagerViewModel {
        id: mediaViewModel

        Component.onCompleted: {
            mediaViewModel.setWindow(root)
        }
    }
    ThermalCameraViewModel {
        id: thermalCameraViewModel
    }
    CameraViewModel {
        id: cameraViewModel
    }


    MapViewModel {
        id: mapViewModel

        // Connect to serial data changes
        Component.onCompleted: {
            viewModel.telemetryChanged.connect(function() {
                mapViewModel.updateGPSData(
                    viewModel.gimbalPoseLat,
                    viewModel.gimbalPoseLon,
                    viewModel.gimbalPoseAlt
                );
            });
        }
    }
    Column {
            anchors.fill: parent
             spacing: 15

            // Top bar with connection controls
            Rectangle {
                width: parent.width
                height: 60
                color: surfaceColor
                border.color: borderColor
                border.width: 1
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 15

                    Text {
                        text: "Port:"
                        font.pixelSize: 12
                        font.bold: true
                        color: textColor
                    }

                    ComboBox {
                        id: portComboBox
                        Layout.preferredWidth: 120
                        model: viewModel.availablePorts
                        enabled: !viewModel.connected

                        background: Rectangle {
                            color: surfaceColor
                            border.color: borderColor
                            border.width: 1
                            radius: 3
                        }

                        contentItem: Text {
                            text: portComboBox.displayText
                            color: textColor
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 8
                        }
                    }

                    Text {
                        text: "Baud Rate:"
                        font.pixelSize: 12
                        font.bold: true
                        color: textColor
                    }

                    ComboBox {
                        id: baudRateComboBox
                        Layout.preferredWidth: 100
                        model: viewModel.baudRates
                        currentIndex: 4
                        enabled: !viewModel.connected

                        background: Rectangle {
                            color: surfaceColor
                            border.color: borderColor
                            border.width: 1
                            radius: 3
                        }

                        contentItem: Text {
                            text: baudRateComboBox.displayText
                            color: textColor
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 8
                        }
                    }

                    Button {
                        id: connectButton
                        text: viewModel.connectButtonText
                        Layout.preferredWidth: 100
                           // Add this line
                        background: Rectangle {
                            color: viewModel.connected ? "red" : "green"
                            radius: 5
                            border.color: borderColor
                            border.width: 1
                        }
                        contentItem: Text {
                            text: connectButton.text
                            color: textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }
                        onClicked: {
                            if (portComboBox.currentText && baudRateComboBox.currentText) {
                                viewModel.connectToSerial(
                                    portComboBox.currentText,
                                    parseInt(baudRateComboBox.currentText)
                                )
                            }
                        }
                        MouseArea {
                               anchors.fill: parent
                               cursorShape: Qt.PointingHandCursor
                               acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                           }
                        hoverEnabled: false  // Change this to true to enable hover

                    }

                    // Visualization button
                    Button {
                        id: visualizationButton
                        text: "Visualization"
                        Layout.preferredWidth: 100

                        background: Rectangle {
                            color: primaryColor
                            radius: 5
                            border.color: borderColor
                            border.width: 1
                        }

                        contentItem: Text {
                            text: visualizationButton.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }

                        onClicked: {
                            root.visualizationPanelVisible = !root.visualizationPanelVisible
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                        hoverEnabled: false
                    }


                    Button {
                                           id: controlsButton
                                           text: "Controls"
                                           Layout.preferredWidth: 80
                                           enabled: viewModel.connected

                                           background: Rectangle {
                                               color:viewModel.connected ?  primaryColor   :"#353638"

                                               radius: 5
                                               border.color: borderColor
                                               border.width: 1
                                           }

                                           contentItem: Text {
                                               text: controlsButton.text
                                               color: textColor
                                               horizontalAlignment: Text.AlignHCenter
                                               verticalAlignment: Text.AlignVCenter
                                               font.bold: true
                                           }

                                           onClicked: {
                                               root.controlsPanelVisible = !root.controlsPanelVisible
                                           }
                                           MouseArea {
                                                  anchors.fill: parent
                                                  cursorShape: Qt.PointingHandCursor
                                                  acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                                              }
                                           hoverEnabled: false  // Change this to true to enable hover
                                       }
                    Button {
                        id: mapButton
                        text: "Map"
                        Layout.preferredWidth: 60

                        background: Rectangle {
                            color: primaryColor
                            radius: 5
                            border.color: borderColor
                            border.width: 1
                        }

                        contentItem: Text {
                            text: mapButton.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }

                        onClicked: {
                            root.mapPanelVisible = !root.mapPanelVisible
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                        hoverEnabled: false
                    }

                    Button {
                        id: captureButton
                        text: "Capture"
                        Layout.preferredWidth: 80

                        background: Rectangle {
                            color: primaryColor
                            radius: 5
                            border.color: borderColor
                            border.width: 1
                        }

                        contentItem: Text {
                            text: captureButton.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }

                        onClicked: {
                            root.capturePanelVisible = !root.capturePanelVisible
                        }
                        MouseArea {
                               anchors.fill: parent
                               cursorShape: Qt.PointingHandCursor
                               acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                           }
                        hoverEnabled: false  // Change this to true to enable hover
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: viewModel.statusMessage
                        font.pixelSize: 11
                        color: viewModel.connected ? successColor : errorColor
                    }
                }
            }

            // Camera control bar
            Rectangle {
                width: parent.width
                height: 60
                color: surfaceColor
                border.color: borderColor
                border.width: 1
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 15

                    Text {
                        text: "Camera IP:"
                        font.pixelSize: 12
                        font.bold: true
                        color: textColor
                    }

                    TextField {
                        id: ipAddressField
                        Layout.preferredWidth: 150
                        text: cameraViewModel.ipAddress
                        placeholderText: "192.168.1.100"
                        enabled: !cameraViewModel.streaming
                        color: textColor
                        placeholderTextColor: "#888888"

                        background: Rectangle {
                            color: surfaceColor
                            border.color: borderColor
                            border.width: 1
                            radius: 3
                        }

                        onTextChanged: {
                            cameraViewModel.ipAddress = text
                        }
                    }

                    Text {
                        text: "Port:"
                        font.pixelSize: 12
                        font.bold: true
                        color: textColor
                    }

                    SpinBox {
                        id: portSpinBox
                        Layout.preferredWidth: 100
                        from: 1
                        to: 65535
                        value: cameraViewModel.port
                        enabled: !cameraViewModel.streaming

                        background: Rectangle {
                            color: surfaceColor
                            border.color: borderColor
                            border.width: 1
                            radius: 3
                        }

                        contentItem: TextInput {
                            text: portSpinBox.textFromValue(portSpinBox.value, portSpinBox.locale)
                            color: textColor
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                        }

                        onValueChanged: {
                            cameraViewModel.port = value
                        }
                    }

                    Button {
                        id: streamButton
                        text: cameraViewModel.streamButtonText
                        Layout.preferredWidth: 120

                        background: Rectangle {
                            color: cameraViewModel.streaming ? errorColor : "green"
                            radius: 5
                            border.color: borderColor
                            border.width: 1
                        }

                        contentItem: Text {
                            text: streamButton.text
                            color: textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }

                        onClicked: {
                            cameraViewModel.toggleStream()
                        }
                        MouseArea {
                               anchors.fill: parent
                               cursorShape: Qt.PointingHandCursor
                               acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                           }
                        hoverEnabled: false  // Change this to true to enable hover
                    }
                    Button {
                        id: trackButton
                        text: cameraViewModel.trackingEnabled ? "Disable Track" : "Track"
                        Layout.preferredWidth: 120

                        background: Rectangle {
                            color: cameraViewModel.trackingEnabled ? "#FFA500" : "#4CAF50"  // Orange when active, green when inactive
                            radius: 5
                            border.color: borderColor
                            border.width: 1
                        }

                        contentItem: Text {
                            text: trackButton.text
                            color: textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }

                        enabled: cameraViewModel.streaming

                        onClicked: {
                            if (cameraViewModel.trackingEnabled) {
                                cameraViewModel.disableTracking()
                            } else {
                                cameraViewModel.enableTracking()
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                        hoverEnabled: false
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    // Camera status and frame info
                    Column {
                        spacing: 2

                        Text {
                            text: cameraViewModel.cameraStatus
                            font.pixelSize: 10
                            color: cameraViewModel.streaming ? successColor : errorColor
                        }

                        Text {
                            text: cameraViewModel.streaming ?
                                  "Frames: " + cameraViewModel.frameCount + " | FPS: " + cameraViewModel.frameRate.toFixed(1) : ""
                            font.pixelSize: 9
                            color: "#aaaaaa"
                        }
                    }
                }
            }

            // Main content area with camera stream - TAKES ALL REMAINING HEIGHT
            // Main content area with camera stream - TAKES ALL REMAINING HEIGHT
                    Rectangle {
                        width: parent.width
                        height: root.height - 60 - 60  -30  // Full window height minus: top bar + camera bar + spacing + margins
                        color: backgroundColor
                        border.color: borderColor
                        border.width: 1
                        radius: 5

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

                            // Replace the existing camera Image and MouseArea section in your QML with this:

                            // Replace the existing camera Image and MouseArea section in your QML with this:

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

                                    // Auto-resize while visible if the window changes:
                                    onVisibleChanged: if (visible) adjustSize()
                                    function adjustSize() {
                                        var sizeFraction = 0.12
                                        var minPx = 60
                                        var maxPx = 320
                                        var base = Math.min(cameraImage.renderedImageWidth, cameraImage.renderedImageHeight)
                                        var s = Math.max(minPx, Math.min(maxPx, Math.round(base * sizeFraction)))
                                        // preserve center point when resizing
                                        var cx = selectionOverlay.x + selectionOverlay.width/2
                                        var cy = selectionOverlay.y + selectionOverlay.height/2
                                        selectionOverlay.width = s
                                        selectionOverlay.height = s
                                        selectionOverlay.x = Math.max(cameraImage.renderedImageX,
                                            Math.min(cameraImage.renderedImageX + cameraImage.renderedImageWidth - s, cx - s/2))
                                        selectionOverlay.y = Math.max(cameraImage.renderedImageY,
                                            Math.min(cameraImage.renderedImageY + cameraImage.renderedImageHeight - s, cy - s/2))
                                    }

                                    // Re-adjust when the rendered image size changes
                                    Connections {
                                        target: cameraImage
                                        function onRenderedImageWidthChanged()  { if (selectionOverlay.visible) selectionOverlay.adjustSize() }
                                        function onRenderedImageHeightChanged() { if (selectionOverlay.visible) selectionOverlay.adjustSize() }
                                    }
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
                                // Replace the existing mouse handling section in your QML with this corrected version:

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

                                            // Convert to source coords to validate click is on the image
                                            var sourceCoords = cameraImage.uiToSourceCoordinates(mouse.x, mouse.y)
                                            if (!sourceCoords)
                                                return

                                            // === NEW: size scales with rendered image size ===
                                            // Fraction of the smaller image dimension
                                            var sizeFraction = 0.12      // tweak between 0.08..0.18 to taste
                                            var minPx = 60               // lower clamp in UI pixels
                                            var maxPx = 320              // upper clamp in UI pixels

                                            var base = Math.min(cameraImage.renderedImageWidth,
                                                                cameraImage.renderedImageHeight)
                                            var defaultUISize = Math.max(minPx,
                                                                  Math.min(maxPx, Math.round(base * sizeFraction)))

                                            // Keep the square centered on the click and fully inside the image
                                            var half = defaultUISize / 2
                                            var left = Math.max(cameraImage.renderedImageX,
                                                        Math.min(cameraImage.renderedImageX + cameraImage.renderedImageWidth - defaultUISize,
                                                                 mouse.x - half))
                                            var top  = Math.max(cameraImage.renderedImageY,
                                                        Math.min(cameraImage.renderedImageY + cameraImage.renderedImageHeight - defaultUISize,
                                                                 mouse.y - half))

                                            selectionOverlay.x = left
                                            selectionOverlay.y = top
                                            selectionOverlay.width  = defaultUISize
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

                                            // IMPORTANT: Send the coordinates directly to the camera view model
                                            // These coordinates are already in 1920x1080 space, no additional scaling needed
                                            cameraViewModel.sendTarget(sourceX, sourceY, sourceW, sourceH)

                                            // Hide selection overlay after a short delay
                                            hideSelectionTimer.start()
                                        }
                                    }
                                } Timer {
                                    id: hideSelectionTimer
                                    interval: 1000
                                    repeat: false
                                    onTriggered: {
                                        selectionOverlay.visible = false
                                    }
                                }
                            }BusyIndicator {
                                anchors.centerIn: parent
                                running: cameraViewModel.cameraStatus.indexOf("Connecting") >= 0
                                visible: running
                            }
                        }
                    } }// Left Arrow Button for Telemetry Panel
    Button {
        id: telemetryArrowButton
        width: 40
        height: 40

        x: root.telemetryPanelVisible ? 330 : 20
        y: 200
        z: 1001
        text: root.telemetryPanelVisible ? "◀" : "▶"

        background: Rectangle {
            color: primaryColor
            radius: 20
            border.color: borderColor
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
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        onClicked: {
            root.telemetryPanelVisible = !root.telemetryPanelVisible
        }
        MouseArea {
               anchors.fill: parent
               cursorShape: Qt.PointingHandCursor
               acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
           }
        hoverEnabled: false  // Change this to true to enable hover
    }

    // Floating Telemetry Side Panel (Left)
    TelemetryPanel {
        id: telemetryPanel
        // Same stacking as before
        z: 1000

        // Maintain sizing/position behavior relative to window
        anchors.left: parent.left
        anchors.top: parent.top

        // Wire visibility to the existing app flag
        panelVisible: root.telemetryPanelVisible

        // Theme passthrough to preserve colors/appearance
        primaryColor:    primaryColor
        backgroundColor: backgroundColor
        surfaceColor:    surfaceColor
        borderColor:     borderColor
        textColor:       textColor
        successColor:    successColor
        warningColor:    warningColor
        errorColor:      errorColor

        // Bind to your existing backend VM (no changes needed elsewhere)
        viewModel: viewModel

        // Close button behavior identical to before
        onCloseRequested: root.telemetryPanelVisible = false
    }
    ControlsPanel {
        id: controlsPanel
        width: 400
        height: root.height - 40
        x: root.controlsPanelVisible ? root.width - width - 20 : root.width
        y: 20
        z: 1000
        visible: root.controlsPanelVisible

        // Theme properties
        primaryColor: root.primaryColor
        backgroundColor: root.backgroundColor
        surfaceColor: root.surfaceColor
        borderColor: root.borderColor
        textColor: root.textColor
        accentColor: root.accentColor
        successColor: root.successColor
        warningColor: root.warningColor
        errorColor: root.errorColor

        // ViewModel
        viewModel: viewModel

        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        onVisibleChanged: {
            if (!visible) {
                root.controlsPanelVisible = false
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: (root.controlsPanelVisible || root.telemetryPanelVisible || root.testPanelVisible || root.capturePanelVisible) ? 0.3 : 0
        z: 999
visible: root.controlsPanelVisible || root.telemetryPanelVisible || root.testPanelVisible || root.capturePanelVisible || root.mapPanelVisible || root.visualizationPanelVisible
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.controlsPanelVisible = false
                root.telemetryPanelVisible = false
                root.testPanelVisible = false
                root.capturePanelVisible = false
                root.mapPanelVisible = false
                root.visualizationPanelVisible = false
            }
        }
    }

    // Capture Panel (Floating popup)
    // Capture Panel (now a component)
    CapturePanel {
        id: capturePanel
        panelVisible: root.capturePanelVisible

        // Theme passthrough (keeps exact colors/appearance)
        primaryColor:    root.primaryColor
        backgroundColor: root.backgroundColor
        surfaceColor:    root.surfaceColor
        borderColor:     root.borderColor
        textColor:       root.textColor
        successColor:    root.successColor
        warningColor:    root.warningColor
        errorColor:      root.errorColor

        // Hook to your existing backend
        mediaViewModel: mediaViewModel

        // Keep original close behavior
        onCloseRequested: root.capturePanelVisible = false

        // Ask Main to run the white flash animation (exactly like before)
        onRequestFlash: flashAnimation.start()
    }
     // Flash effect for screenshot
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
            duration: 200

            onStarted: {
                flashEffect.visible = true
            }

            onFinished: {
                flashEffect.visible = false
            }
        }
    }


    // 5. ADD THIS MAP PANEL (after test panel, around line 1200)
    // Real Map Panel with Google Maps style
    // In Main.qml (replace the existing mapPanel)
    MapPanel {
        id: mapPanel
        width: 400
        height: root.height - 40
        x: root.mapPanelVisible ? root.width - width - 20 : root.width
        y: 20
        z: 1000
        visible: root.mapPanelVisible

        // Theme properties
        surfaceColor: root.surfaceColor
        borderColor: root.borderColor
        primaryColor: root.primaryColor
        textColor: root.textColor
        successColor: root.successColor
        warningColor: root.warningColor
        errorColor: root.errorColor

        // ViewModel
        mapViewModel: mapViewModel

        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        onVisibleChanged: {
            if (!visible) {
                root.mapPanelVisible = false
            }
        }
    }
    Rectangle {
        id: visualizationPanel
        width: 450
        height: root.height - 40
        x: root.visualizationPanelVisible ? root.width - width - 20 : root.width
        y: 20
        z: 1000
        color: surfaceColor
        border.color: borderColor
        border.width: 2
        radius: 10
        opacity: 0.95
        visible: root.visualizationPanelVisible

        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        // Panel header
        Rectangle {
            id: visualizationHeader
            width: parent.width
            height: 50
            color: primaryColor
            border.color: borderColor
            radius: 10
            anchors.top: parent.top

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "THERMAL VISUALIZATION"
                    font.pixelSize: 16
                    font.bold: true
                    Layout.fillWidth: true
                    color: textColor
                }

                Button {
                    text: "✕"
                    width: 30
                    height: 30

                    background: Rectangle {
                        color: parent.pressed ? Qt.darker(errorColor, 1.2) : errorColor
                        radius: 15
                        border.color: borderColor
                    }

                    contentItem: Text {
                        text: parent.text
                        color: textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }

                    onClicked: root.visualizationPanelVisible = false
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.NoButton
                    }
                    hoverEnabled: false
                }
            }
        }

        // Panel content
        // Panel content - Updated to use ColumnLayout instead of ScrollView
        // Panel content - Updated to use ColumnLayout instead of ScrollView
        // Panel content - Updated to use ColumnLayout instead of ScrollView
        ColumnLayout {
            anchors.top: visualizationHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15
            spacing: 20

            // Thermal Camera Controls
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    Text {
                        text: "THERMAL CAMERA CONTROLS"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: textColor
                    }

                    RowLayout {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Thermal IP:"
                            font.pixelSize: 12
                            font.bold: true
                            color: textColor
                        }

                        TextField {
                            Layout.preferredWidth: 120
                            text: thermalCameraViewModel.thermalIpAddress
                            enabled: !thermalCameraViewModel.thermalStreaming
                            color: textColor

                            background: Rectangle {
                                color: surfaceColor
                                border.color: borderColor
                                border.width: 1
                                radius: 3
                            }

                            onTextChanged: {
                                thermalCameraViewModel.thermalIpAddress = text
                            }
                        }

                        Text {
                            text: "Port:"
                            font.pixelSize: 12
                            font.bold: true
                            color: textColor
                        }

                        SpinBox {
                            Layout.preferredWidth: 80
                            from: 1
                            to: 65535
                            value: thermalCameraViewModel.thermalPort
                            enabled: !thermalCameraViewModel.thermalStreaming

                            background: Rectangle {
                                color: surfaceColor
                                border.color: borderColor
                                border.width: 1
                                radius: 3
                            }

                            contentItem: TextInput {
                                text: parent.textFromValue(parent.value, parent.locale)
                                color: textColor
                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter
                            }

                            onValueChanged: {
                                thermalCameraViewModel.thermalPort = value
                            }
                        }

                        Button {
                            text: thermalCameraViewModel.thermalStreamButtonText
                            Layout.preferredWidth: 100

                            background: Rectangle {
                                color: thermalCameraViewModel.thermalStreaming ? errorColor : "green"
                                radius: 5
                                border.color: borderColor
                                border.width: 1
                            }

                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            onClicked: {
                                thermalCameraViewModel.toggleThermalStream()
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                            hoverEnabled: false
                        }
                    }
                }
            }

            // Thermal Camera Display
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 300
                color: backgroundColor
                border.color: borderColor
                border.width: 2
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    // Status and frame info
                    Row {
                        width: parent.width
                        spacing: 20

                        Text {
                            text: thermalCameraViewModel.thermalCameraStatus
                            font.pixelSize: 12
                            color: thermalCameraViewModel.thermalStreaming ? successColor : errorColor
                        }

                        Text {
                            text: thermalCameraViewModel.thermalStreaming ?
                                  "Frames: " + thermalCameraViewModel.thermalFrameCount + " | FPS: " + thermalCameraViewModel.thermalFrameRate.toFixed(1) : ""
                            font.pixelSize: 10
                            color: "#aaaaaa"
                        }
                    }

                    // Thermal video display
                    Item {
                        id: thermalContainer
                        width: parent.width
                        height: parent.height - 40

                        // Calculate maximum size that maintains 16:9 aspect ratio
                        property real targetAspect: 16.0 / 9.0
                        property real availableWidth: width - 20  // Account for margins
                        property real availableHeight: height - 20

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
                            id: thermalImage
                            anchors.centerIn: parent
                            width: thermalContainer.displayWidth
                            height: thermalContainer.displayHeight
                            fillMode: Image.PreserveAspectFit
                            source: root.framesSwapped ? cameraViewModel.currentFrameUrl : thermalCameraViewModel.currentThermalFrameUrl
                            cache: false
                            smooth: true

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                border.color: thermalCameraViewModel.thermalStreaming ? "#FF6B35" : borderColor
                                border.width: 2
                                radius: 5
                                visible: thermalCameraViewModel.thermalStreaming
                            }

                            Text {
                                anchors.centerIn: parent
                                text: thermalCameraViewModel.thermalStreaming ? "" : "Thermal Camera Display\n\nConfigure IP and Port above,\nthen click 'Start Thermal'"
                                font.pixelSize: 14
                                color: "#888888"
                                horizontalAlignment: Text.AlignHCenter
                                lineHeight: 1.5
                                visible: !thermalCameraViewModel.thermalStreaming
                            }

                            // Add click functionality to swap frames
                            MouseArea {
                                anchors.fill: parent
                                enabled: thermalCameraViewModel.thermalStreaming && cameraViewModel.streaming
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                                onClicked: {
                                    root.framesSwapped = !root.framesSwapped
                                }
                            }

                            // Visual indicator for swap state
                            Rectangle {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: 10
                                width: 80
                                height: 25
                                color: Qt.rgba(0, 0, 0, 0.7)
                                radius: 12
                                visible: thermalCameraViewModel.thermalStreaming && cameraViewModel.streaming

                                Text {
                                    anchors.centerIn: parent
                                    text: root.framesSwapped ? "OPTICAL" : "THERMAL"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: root.framesSwapped ? "#00FF00" : "#FF6B35"
                                }
                            }
                        }

                        BusyIndicator {
                            anchors.centerIn: parent
                            running: thermalCameraViewModel.thermalCameraStatus.indexOf("Connecting") >= 0
                            visible: running
                        }
                    }
                }
            }

            // Thermal Analysis Tools
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 350  // Increased height
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Text {
                        text: "DETECTED OBJECT"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: textColor
                    }

                    // Object Detection Status
                    Rectangle {
                        width: parent.width
                        height: 40
                        color: surfaceColor
                        border.color: borderColor
                        radius: 5

                        Row {
                            anchors.centerIn: parent
                            spacing: 10

                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: {
                                    if (!cameraViewModel.trackingEnabled) return "#666666"
                                    if (objectDetectionInfo.status === "tracking") return "#00FF00"
                                    if (objectDetectionInfo.status === "lost") return "#FF0000"
                                    if (objectDetectionInfo.status === "waiting_for_target") return "#FFA500"
                                    return "#666666"
                                }
                            }

                            Text {
                                text: {
                                    if (!cameraViewModel.trackingEnabled) return "Tracking Disabled"
                                    if (objectDetectionInfo.status === "tracking") return "TRACKING ACTIVE"
                                    if (objectDetectionInfo.status === "lost") return "TARGET LOST"
                                    if (objectDetectionInfo.status === "waiting_for_target") return "WAITING FOR TARGET"
                                    return "READY"
                                }
                                font.pixelSize: 12
                                font.bold: true
                                color: textColor
                            }
                        }
                    }

                    // Object ROI Display
                    Rectangle {
                        width: parent.width
                        height: 180
                        color: surfaceColor
                        border.color: objectDetectionInfo.status === "tracking" ? successColor : borderColor
                        border.width: 2
                        radius: 8

                        Item {
                            anchors.fill: parent
                            anchors.margins: 10

                            // ROI Image Display
                            Image {
                                id: objectRoiImage
                                anchors.centerIn: parent
                                width: Math.min(150, parent.width - 20)
                                height: Math.min(150, parent.height - 40)
                                fillMode: Image.PreserveAspectFit
                                source: objectDetectionInfo.roiImageUrl || ""
                                cache: false
                                smooth: true
                                visible: objectDetectionInfo.status === "tracking" && objectDetectionInfo.roiImageUrl

                                Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                    border.color: successColor
                                    border.width: 2
                                    radius: 5
                                }

                                // Crosshair overlay
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 20
                                    height: 2
                                    color: "#FF0000"
                                }
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 2
                                    height: 20
                                    color: "#FF0000"
                                }
                            }

                            // Placeholder text when no object
                            Text {
                                anchors.centerIn: parent
                                text: {
                                    if (!cameraViewModel.trackingEnabled) return "Enable tracking\nto detect objects"
                                    if (objectDetectionInfo.status === "waiting_for_target") return "Click on video\nto select target"
                                    if (objectDetectionInfo.status === "lost") return "Target lost\nSelect new target"
                                    return "No object\nselected"
                                }
                                font.pixelSize: 12
                                color: "#888888"
                                horizontalAlignment: Text.AlignHCenter
                                lineHeight: 1.3
                                visible: !objectRoiImage.visible
                            }
                        }
                    }

                    // Object Information Grid
                    Rectangle {
                        width: parent.width
                        height: 80
                        color: backgroundColor
                        border.color: borderColor
                        radius: 5
                        visible: objectDetectionInfo.status === "tracking"

                        GridLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            columns: 2
                            rowSpacing: 5
                            columnSpacing: 15

                            // Position
                            Text {
                                text: "Position:"
                                font.pixelSize: 10
                                font.bold: true
                                color: textColor
                            }
                            Text {
                                text: objectDetectionInfo.centerX ?
                                      "(" + objectDetectionInfo.centerX + ", " + objectDetectionInfo.centerY + ")" :
                                      "N/A"
                                font.pixelSize: 10
                                color: successColor
                            }

                            // Size
                            Text {
                                text: "Size:"
                                font.pixelSize: 10
                                font.bold: true
                                color: textColor
                            }
                            Text {
                                text: objectDetectionInfo.currentBboxWidth ?
                                      objectDetectionInfo.currentBboxWidth + " × " + objectDetectionInfo.currentBboxHeight :
                                      "N/A"
                                font.pixelSize: 10
                                color: successColor
                            }

                            // Area
                            Text {
                                text: "Area:"
                                font.pixelSize: 10
                                font.bold: true
                                color: textColor
                            }
                            Text {
                                text: objectDetectionInfo.area ? objectDetectionInfo.area + " px²" : "N/A"
                                font.pixelSize: 10
                                color: successColor
                            }

                            // Confidence
                            Text {
                                text: "Confidence:"
                                font.pixelSize: 10
                                font.bold: true
                                color: textColor
                            }
                            Text {
                                text: objectDetectionInfo.confidence ?
                                      (objectDetectionInfo.confidence * 100).toFixed(1) + "%" :
                                      "N/A"
                                font.pixelSize: 10
                                color: objectDetectionInfo.confidence > 0.7 ? successColor : warningColor
                            }
                        }
                    }
                }
            }
         }
        QtObject {
            id: objectDetectionInfo

            property string status: "waiting_for_target"
            property int centerX: 0
            property int centerY: 0
            property int currentBboxX: 0
            property int currentBboxY: 0
            property int currentBboxWidth: 0
            property int currentBboxHeight: 0
            property int area: 0
            property real confidence: 0.0
            property string roiImageUrl: ""

            // UDP Socket for receiving object detection info
            property var detectionSocket: null

            Component.onCompleted: {
                // Create UDP socket for object detection info
                try {
                    detectionSocket = Qt.createQmlObject('
                        import QtNetwork 1.0
                        UdpSocket {
                            onMessageReceived: {
                                try {
                                    var data = JSON.parse(message);
                                    objectDetectionInfo.status = data.status || "unknown";

                                    if (data.center_x !== undefined) {
                                        objectDetectionInfo.centerX = data.center_x;
                                        objectDetectionInfo.centerY = data.center_y;
                                    }

                                    if (data.current_bbox !== undefined && data.current_bbox.length === 4) {
                                        objectDetectionInfo.currentBboxX = data.current_bbox[0];
                                        objectDetectionInfo.currentBboxY = data.current_bbox[1];
                                        objectDetectionInfo.currentBboxWidth = data.current_bbox[2];
                                        objectDetectionInfo.currentBboxHeight = data.current_bbox[3];
                                    }

                                    if (data.area !== undefined) {
                                        objectDetectionInfo.area = data.area;
                                    }

                                    if (data.confidence !== undefined) {
                                        objectDetectionInfo.confidence = data.confidence;
                                    }

                                    // Handle ROI image
                                    if (data.roi_image) {
                                        // Convert base64 to temporary image URL
                                        var imageData = "data:image/jpeg;base64," + data.roi_image;
                                        objectDetectionInfo.roiImageUrl = imageData;
                                    } else {
                                        objectDetectionInfo.roiImageUrl = "";
                                    }

                                } catch (e) {
                                    console.log("Error parsing object detection data:", e);
                                }
                            }
                        }', objectDetectionInfo, "detectionSocket");

                    detectionSocket.bind("127.0.0.1", 5201); // OBJECT_INFO_PORT
                    console.log("Object detection socket bound to port 5201");

                } catch (e) {
                    console.log("Failed to create detection socket:", e);
                }
            }
        }}
}
