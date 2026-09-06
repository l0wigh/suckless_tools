import QtQuick

// Debian swirl — the command center, no extra buttons needed:
//   left: app launcher · right: wallpaper picker · middle: random wallpaper
// Both wallpaper paths re-theme the desktop from the image's palette.
// FiraCode NF carries the Font Logos glyph; JetBrainsMono NF here doesn't.
BarModule {
    id: root

    icon: ""  // Gentoo logo (Font Logos)
    iconFont: "FiraCode Nerd Font"
    iconColor: Theme.accent
    active: appPopup.visible

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton)
            picker.toggle()
        else if (mouse.button === Qt.MiddleButton)
            picker.applyRandom()
        else
            appPopup.toggle()
    }

    AppLauncherPopup {
        id: appPopup
        anchorItem: root
    }

    WallpaperPicker {
        id: picker
        anchorItem: root
    }
}
