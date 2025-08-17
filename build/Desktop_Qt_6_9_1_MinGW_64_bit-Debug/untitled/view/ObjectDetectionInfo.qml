import QtQuick 2.15

QtObject {
    id: objectDetectionInfo

    // Object detection data properties - exact same as original
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

    // UDP Socket for receiving object detection info - exact same as original
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
}
