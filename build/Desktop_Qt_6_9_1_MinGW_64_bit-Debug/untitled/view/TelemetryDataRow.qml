import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    Layout.fillWidth: true
    Layout.columnSpan: 2
    height: 40

    property string label: ""
    property string value: ""
    property string valueColor: Theme.successColor
    property int fontSize: 13

    Row {
        anchors.fill: parent
        spacing: 10

        Text {
            text: label
            font.pixelSize: fontSize
            font.bold: true
            color: Theme.textColor
            width: 120
        }

        Rectangle {
            width: parent.parent.width - 140
            height: 30
            color: Theme.backgroundColor
            border.color: Theme.primaryColor
            radius: 5

            Text {
                anchors.centerIn: parent
                text: value
                font.pixelSize: fontSize
                color: valueColor
                font.bold: true
            }
        }
    }
}
