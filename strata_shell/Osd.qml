import QtQuick
import Quickshell
import Quickshell.X11
import Quickshell.Io

XPanelWindow {
    id: root
    property var modelData
    screen: modelData

    anchors {
        bottom: true
    }
    margins {
        bottom: 80
    }

    implicitWidth: 240
    implicitHeight: 54
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: false
    visible: osdOpacity > 0

    property real osdOpacity: 0
    property string osdIcon: "󰕾"
    property int osdValue: 0
    property bool osdMuted: false
    property string osdLabel: "Volume"
    property string osdSubText: ""
    property bool hasProgressBar: true
    property color osdIconColor: Theme.accent

    Behavior on osdOpacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    Timer {
        id: hideTimer
        interval: 1800
        onTriggered: root.osdOpacity = 0
    }

    function showOsd(icon, val, label, isMuted, subText, showBar, iconColor) {
        root.osdIcon = icon
        root.osdValue = val ?? 0
        root.osdLabel = label
        root.osdMuted = isMuted ?? false
        root.osdSubText = subText ?? ""
        root.hasProgressBar = showBar !== undefined ? showBar : true
        root.osdIconColor = iconColor ? iconColor : (root.osdMuted ? Theme.red : Theme.accent)
        root.osdOpacity = 1
        hideTimer.restart()
    }

    // PulseAudio Volume watcher for OSD
    property int _lastVol: -1
    property bool _lastMuted: false
    property bool _initDone: false

    Process {
        id: volProc
        command: ["sh", "-c", "LC_ALL=C pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null; LC_ALL=C pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | head -1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                if (lines.length >= 2) {
                    const isMuted = lines[0].toLowerCase().indexOf("yes") !== -1
                    const m = lines[1].match(/(\d+)%/)
                    if (m) {
                        const v = parseInt(m[1])
                        if (root._initDone && (v !== root._lastVol || isMuted !== root._lastMuted)) {
                            const icon = isMuted ? "󰝟" : v < 25 ? "󰕿" : v < 65 ? "󰖀" : "󰕾"
                            root.showOsd(icon, v, isMuted ? "Muted" : "Volume", isMuted)
                        }
                        root._lastVol = v
                        root._lastMuted = isMuted
                        root._initDone = true
                    }
                }
            }
        }
    }

    Timer {
        id: pollVolTimer
        interval: 60
        onTriggered: {
            volProc.running = false
            volProc.running = true
        }
    }

    Process {
        id: subProc
        command: ["sh", "-c", "LC_ALL=C pactl subscribe"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (line.indexOf("sink") !== -1 || line.indexOf("destination") !== -1)
                    pollVolTimer.restart()
            }
        }
    }

    // Backlight watcher for OSD
    property int _lastBri: -1
    property bool _briInitDone: false

    Process {
        id: briProc
        command: ["sh", "-c", "brightnessctl -m -c backlight 2>/dev/null | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(",")
                if (parts.length >= 4) {
                    const m = parts[3].match(/(\d+)%/)
                    if (m) {
                        const v = parseInt(m[1])
                        if (root._briInitDone && v !== root._lastBri) {
                            const icon = v < 30 ? "󰃞" : v < 70 ? "󰃟" : "󰃠"
                            root.showOsd(icon, v, "Brightness", false)
                        }
                        root._lastBri = v
                        root._briInitDone = true
                    }
                }
            }
        }
    }

    Timer {
        id: pollBriTimer
        interval: 50
        onTriggered: {
            briProc.running = false
            briProc.running = true
        }
    }

    Process {
        id: briSubProc
        command: ["sh", "-c", "udevadm monitor -s backlight -u"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (line.indexOf("backlight") !== -1)
                    pollBriTimer.restart()
            }
        }
    }

    // Wi-Fi watcher for OSD
    property bool _wifiBlocked: false
    property string _wifiState: ""
    property string _wifiSsid: ""
    property bool _wifiInitDone: false

    Process {
        id: wifiProc
        command: ["sh", "-c",
            "blocked=$(rfkill list wifi 2>/dev/null | grep -q 'blocked: yes' && echo 1 || echo 0); " +
            "st=$(wpa_cli status 2>/dev/null); " +
            "state=$(echo \"$st\" | awk -F= '/^wpa_state=/{print $2}'); " +
            "ssid=$(echo \"$st\" | awk -F= '/^ssid=/{print $2}'); " +
            "echo \"$blocked|$state|$ssid\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split("|")
                if (parts.length >= 3) {
                    const blocked = parts[0] === "1"
                    const state = parts[1]
                    const ssid = parts.slice(2).join("|")

                    if (root._wifiInitDone) {
                        if (blocked !== root._wifiBlocked) {
                            if (blocked) {
                                root.showOsd("󰤮", 0, "Wi-Fi", true, "Disabled", false, Theme.red)
                            } else if (state === "COMPLETED" && ssid !== "") {
                                root.showOsd("󰤨", 0, "Wi-Fi", false, ssid, false, Theme.accent)
                            } else {
                                root.showOsd("󰤭", 0, "Wi-Fi", false, "Enabled", false, Theme.disabled)
                            }
                        } else if (state !== root._wifiState || ssid !== root._wifiSsid) {
                            if (state === "COMPLETED" && ssid !== "") {
                                root.showOsd("󰤨", 0, "Wi-Fi", false, ssid, false, Theme.accent)
                            } else if (root._wifiState === "COMPLETED" && state !== "COMPLETED") {
                                root.showOsd("󰤭", 0, "Wi-Fi", false, "Disconnected", false, Theme.disabled)
                            }
                        }
                    }

                    root._wifiBlocked = blocked
                    root._wifiState = state
                    root._wifiSsid = ssid
                    root._wifiInitDone = true
                }
            }
        }
    }

    Timer {
        id: pollWifiTimer
        interval: 100
        onTriggered: {
            wifiProc.running = false
            wifiProc.running = true
        }
    }

    Process {
        id: wifiSubProc
        command: ["sh", "-c", "trap 'kill 0' EXIT; rfkill event 2>/dev/null & tail -f /dev/null | wpa_cli 2>/dev/null"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                pollWifiTimer.restart()
            }
        }
    }

    Timer {
        interval: 8000
        running: true
        repeat: true
        onTriggered: pollWifiTimer.restart()
    }

    // Battery watcher for OSD
    property bool _batInitDone: false
    property bool _batLowWarned: false
    property bool _batHighWarned: false

    Connections {
        target: Sys
        function onBatteryChanged() {
            root.checkBattery()
        }
        function onBatteryChargingChanged() {
            root.checkBattery()
        }
    }

    function checkBattery() {
        if (!Sys.hasBattery || Sys.battery <= 0) return

        if (!root._batInitDone) {
            root._batLowWarned = Sys.battery <= 30
            root._batHighWarned = Sys.battery >= 80
            root._batInitDone = true
            return
        }

        const pct = Math.round(Sys.battery)

        // Low battery alert (discharging <= 30%)
        if (!Sys.batteryCharging && pct <= 30) {
            if (!root._batLowWarned) {
                root._batLowWarned = true
                root.showOsd("󰂃", pct, "Battery Low", true, "", true, Theme.red)
            }
        } else if (pct > 35 || Sys.batteryCharging) {
            root._batLowWarned = false
        }

        // High battery alert (charging >= 80%)
        if (Sys.batteryCharging && pct >= 80) {
            if (!root._batHighWarned) {
                root._batHighWarned = true
                root.showOsd("󰂅", pct, "Battery Charged", false, "", true, Theme.green)
            }
        } else if (pct < 75 || !Sys.batteryCharging) {
            root._batHighWarned = false
        }
    }

    Component.onCompleted: {
        volProc.running = true
        briProc.running = true
        wifiProc.running = true
    }

    // OSD Card
    Rectangle {
        anchors.fill: parent
        radius: 14
        color: Theme.bg
        border.width: 0

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: root.osdIcon
                color: root.osdIconColor
                font.family: Theme.iconFontFamily
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 36
                spacing: root.hasProgressBar ? 6 : 4

                Item {
                    width: parent.width
                    height: 14

                    Text {
                        anchors.left: parent.left
                        text: root.osdLabel
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: 11
                        font.bold: true
                    }

                    Text {
                        anchors.right: parent.right
                        visible: root.hasProgressBar
                        text: root.osdMuted ? "0%" : root.osdValue + "%"
                        color: root.osdIconColor
                        font.family: Theme.fontFamily
                        font.pixelSize: 11
                        font.bold: true
                    }
                }

                Rectangle {
                    visible: root.hasProgressBar
                    width: parent.width
                    height: 6
                    radius: 3
                    color: Qt.alpha(Theme.fg, 0.15)

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * Math.min(1, Math.max(0, root.osdMuted ? 0 : root.osdValue / 100))
                        radius: 3
                        color: root.osdIconColor
                        Behavior on width { NumberAnimation { duration: 100 } }
                    }
                }

                Text {
                    visible: !root.hasProgressBar
                    width: parent.width
                    text: root.osdSubText
                    color: Theme.disabled
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }
            }
        }
    }
}
