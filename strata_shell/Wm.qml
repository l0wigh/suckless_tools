pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Tag state + control — dwm backend. Requires the quickshell-extbar patch
// (suckless/dwm/patches/dwm-quickshell-extbar.diff): it publishes
// _DWM_SELTAGS (raw tagset bitmask, faithful for multi-tag views) plus
// the layout/tweak atoms below, and accepts _NET_CURRENT_DESKTOP /
// _NET_WM_DESKTOP client messages so xdotool works for actions.
// Occupancy is recomputed from each client's _NET_CLIENT_INFO tag
// bitmask (debounced). The focused window title comes from the same
// two-stage xprop spy as the other backends.
Singleton {
    id: root

    property int seltags: 1
    property int occtags: 0
    property int urgtags: 0     // dwm exports no urgency atom yet
    property int tagCount: 12
    property string title: ""
    property string activeWinId: ""

    // Fluorite layouts (matching polybar squared/top.ini hook-0..4)
    readonly property var layouts: [
        { name: "Cascade",   glyph: "" },
        { name: "DWM",       glyph: "" },
        { name: "Centered",  glyph: "󰕬" },
        { name: "Stacked",   glyph: "󰯋" },
        { name: "Scrolling", glyph: "󰈰" }
    ]
    property int layoutIndex: 1
    property string scratchpads: ""

    // desktop tweaks, same publish/set mechanism (_DWM_GAPS/_DWM_MFACT/
    // _DWM_NMASTER read, _DWM_SET* written). mfact is a percent; mfact
    // and nmaster are pertag — they follow the focused tag.
    property int gaps: 8
    property int mfact: 50
    property int nmaster: 1
    property bool follow: true  // window-follow on tag/monitor send (wfsymbol)

    property bool _followSeen: false
    function _setFollow(f) {
        // notify on real changes only — click and Mod+n both land here
        if (_followSeen && f !== follow)
            Quickshell.execDetached(["notify-send", "-a", "dwm", "-t", "1500",
                "Window follow", f ? "Sent windows are followed" : "Sent windows stay put"])
        _followSeen = true
        follow = f
    }

    function _setProp(atom, v) {
        Quickshell.execDetached(["xprop", "-root", "-f", atom, "32c",
            "-set", atom, String(v)])
    }
    function setLayout(i) { _setProp("_DWM_SETLAYOUT", i) }
    function cycleLayout(dir) {
        setLayout(((layoutIndex + dir) % layouts.length + layouts.length) % layouts.length)
    }
    function setGaps(v) { _setProp("_DWM_SETGAPS", v) }
    function setMfact(pct) { _setProp("_DWM_SETMFACT", pct) }
    function setNmaster(n) { _setProp("_DWM_SETNMASTER", n) }
    function toggleFollow() { _setProp("_DWM_SETFOLLOW", follow ? 0 : 1) }

    // xprop -spy silently drops atoms that don't exist when it starts
    // ("no such atom", then never reports them) — and on login the bar
    // can beat dwm's atom seeding. Restart the spy until every atom
    // resolves; bounded, since an unpatched dwm never publishes them.
    // --- EWMH Root properties spy ---
    Process {
        id: spy
        command: ["xprop", "-spy", "-root",
                  "_NET_CURRENT_DESKTOP", "_NET_NUMBER_OF_DESKTOPS", "_NET_CLIENT_LIST"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (line.indexOf("_NET_CURRENT_DESKTOP") === 0) {
                    const m = line.match(/= (\d+)/)
                    if (m) {
                        const ws = parseInt(m[1])
                        root.seltags = (1 << ws)
                    }
                } else if (line.indexOf("_NET_NUMBER_OF_DESKTOPS") === 0) {
                    const m = line.match(/= (\d+)/)
                    if (m)
                        root.tagCount = parseInt(m[1])
                }
                occRefresh.restart()
            }
        }
    }

    Process {
        id: initFluoriteProps
        command: ["sh", "-c", "xprop -root FLUORITE_LAYOUT 2>/dev/null; xprop -root FLUORITE_SCRATCHPADS 2>/dev/null"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (line.indexOf("FLUORITE_LAYOUT") === 0) {
                    const m = line.match(/= (\d+)/)
                    if (m) {
                        const idx = parseInt(m[1])
                        if (idx >= 0 && idx < root.layouts.length)
                            root.layoutIndex = idx
                    }
                } else if (line.indexOf("FLUORITE_SCRATCHPADS") === 0) {
                    const m = line.match(/= "(.*)"/)
                    root.scratchpads = m ? m[1].trim() : ""
                }
            }
        }
    }

    Process {
        id: fluoriteSpy
        command: ["xprop", "-spy", "-root", "FLUORITE_LAYOUT", "FLUORITE_SCRATCHPADS"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (line.indexOf("FLUORITE_LAYOUT") === 0) {
                    const m = line.match(/= (\d+)/)
                    if (m) {
                        const idx = parseInt(m[1])
                        if (idx >= 0 && idx < root.layouts.length)
                            root.layoutIndex = idx
                    }
                } else if (line.indexOf("FLUORITE_SCRATCHPADS") === 0) {
                    const m = line.match(/= "(.*)"/)
                    root.scratchpads = m ? m[1].trim() : ""
                }
            }
        }
    }

    Timer {
        id: occRefresh
        interval: 150
        onTriggered: {
            occProc.running = false
            occProc.running = true
        }
    }

    property int _occ: 0
    Process {
        id: occProc
        command: ["sh", "-c",
            "for w in $(xprop -root _NET_CLIENT_LIST 2>/dev/null | grep -oE '0x[0-9a-f]+'); do " +
            "xprop -id $w _NET_WM_DESKTOP 2>/dev/null | sed -n 's/.*= \\([0-9]*\\).*/\\1/p'; done"]
        stdout: SplitParser {
            onRead: line => {
                const ws = parseInt(line)
                if (!isNaN(ws) && ws >= 0 && ws < 32)
                    root._occ |= (1 << ws)
            }
        }
        onRunningChanged: {
            if (running) root._occ = 0
            else root.occtags = root._occ & ((1 << root.tagCount) - 1)
        }
    }

    // --- focused window title ---

    Process {
        command: ["xprop", "-spy", "-root", "_NET_ACTIVE_WINDOW"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const m = line.match(/window id # (0x[0-9a-fA-F]+)/)
                const id = m ? m[1] : ""
                if (id !== root.activeWinId) {
                    root.activeWinId = id
                    titleSpy.running = false
                    if (id !== "")
                        titleSpy.running = true
                    else
                        root.title = ""
                }
            }
        }
    }

    Process {
        id: titleSpy
        command: ["xprop", "-spy", "-id", root.activeWinId, "_NET_WM_NAME"]
        stdout: SplitParser {
            onRead: line => {
                const m = line.match(/= "([\s\S]*)"$/)
                if (m)
                    root.title = m[1].replace(/\\"/g, '"').replace(/\\\\/g, "\\")
            }
        }
    }

    // --- actions (handled by the extbar patch's clientmessage additions) ---

    function viewTag(i) { Quickshell.execDetached(["xdotool", "set_desktop", String(i)]) }
    function toggleViewTag(i) { viewTag(i) }
    function sendToTag(i) {
        Quickshell.execDetached(["xdotool", "getactivewindow", "set_desktop_for_window", String(i)])
    }
    function cycleTag(dir) {
        Quickshell.execDetached(["xdotool", "set_desktop", "--relative", "--", String(dir)])
    }
    function cycleFluoriteLayout() {
        Quickshell.execDetached(["xdotool", "key", "--clearmodifiers", "Super+r"])
    }
    function toggleScratchpad() {
        Quickshell.execDetached(["xdotool", "key", "--clearmodifiers", "Super+ugrave"])
    }

    function openLauncher() {
        Quickshell.execDetached(["dmenu_run_desktop"])
    }
    function openPowerMenu() {
        Quickshell.execDetached([Theme.configDir + "/scripts/power"])
    }
}
