import QtQuick
import Quickshell

Popout {
    id: root

    cardWidth: 72
    cardHeight: 200

    Column {
        anchors.fill: parent
        spacing: 12

        Text {
            text: Math.round(Sys.battery) + "%"
            color: Sys.batteryCharging ? Theme.green : (Sys.battery < 20 ? Theme.red : Theme.accent)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.cardTextSize + 1
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            width: parent.width
            height: parent.height - 36

            // Sleek OSD-style Vertical Progress Bar (10px thickness)
            Rectangle {
                width: 10
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                radius: 5
                color: Qt.alpha(Theme.fg, 0.12)
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: Math.min(parent.height, Math.max(0, parent.height * (Sys.battery / 100)))
                    radius: 5
                    color: Sys.batteryCharging ? Theme.green : (Sys.battery < 20 ? Theme.red : Theme.accent)
                    Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                }
            }
        }
    }
}
