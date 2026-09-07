import QtQuick
import Quickshell

BarModule {
    id: root

    visible: Sys.hasBattery
    active: popup.visible

    icon: Sys.batteryIcon
    iconColor: Sys.batteryCharging ? Theme.green
             : Sys.battery <= 20 ? Theme.red
             : Sys.battery <= 30 ? Theme.yellow
             : Qt.alpha(Theme.fg, 0.8)

    onClicked: mouse => {
        popup.toggle()
    }

    BatteryPopup {
        id: popup
        anchorItem: root
    }
}
