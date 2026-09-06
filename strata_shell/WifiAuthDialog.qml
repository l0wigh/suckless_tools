import QtQuick
import QtQuick.Window

Window {
    id: root

    title: "Wi-Fi Authentication"
    visible: false
    flags: Qt.Dialog
    width: 360
    height: 150
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2
    color: "transparent"

    property string ssid: ""

    signal submitted(string ssid, string password)
    signal canceled()

    function openFor(targetSsid) {
        ssid = targetSsid
        pwField.text = ""
        visible = true
        pwField.forceActiveFocus()
    }

    function close() {
        visible = false
        pwField.text = ""
        ssid = ""
    }

    function submit() {
        const s = ssid
        const pass = pwField.text
        close()
        submitted(s, pass)
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        radius: 8
        border.width: 1
        border.color: Qt.alpha(Theme.border, 0.6)

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Row {
                width: parent.width
                spacing: 8

                Text {
                    text: "󰤨"
                    color: Theme.accent
                    font.family: Theme.iconFontFamily
                    font.pixelSize: 18
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "Connect to " + root.ssid
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    elide: Text.ElideRight
                    width: parent.width - 30
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: parent.width
                height: 36
                radius: 6
                color: Qt.alpha(Theme.fg, 0.08)
                border.width: pwField.activeFocus ? 2 : 1
                border.color: pwField.activeFocus ? Theme.accent : Theme.border

                TextInput {
                    id: pwField
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    verticalAlignment: TextInput.AlignVCenter
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: 13
                    echoMode: TextInput.Password
                    onAccepted: root.submit()
                    Keys.onEscapePressed: {
                        root.close()
                        root.canceled()
                    }
                }
            }

            Row {
                anchors.right: parent.right
                spacing: 10

                Rectangle {
                    width: 75
                    height: 30
                    radius: 5
                    color: cancelMa.containsMouse ? Qt.alpha(Theme.fg, 0.15) : "transparent"
                    border.width: 1
                    border.color: Theme.border

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: cancelMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.close()
                            root.canceled()
                        }
                    }
                }

                Rectangle {
                    width: 85
                    height: 30
                    radius: 5
                    color: connectMa.containsMouse ? Qt.lighter(Theme.accent, 1.1) : Theme.accent

                    Text {
                        anchors.centerIn: parent
                        text: "Connect"
                        color: Theme.bg
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                    }

                    MouseArea {
                        id: connectMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.submit()
                    }
                }
            }
        }
    }
}
