import QtQuick
import Quickshell
import Quickshell.Io

// Command menu: quick actions that have NO other bar surface — power
// profile, keep-awake, mic mute, night light, bluetooth power, brightness
// (laptops), pomodoro, updates, power menu. The rule: the bar shows
// state, this menu holds actions that would otherwise each need a whole
// new bar widget. Stateful glanceable things (volume, network, DND,
// media) keep their own modules and never appear here.
// Quick-settings layout: toggle pills in a 2-col grid (filled = on,
// right-click = the full external tool where one exists), sliders under
// them, then launcher rows. Toggles stay open so the state change is
// visible; launchers close. A running pomodoro puts its countdown on
// this pill itself — glanceable without a dedicated module.
BarModule {
    id: root

    implicitWidth: 36
    icon: (pomoRunning || pomoDone) ? "" : "󰘳"
    iconColor: pomoDone ? Theme.bg
             : pomoRunning ? Theme.accent : Qt.alpha(Theme.fg, 0.7)
    label: pomoRunning ? fmtPomo(pomoLeft) : pomoDone ? "0m" : ""
    labelColor: pomoDone ? Theme.bg : Theme.accent
    // time's-up alert: the pill itself goes red until acknowledged, so
    // the signal survives DND (which holds the dunst notification back)
    color: pomoDone ? Theme.red
         : hovered ? Qt.alpha(Theme.fg, 0.14) : Qt.alpha(Theme.fg, 0.07)
    progress: pomoRunning ? pomoLeft / pomoTotal : -1

    onClicked: {
        pomoDone = false
        menu.visible = !menu.visible
    }

    // polled on every open; night light has no query, so it's tracked
    // locally (only this menu toggles it) — everything else is read back
    // from the system so a bar restart can't desync the pills
    property bool caffeine: false
    property bool nightLight: false
    property bool hasBacklight: false
    property int brightness: 50

    Process {
        id: stateProc
        command: ["sh", "-c",
            "printf '%s\\n' " +
            "\"$(brightnessctl -m -c backlight 2>/dev/null | head -n1)\" " +
            "\"$(xset q | awk '/timeout:/{print $2}')\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n")
                const bl = (lines[0] ?? "").split(",")
                root.hasBacklight = bl.length >= 4
                if (root.hasBacklight)
                    root.brightness = parseInt(bl[3]) || root.brightness
                // screensaver timeout 0 = blanking disabled = kept awake
                if (lines[1] !== undefined && lines[1] !== "")
                    root.caffeine = lines[1] === "0"
            }
        }
    }

    // pomodoro: countdown + drain bar live on the pill. Duration edits
    // only while idle: right-click cycles presets, scroll nudges ±5 min.
    property int pomoMinutes: 25
    readonly property var pomoPresets: [15, 25, 45, 60]
    readonly property int pomoTotal: pomoMinutes * 60
    property double pomoEndMs: 0
    property int pomoLeft: 0
    property bool pomoDone: false
    readonly property bool pomoRunning: pomoEndMs > 0

    // end-timestamp + minutes in a plain state file so a running timer
    // (and the duration preference) survives bar restarts; watched, so
    // `echo "0 25" > ~/.config/suckless/pomodoro` stops it from a shell
    function persistPomo() {
        Quickshell.execDetached(["sh", "-c",
            "printf '%s %s\\n' " + Math.round(pomoEndMs) + " " + pomoMinutes +
            " > '" + Theme.configDir + "/pomodoro'"])
    }

    FileView {
        path: Theme.configDir + "/pomodoro"
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const parts = text().trim().split(/\s+/)
            const end = parseFloat(parts[0]) || 0
            const mins = parseInt(parts[1]) || 0
            if (mins >= 5 && mins <= 90)
                root.pomoMinutes = mins
            if (end > Date.now()) {
                root.pomoEndMs = end
                root.pomoLeft = Math.round((end - Date.now()) / 1000)
            } else if (end === 0) {
                root.pomoEndMs = 0
            }
            // end in the past: expired while the bar was down — stay idle
        }
    }

    function fmtPomo(s) {
        if (s >= 60)
            return Math.ceil(s / 60) + "m"
        return s + "s"
    }
    function togglePomodoro() {
        pomoDone = false
        if (pomoRunning) {
            pomoEndMs = 0
        } else {
            pomoEndMs = Date.now() + pomoTotal * 1000
            pomoLeft = pomoTotal
        }
        persistPomo()
    }
    function cyclePomoPreset() {
        if (pomoRunning) return
        pomoMinutes = pomoPresets[(pomoPresets.indexOf(pomoMinutes) + 1)
                                  % pomoPresets.length]
        persistPomo()
    }
    function nudgePomo(dir) {
        if (pomoRunning) return
        pomoMinutes = Math.min(90, Math.max(5, pomoMinutes + dir * 5))
        persistPomo()
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.pomoRunning
        onTriggered: {
            root.pomoLeft = Math.max(0, Math.round((root.pomoEndMs - Date.now()) / 1000))
            if (root.pomoLeft <= 0) {
                root.pomoEndMs = 0
                root.pomoDone = true
                root.persistPomo()
                // chime plays regardless of DND — it's an alarm; the
                // notification lands in dunst history if DND holds it
                Quickshell.execDetached(["paplay", "--volume=40000",
                    "/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"])
                Quickshell.execDetached(["notify-send", "-u", "critical",
                    "Pomodoro", "Time's up — take a break"])
            }
        }
    }

    // filled = on; right-click launches modelData.alt (full external tool)
    component TogglePill: Rectangle {
        id: pill
        required property var modelData
        readonly property bool on: modelData.active === true

        width: (parent.width - 6) / 2
        height: 40
        radius: 6
        color: on ? Theme.selbg
             : pillMa.containsMouse ? Qt.alpha(Theme.fg, 0.12)
             : Qt.alpha(Theme.fg, 0.05)

        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            anchors.centerIn: parent
            spacing: 7

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: pill.modelData.icon
                color: pill.modelData.alert ? Theme.red
                     : pill.on ? Theme.selfg : Theme.cyan
                font.family: Theme.fontFamily
                font.pixelSize: 15
                Behavior on color { ColorAnimation { duration: 250 } }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: pill.modelData.label
                color: pill.on ? Theme.selfg : Qt.alpha(Theme.fg, 0.9)
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.bold: pill.on
            }
        }

        MouseArea {
            id: pillMa
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: m => {
                if (m.button === Qt.RightButton) {
                    if (pill.modelData.alt) {           // external tool
                        menu.visible = false
                        Quickshell.execDetached(pill.modelData.alt)
                    } else if (pill.modelData.altFn) {  // in-panel action
                        pill.modelData.altFn()
                    }
                } else {
                    pill.modelData.run()
                }
            }
            onWheel: w => pill.modelData.onScroll?.(w.angleDelta.y > 0 ? 1 : -1)
        }
    }

    component CommandRow: Rectangle {
        id: rowRect
        required property var modelData

        width: parent.width
        height: 34
        radius: 6
        color: rowMa.containsMouse ? Qt.alpha(Theme.fg, 0.12) : "transparent"

        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            spacing: 10

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: rowRect.modelData.icon
                color: rowRect.modelData.color ?? Theme.cyan
                font.family: Theme.iconFontFamily
                font.pixelSize: 16
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: rowRect.modelData.label
                color: Qt.alpha(Theme.fg, 0.9)
                font.family: Theme.fontFamily
                font.pixelSize: Theme.cardTextSize
            }
        }

        MouseArea {
            id: rowMa
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (!rowRect.modelData.keepOpen) menu.visible = false
                rowRect.modelData.run()
            }
        }
    }

    Popout {
        id: menu
        anchorItem: root
        cardWidth: 270
        cardHeight: (powerView ? powerCol.implicitHeight : col.implicitHeight) + 2 * cardPadding

        property bool powerView: false

        onVisibleChanged: {
            if (visible) {
                powerView = false
                stateProc.running = false
                stateProc.running = true
            }
        }

        // scriptable open/close: qs -p ~/.config/suckless/quickshell ipc call commands toggle
        IpcHandler {
            target: "commands"
            function toggle(): void { menu.visible = !menu.visible }
        }

        Column {
            id: col
            visible: !menu.powerView
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 6

            Grid {
                width: parent.width
                columns: 2
                spacing: 6

                Repeater {
                    model: [
                        { icon: "󰅶", label: "Keep awake",
                          active: root.caffeine,
                          run: () => {
                              root.caffeine = !root.caffeine
                              Quickshell.execDetached(["sh", "-c",
                                  root.caffeine ? "xset s off -dpms" : "xset s on +dpms"])
                          } },
                        { icon: "󱩌", label: "Night light",
                          active: root.nightLight,
                          run: () => {
                              root.nightLight = !root.nightLight
                              Quickshell.execDetached(["sh", "-c",
                                  root.nightLight ? "redshift -P -O 4500" : "redshift -x"])
                          } },
                        { icon: Sys.dndOn ? "󰂛" : "󰂚",
                          label: "DND",
                          active: Sys.dndOn, alert: Sys.dndOn,
                          run: () => Sys.toggleDnd() },
                        { icon: "󰔟",
                          label: root.pomoRunning ? "Stop" : root.pomoMinutes + " min",
                          active: root.pomoRunning,
                          altFn: () => root.cyclePomoPreset(),
                          onScroll: dir => root.nudgePomo(dir),
                          run: () => root.togglePomodoro() }
                    ]
                    TogglePill {}
                }
            }

            TweakSlider {
                visible: root.hasBacklight
                label: "brightness"
                from: 5; to: 100
                value: root.brightness
                suffix: "%"
                applyFn: v => {
                    Sys.suppressBrightnessOSD(1500)
                    root.brightness = v
                    Quickshell.execDetached(
                        ["brightnessctl", "-c", "backlight", "set", v + "%"])
                }
                persistFn: v => {
                    Sys.suppressBrightnessOSD(1500)
                    root.brightness = v
                }
            }

            Rectangle {
                width: parent.width - 8
                anchors.horizontalCenter: parent.horizontalCenter
                height: 1
                color: Qt.alpha(Theme.fg, 0.15)
            }

            Repeater {
                model: [
                    { icon: "󰐥", label: "Power menu", color: Theme.red, keepOpen: true,
                      run: () => { menu.powerView = true } }
                ]
                CommandRow {}
            }
        }

        // Sub-view: Power actions
        Column {
            id: powerCol
            visible: menu.powerView
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 6

            Repeater {
                model: [
                    { icon: "󰐥", label: "Power off", color: Theme.red,
                      run: () => Quickshell.execDetached(["loginctl", "poweroff"]) },
                    { icon: "󰜉", label: "Restart", color: Theme.yellow,
                      run: () => Quickshell.execDetached(["loginctl", "reboot"]) },
                    { icon: "󰒲", label: "Suspend", color: Theme.blue,
                      run: () => Quickshell.execDetached(["/home/thomas/tools/suckless_tools/scripts/lock.sh"]) },
                    { icon: "󰍃", label: "Log out", color: Theme.peach,
                      run: () => Quickshell.execDetached(["sh", "-c", "loginctl terminate-user $USER 2>/dev/null || pkill fluorite"]) }
                ]
                CommandRow {}
            }
        }
    }
}
