import QtQuick
import Quickshell
import Quickshell.Widgets

Popout {
    id: root

    cardWidth: 300
    cardHeight: 400

    property var allApps: []

    function updateApps() {
        try {
            const list = DesktopEntries.applications.values
            allApps = [...list].sort((a, b) => a.name.localeCompare(b.name))
        } catch (e) {
            allApps = []
        }
    }

    Component.onCompleted: updateApps()

    onVisibleChanged: {
        if (visible) {
            updateApps()
        }
    }

    function launchApp(app) {
        if (!app) return
        app.execute()
        root.close()
    }

    Column {
        anchors.fill: parent
        spacing: 8

        // ================= Header =================
        Item {
            width: parent.width
            height: 26

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Applications"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: 13
                    font.bold: true
                }
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: root.allApps.length + " apps"
                color: Qt.alpha(Theme.fg, 0.45)
                font.family: Theme.fontFamily
                font.pixelSize: 11
            }
        }

        // ================= Applications List =================
        ListView {
            id: appList
            width: parent.width
            height: parent.height - 34
            clip: true
            model: root.allApps
            spacing: 2
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                id: itemRect
                required property var modelData
                width: appList.width
                height: 40
                radius: 6
                color: itemMouse.containsMouse ? Qt.alpha(Theme.fg, 0.12) : "transparent"
                Behavior on color { ColorAnimation { duration: 100 } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter

                    IconImage {
                        anchors.verticalCenter: parent.verticalCenter
                        source: Quickshell.iconPath(itemRect.modelData.icon, "application-x-executable")
                        implicitSize: 24
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 38
                        spacing: 1

                        Text {
                            text: itemRect.modelData.name
                            color: itemMouse.containsMouse ? Theme.accent : Theme.fg
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            font.bold: true
                            elide: Text.ElideRight
                            width: parent.width
                            Behavior on color { ColorAnimation { duration: 100 } }
                        }

                        Text {
                            visible: text !== ""
                            text: itemRect.modelData.genericName || itemRect.modelData.comment || ""
                            color: Qt.alpha(Theme.fg, 0.5)
                            font.family: Theme.fontFamily
                            font.pixelSize: 10
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }
                }

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.launchApp(itemRect.modelData)
                }
            }

            Text {
                anchors.centerIn: parent
                visible: root.allApps.length === 0
                text: "No applications available"
                color: Qt.alpha(Theme.fg, 0.4)
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }
        }
    }
}
