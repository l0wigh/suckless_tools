import QtQuick
import Quickshell

PanelWindow {
    id: root

    property var modelData
    screen: modelData

    anchors {
        bottom: true
    }

    implicitWidth: screen?.width ?? 1920
    implicitHeight: Config.bottomBarHeight
    exclusiveZone: Config.bottomBarHeight
    exclusionMode: ExclusionMode.Normal
    color: "transparent"
    visible: false

    Timer {
        interval: Config.bottomBarDelay
        running: Config.enableBottomBar
        repeat: false
        onTriggered: root.visible = true
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bg
    }
}
