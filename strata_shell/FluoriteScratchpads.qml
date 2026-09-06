import QtQuick

BarModule {
    id: root

    active: popup.visible
    icon: "󰖮"
    iconColor: Wm.scratchpads !== "" ? Theme.accent : Qt.alpha(Theme.fg, 0.45)



    onClicked: mouse => {
        popup.toggle()
    }

    ScratchpadPopup {
        id: popup
        anchorItem: root
    }
}
