import QtQuick
import Quickshell

PanelWindow {
    id: root

    property var modelData
    screen: modelData

    anchors {
        top: true
    }

    implicitWidth: screen?.width ?? 1920
    implicitHeight: Config.topBarHeight
    exclusiveZone: Config.topBarHeight
    exclusionMode: ExclusionMode.Normal
    color: "transparent"
    visible: false

    Timer {
        interval: Config.topBarDelay
        running: Config.enableTopBar
        repeat: false
        onTriggered: root.visible = true
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bg
    }
}
