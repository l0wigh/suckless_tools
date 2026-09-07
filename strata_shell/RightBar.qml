import QtQuick
import QtQuick.Shapes
import Quickshell

PanelWindow {
    id: root

    property var modelData
    screen: modelData

    anchors {
        right: true
    }

    implicitWidth: Config.rightBarImplicitWidth
    implicitHeight: screen?.height ?? 1080
    exclusiveZone: Config.rightBarWidth
    exclusionMode: ExclusionMode.Normal
    color: "transparent"
    visible: false

    Timer {
        interval: Config.rightBarDelay
        running: Config.enableRightBar
        repeat: false
        onTriggered: root.visible = true
    }

    // Main 12px vertical strip
    Rectangle {
        id: rightBarBody
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Config.rightBarWidth
        color: Theme.bg
    }

    // Top-right concave fillet (smoothly joins TopBar and RightBar)
    Shape {
        x: 0
        y: Config.topBarHeight
        width: Config.cornerRadius
        height: Config.cornerRadius
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            fillColor: Theme.bg
            strokeColor: "transparent"
            startX: 0
            startY: 0
            PathLine { x: Config.cornerRadius; y: 0 }
            PathLine { x: Config.cornerRadius; y: Config.cornerRadius }
            PathArc {
                x: 0
                y: 0
                radiusX: Config.cornerRadius
                radiusY: Config.cornerRadius
                direction: PathArc.Counterclockwise
            }
        }
    }

    // Bottom-right concave fillet (smoothly joins BottomBar and RightBar)
    Shape {
        x: 0
        y: root.height - Config.bottomBarHeight - Config.cornerRadius
        width: Config.cornerRadius
        height: Config.cornerRadius
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            fillColor: Theme.bg
            strokeColor: "transparent"
            startX: 0
            startY: Config.cornerRadius
            PathLine { x: Config.cornerRadius; y: Config.cornerRadius }
            PathLine { x: Config.cornerRadius; y: 0 }
            PathArc {
                x: 0
                y: Config.cornerRadius
                radiusX: Config.cornerRadius
                radiusY: Config.cornerRadius
                direction: PathArc.Clockwise
            }
        }
    }
}
