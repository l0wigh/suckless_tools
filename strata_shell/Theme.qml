pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string configDir: {
        let sd = String(Quickshell.shellDir ?? "")
        if (sd.startsWith("file://"))
            sd = sd.slice(7)
        return sd.substring(0, sd.lastIndexOf("/"))
    }

    property int barHeight: 42
    property real barUserScale: 1.0

    property int _barStateLoads: 0
    readonly property bool barStateReady: _barStateLoads >= 2
    Timer {
        running: !root.barStateReady
        interval: 1000
        onTriggered: root._barStateLoads = 2
    }

    // Colors dynamically initialized from ~/.Xresources / xrdb
    property color bg: "#f2ecec"
    property color altbg: "#c8bebe"
    property color surface: "#e0d8d8"
    property color surfaceAlt: "#c8bebe"
    property color fg: "#5a524c"
    property color border: "#c8bebe"
    property int borderWidth: 2
    property color primary: "#df5a75"
    property color secondary: "#9b6daf"
    property color alert: "#df5a75"
    property color disabled: "#a09894"

    readonly property color accent: primary
    readonly property color selbg: primary
    readonly property color selfg: bg
    readonly property color red: alert
    property color yellow: "#d28e5d"
    property color blue: "#5a7da3"
    property color green: "#6a994e"
    property color cyan: "#548d8d"
    property color magenta: "#9b6daf"
    property color peach: "#e87a90"

    readonly property string fontFamily: "IBM Plex Mono"
    readonly property string iconFontFamily: "BlexMono Nerd Font"

    readonly property real barScale: barUserScale
    readonly property int fontSize: Math.round(14 * barScale)
    readonly property int iconSize: Math.round(21 * barScale)
    readonly property int cardTitleSize: 15
    readonly property int cardTextSize: 13
    readonly property int cardSmallSize: 11
    readonly property int cardIconSize: 17
    readonly property int moduleHeight: Math.round(28 * barScale)
    readonly property int effectiveBarHeight: Math.max(barHeight, moduleHeight + 12)

    function applyColorDict(dict) {
        if (dict["c0"] || dict["*.color0"]) root.bg = dict["c0"] ?? dict["*.color0"]
        if (dict["c7"] || dict["*.color7"]) root.fg = dict["c7"] ?? dict["*.color7"]
        if (dict["c8"] || dict["*.color8"]) {
            root.border = dict["c8"] ?? dict["*.color8"]
            root.altbg = dict["c8"] ?? dict["*.color8"]
            root.surface = dict["c8"] ?? dict["*.color8"]
        }
        if (dict["fluorite.border_width"])
            root.borderWidth = parseInt(dict["fluorite.border_width"]) || 2
        if (dict["pr"] || dict["fluorite.border_focused"] || dict["c1"] || dict["*.color1"])
            root.primary = dict["pr"] ?? dict["fluorite.border_focused"] ?? dict["c1"] ?? dict["*.color1"]
        if (dict["c2"] || dict["*.color2"]) root.green = dict["c2"] ?? dict["*.color2"]
        if (dict["c3"] || dict["*.color3"]) root.yellow = dict["c3"] ?? dict["*.color3"]
        if (dict["c4"] || dict["*.color4"]) root.blue = dict["c4"] ?? dict["*.color4"]
        if (dict["c5"] || dict["*.color5"]) root.magenta = dict["c5"] ?? dict["*.color5"]
        if (dict["c6"] || dict["*.color6"]) root.cyan = dict["c6"] ?? dict["*.color6"]
        if (dict["c9"] || dict["*.color9"]) root.peach = dict["c9"] ?? dict["*.color9"]
    }

    function parseXresourcesText(raw) {
        if (!raw) return
        const dict = {}
        const lines = raw.split("\n")
        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim()
            if (!line || line.startsWith("!")) continue
            if (line.startsWith("#define")) {
                const parts = line.split(/\s+/)
                if (parts.length >= 3)
                    dict[parts[1].trim()] = parts[2].trim()
            } else {
                const idx = line.indexOf(":")
                if (idx !== -1) {
                    const k = line.slice(0, idx).trim()
                    let v = line.slice(idx + 1).trim()
                    if (dict[v]) v = dict[v]
                    dict[k] = v
                }
            }
        }
        applyColorDict(dict)
    }

    Timer {
        id: xrdbDebounce
        interval: 150
        onTriggered: {
            xrdbProc.running = false
            xrdbProc.running = true
        }
    }

    Process {
        id: xrdbProc
        command: ["xrdb", "-query"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n")
                const dict = {}
                for (let i = 0; i < lines.length; i++) {
                    const line = lines[i].trim()
                    if (!line || line.startsWith("!")) continue
                    const idx = line.indexOf(":")
                    if (idx !== -1) {
                        const key = line.slice(0, idx).trim()
                        const val = line.slice(idx + 1).trim()
                        dict[key] = val
                    }
                }
                applyColorDict(dict)
            }
        }
    }

    // Watch ~/.Xresources and parse instantly when the file is written
    FileView {
        path: Quickshell.env("HOME") + "/.Xresources"
        watchChanges: true
        onLoaded: parseXresourcesText(text())
        onFileChanged: {
            reload()
            parseXresourcesText(text())
            xrdbDebounce.restart()
        }
    }

    FileView {
        path: root.configDir + "/bar-height"
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: root._barStateLoads++
        onLoaded: {
            root._barStateLoads++
            const v = parseInt(text())
            if (!isNaN(v))
                root.barHeight = Math.min(Math.max(v, 32), 80)
        }
    }

    FileView {
        path: root.configDir + "/bar-scale"
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: root._barStateLoads++
        onLoaded: {
            root._barStateLoads++
            const v = parseFloat(text())
            if (!isNaN(v))
                root.barUserScale = Math.min(Math.max(v, 0.7), 2.0)
        }
    }
}
