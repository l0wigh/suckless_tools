import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

// StatusNotifierItem tray (SNI over DBus, works on X11).
// Left click activates, right click opens the item's menu.
Column {
    id: root

    readonly property int count: SystemTray.items.values.length
    visible: count > 0
    spacing: 5

    Repeater {
        model: SystemTray.items

        Rectangle {
            id: trayItem
            required property SystemTrayItem modelData

            width: Math.round(34 * Theme.barScale)
            height: Math.round(34 * Theme.barScale)
            radius: 6
            color: mouse.containsMouse ? Qt.alpha(Theme.fg, 0.14) : "transparent"
            scale: mouse.pressed ? 0.92 : 1

            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on scale { NumberAnimation { duration: 80; easing.type: Easing.OutQuad } }

            IconImage {
                anchors.centerIn: parent
                implicitSize: Math.round(18 * Theme.barScale)
                source: trayItem.modelData.icon
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: trayItem.modelData.menu
                anchor.item: trayItem
                anchor.rect.x: trayItem.width + 8
                anchor.rect.y: 0
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: m => {
                    if (m.button === Qt.LeftButton)
                        trayItem.modelData.activate()
                    else if (m.button === Qt.MiddleButton)
                        trayItem.modelData.secondaryActivate()
                    else if (trayItem.modelData.hasMenu)
                        menuAnchor.open()
                }

                onWheel: w => {
                    trayItem.modelData.scroll(w.angleDelta.y, false)
                }
            }
        }
    }
}
