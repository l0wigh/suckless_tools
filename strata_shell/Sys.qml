pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Lightweight system metrics: cpu/mem/disk on a 3s tick, network on 10s.
Singleton {
    id: root

    property real cpu: 0
    property real mem: 0
    property real disk: 0
    property bool hasBattery: false
    property real battery: 0
    property bool batteryCharging: false
    property string netName: ""
    property string netType: ""
    property bool vpnOn: false
    property string vpnName: ""

    readonly property string netIcon: vpnOn ? "󰦝"
                                    : netType.indexOf("wireless") !== -1 ? "󰤨"
                                    : netType.indexOf("ethernet") !== -1 ? "󰈀"
                                    : "󰤭"
    readonly property bool online: netName !== ""

    readonly property string batteryIcon: {
        const b = battery
        if (batteryCharging) {
            if (b >= 95) return "󰂅"
            if (b >= 85) return "󰂋"
            if (b >= 75) return "󰂊"
            if (b >= 65) return "󰢞"
            if (b >= 55) return "󰂉"
            if (b >= 45) return "󰢝"
            if (b >= 35) return "󰂈"
            if (b >= 25) return "󰂇"
            if (b >= 15) return "󰂆"
            if (b >= 10) return "󰢜"
            return "󰢟"
        } else {
            if (b >= 95) return "󰁹"
            if (b >= 85) return "󰂂"
            if (b >= 75) return "󰂁"
            if (b >= 65) return "󰂀"
            if (b >= 55) return "󰁿"
            if (b >= 45) return "󰁾"
            if (b >= 35) return "󰁽"
            if (b >= 25) return "󰁼"
            if (b >= 15) return "󰁻"
            return "󰁺"
        }
    }

    property var _prev: ({ idle: 0, total: 0 })

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statProc.running = true
    }

    Process {
        id: statProc
        command: ["sh", "-c",
            "head -1 /proc/stat; grep -E '^(MemTotal|MemAvailable)' /proc/meminfo; df --output=pcent / | tail -1; " +
            "for b in /sys/class/power_supply/BAT*; do [ -r \"$b/capacity\" ] && echo \"BAT $(cat \"$b/capacity\") $(cat \"$b/status\")\" && break; done; true"]
        stdout: StdioCollector {
            onStreamFinished: root.parseStat(text)
        }
    }

    function parseStat(t) {
        const lines = t.trim().split("\n")
        let memTotal = 0, memAvail = 0, foundBattery = false
        for (const line of lines) {
            if (line.startsWith("cpu ")) {
                const f = line.trim().split(/\s+/).slice(1).map(Number)
                const idle = f[3] + (f[4] || 0)
                const total = f.reduce((a, b) => a + b, 0)
                const dIdle = idle - _prev.idle
                const dTotal = total - _prev.total
                if (_prev.total > 0 && dTotal > 0)
                    cpu = Math.max(0, Math.min(100, 100 * (1 - dIdle / dTotal)))
                _prev = { idle: idle, total: total }
            } else if (line.startsWith("MemTotal:")) {
                memTotal = parseInt(line.split(/\s+/)[1])
            } else if (line.startsWith("MemAvailable:")) {
                memAvail = parseInt(line.split(/\s+/)[1])
            } else if (line.startsWith("BAT ")) {
                const parts = line.split(/\s+/)
                foundBattery = true
                battery = parseInt(parts[1])
                batteryCharging = parts[2] === "Charging"
            } else if (line.indexOf("%") !== -1) {
                disk = parseInt(line)
            }
        }
        if (memTotal > 0)
            mem = 100 * (1 - memAvail / memTotal)
        hasBattery = foundBattery
    }

    property bool capsOn: false
    property bool dndOn: false
    property bool micMuted: false
    property bool composited: true
    property double suppressVolumeUntil: 0
    property double suppressBrightnessUntil: 0

    function suppressVolumeOSD(ms) {
        suppressVolumeUntil = Date.now() + (ms || 1500)
    }

    function suppressBrightnessOSD(ms) {
        suppressBrightnessUntil = Date.now() + (ms || 1500)
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: capsProc.running = true
    }

    // one process per tick covers the indicators: caps lock +
    // default-source mute + compositor status
    Process {
        id: capsProc
        command: ["sh", "-c", "xset q | awk '/Caps Lock/{print $4}'; " +
            "pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null; " +
            "pgrep -x picom >/dev/null && echo comp || echo nocomp"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                root.capsOn = lines[0] === "on"
                root.micMuted = lines[1] === "Mute: yes"
                root.composited = lines[2] !== "nocomp"
            }
        }
    }

    // fast re-poll so the icon settles right after a toggle instead of
    // waiting out (or fighting) the 1s tick
    Timer {
        id: dndRefresh
        interval: 300
        onTriggered: capsProc.running = true
    }

    function toggleMicMute() {
        Quickshell.execDetached(["pactl", "set-source-mute",
                                 "@DEFAULT_SOURCE@", "toggle"])
        micMuted = !micMuted
        dndRefresh.restart()
    }

    function toggleDnd() {
        dndOn = !dndOn
    }
    function popNotification() {
        // replaying must always show something: leave DND first, and say so
        // when the history is empty instead of silently doing nothing
        Quickshell.execDetached(["sh", "-c",
            "dunstctl set-paused false; " +
            "if [ \"$(dunstctl count history)\" -eq 0 ]; then " +
            "notify-send -a dunst -t 2000 'Notifications' 'History is empty'; " +
            "else dunstctl history-pop; fi"])
        dndRefresh.restart()
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netProc.running = true
    }

    // primary transport + vpn tracked separately: a vpn/wireguard/tun
    // connection rides ON a transport, it isn't one
    Process {
        id: netProc
        command: ["sh", "-c",
            "vpn=''; for iface in /sys/class/net/tun* /sys/class/net/wg* /sys/class/net/vpn*; do [ -e \"$iface\" ] && vpn=$(basename \"$iface\") && break; done; " +
            "eth=''; for iface in /sys/class/net/en* /sys/class/net/eth*; do [ -e \"$iface/carrier\" ] && [ \"$(cat \"$iface/carrier\" 2>/dev/null)\" = '1' ] && eth=$(basename \"$iface\") && break; done; " +
            "wifi=''; wpa_st=$(wpa_cli status 2>/dev/null); if echo \"$wpa_st\" | grep -q 'wpa_state=COMPLETED'; then wifi=$(echo \"$wpa_st\" | awk -F= '/^ssid=/{print $2}'); fi; " +
            "echo \"VPN:$vpn\"; echo \"ETH:$eth\"; echo \"WIFI:$wifi\""]
        stdout: StdioCollector {
            onStreamFinished: {
                let name = "", type = "", vName = "", vOn = false
                for (const line of text.trim().split("\n")) {
                    if (line.startsWith("VPN:")) {
                        const v = line.slice(4).trim()
                        if (v !== "") { vOn = true; vName = v }
                    } else if (line.startsWith("ETH:")) {
                        const e = line.slice(4).trim()
                        if (e !== "") { name = e; type = "ethernet" }
                    } else if (line.startsWith("WIFI:")) {
                        const w = line.slice(5).trim()
                        if (w !== "") { name = w; type = "wireless" }
                    }
                }
                root.netName = name
                root.netType = type
                root.vpnOn = vOn
                root.vpnName = vName
            }
        }
    }
}
