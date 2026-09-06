import QtQuick
import Quickshell

Popout {
    id: root

    cardWidth: 260
    cardHeight: 100

    Column {
        anchors.fill: parent
        spacing: 12

        // Top row: icon + title + percentage
        Item {
            width: parent.width
            height: 24

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    text: Sys.batteryCharging ? "󰂄" : (Sys.battery < 20 ? "󰁺" : "󰁹")
                    color: Sys.batteryCharging ? Theme.green : (Sys.battery < 20 ? Theme.red : Theme.accent)
                    font.family: Theme.iconFontFamily
                    font.pixelSize: Theme.cardIconSize + 1
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "Battery"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.cardTitleSize
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round(Sys.battery) + "%"
                color: Sys.batteryCharging ? Theme.green : (Sys.battery < 20 ? Theme.red : Theme.accent)
                font.family: Theme.fontFamily
                font.pixelSize: Theme.cardTextSize + 1
                font.bold: true
            }
        }

        // Progress bar
        Rectangle {
            width: parent.width
            height: 10
            radius: 5
            color: Qt.alpha(Theme.fg, 0.12)

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.min(parent.width, Math.max(0, parent.width * (Sys.battery / 100)))
                radius: 5
                color: Sys.batteryCharging ? Theme.green : (Sys.battery < 20 ? Theme.red : Theme.accent)
                Behavior on width { NumberAnimation { duration: 300 } }
            }
        }

        // Status text
        Text {
            text: Sys.batteryCharging ? "Charging" : "On battery"
            color: Qt.alpha(Theme.fg, 0.6)
            font.family: Theme.fontFamily
            font.pixelSize: 11
        }
    }
}
