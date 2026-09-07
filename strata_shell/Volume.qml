import QtQuick
import Quickshell
import Quickshell.Io

BarModule {
    id: root

    property bool muted: false
    property int volume: 0

    // Flash volume % briefly on change
    property bool flash: false
    onVolumeChanged: { flash = true; flashTimer.restart() }
    onMutedChanged: { flash = true; flashTimer.restart() }
    Timer {
        id: flashTimer
        interval: 1500
        onTriggered: root.flash = false
    }

    icon: muted ? "󰝟" : volume < 25 ? "󰕿" : volume < 65 ? "󰖀" : "󰕾"
    iconColor: muted ? Qt.alpha(Theme.fg, 0.45) : Theme.green
    active: popup.visible
    label: ""

    Component.onCompleted: queryProc.running = true

    Timer {
        id: updateTimer
        interval: 50
        onTriggered: {
            queryProc.running = false
            queryProc.running = true
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: updateTimer.restart()
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
                    updateTimer.restart()
            }
        }
    }

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) {
            Quickshell.execDetached(["pavucontrol"])
        } else {
            popup.toggle()
        }
    }

    onScrolled: dir => {
        Sys.suppressVolumeOSD(1500)
        const delta = dir > 0 ? "+2%" : "-2%"
        Quickshell.execDetached(["pactl", "set-sink-volume", "@DEFAULT_SINK@", delta])
        updateTimer.restart()
    }

    VolumePopup {
        id: popup
        anchorItem: root
    }
}
