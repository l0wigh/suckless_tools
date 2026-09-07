import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.X11
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Services.Mpris

XPanelWindow {
    id: root
    property var modelData
    screen: modelData

    anchors {
        top: true
    }
    margins {
        top: Config.enableFrameBars ? Config.topBarHeight : 0
    }

    implicitWidth: 272
    implicitHeight: root.hasProgressBar ? 82 : 62
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: false
    property bool osdVisible: false
    property bool osdMuted: false
    property string osdLabel: "Volume"
    property string osdSubText: ""
    property bool hasProgressBar: true
    property color osdIconColor: Theme.accent
    property string osdImage: ""

    Timer {
        id: hideTimer
        interval: 1800
        onTriggered: root.osdVisible = false
    }

    function showOsd(icon, val, label, isMuted, subText, showBar, iconColor, durationMs, imageUrl) {
        root.osdIcon = icon
        root.osdValue = val ?? 0
        root.osdLabel = label
        root.osdMuted = isMuted ?? false
        root.osdSubText = subText ?? ""
        root.hasProgressBar = showBar !== undefined ? showBar : true
        root.osdIconColor = iconColor ? iconColor : (root.osdMuted ? Theme.red : Theme.accent)
        root.osdImage = imageUrl ?? ""
        root.osdVisible = true
        hideTimer.interval = durationMs ?? 1800
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
                            if (Date.now() > Sys.suppressVolumeUntil) {
                                const icon = isMuted ? "󰝟" : v < 25 ? "󰕿" : v < 65 ? "󰖀" : "󰕾"
                                root.showOsd(icon, v, isMuted ? "Muted" : "Volume", isMuted)
                            }
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
    property bool _lastCharging: false

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
            root._lastCharging = Sys.batteryCharging
            root._batInitDone = true
            return
        }

        const pct = Math.round(Sys.battery)

        // Affichage OSD au changement d'état du secteur (branché / débranché)
        if (Sys.batteryCharging !== root._lastCharging) {
            root._lastCharging = Sys.batteryCharging
            const icon = Sys.batteryIcon
            const label = Sys.batteryCharging ? "Charging" : "Discharging"
            const color = Sys.batteryCharging ? Theme.green : Theme.accent
            root.showOsd(icon, pct, label, false, "", true, color)
        }

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

    // Notifications watcher for OSD
    Connections {
        target: Notifs
        function onNotificationArrived(item) {
            if (!item || Sys.dndOn) return

            const isCrit = item.urgency === NotificationUrgency.Critical
            const icon = isCrit ? "󰵚" : "󰂚"
            const color = isCrit ? Theme.red : Theme.accent

            // Clean body: remove newlines, tags, collapse spaces
            let bodyText = (item.body || "").replace(/<[^>]*>/g, "").replace(/\s+/g, " ").trim()
            if (bodyText.length > 45)
                bodyText = bodyText.slice(0, 42) + "…"

            let titleText = (item.summary || item.appName || "Notification").trim()
            if (titleText.length > 30)
                titleText = titleText.slice(0, 27) + "…"

            root.showOsd(icon, 0, titleText, isCrit, bodyText, false, color, 3500)
        }
    }

    // Media track change watcher for OSD
    readonly property var activePlayer: {
        const ps = Mpris.players.values
        for (let i = 0; i < ps.length; i++)
            if (ps[i].playbackState === MprisPlaybackState.Playing)
                return ps[i]
        return null
    }

    property string _lastTrackKey: ""
    property bool _mediaInitDone: false

    Connections {
        target: root.activePlayer
        function onTrackTitleChanged() {
            root.checkTrackChange()
        }
        function onPlaybackStateChanged() {
            root.checkTrackChange()
        }
    }

    onActivePlayerChanged: checkTrackChange()

    function checkTrackChange() {
        const p = root.activePlayer
        if (!p || p.playbackState !== MprisPlaybackState.Playing) return
        const title = (p.trackTitle || "").trim()
        if (!title) return

        let artist = ""
        if (p.trackArtists && p.trackArtists.length > 0)
            artist = Array.isArray(p.trackArtists) ? p.trackArtists.join(", ") : String(p.trackArtists)
        else if (p.trackAlbum)
            artist = p.trackAlbum

        const key = title + " - " + artist

        if (!root._mediaInitDone) {
            root._lastTrackKey = key
            root._mediaInitDone = true
            return
        }

        if (key !== root._lastTrackKey) {
            root._lastTrackKey = key
            const art = p.trackArtUrl || ""
            root.showOsd("󰝚", 0, title, false, artist, false, Theme.magenta, 3500, art)
        }
    }

    Component.onCompleted: {
        volProc.running = true
        briProc.running = true
        wifiProc.running = true
    }

    property string osdIcon: "󰕾"
    property int osdValue: 0
    readonly property int targetHeight: root.hasProgressBar ? 82 : 62

    visible: slide.y > -root.targetHeight

    // OSD Card (styled as top bar popout flush with concave fillets)
    Rectangle {
        id: card
        width: 260
        height: root.targetHeight
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: Config.popoutCornerRadius
        bottomRightRadius: Config.popoutCornerRadius
        color: Theme.bg
        border.width: 0

        transform: Translate {
            id: slide
            y: root.osdVisible ? 0 : -root.targetHeight

            Behavior on y {
                NumberAnimation {
                    duration: Config.animDuration
                    easing.type: root.osdVisible ? Easing.OutCubic : Easing.InCubic
                }
            }
        }

        // Top-left concave fillet (joins TopBar smoothly)
        Shape {
            visible: Config.enableFrameBars
            anchors.right: parent.left
            anchors.top: parent.top
            anchors.topMargin: -1
            width: Config.popoutCornerRadius
            height: Config.popoutCornerRadius
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                fillColor: Theme.bg
                strokeColor: "transparent"
                startX: 0
                startY: 0
                PathLine { x: Config.popoutCornerRadius; y: 0 }
                PathLine { x: Config.popoutCornerRadius; y: Config.popoutCornerRadius }
                PathArc {
                    x: 0
                    y: 0
                    radiusX: Config.popoutCornerRadius
                    radiusY: Config.popoutCornerRadius
                    direction: PathArc.Counterclockwise
                }
            }
        }

        // Top-right concave fillet (joins TopBar smoothly)
        Shape {
            visible: Config.enableFrameBars
            anchors.left: parent.right
            anchors.top: parent.top
            anchors.topMargin: -1
            width: Config.popoutCornerRadius
            height: Config.popoutCornerRadius
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                fillColor: Theme.bg
                strokeColor: "transparent"
                startX: Config.popoutCornerRadius
                startY: 0
                PathLine { x: 0; y: 0 }
                PathLine { x: 0; y: Config.popoutCornerRadius }
                PathArc {
                    x: Config.popoutCornerRadius
                    y: 0
                    radiusX: Config.popoutCornerRadius
                    radiusY: Config.popoutCornerRadius
                    direction: PathArc.Clockwise
                }
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            // Top row: icon/art + title + percentage
            Item {
                width: parent.width
                height: 24

                Item {
                    id: iconBox
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        visible: root.osdImage === "" || artImage.status !== Image.Ready
                        text: root.osdIcon
                        color: root.osdIconColor
                        font.family: Theme.iconFontFamily
                        font.pixelSize: Theme.cardIconSize + 1
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: 4
                        clip: true
                        color: Qt.alpha(Theme.fg, 0.08)
                        visible: root.osdImage !== "" && artImage.status === Image.Ready

                        Image {
                            id: artImage
                            anchors.fill: parent
                            source: root.osdImage
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                        }
                    }
                }

                Text {
                    id: pctText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.hasProgressBar
                    text: root.osdMuted ? "0%" : root.osdValue + "%"
                    color: root.osdIconColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.cardTextSize + 1
                    font.bold: true
                }

                Text {
                    anchors.left: iconBox.right
                    anchors.leftMargin: 8
                    anchors.right: pctText.visible ? pctText.left : parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.osdLabel
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.cardTitleSize
                    font.bold: true
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }
            }

            // Progress bar (10px height, radius 5px matching Popout)
            Rectangle {
                visible: root.hasProgressBar
                width: parent.width
                height: 10
                radius: 5
                color: Qt.alpha(Theme.fg, 0.12)

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * Math.min(1, Math.max(0, root.osdMuted ? 0 : root.osdValue / 100))
                    radius: 5
                    color: root.osdIconColor
                    Behavior on width { NumberAnimation { duration: Config.animDuration } }
                }
            }

            // Status text / Subtext
            Text {
                visible: root.osdSubText !== "" || !root.hasProgressBar
                width: parent.width
                text: root.osdSubText !== "" ? root.osdSubText : (root.osdMuted ? "Muted" : "")
                color: Qt.alpha(Theme.fg, 0.6)
                font.family: Theme.fontFamily
                font.pixelSize: 11
                elide: Text.ElideRight
            }
        }
    }
}
