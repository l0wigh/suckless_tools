import QtQuick
import Quickshell

BarModule {
    id: root

    visible: Sys.hasBattery
    active: popup.visible

    function getBatIcon() {
        const b = Sys.battery
        if (Sys.batteryCharging) {
            if (b >= 90) return "󰂋"
            if (b >= 80) return "󰂊"
            if (b >= 70) return "󰂉"
            if (b >= 60) return "󰂈"
            if (b >= 50) return "󰂇"
            if (b >= 40) return "󰂆"
            if (b >= 30) return "󰂅"
            if (b >= 20) return "󰂄"
            return "󰢜"
        } else {
            if (b >= 95) return "󰁹"
            if (b >= 85) return "󰂂"
            if (b >= 75) return "󰂁"
            if (b >= 65) return "󰂀"
            if (b >= 55) return "󰁿"
            if (b >= 45) return "󰁾"
            if (b >= 35) return "󰁽"
            if (b >= 25) return "󰁼"
            if (b >= 15) return "󰁻"
            return "󰁺"
        }
    }

    icon: getBatIcon()
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
