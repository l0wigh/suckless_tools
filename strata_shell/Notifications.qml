import QtQuick
import Quickshell

BarModule {
    id: root

    active: popup.visible
    badgeCount: Sys.dndOn ? 0 : Notifs.count

    icon: Sys.dndOn ? "󰂛" : (Notifs.count > 0 ? "󰂚" : "󰂞")
    iconColor: Sys.dndOn ? Qt.alpha(Theme.fg, 0.4) : (Notifs.count > 0 ? Theme.accent : Qt.alpha(Theme.fg, 0.5))

    onClicked: mouse => {
        popup.toggle()
    }


    NotifPopup {
        id: popup
        anchorItem: root
    }
}
