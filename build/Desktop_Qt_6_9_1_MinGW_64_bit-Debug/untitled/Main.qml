import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SerialApp 1.0
import QtLocation 5.15
import QtPositioning 5.15
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
                    viewModel.latitude,
                    viewModel.longitude,
                    viewModel.altitude
                );
            });
        }
    }
    ScrollView {
        anchors.fill: parent
        anchors.margins: 10

        Column {
            width: root.width - 40
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

            // Main content area with camera stream
            Rectangle {
                width: parent.width
                height: 600
                color: backgroundColor
                border.color: borderColor
                border.width: 1
                radius: 5

                // Camera display area
                Item {
                    id: cameraContainer
                      anchors.centerIn: parent

                      // Maintain 16:9 aspect ratio based on available space
                      property real targetAspect: 16 / 9
                      property real availableWidth: parent.width
                      property real availableHeight: parent.height
                      property real scaledWidth: availableWidth
                      property real scaledHeight: availableHeight

                      onAvailableWidthChanged: recalcSize()
                      onAvailableHeightChanged: recalcSize()

                      function recalcSize() {
                          var containerAspect = availableWidth / availableHeight
                          if (containerAspect > targetAspect) {
                              // Too wide — height limits
                              scaledHeight = availableHeight
                              scaledWidth = scaledHeight * targetAspect
                          } else {
                              // Too tall — width limits
                              scaledWidth = availableWidth
                              scaledHeight = scaledWidth / targetAspect
                          }
                      }

                    Image {
                        id: cameraImage
                               anchors.centerIn: parent
                               width: cameraContainer.scaledWidth
                               height: cameraContainer.scaledHeight
                               fillMode: Image.PreserveAspectFit
                               source: cameraViewModel.currentFrameUrl
                               cache: false
                               smooth: true
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

                        Text {
                            anchors.centerIn: parent
                            text: cameraViewModel.streaming ? "" : "Camera Stream Area\n\nConfigure IP and Port above, then click 'Start Stream'\nOr use the Test panel to send test frames"
                            font.pixelSize: 16
                            color: "#888888"
                            horizontalAlignment: Text.AlignHCenter
                            lineHeight: 1.5
                            visible: !cameraViewModel.streaming
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

                                    // Show selection overlay at click point (default 120x120 box)
                                    var defaultSize = 120
                                    selectionOverlay.x = Math.max(0, Math.min(cameraImage.width - defaultSize, mouse.x - defaultSize/2))
                                    selectionOverlay.y = Math.max(0, Math.min(cameraImage.height - defaultSize, mouse.y - defaultSize/2))
                                    selectionOverlay.width = defaultSize
                                    selectionOverlay.height = defaultSize
                                    selectionOverlay.visible = true
                                }
                            }

                            onPositionChanged: {
                                if (pressed && mouse.buttons & Qt.LeftButton) {
                                    isDragging = true

                                    // Update selection rectangle during drag
                                    var startX = Math.min(pressX, mouse.x)
                                    var startY = Math.min(pressY, mouse.y)
                                    var endX = Math.max(pressX, mouse.x)
                                    var endY = Math.max(pressY, mouse.y)

                                    selectionOverlay.x = Math.max(0, startX)
                                    selectionOverlay.y = Math.max(0, startY)
                                    selectionOverlay.width = Math.min(cameraImage.width - selectionOverlay.x, endX - startX)
                                    selectionOverlay.height = Math.min(cameraImage.height - selectionOverlay.y, endY - startY)
                                }
                            }

                            onReleased: {
                                if (mouse.button === Qt.LeftButton && selectionOverlay.visible) {
                                    // Calculate coordinates in the original frame space (1920x1080)

                                    // Get the actual painted dimensions of the image
                                    var paintedWidth = cameraImage.paintedWidth
                                    var paintedHeight = cameraImage.paintedHeight

                                    console.log("Image dimensions:", cameraImage.width, "x", cameraImage.height)
                                    console.log("Painted dimensions:", paintedWidth, "x", paintedHeight)
                                    console.log("Selection overlay:", selectionOverlay.x, selectionOverlay.y, selectionOverlay.width, selectionOverlay.height)

                                    if (paintedWidth <= 0 || paintedHeight <= 0) {
                                        console.log("ERROR: Invalid painted dimensions")
                                        return
                                    }

                                    // Calculate scale factors
                                    var scaleX = 1920.0 / paintedWidth
                                    var scaleY = 1080.0 / paintedHeight

                                    console.log("Scale factors:", scaleX, scaleY)

                                    // Calculate the painted image offset within the Image component
                                    var paintedX = (cameraImage.width - paintedWidth) / 2
                                    var paintedY = (cameraImage.height - paintedHeight) / 2

                                    console.log("Painted offset:", paintedX, paintedY)

                                    // Convert selection coordinates to frame coordinates
                                    var frameX = Math.round((selectionOverlay.x - paintedX) * scaleX)
                                    var frameY = Math.round((selectionOverlay.y - paintedY) * scaleY)
                                    var frameW = Math.round(selectionOverlay.width * scaleX)
                                    var frameH = Math.round(selectionOverlay.height * scaleY)

                                    console.log("Before clamping:", frameX, frameY, frameW, frameH)

                                    // Ensure coordinates are within bounds and reasonable
                                    frameX = Math.max(0, Math.min(1920 - 20, frameX))
                                    frameY = Math.max(0, Math.min(1080 - 20, frameY))
                                    frameW = Math.max(20, Math.min(1920 - frameX, frameW))
                                    frameH = Math.max(20, Math.min(1080 - frameY, frameH))

                                    console.log("Final target coordinates:", frameX, frameY, frameW, frameH)

                                    // Validate before sending
                                    if (frameW < 10 || frameH < 10) {
                                        console.log("ERROR: Target too small, ignoring")
                                        return
                                    }

                                    if (frameX < 0 || frameY < 0 || frameX + frameW > 1920 || frameY + frameH > 1080) {
                                        console.log("ERROR: Target outside frame bounds, ignoring")
                                        return
                                    }

                                    // Send target to C++ backend
                                    console.log("Sending target to backend:", frameX, frameY, frameW, frameH)
                                    cameraViewModel.sendTarget(frameX, frameY, frameW, frameH)

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
        }
    }

    // Left Arrow Button for Telemetry Panel
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
    Rectangle {
        id: telemetryPanel
        width: 300
        height: root.height - 300
        x: root.telemetryPanelVisible ? 20 : -width
        y: 105
        z: 1000
        color: surfaceColor
        border.color: borderColor
        border.width: 2
        radius: 10
        opacity: 0.95
        visible: root.telemetryPanelVisible

        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        // Panel header
        Rectangle {
            id: telemetryHeader
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
                    text: "TELEMETRY DATA"
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
                    MouseArea {
                           anchors.fill: parent
                           cursorShape: Qt.PointingHandCursor
                           acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                       }
                    hoverEnabled: false  // Change this to true to enable hover

                    onClicked: root.telemetryPanelVisible = false
                }

            }
        }

        // Panel content
        ScrollView {
            anchors.top: telemetryHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15

            GridLayout {
                columns: 2
                columnSpacing: 20
                rowSpacing: 15
                width: telemetryPanel.width - 30

                // Roll
                Text {
                    text: "Roll:"
                    font.pixelSize: 13
                    font.bold: true
                    color: textColor
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: backgroundColor
                    border.color: primaryColor
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: viewModel.roll + "°"
                        font.pixelSize: 13
                        color: successColor
                        font.bold: true
                    }
                }

                // Pitch
                Text {
                    text: "Pitch:"
                    font.pixelSize: 13
                    font.bold: true
                    color: textColor
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: backgroundColor
                    border.color: primaryColor
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: viewModel.pitch + "°"
                        font.pixelSize: 13
                        color: successColor
                        font.bold: true
                    }
                }

                // Yaw
                Text {
                    text: "Yaw:"
                    font.pixelSize: 13
                    font.bold: true
                    color: textColor
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: backgroundColor
                    border.color: primaryColor
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: viewModel.yaw + "°"
                        font.pixelSize: 13
                        color: successColor
                        font.bold: true
                    }
                }

                // Azimuth Motor
                Text {
                    text: "Azimuth Motor:"
                    font.pixelSize: 13
                    font.bold: true
                    color: textColor
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: backgroundColor
                    border.color: primaryColor
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: viewModel.azimuthMotor.toString()
                        font.pixelSize: 13
                        color: successColor
                        font.bold: true
                    }
                }

                // Elevation Motor
                Text {
                    text: "Elevation Motor:"
                    font.pixelSize: 13
                    font.bold: true
                    color: textColor
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: backgroundColor
                    border.color: primaryColor
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: viewModel.elevationMotor.toString()
                        font.pixelSize: 13
                        color: successColor
                        font.bold: true
                    }
                }

                // Latitude
                Text {
                    text: "Latitude:"
                    font.pixelSize: 13
                    font.bold: true
                    color: textColor
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: backgroundColor
                    border.color: primaryColor
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: viewModel.latitude.toFixed(7) + "°"
                        font.pixelSize: 11
                        color: successColor
                        font.bold: true
                    }
                }

                // Longitude
                Text {
                    text: "Longitude:"
                    font.pixelSize: 13
                    font.bold: true
                    color: textColor
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: backgroundColor
                    border.color: primaryColor
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: viewModel.longitude.toFixed(7) + "°"
                        font.pixelSize: 11
                        color: successColor
                        font.bold: true
                    }
                }

                // Altitude
                Text {
                    text: "Altitude:"
                    font.pixelSize: 13
                    font.bold: true
                    color: textColor
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: backgroundColor
                    border.color: primaryColor
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: viewModel.altitude.toFixed(2) + " m"
                        font.pixelSize: 13
                        color: successColor
                        font.bold: true
                    }
                }
            }
        }
    }

    // Floating Controls Side Panel (Right)
       Rectangle {
           id: controlsPanel
           width: 400
           height: root.height - 40
           x: root.controlsPanelVisible ? root.width - width - 20 : root.width
           y: 20
           z: 1000
           color: surfaceColor
           border.color: borderColor
           border.width: 2
           radius: 10
           opacity: 0.95
           visible: root.controlsPanelVisible

           Behavior on x {
               NumberAnimation {
                   duration: 300
                   easing.type: Easing.OutCubic
               }
           }

           // Panel header
           Rectangle {
               id: panelHeader
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
                       text: "CONTROLS PANEL"
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
                       MouseArea {
                              anchors.fill: parent
                              cursorShape: Qt.PointingHandCursor
                              acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                          }
                       hoverEnabled: false  // Change this to true to enable hover
                       onClicked: root.controlsPanelVisible = false
                   }
               }
           }

           // Panel content
           ScrollView {
               anchors.top: panelHeader.bottom
               anchors.bottom: parent.bottom
               anchors.left: parent.left
               anchors.right: parent.right
               anchors.margins: 15

               Column {
                   width: controlsPanel.width - 30
                   spacing: 20

                   // Joystick Control Section
                   Rectangle {
                       width: parent.width
                       height: 320
                       color: backgroundColor
                       border.color: borderColor
                       border.width: 1
                       radius: 8

                       Column {
                           anchors.fill: parent
                           anchors.margins: 15
                           spacing: 15

                           Text {
                               text: "JOYSTICK CONTROL"
                               font.pixelSize: 14
                               font.bold: true
                               anchors.horizontalCenter: parent.horizontalCenter
                               color: textColor
                           }

                           // Joystick visual representation and controls
                           Item {
                               width: parent.width
                               height: 180

                               // Up button
                               Button {
                                   id: upButton
                                   text: "↑"
                                   width: 50
                                   height: 40
                                   anchors.horizontalCenter: parent.horizontalCenter
                                   anchors.top: parent.top
                                   enabled: viewModel.connected

                                   background: Rectangle {
                                       color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor)
                                       border.color: upButton.pressed ? Qt.lighter(borderColor, 1.5) : borderColor
                                       border.width: 2
                                       radius: 8

                                       // Add subtle shadow effect
                                       Rectangle {
                                           anchors.fill: parent
                                           anchors.topMargin: 2
                                           color: "transparent"
                                           border.color: Qt.rgba(255, 255, 255, 0.1)
                                           border.width: 1
                                           radius: parent.radius
                                       }
                                   }

                                   contentItem: Text {
                                       text: upButton.text
                                       color: textColor
                                       horizontalAlignment: Text.AlignHCenter
                                       verticalAlignment: Text.AlignVCenter
                                       font.bold: true
                                   }
                                   MouseArea {
                                          anchors.fill: parent
                                          cursorShape: Qt.PointingHandCursor
                                          acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                                      }
                                   hoverEnabled: false  // Change this to true to enable hover
                                   onClicked: viewModel.sendJoystickUp()
                               }

                               // Left and Right buttons
                               RowLayout {
                                   anchors.centerIn: parent
                                   spacing: 60

                                   Button {
                                       id: leftButton
                                       text: "←"
                                       width: 50        // Add this line
                                         height: 40       // Add this line
                                         Layout.preferredWidth: 50   // Add this line for RowLayout
                                         Layout.preferredHeight: 40  // Add this line for RowLayout
                                         enabled: viewModel.connected

                                       background: Rectangle {
                                           color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor)
                                           border.color: upButton.pressed ? Qt.lighter(borderColor, 1.5) : borderColor
                                           border.width: 2
                                           radius: 8

                                           // Add subtle shadow effect
                                           Rectangle {
                                               anchors.fill: parent
                                               anchors.topMargin: 2
                                               color: "transparent"
                                               border.color: Qt.rgba(255, 255, 255, 0.1)
                                               border.width: 1
                                               radius: parent.radius
                                           }
                                       }

                                       contentItem: Text {
                                           text: leftButton.text
                                           color: textColor
                                           horizontalAlignment: Text.AlignHCenter
                                           verticalAlignment: Text.AlignVCenter
                                           font.bold: true
                                       }

                                       onClicked: viewModel.sendJoystickLeft()
                                       MouseArea {
                                              anchors.fill: parent
                                              cursorShape: Qt.PointingHandCursor
                                              acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                                          }
                                       hoverEnabled: false  // Change this to true to enable hover
                                   }

                                   Button {
                                       id: rightButton
                                       text: "→"
                                       width: 50        // Add this line
                                         height: 40       // Add this line
                                         Layout.preferredWidth: 50   // Add this line for RowLayout
                                         Layout.preferredHeight: 40  // Add this line for RowLayout
                                       enabled: viewModel.connected

                                       background: Rectangle {
                                           color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor)
                                           border.color: upButton.pressed ? Qt.lighter(borderColor, 1.5) : borderColor
                                           border.width: 2
                                           radius: 8

                                           // Add subtle shadow effect
                                           Rectangle {
                                               anchors.fill: parent
                                               anchors.topMargin: 2
                                               color: "transparent"
                                               border.color: Qt.rgba(255, 255, 255, 0.1)
                                               border.width: 1
                                               radius: parent.radius
                                           }
                                       }

                                       contentItem: Text {
                                           text: rightButton.text
                                           color: textColor
                                           horizontalAlignment: Text.AlignHCenter
                                           verticalAlignment: Text.AlignVCenter
                                           font.bold: true
                                       }

                                       onClicked: viewModel.sendJoystickRight()
                                       MouseArea {
                                              anchors.fill: parent
                                              cursorShape: Qt.PointingHandCursor
                                              acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                                          }
                                       hoverEnabled: false  // Change this to true to enable hover
                                   }
                               }

                               // Down button
                               Button {
                                   id: downButton
                                   text: "↓"
                                   width: 50
                                   height: 40
                                   anchors.horizontalCenter: parent.horizontalCenter
                                   anchors.bottom: parent.bottom
                                   enabled: viewModel.connected

                                   background: Rectangle {
                                       color: upButton.pressed ? Qt.darker(primaryColor, 1.2) : (upButton.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor)
                                       border.color: upButton.pressed ? Qt.lighter(borderColor, 1.5) : borderColor
                                       border.width: 2
                                       radius: 8

                                       // Add subtle shadow effect
                                       Rectangle {
                                           anchors.fill: parent
                                           anchors.topMargin: 2
                                           color: "transparent"
                                           border.color: Qt.rgba(255, 255, 255, 0.1)
                                           border.width: 1
                                           radius: parent.radius
                                       }
                                   }
                                   contentItem: Text {
                                       text: downButton.text
                                       color: textColor
                                       horizontalAlignment: Text.AlignHCenter
                                       verticalAlignment: Text.AlignVCenter
                                       font.bold: true
                                   }

                                   onClicked: viewModel.sendJoystickDown()
                                   MouseArea {
                                          anchors.fill: parent
                                          cursorShape: Qt.PointingHandCursor
                                          acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                                      }
                                   hoverEnabled: false  // Change this to true to enable hover
                               }
                           }

                           // Current values display
                           RowLayout {
                               width: parent.width
                               spacing: 20

                               Column {
                                   Text {
                                       text: "Pitch Value:"
                                       font.pixelSize: 11
                                       font.bold: true
                                       color: textColor
                                   }
                                   SpinBox {
                                       from: 0
                                       to: 255
                                       value: viewModel.joystickPitch
                                       enabled: viewModel.connected
                                       Layout.preferredWidth: 80

                                       background: Rectangle {
                                           implicitWidth: 80
                                           implicitHeight: 30
                                           color: surfaceColor
                                           border.color: borderColor
                                           border.width: 1
                                           radius: 3
                                       }

                                       contentItem: TextInput {
                                           anchors.fill: parent
                                           anchors.margins: 4
                                           text: parent.textFromValue(parent.value, parent.locale)
                                           color: textColor
                                           horizontalAlignment: Text.AlignHCenter
                                           verticalAlignment: Text.AlignVCenter
                                           font.pixelSize: 13
                                       }

                                       onValueChanged: {
                                           if (value !== viewModel.joystickPitch) {
                                               viewModel.joystickPitch = value
                                               viewModel.sendCurrentJoystickValues()
                                           }
                                       }
                                   }
                               }

                               Column {
                                   Text {
                                       text: "Yaw Value:"
                                       font.pixelSize: 11
                                       font.bold: true
                                       color: textColor
                                   }
                                   SpinBox {
                                       from: 0
                                       to: 255
                                       value: viewModel.joystickYaw
                                       enabled: viewModel.connected
                                       Layout.preferredWidth: 80

                                       background: Rectangle {
                                           implicitWidth: 80
                                           implicitHeight: 30
                                           color: surfaceColor
                                           border.color: borderColor
                                           border.width: 1
                                           radius: 3
                                       }

                                       contentItem: TextInput {
                                           anchors.fill: parent
                                           anchors.margins: 4
                                           text: parent.textFromValue(parent.value, parent.locale)
                                           color: textColor
                                           horizontalAlignment: Text.AlignHCenter
                                           verticalAlignment: Text.AlignVCenter
                                           font.pixelSize: 13
                                       }

                                       onValueChanged: {
                                           if (value !== viewModel.joystickYaw) {
                                               viewModel.joystickYaw = value
                                               viewModel.sendCurrentJoystickValues()
                                           }
                                       }
                                   }

                               }
                           }
                       }
                   }

                   // PID Gains Control Section
                   Rectangle {
                       width: parent.width
                       height: 300
                       color: backgroundColor
                       border.color: borderColor
                       border.width: 1
                       radius: 8

                       Column {
                           anchors.fill: parent
                           anchors.margins: 15
                           spacing: 10

                           Text {
                               text: "PID GAINS CONTROL"
                               font.pixelSize: 14
                               font.bold: true
                               anchors.horizontalCenter: parent.horizontalCenter
                               color: textColor
                           }

                           // Azimuth PID gains
                           Rectangle {
                               width: parent.width
                               height: 90
                               color: surfaceColor
                               border.color: borderColor
                               radius: 5

                               Column {
                                   anchors.fill: parent
                                   anchors.margins: 10
                                   spacing: 8

                                   Text {
                                       text: "Azimuth Motor PID"
                                       font.pixelSize: 12
                                       font.bold: true
                                       color: textColor
                                   }

                                   RowLayout {
                                       width: parent.width
                                       spacing: 10

                                       Column {
                                           Text {
                                               text: "Kp:"
                                               font.pixelSize: 10
                                               color: textColor
                                           }
                                           SpinBox {
                                               from: 0
                                               to: 255
                                               value: viewModel.azimuthKp
                                               enabled: viewModel.connected
                                               Layout.preferredWidth: 80

                                               background: Rectangle {
                                                   implicitWidth: 80
                                                   implicitHeight: 30
                                                   color: backgroundColor
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

                                               onValueChanged: viewModel.azimuthKp = value
                                           }
                                       }

                                       Column {
                                           Text {
                                               text: "Ki:"
                                               font.pixelSize: 10
                                               color: textColor
                                           }
                                           SpinBox {
                                               from: 0
                                               to: 255
                                               value: viewModel.azimuthKi
                                               enabled: viewModel.connected
                                               Layout.preferredWidth: 80

                                               background: Rectangle {
                                                   color: backgroundColor
                                                   border.color: borderColor
                                                   border.width: 1
                                                   radius: 3
                                                   implicitWidth: 80
                                                   implicitHeight: 30
                                               }

                                               contentItem: TextInput {
                                                   text: parent.textFromValue(parent.value, parent.locale)
                                                   color: textColor
                                                   horizontalAlignment: Qt.AlignHCenter
                                                   verticalAlignment: Qt.AlignVCenter
                                               }

                                               onValueChanged: viewModel.azimuthKi = value
                                           }
                                       }

                                       Column {
                                           Text {
                                               text: "Kd:"
                                               font.pixelSize: 10
                                               color: textColor
                                           }
                                           SpinBox {
                                               from: 0
                                               to: 255
                                               value: viewModel.azimuthKd
                                               enabled: viewModel.connected
                                               Layout.preferredWidth: 80

                                               background: Rectangle {
                                                   color: backgroundColor
                                                   border.color: borderColor
                                                   border.width: 1
                                                   radius: 3
                                                   implicitWidth: 80
                                                   implicitHeight: 30
                                               }

                                               contentItem: TextInput {
                                                   text: parent.textFromValue(parent.value, parent.locale)
                                                   color: textColor
                                                   horizontalAlignment: Qt.AlignHCenter
                                                   verticalAlignment: Qt.AlignVCenter
                                               }

                                               onValueChanged: viewModel.azimuthKd = value
                                           }
                                       }
                                   }
                               }
                           }

                           // Elevation PID gains
                           Rectangle {
                               width: parent.width
                               height: 90
                               color: surfaceColor
                               border.color: borderColor
                               radius: 5

                               Column {
                                   anchors.fill: parent
                                   anchors.margins: 10
                                   spacing: 8

                                   Text {
                                       text: "Elevation Motor PID"
                                       font.pixelSize: 12
                                       font.bold: true
                                       color: textColor
                                   }

                                   RowLayout {
                                       width: parent.width
                                       spacing: 10

                                       Column {
                                           Text {
                                               text: "Kp:"
                                               font.pixelSize: 10
                                               color: textColor
                                           }
                                           SpinBox {
                                               from: 0
                                               to: 255
                                               value: viewModel.elevationKp
                                               enabled: viewModel.connected
                                               Layout.preferredWidth: 80

                                               background: Rectangle {
                                                   color: backgroundColor
                                                   border.color: borderColor
                                                   border.width: 1
                                                   radius: 3
                                                   implicitWidth: 80
                                                   implicitHeight: 30
                                               }

                                               contentItem: TextInput {
                                                   text: parent.textFromValue(parent.value, parent.locale)
                                                   color: textColor
                                                   horizontalAlignment: Qt.AlignHCenter
                                                   verticalAlignment: Qt.AlignVCenter
                                               }

                                               onValueChanged: viewModel.elevationKp = value
                                           }
                                       }

                                       Column {
                                           Text {
                                               text: "Ki:"
                                               font.pixelSize: 10
                                               color: textColor
                                           }
                                           SpinBox {
                                               from: 0
                                               to: 255
                                               value: viewModel.elevationKi
                                               enabled: viewModel.connected
                                               Layout.preferredWidth: 80

                                               background: Rectangle {
                                                   color: backgroundColor
                                                   border.color: borderColor
                                                   border.width: 1
                                                   radius: 3
                                                   implicitWidth: 80
                                                   implicitHeight: 30
                                               }

                                               contentItem: TextInput {
                                                   text: parent.textFromValue(parent.value, parent.locale)
                                                   color: textColor
                                                   horizontalAlignment: Qt.AlignHCenter
                                                   verticalAlignment: Qt.AlignVCenter
                                               }

                                               onValueChanged: viewModel.elevationKi = value
                                           }
                                       }

                                       Column {
                                           Text {
                                               text: "Kd:"
                                               font.pixelSize: 10
                                               color: textColor
                                           }
                                           SpinBox {
                                               from: 0
                                               to: 255
                                               value: viewModel.elevationKd
                                               enabled: viewModel.connected
                                               Layout.preferredWidth: 80

                                               background: Rectangle {
                                                   color: backgroundColor
                                                   border.color: borderColor
                                                   border.width: 1
                                                   radius: 3
                                                   implicitWidth: 80
                                                   implicitHeight: 30
                                               }

                                               contentItem: TextInput {
                                                   text: parent.textFromValue(parent.value, parent.locale)
                                                   color: textColor
                                                   horizontalAlignment: Qt.AlignHCenter
                                                   verticalAlignment: Qt.AlignVCenter
                                               }

                                               onValueChanged: viewModel.elevationKd = value
                                           }
                                       }
                                   }
                               }
                           }

                           // Send PID gains button
                           Button {
                               text: "Send PID Gains"
                               width: 150
                               height: 35
                               anchors.horizontalCenter: parent.horizontalCenter
                               enabled: viewModel.connected

                               background: Rectangle {
                                   color:primaryColor
                                   radius: 5
                                   border.color: borderColor
                               }

                               contentItem: Text {
                                   text: parent.text
                                   color: textColor
                                   horizontalAlignment: Text.AlignHCenter
                                   verticalAlignment: Text.AlignVCenter
                                   font.bold: true
                               }

                               onClicked: viewModel.sendPIDGains()
                               MouseArea {
                                      anchors.fill: parent
                                      cursorShape: Qt.PointingHandCursor
                                      acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                                  }
                               hoverEnabled: false  // Change this to true to enable hover
                           }
                       }
                   }

                   // Camera Control Section in Controls Panel
                   Rectangle {
                       width: parent.width
                       height: 120
                       color: backgroundColor
                       border.color: borderColor
                       border.width: 1
                       radius: 8

                       Column {
                           anchors.fill: parent
                           anchors.margins: 15
                           spacing: 15

                           Text {
                               text: "CAMERA CONTROLS"
                               font.pixelSize: 14
                               font.bold: true
                               anchors.horizontalCenter: parent.horizontalCenter
                               color: textColor
                           }

                           // Zoom Control
                           RowLayout {
                               width: parent.width
                               spacing: 15

                               Text {
                                   text: "Zoom Level:"
                                   font.pixelSize: 12
                                   font.bold: true
                                   color: textColor
                               }

                               SpinBox {
                                   id: zoomSpinBox
                                   from: 0
                                   to: 255
                                   value: viewModel.zoomLevel
                                   enabled: viewModel.connected

                                   background: Rectangle {
                                       color: surfaceColor
                                       border.color: borderColor
                                       border.width: 1
                                       radius: 3
                                       implicitWidth: 80
                                       implicitHeight: 30
                                   }

                                   contentItem: TextInput {
                                       text: parent.textFromValue(parent.value, parent.locale)
                                       color: textColor
                                       horizontalAlignment: Qt.AlignHCenter
                                       verticalAlignment: Qt.AlignVCenter
                                   }

                                   onValueChanged: viewModel.zoomLevel = value
                               }

                               Button {
                                   text: "Send Zoom"
                                   enabled: viewModel.connected

                                   background: Rectangle {
                                       color: primaryColor
                                       radius: 5
                                       border.color: borderColor
                                   }

                                   contentItem: Text {
                                       text: parent.text
                                       color: "white"
                                       horizontalAlignment: Text.AlignHCenter
                                       verticalAlignment: Text.AlignVCenter
                                       font.bold: true
                                   }

                                   onClicked: viewModel.sendZoom()
                                   MouseArea {
                                          anchors.fill: parent
                                          cursorShape: Qt.PointingHandCursor
                                          acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                                      }
                                   hoverEnabled: false  // Change this to true to enable hover
                               }
                           }
                       }
                   }
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
    Rectangle {
        id: capturePanel
        width: 300
        height: 250
        x: root.capturePanelVisible ? (root.width - width) / 2 : root.width
        y: root.capturePanelVisible ? (root.height - height) / 2 : -height
        z: 1003
        color: surfaceColor
        border.color: borderColor
        border.width: 2
        radius: 15
        opacity: 0.98
        visible: root.capturePanelVisible

        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        // Panel header
        Rectangle {
            id: captureHeader
            width: parent.width
            height: 50
            color: primaryColor
            border.color: borderColor
            radius: 15
            anchors.top: parent.top

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "CAPTURE OPTIONS"
                    font.pixelSize: 16
                    font.bold: true
                    Layout.fillWidth: true
                    color: "white"
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

                    onClicked: root.capturePanelVisible = false
                    MouseArea {
                           anchors.fill: parent
                           cursorShape: Qt.PointingHandCursor
                           acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                       }
                    hoverEnabled: false  // Change this to true to enable hover
                }
            }
        }

        // Panel content
        Column {
            anchors.top: captureHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            spacing: 20

            // Recording Section
            Rectangle {
                width: parent.width
                height: 80
                color: backgroundColor
                border.color: borderColor
                radius: 8

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Button {
                        text: mediaViewModel.isRecording ? "Stop Recording" : "Start Recording"
                        width: 200
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter

                        background: Rectangle {
                            color: mediaViewModel.isRecording ? errorColor : "green"
                            radius: 8
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
                            root.capturePanelVisible = false
                            mediaViewModel.startOrStopRecording("")
                        }
                        MouseArea {
                               anchors.fill: parent
                               cursorShape: Qt.PointingHandCursor
                               acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                           }
                        hoverEnabled: false  // Change this to true to enable hover
                    }


                }
            }

            // Screenshot Section
            Rectangle {
                width: parent.width
                height: 60
                color: backgroundColor
                border.color: borderColor
                radius: 8

                Button {
                    text: "Take Screenshot"
                    width: 200
                    height: 40
                    anchors.centerIn: parent

                    background: Rectangle {
                        color: "green"
                        radius: 8
                        border.color: borderColor
                        border.width: 1
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }

                    onClicked: {
                        root.capturePanelVisible = false
                        screenshotTimer.start()
                    }
                    MouseArea {
                           anchors.fill: parent
                           cursorShape: Qt.PointingHandCursor
                           acceptedButtons: Qt.NoButton  // Don't interfere with button clicks
                       }
                    hoverEnabled: false  // Change this to true to enable hover
                }
            }
        }

        // Timer for delayed screenshot
        Timer {
            id: screenshotTimer
            interval: 350
            repeat: false
            onTriggered: {
                flashAnimation.start()
                mediaViewModel.takeSnapshot("")
            }
        }
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
    Rectangle {
        id: mapPanel
        width: 400
        height: root.height - 40
        x: root.mapPanelVisible ? root.width - width - 20 : root.width
        y: 20
        z: 1000
        color: surfaceColor
        border.color: borderColor
        border.width: 2
        radius: 10
        opacity: 0.95
        visible: root.mapPanelVisible

        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        // Panel header
        Rectangle {
            id: mapHeader
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
                    text: "MAP VIEW"
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

                    onClicked: root.mapPanelVisible = false
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
        Column {
            anchors.top: mapHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15
            spacing: 15

            // Map View
            Rectangle {
                width: parent.width
                height: 450
                color: backgroundColor
                border.color: borderColor
                border.width: 2
                radius: 8
                clip: true

                Map {
                    id: map
                    anchors.fill: parent
                    anchors.margins: 2

                    // Map plugin - OpenStreetMap (free)
                    plugin: Plugin {
                        name: "osm"
                    }

                    center: mapViewModel.mapCenter
                    zoomLevel: 12

                    // Disable gestures for simplicity

                    // Plane marker
                    MapQuickItem {
                        id: planeMarker
                        coordinate: mapViewModel.planeCoordinate
                        anchorPoint.x: planeIcon.width / 2
                        anchorPoint.y: planeIcon.height / 2

                        sourceItem: Rectangle {
                            id: planeIcon
                            width: 32
                            height: 32
                            color: "transparent"

                            rotation: mapViewModel.planeHeading

                            // Plane shape
                            Canvas {
                                anchors.fill: parent
                                onPaint: {
                                    var ctx = getContext("2d");
                                    ctx.clearRect(0, 0, width, height);

                                    // Set plane color based on GPS status
                                    ctx.fillStyle = mapViewModel.hasGPSData ? "#00FF00" : "#FFAA00";
                                    ctx.strokeStyle = "#FFFFFF";
                                    ctx.lineWidth = 2;

                                    // Draw plane shape
                                    ctx.beginPath();
                                    // Nose
                                    ctx.moveTo(width/2, 2);
                                    // Right wing
                                    ctx.lineTo(width/2 + 10, height/2 + 5);
                                    ctx.lineTo(width/2 + 8, height/2 + 8);
                                    // Right tail
                                    ctx.lineTo(width/2 + 3, height - 2);
                                    ctx.lineTo(width/2 + 1, height - 2);
                                    ctx.lineTo(width/2 + 1, height/2 + 8);
                                    // Body
                                    ctx.lineTo(width/2, height/2 + 6);
                                    ctx.lineTo(width/2 - 1, height/2 + 8);
                                    ctx.lineTo(width/2 - 1, height - 2);
                                    ctx.lineTo(width/2 - 3, height - 2);
                                    // Left tail
                                    ctx.lineTo(width/2 - 8, height/2 + 8);
                                    ctx.lineTo(width/2 - 10, height/2 + 5);
                                    // Left wing
                                    ctx.closePath();

                                    ctx.fill();
                                    ctx.stroke();
                                }
                            }

                            // Pulsing effect for GPS mode
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width + 10
                                height: parent.height + 10
                                color: "transparent"
                                border.color: mapViewModel.hasGPSData ? "#00FF00" : "#FFAA00"
                                border.width: 2
                                radius: width / 2
                                opacity: 0.3

                                SequentialAnimation on scale {
                                    running: true
                                    loops: Animation.Infinite
                                    NumberAnimation { from: 1.0; to: 1.3; duration: 1000 }
                                    NumberAnimation { from: 1.3; to: 1.0; duration: 1000 }
                                }
                            }
                        }
                    }
                }
            }

            // GPS Data Display Rectangle
            Rectangle {
                width: parent.width
                height: 150
                color: backgroundColor
                border.color: mapViewModel.hasGPSData ? successColor : warningColor
                border.width: 2
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12

                    Text {
                        text: mapViewModel.hasGPSData ? "GPS DATA" : "RANDOM MODE"
                        font.pixelSize: 14
                        font.bold: true
                        color: mapViewModel.hasGPSData ? successColor : warningColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // Latitude
                    Row {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Latitude:"
                            font.pixelSize: 12
                            font.bold: true
                            color: textColor
                            width: 70
                        }

                        Text {
                            text: mapViewModel.latitudeText
                            font.pixelSize: 12
                            color: mapViewModel.hasGPSData ? successColor : warningColor
                            font.bold: true
                        }
                    }

                    // Longitude
                    Row {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Longitude:"
                            font.pixelSize: 12
                            font.bold: true
                            color: textColor
                            width: 70
                        }

                        Text {
                            text: mapViewModel.longitudeText
                            font.pixelSize: 12
                            color: mapViewModel.hasGPSData ? successColor : warningColor
                            font.bold: true
                        }
                    }

                    // Altitude
                    Row {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Altitude:"
                            font.pixelSize: 12
                            font.bold: true
                            color: textColor
                            width: 70
                        }

                        Text {
                            text: mapViewModel.altitudeText
                            font.pixelSize: 12
                            color: mapViewModel.hasGPSData ? successColor : warningColor
                            font.bold: true
                        }
                    }
                }
            }
        }}
    // Floating Visualization Side Panel (Right)
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
        ScrollView {
            anchors.top: visualizationHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15

            Column {
                width: visualizationPanel.width - 30
                spacing: 20

                // Thermal Camera Controls
                Rectangle {
                    width: parent.width
                    height: 100
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
                    width: parent.width
                    height: 300
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
                                                                  width: parent.width
                                                                  height: 250

                                                                  Image {
                                                                      id: thermalImage
                                                                      anchors.centerIn: parent
                                                                      fillMode: Image.PreserveAspectFit
                                                                      source: thermalCameraViewModel.currentThermalFrameUrl
                                                                      cache: false

                                                                      sourceSize.width: parent.width * 0.9
                                                                      sourceSize.height: parent.height * 0.9

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
                                                                  }

                                                                  BusyIndicator {
                                                                      anchors.centerIn: parent
                                                                      running: thermalCameraViewModel.thermalCameraStatus.indexOf("Connecting") >= 0
                                                                      visible: running
                                                                  }
                                                              }
                                                          }
                                                      }

                                                      // Thermal Analysis Tools (optional section for future expansion)
                                                      Rectangle {
                                                          width: parent.width
                                                          height: 120
                                                          color: backgroundColor
                                                          border.color: borderColor
                                                          border.width: 1
                                                          radius: 8

                                                          Column {
                                                              anchors.fill: parent
                                                              anchors.margins: 15
                                                              spacing: 10

                                                              Text {
                                                                  text: "THERMAL ANALYSIS"
                                                                  font.pixelSize: 14
                                                                  font.bold: true
                                                                  anchors.horizontalCenter: parent.horizontalCenter
                                                                  color: textColor
                                                              }

                                                              Text {
                                                                  text: "Temperature range, hotspot detection,\nand thermal analysis tools will be\navailable in future updates."
                                                                  font.pixelSize: 11
                                                                  color: "#888888"
                                                                  horizontalAlignment: Text.AlignHCenter
                                                                  anchors.horizontalCenter: parent.horizontalCenter
                                                                  lineHeight: 1.3
                                                              }
                                                          }
                                                      }
                                                  }
                                              }
                                          }
}
