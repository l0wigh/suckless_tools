import QtQuick

// Current layout as its nerd-font glyph — the same symbols dwm's retired
// native bar used (layouts[] in config.h). Scroll cycles layouts, click
// opens the picker grid.
BarModule {
    id: root



    icon: (Wm.layouts[Wm.layoutIndex] ? Wm.layouts[Wm.layoutIndex].glyph : "")
    iconColor: Theme.primary
    iconOffsetX: 0

    onClicked: Wm.cycleFluoriteLayout()
    onScrolled: dir => Wm.cycleFluoriteLayout()
}
