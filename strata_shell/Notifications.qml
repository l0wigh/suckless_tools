import QtQuick
import Quickshell

BarModule {
    id: root

    active: popup.visible
    badgeCount: Notifs.count

    icon: Notifs.count > 0 ? "󰂚" : "󰂞"
    iconColor: Notifs.count > 0 ? Theme.accent : Qt.alpha(Theme.fg, 0.5)

    onClicked: mouse => {
        popup.toggle()
    }


    NotifPopup {
        id: popup
        anchorItem: root
    }
}
