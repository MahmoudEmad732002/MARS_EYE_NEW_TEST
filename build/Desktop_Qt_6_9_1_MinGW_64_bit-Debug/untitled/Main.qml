import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SerialApp 1.0
import QtLocation 5.15
import QtPositioning 5.15
import "view"
import Qt.labs.settings

ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 800
    minimumHeight: 600
    minimumWidth: 850
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

    // Settings {
    //     id: appSettings
    //     category: "AppState"
    //     property bool firstLaunch: true
    //     property int savedInterval: 1000
    //     property var savedIndicatorConfig: ({})
    //     property bool isDarkTheme: false
    // }

    MapViewModel {
        id: mapViewModel

        // Connect to GPS data changes
        Component.onCompleted: {
            viewModel.targetGPSChanged.connect(function() {
                mapViewModel.updateGPSData(
                    viewModel.targetPoseLat,
                    viewModel.targetPoseLon,
                    viewModel.targetPoseAlt
                );
            });
        }
    }
    Column {
            anchors.fill: parent
             spacing: 15

            // Top bar with connection controls
             // Top bar with connection controls
             TopBar {
                 id: topBar
                 width: parent.width

                 // Pass theme properties
                 primaryColor: root.primaryColor
                 backgroundColor: root.backgroundColor
                 surfaceColor: root.surfaceColor
                 borderColor: root.borderColor
                 textColor: root.textColor
                 successColor: root.successColor
                 errorColor: root.errorColor

                 // Pass viewModel
                 viewModel: viewModel

                 // Handle panel visibility signals
                 onVisualizationPanelToggled: root.visualizationPanelVisible = !root.visualizationPanelVisible
                 onControlsPanelToggled: root.controlsPanelVisible = !root.controlsPanelVisible
                 onMapPanelToggled: root.mapPanelVisible = !root.mapPanelVisible
                 onCapturePanelToggled: root.capturePanelVisible = !root.capturePanelVisible
             }
              // Camera control bar
             // Camera control bar
             CameraControlBar {
                 id: cameraControlBar
                 width: parent.width

                 // Pass theme properties
                 surfaceColor: root.surfaceColor
                 borderColor: root.borderColor
                 textColor: root.textColor
                 successColor: root.successColor
                 errorColor: root.errorColor

                 // Pass BOTH view models - CRITICAL for serial integration
                 cameraViewModel: cameraViewModel
                 serialViewModel: viewModel  // This is your SerialViewModel instance
             }

             // Also ensure your main application initialization properly connects the view models.
             // Add this to your Component.onCompleted for the main window:

             Component.onCompleted: {
                 // Connect camera view model with serial view model for tracking
                 // This should be done in your C++ main, but verify it's working
                 console.log("Application initialized")
                 console.log("Camera streaming:", cameraViewModel.streaming)
                 console.log("Serial connected:", viewModel.connected)
             }


                // Main content area with camera stream - TAKES ALL REMAINING HEIGHT
                    Rectangle {
                        id:imgRect
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
                                            var centerX = sourceX + sourceW / 2
                                            var centerY = sourceY + sourceH / 2
                                            console.log("Sending target with frame ID:", frameId)

                                            // Send to serial model via view model
                                            viewModel.sendSelectTarget(Math.round(centerX), Math.round(centerY), frameId)

                                            // IMPORTANT: Send the coordinates directly to the camera view model
                                            // These coordinates are already in 1920x1080 space, no additional scaling needed
                                            cameraViewModel.sendTarget(sourceX, sourceY, sourceW, sourceH)

                                            // Hide selection overlay immediately after target selection
                                            selectionOverlay.visible = false
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
                duration: 200
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
        anchors.top: cameraImage.top

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
                color: surfaceColor
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
                            id: thermalPortSpin
                            Layout.preferredWidth: 80
                            from: 1
                            to: 65535
                            stepSize: 1
                            value: thermalCameraViewModel.thermalPort
                            enabled: !thermalCameraViewModel.thermalStreaming
                            editable: true

                            // leave space so arrows receive clicks
                            leftPadding: 6
                            rightPadding: 28

                            background: Rectangle {
                                color: surfaceColor
                                border.color: borderColor
                                border.width: 1
                                radius: 3
                            }

                            // Custom display/editor that doesn't block the arrows
                            contentItem: TextInput {
                                text: thermalPortSpin.displayText
                                color: textColor
                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter
                                validator: IntValidator { bottom: thermalPortSpin.from; top: thermalPortSpin.to }
                                inputMethodHints: Qt.ImhDigitsOnly

                                // user pressed Enter
                                onAccepted: {
                                    thermalPortSpin.value = thermalPortSpin.valueFromText(text, thermalPortSpin.locale)
                                }
                            }

                            // single source of truth -> ViewModel
                            onValueChanged: thermalCameraViewModel.thermalPort = value
                        }


                        Button {
                            text: thermalCameraViewModel.thermalStreamButtonText
                            Layout.preferredWidth: 70

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
                Layout.preferredHeight: 500
                color: surfaceColor
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
                Layout.preferredHeight: 300  // Increased height
                Layout.fillHeight: true
                color: surfaceColor
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


                }
            }
         }
   }
}
