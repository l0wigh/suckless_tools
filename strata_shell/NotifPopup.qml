import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

Popout {
    id: root

    cardWidth: 340
    cardHeight: 380

    function age(d) {
        if (!d) return ""
        const s = Math.max(0, Math.round((Date.now() - d.getTime()) / 1000))
        if (s < 60) return "just now"
        const m = Math.floor(s / 60)
        if (m < 60) return m + "m"
        const h = Math.floor(m / 60)
        return h + "h"
    }

    Column {
        anchors.fill: parent
        spacing: 8

        // ================= Header =================
        Item {
            width: parent.width
            height: 28

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Notifications"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.cardTitleSize
                    font.bold: true
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Notifs.count > 0
                    text: "(" + Notifs.count + ")"
                    color: Theme.accent
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.cardTextSize
                    font.bold: true
                }
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: Notifs.count > 0
                text: "Clear all"
                color: clearAllMa.containsMouse ? Theme.red : Qt.alpha(Theme.fg, 0.5)
                font.family: Theme.fontFamily
                font.pixelSize: Theme.cardSmallSize + 1

                MouseArea {
                    id: clearAllMa
                    anchors.fill: parent
                    anchors.margins: -4
                    hoverEnabled: true
                    onClicked: Notifs.clearAll()
                }
            }
        }

        // ================= Notifications List =================
        ListView {
            id: notifList
            width: parent.width
            height: parent.height - 34
            clip: true
            model: Notifs.list
            spacing: 6
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                id: card
                required property var modelData

                readonly property color urgencyColor: card.modelData.urgency === NotificationUrgency.Critical ? Theme.red
                                                    : card.modelData.urgency === NotificationUrgency.Low ? Qt.alpha(Theme.fg, 0.4)
                                                    : Theme.accent

                width: notifList.width
                height: Math.max(56, contentCol.implicitHeight + 16)
                radius: 6
                color: Qt.alpha(Theme.fg, itemMouse.containsMouse ? 0.09 : 0.05)
                border.width: 1
                border.color: card.modelData.urgency === NotificationUrgency.Critical ? Qt.alpha(Theme.red, 0.4)
                            : Qt.alpha(Theme.fg, 0.1)
                Behavior on color { ColorAnimation { duration: 100 } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 8
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter

                    IconImage {
                        visible: card.modelData.appIcon !== ""
                        anchors.verticalCenter: parent.verticalCenter
                        source: Quickshell.iconPath(card.modelData.appIcon, "dialog-information")
                        implicitSize: 24
                    }

                    Column {
                        id: contentCol
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - (card.modelData.appIcon !== "" ? 32 : 0) - 24
                        spacing: 3

                        Item {
                            width: parent.width
                            height: 16

                            Row {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 6
                                width: parent.width - 50

                                // App name chip
                                Rectangle {
                                    visible: card.modelData.appName !== ""
                                    height: 15
                                    width: appChipText.implicitWidth + 6
                                    radius: 3
                                    color: Qt.alpha(card.urgencyColor, 0.15)
                                    anchors.verticalCenter: parent.verticalCenter

                                    Text {
                                        id: appChipText
                                        anchors.centerIn: parent
                                        text: card.modelData.appName
                                        color: card.urgencyColor
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 10
                                        font.bold: true
                                    }
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: card.modelData.summary
                                    color: Theme.fg
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.cardTextSize
                                    font.bold: true
                                    elide: Text.ElideRight
                                    width: parent.width - (card.modelData.appName !== "" ? appChipText.implicitWidth + 12 : 0)
                                }
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.age(card.modelData.time)
                                color: Qt.alpha(Theme.fg, 0.4)
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.cardSmallSize
                            }
                        }

                        Text {
                            width: parent.width
                            visible: text !== ""
                            text: card.modelData.body
                            color: Qt.alpha(Theme.fg, 0.65)
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.cardSmallSize + 1
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "󰅖"
                        color: disMa.containsMouse ? Theme.red : Qt.alpha(Theme.fg, 0.4)
                        font.family: Theme.iconFontFamily
                        font.pixelSize: 13

                        MouseArea {
                            id: disMa
                            anchors.fill: parent
                            anchors.margins: -4
                            hoverEnabled: true
                            onClicked: Notifs.dismiss(card.modelData)
                        }
                    }
                }

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Notifs.dismiss(card.modelData)
                }
            }

            // Empty state
            Column {
                anchors.centerIn: parent
                visible: Notifs.count === 0
                spacing: 6

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "󰂚"
                    color: Qt.alpha(Theme.fg, 0.25)
                    font.family: Theme.iconFontFamily
                    font.pixelSize: 32
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "No notifications"
                    color: Qt.alpha(Theme.fg, 0.4)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.cardTextSize
                }
            }
        }
    }
}
