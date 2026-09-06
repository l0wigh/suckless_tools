import QtQuick
import Quickshell

Popout {
    id: root

    cardWidth: 260
    cardHeight: col.implicitHeight + 2 * cardPadding

    readonly property bool hasPads: Wm.scratchpads !== ""
    readonly property bool isShown: Wm.scratchpads.indexOf("[") !== -1
    readonly property string cleanKeys: Wm.scratchpads.replace(/[\[\]\s]/g, "")

    // Split scratchpad tokens from Fluorite e.g. "[k] " or "k s "
    readonly property var tokens: {
        if (!hasPads) return []
        return Wm.scratchpads.trim().split(/\s+/).filter(t => t.length > 0)
    }

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 12

        // Header
        Item {
            width: parent.width
            height: 24

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    text: "󰖮"
                    color: root.hasPads ? Theme.accent : Qt.alpha(Theme.fg, 0.45)
                    font.family: Theme.iconFontFamily
                    font.pixelSize: Theme.cardIconSize + 2
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "Scratchpads"
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
                text: root.hasPads ? (root.tokens.length + " active") : "None"
                color: root.hasPads ? Theme.accent : Qt.alpha(Theme.fg, 0.45)
                font.family: Theme.fontFamily
                font.pixelSize: Theme.cardSmallSize
                font.bold: true
            }
        }

        // Empty state
        Rectangle {
            visible: !root.hasPads
            width: parent.width
            height: 48
            radius: 6
            color: Qt.alpha(Theme.fg, 0.04)

            Text {
                anchors.centerIn: parent
                text: "No scratchpad attached"
                color: Qt.alpha(Theme.fg, 0.5)
                font.family: Theme.fontFamily
                font.pixelSize: Theme.cardTextSize
            }
        }

        // Active scratchpad keys list
        Column {
            visible: root.hasPads
            width: parent.width
            spacing: 6

            Repeater {
                model: root.tokens

                delegate: Rectangle {
                    id: keyItem
                    required property string modelData

                    readonly property bool padShown: modelData.indexOf("[") !== -1
                    readonly property string padKey: modelData.replace(/[\[\]]/g, "")

                    width: parent.width
                    height: 42
                    radius: 6
                    color: padShown ? Qt.alpha(Theme.primary, 0.12) : Qt.alpha(Theme.fg, 0.05)
                    border.width: 1
                    border.color: padShown ? Qt.alpha(Theme.primary, 0.5) : Qt.alpha(Theme.fg, 0.12)

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 10

                        // Keyboard key badge
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 28
                            height: 28
                            radius: 5
                            color: Theme.bg
                            border.width: 1
                            border.color: keyItem.padShown ? Theme.primary : Qt.alpha(Theme.fg, 0.3)

                            Text {
                                anchors.centerIn: parent
                                text: keyItem.padKey.toUpperCase()
                                color: keyItem.padShown ? Theme.primary : Theme.fg
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.bold: true
                            }
                        }

                        // State label
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: keyItem.padShown ? "Shown" : "Hidden"
                            color: keyItem.padShown ? Theme.green : Theme.yellow
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.cardTextSize
                            font.bold: true
                        }

                        Item {
                            width: 1
                            height: 1
                            // spacer
                        }

                        // State dot on right
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 8
                            height: 8
                            radius: 4
                            color: keyItem.padShown ? Theme.green : Theme.yellow
                        }
                    }
                }
            }
        }


    }
}
