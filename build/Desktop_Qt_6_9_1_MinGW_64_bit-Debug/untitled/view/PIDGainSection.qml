// PIDGainSection.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: parent.width
    height: 90
    color: Theme.surfaceColor
    border.color: Theme.borderColor
    radius: 5

    property string title: ""
    property int kpValue: 0
    property int kiValue: 0
    property bool enabled: true

    signal kpChanged(int value)
    signal kiChanged(int value)

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Text {
            text: root.title
            font.pixelSize: 12
            font.bold: true
            color: Theme.textColor
        }

        RowLayout {
            width: parent.width
            spacing: 10

            Column {
                Text {
                    text: "Kp:"
                    font.pixelSize: 10
                    color: Theme.textColor
                }
                TextField {
                    width: 80
                    height: 30
                    text: root.kpValue.toString()
                    enabled: root.enabled
                    color: Theme.textColor
                    placeholderText: "Enter value"
                    placeholderTextColor: "#888888"
                    selectByMouse: true

                    background: Rectangle {
                        color: Theme.backgroundColor
                        border.color: Theme.borderColor
                        border.width: 1
                        radius: 3
                    }

                    validator: IntValidator {
                        bottom: -2147483648
                        top: 2147483647
                    }

                    onTextChanged: {
                        var value = parseInt(text)
                        if (!isNaN(value)) {
                            root.kpChanged(value)
                        }
                    }

                    onEditingFinished: {
                        text = root.kpValue.toString()
                    }
                }
            }

            Column {
                Text {
                    text: "Ki:"
                    font.pixelSize: 10
                    color: Theme.textColor
                }
                TextField {
                    width: 80
                    height: 30
                    text: root.kiValue.toString()
                    enabled: root.enabled
                    color: Theme.textColor
                    placeholderText: "Enter value"
                    placeholderTextColor: "#888888"
                    selectByMouse: true

                    background: Rectangle {
                        color: Theme.backgroundColor
                        border.color: Theme.borderColor
                        border.width: 1
                        radius: 3
                    }

                    validator: IntValidator {
                        bottom: -2147483648
                        top: 2147483647
                    }

                    onTextChanged: {
                        var value = parseInt(text)
                        if (!isNaN(value)) {
                            root.kiChanged(value)
                        }
                    }

                    onEditingFinished: {
                        text = root.kiValue.toString()
                    }
                }
            }
        }
    }
}
