import QtQuick
import Quickshell
import Quickshell.Io

Popout {
    id: root

    cardWidth: 280
    cardHeight: 100

    property int volume: 0
    property bool muted: false

    onVisibleChanged: {
        if (visible)
            queryProc.running = true
    }

    Timer {
        id: refreshTimer
        interval: 50
        onTriggered: {
            queryProc.running = false
            queryProc.running = true
        }
    }

    Process {
        id: queryProc
        command: ["sh", "-c", "LC_ALL=C pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null; LC_ALL=C pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | head -1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                if (lines.length >= 2) {
                    root.muted = lines[0].toLowerCase().indexOf("yes") !== -1
                    const m = lines[1].match(/(\d+)%/)
                    if (m)
                        root.volume = parseInt(m[1])
                }
            }
        }
    }

    Process {
        id: subProc
        command: ["sh", "-c", "LC_ALL=C pactl subscribe"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (line.indexOf("sink") !== -1 || line.indexOf("server") !== -1 || line.indexOf("destination") !== -1)
                    refreshTimer.restart()
            }
        }
    }

    function setVolume(pct) {
        pct = Math.max(0, Math.min(100, Math.round(pct)))
        root.volume = pct
        Quickshell.execDetached(["pactl", "set-sink-volume", "@DEFAULT_SINK@", pct + "%"])
    }

    function toggleMute() {
        Quickshell.execDetached(["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"])
        refreshTimer.restart()
    }

    Column {
        anchors.fill: parent
        spacing: 12

        // Top row
        Item {
            width: parent.width
            height: 24

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                // Mute button
                Text {
                    text: root.muted ? "󰝟" : root.volume < 25 ? "󰕿" : root.volume < 65 ? "󰖀" : "󰕾"
                    color: root.muted ? Theme.red : Theme.accent
                    font.family: Theme.iconFontFamily
                    font.pixelSize: Theme.cardIconSize + 1
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        onClicked: root.toggleMute()
                    }
                }

                Text {
                    text: "Volume"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.cardTitleSize
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Text {
                    text: root.muted ? "Muted" : root.volume + "%"
                    color: root.muted ? Theme.disabled : Theme.accent
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.cardTextSize + 1
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "󰒓"
                    color: Theme.secondary
                    font.family: Theme.iconFontFamily
                    font.pixelSize: Theme.cardIconSize
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        onClicked: Quickshell.execDetached(["pavucontrol"])
                    }
                }
            }
        }

        // Slider track
        Rectangle {
            id: track
            width: parent.width
            height: 12
            radius: 6
            color: Qt.alpha(Theme.fg, 0.12)

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.min(parent.width, Math.max(0, parent.width * (root.volume / 100)))
                radius: 6
                color: root.muted ? Qt.alpha(Theme.fg, 0.3) : Theme.accent
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            // Grabber handle
            Rectangle {
                x: Math.min(track.width - width, Math.max(0, (track.width * (root.volume / 100)) - width / 2))
                anchors.verticalCenter: parent.verticalCenter
                width: 16
                height: 16
                radius: 8
                color: Theme.fg
                border.width: 2
                border.color: Theme.bg
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6

                function updateFromMouse(mouse) {
                    const frac = Math.max(0, Math.min(1, mouse.x / track.width))
                    root.setVolume(frac * 100)
                }

                onPressed: mouse => updateFromMouse(mouse)
                onPositionChanged: mouse => {
                    if (pressed) updateFromMouse(mouse)
                }
            }
        }
    }
}
