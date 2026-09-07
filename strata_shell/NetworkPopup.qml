import QtQuick
import Quickshell
import Quickshell.Io

Popout {
    id: root

    cardWidth: 320
    cardHeight: 340

    property bool scanning: false
    property var nets: []
    property var savedWifi: []
    property string activeSsid: ""
    property bool wifiOn: true
    property string statusMsg: ""

    onVisibleChanged: {
        if (visible) {
            statusMsg = ""
            refresh(true)
        } else {
            refreshTimer.stop()
            scanProc.running = false
            statusProc.running = false
            radioProc.running = false
            savedProc.running = false
            actProc.running = false
            scanning = false
        }
    }

    function refresh(rescan) {
        if (!visible) return
        scanning = true
        statusMsg = rescan ? "Scanning networks…" : ""
        statusProc.running = true
        radioProc.running = true
        savedProc.running = true
        scanProc.command = ["sh", "-c",
            (rescan ? "wpa_cli scan >/dev/null 2>&1; sleep 1; " : "") +
            "cur=$(wpa_cli status 2>/dev/null | awk -F= '/^ssid=/{print $2}'); " +
            "wpa_cli scan_results 2>/dev/null | tail -n +2 | while IFS=$(printf '\\t') read -r bssid freq sig flags ssid; do " +
            "  [ -z \"$ssid\" ] && continue; " +
            "  inuse='0'; [ \"$ssid\" = \"$cur\" ] && inuse='1'; " +
            "  echo \"$inuse:$sig:$flags:$ssid\"; " +
            "done"]
        scanProc.running = true
    }

    function connectTo(net) {
        if (net.inUse) {
            statusMsg = "Disconnecting…"
            runCmd(["wpa_cli", "disconnect"])
        } else if (savedWifi.indexOf(net.ssid) !== -1) {
            statusMsg = "Connecting to " + net.ssid + "…"
            runCmd(["sh", "-c",
                "id=$(wpa_cli list_networks 2>/dev/null | awk -F'\\t' -v s=\"" + net.ssid + "\" '$2==s {print $1}'); " +
                "wpa_cli select_network \"$id\"; wpa_cli reconnect"])
        } else if (net.security.indexOf("WPA") === -1 && net.security.indexOf("WEP") === -1) {
            statusMsg = "Connecting to " + net.ssid + "…"
            runCmd(["sh", "-c",
                "id=$(wpa_cli add_network 2>/dev/null | tail -n 1); " +
                "wpa_cli set_network \"$id\" ssid '\"" + net.ssid + "\"'; " +
                "wpa_cli set_network \"$id\" key_mgmt NONE; " +
                "wpa_cli enable_network \"$id\"; wpa_cli select_network \"$id\"; wpa_cli save_config; wpa_cli reconnect"])
        } else {
            wifiAuthDialog.openFor(net.ssid)
        }
    }

    function submitPassword(ssid, password) {
        if (!ssid || !password) return
        statusMsg = "Connecting to " + ssid + "…"
        runCmd(["sh", "-c",
            "id=$(wpa_cli add_network 2>/dev/null | tail -n 1); " +
            "wpa_cli set_network \"$id\" ssid '\"" + ssid + "\"'; " +
            "wpa_cli set_network \"$id\" psk '\"" + password + "\"'; " +
            "wpa_cli enable_network \"$id\"; wpa_cli select_network \"$id\"; wpa_cli save_config; wpa_cli reconnect"])
    }

    function runCmd(cmd) {
        actProc.command = cmd
        actProc.running = true
    }

    Process {
        id: actProc
        onExited: (code, st) => {
            if (!root.visible) return
            root.statusMsg = code === 0 ? "Ready" : "Action failed"
            refreshTimer.restart()
        }
    }

    Timer {
        id: refreshTimer
        interval: 1500
        onTriggered: {
            if (root.visible) root.refresh(false)
        }
    }

    Process {
        id: statusProc
        command: ["sh", "-c", "wpa_cli status 2>/dev/null | awk -F= '/^ssid=/{print $2}'"]
        stdout: SplitParser {
            onRead: line => {
                if (root.visible) root.activeSsid = line.trim()
            }
        }
    }

    Process {
        id: radioProc
        command: ["sh", "-c", "rfkill list wifi 2>/dev/null | grep -q 'Soft blocked: yes' && echo 'disabled' || echo 'enabled'"]
        stdout: SplitParser {
            onRead: line => {
                if (root.visible) root.wifiOn = (line.trim() === "enabled")
            }
        }
    }

    property var _savedList: []
    Process {
        id: savedProc
        command: ["sh", "-c", "wpa_cli list_networks 2>/dev/null | awk -F'\\t' 'NF>=2 && $1 ~ /^[0-9]+$/ {print $2}'"]
        stdout: SplitParser {
            onRead: line => {
                if (!root.visible) return
                const n = line.trim()
                if (n !== "") root._savedList.push(n)
            }
        }
        onRunningChanged: {
            if (!root.visible) return
            if (running) root._savedList = []
            else root.savedWifi = root._savedList
        }
    }

    property var _scanned: []
    Process {
        id: scanProc
        stdout: SplitParser {
            onRead: line => {
                if (!root.visible) return
                const p = line.split(":")
                if (p.length < 4) return
                const ssid = p.slice(3).join(":").replace(/\\:/g, ":")
                if (ssid === "") return
                const dbm = parseInt(p[1]) || -100
                const sig = Math.min(100, Math.max(0, 2 * (dbm + 100)))
                root._scanned.push({ inUse: p[0] === "1", signal: sig, security: p[2], ssid: ssid })
            }
        }
        onRunningChanged: {
            if (!root.visible) return
            if (running) {
                root._scanned = []
            } else {
                const best = {}
                for (const n of root._scanned) {
                    if (!best[n.ssid] || n.signal > best[n.ssid].signal || n.inUse)
                        best[n.ssid] = n
                }
                root.nets = Object.values(best).sort((a, b) => (b.inUse - a.inUse) || (b.signal - a.signal))
                root.scanning = false
            }
        }
    }

    function sigIcon(s) {
        return s < 25 ? "󰤟" : s < 50 ? "󰤢" : s < 75 ? "󰤥" : "󰤨"
    }

    Column {
        anchors.fill: parent
        spacing: 10

        // Header
        Item {
            id: headerRow
            width: parent.width
            height: 28

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "Wi-Fi & Network"
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.cardTitleSize
                font.bold: true
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                // Rescan button
                Text {
                    text: "󰑐"
                    color: root.scanning ? Theme.accent : Theme.secondary
                    font.family: Theme.iconFontFamily
                    font.pixelSize: Theme.cardIconSize
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        onClicked: root.refresh(true)
                    }
                }

                // WiFi Radio Switch
                Rectangle {
                    width: 32
                    height: 18
                    radius: 9
                    color: root.wifiOn ? Theme.accent : Qt.alpha(Theme.fg, 0.15)
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Rectangle {
                        x: root.wifiOn ? parent.width - width - 2 : 2
                        anchors.verticalCenter: parent.verticalCenter
                        width: 14; height: 14; radius: 7
                        color: root.wifiOn ? Theme.bg : Qt.alpha(Theme.fg, 0.7)
                        Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.runCmd(["rfkill", root.wifiOn ? "block" : "unblock", "wifi"])
                            root.wifiOn = !root.wifiOn
                            refreshTimer.restart()
                        }
                    }
                }
            }
        }

        // Status text if any
        Text {
            id: statusLabel
            visible: root.statusMsg !== ""
            text: root.statusMsg
            color: Theme.accent
            font.family: Theme.fontFamily
            font.pixelSize: Theme.cardSmallSize + 1
        }

        // Password input box
        // Networks list
        Flickable {
            width: parent.width
            height: Math.max(50, parent.height - headerRow.height - parent.spacing
                    - (statusLabel.visible ? statusLabel.height + parent.spacing : 0))
            contentHeight: netCol.implicitHeight
            clip: true

            Column {
                id: netCol
                width: parent.width
                spacing: 4

                Repeater {
                    model: root.nets

                    Rectangle {
                        id: netItem
                        required property var modelData
                        width: parent.width
                        height: 36
                        radius: 6
                        color: netItem.modelData.inUse ? Qt.alpha(Theme.accent, 0.15)
                             : netMouse.containsMouse ? Qt.alpha(Theme.fg, 0.08)
                             : "transparent"

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 8
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: root.sigIcon(netItem.modelData.signal)
                                color: netItem.modelData.inUse ? Theme.green : Theme.accent
                                font.family: Theme.iconFontFamily
                                font.pixelSize: Theme.cardIconSize
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: netItem.modelData.ssid
                                color: netItem.modelData.inUse ? Theme.accent : Theme.fg
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.cardTextSize + 1
                                font.bold: netItem.modelData.inUse
                                elide: Text.ElideRight
                                width: parent.width - 80
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                visible: netItem.modelData.security.indexOf("WPA") !== -1 || netItem.modelData.security.indexOf("WEP") !== -1
                                text: "󰌾"
                                color: Theme.secondary
                                font.family: Theme.iconFontFamily
                                font.pixelSize: 13
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: netMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.connectTo(netItem.modelData)
                        }
                    }
                }
            }
        }
    }

    WifiAuthDialog {
        id: wifiAuthDialog
        onSubmitted: (ssid, password) => root.submitPassword(ssid, password)
    }
}
