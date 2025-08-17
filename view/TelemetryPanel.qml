import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    // External bindings (wired from Main.qml)
    property bool panelVisible: false
    property var  viewModel

    // Theme passed from Main.qml (defaults keep dev-preview alive)
    property color primaryColor:   "#FF4713"
    property color backgroundColor:"#1a1a1a"
    property color surfaceColor:   "#2d2d2d"
    property color borderColor:    "#404040"
    property color textColor:      "#ffffff"
    property color successColor:   "#4CAF50"
    property color warningColor:   "#FFC107"
    property color errorColor:     "#F44336"

    // Positioning like original
    width: 300
    height: parent ? parent.height - 300 : 600
    x: panelVisible ? 20 : -width
    y: 105
    z: 1000
    visible: panelVisible
    opacity: 0.95

    signal closeRequested()

    Behavior on x {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    // === Original panel UI (unchanged) ===
    Rectangle {
        id: panelCard
        anchors.fill: parent
        color: surfaceColor
        border.color: borderColor
        border.width: 2
        radius: 10

        // Header
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
                    width: 30; height: 30
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
                    onClicked: root.closeRequested()
                }
            }
        }

        // Content (copied 1:1 from your Main.qml)
        ScrollView {
            anchors.top: telemetryHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15

            GridLayout {
                columns: 2
                columnSpacing: 20
                rowSpacing: 10
                width: panelCard.width - 30

                // Gimbal Roll
                Text { text: "Gimbal Roll:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.gimbalRoll + "°"; font.pixelSize: 13; color: successColor; font.bold: true }
                }

                // Gimbal Pitch
                Text { text: "Gimbal Pitch:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.gimbalPitch + "°"; font.pixelSize: 13; color: successColor; font.bold: true }
                }

                // Gimbal Yaw
                Text { text: "Gimbal Yaw:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.gimbalYaw + "°"; font.pixelSize: 13; color: successColor; font.bold: true }
                }

                // Yaw Motor Pose
                Text { text: "Yaw Motor:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.yawMotorPose.toString(); font.pixelSize: 13; color: successColor; font.bold: true }
                }

                // Pitch Motor Pose
                Text { text: "Pitch Motor:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.pitchMotorPose.toString(); font.pixelSize: 13; color: successColor; font.bold: true }
                }

                // Gimbal Pose Lat
                Text { text: "Gimbal Lat:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.gimbalPoseLat.toFixed(7) + "°"; font.pixelSize: 11; color: successColor; font.bold: true }
                }

                // Gimbal Pose Lon
                Text { text: "Gimbal Lon:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.gimbalPoseLon.toFixed(7) + "°"; font.pixelSize: 11; color: successColor; font.bold: true }
                }

                // Gimbal Pose Alt
                Text { text: "Gimbal Alt:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.gimbalPoseAlt.toFixed(2) + " m"; font.pixelSize: 13; color: successColor; font.bold: true }
                }

                // Target Lat/Lon/Alt
                Text { text: "Target Lat: "; font.pixelSize: 13; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.targetPoseLat.toFixed(7) + "°"; font.pixelSize: 13; color: successColor; font.bold: true }
                }
                Text { text: "Target Lon: "; font.pixelSize: 13; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.targetPoseLon.toFixed(7) + "°"; font.pixelSize: 13; color: successColor; font.bold: true }
                }
                Text { text: "Target Alt: "; font.pixelSize: 13; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text { anchors.centerIn: parent; text: viewModel.targetPoseAlt.toFixed(2) + " m"; font.pixelSize: 13; color: successColor; font.bold: true }
                }

                // Battery
                Text { text: "Battery:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text {
                        anchors.centerIn: parent
                        text: viewModel.battery + "%"
                        font.pixelSize: 13
                        color: viewModel.battery > 20 ? successColor : errorColor
                        font.bold: true
                    }
                }

                // Signal
                Text { text: "Signal:"; font.pixelSize: 13; font.bold: true; color: textColor }
                Rectangle {
                    Layout.fillWidth: true; height: 30
                    color: backgroundColor; border.color: primaryColor; radius: 5
                    Text {
                        anchors.centerIn: parent
                        text: viewModel.signalStrength + "/100"
                        font.pixelSize: 13
                        color: viewModel.signalStrength > 50 ? successColor : warningColor
                        font.bold: true
                    }
                }
            }
        }
    }
}
