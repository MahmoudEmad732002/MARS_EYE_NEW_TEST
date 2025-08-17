// PlaneMarker.qml
import QtQuick 2.15

Rectangle {
    id: root
    width: 32
    height: 32
    color: "transparent"

    property bool hasGPSData: false
    property real heading: 0

    rotation: heading

    // Plane shape
    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            // Set plane color based on GPS status
            ctx.fillStyle = root.hasGPSData ? "#00FF00" : "#FFAA00";
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
        border.color: root.hasGPSData ? "#00FF00" : "#FFAA00"
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
