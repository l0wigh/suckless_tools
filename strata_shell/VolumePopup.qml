import QtQuick
import Quickshell
import Quickshell.Io

Popout {
    id: root

    cardWidth: 72
    cardHeight: 200

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
        Sys.suppressVolumeOSD(1500)
        pct = Math.max(0, Math.min(100, Math.round(pct)))
        root.volume = pct
        Quickshell.execDetached(["pactl", "set-sink-volume", "@DEFAULT_SINK@", pct + "%"])
    }

    function toggleMute() {
        Sys.suppressVolumeOSD(1500)
        Quickshell.execDetached(["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"])
        refreshTimer.restart()
    }

    Column {
        anchors.fill: parent
        spacing: 12

        Text {
            text: root.muted ? "Muted" : root.volume + "%"
            color: root.muted ? Theme.red : Theme.accent
            font.family: Theme.fontFamily
            font.pixelSize: Theme.cardTextSize + 1
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            width: parent.width
            height: parent.height - 36

            // Sleek OSD-style Vertical Slider Track (10px thickness)
            Rectangle {
                id: track
                width: 10
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                radius: 5
                color: Qt.alpha(Theme.fg, 0.12)
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    id: fillBar
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: Math.min(parent.height, Math.max(0, parent.height * (root.volume / 100)))
                    radius: 5
                    color: root.muted ? Qt.alpha(Theme.fg, 0.3) : Theme.accent
                    Behavior on height {
                        enabled: !dragArea.pressed
                        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                    }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    anchors.margins: -16

                    function updateFromMouse(mouse) {
                        const localY = mapToItem(track, mouse.x, mouse.y).y
                        const frac = Math.max(0, Math.min(1, 1 - (localY / track.height)))
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
}
