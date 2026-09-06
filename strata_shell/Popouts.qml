pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property var activePopout: null
    readonly property bool hasActive: activePopout !== null

    function register(popout) {
        if (activePopout && activePopout !== popout) {
            activePopout.close()
        }
        activePopout = popout
    }

    function unregister(popout) {
        if (activePopout === popout) {
            activePopout = null
        }
    }
}
