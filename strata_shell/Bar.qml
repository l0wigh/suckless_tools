import QtQuick
import QtQuick.Shapes
import Quickshell

PanelWindow {
    id: root

    property var modelData
    screen: modelData

    anchors {
        top: true
        bottom: true
        left: true
    }
    margins {
        top: 0
        bottom: 0
        left: 0
    }
    implicitWidth: Config.leftBarImplicitWidth
    exclusiveZone: Config.leftBarWidth
    exclusionMode: ExclusionMode.Normal
    aboveWindows: true
    color: "transparent"
    visible: true

    Rectangle {
        id: barBody
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Config.leftBarWidth
        color: Theme.bg
    }

    // Top-left concave fillet (smoothly joins TopBar and Bar)
    Shape {
        visible: Config.enableFrameBars
        x: Config.leftBarWidth
        y: Config.topBarHeight
        width: Config.cornerRadius
        height: Config.cornerRadius
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            fillColor: Theme.bg
            strokeColor: "transparent"
            startX: Config.cornerRadius
            startY: 0
            PathLine { x: 0; y: 0 }
            PathLine { x: 0; y: Config.cornerRadius }
            PathArc {
                x: Config.cornerRadius
                y: 0
                radiusX: Config.cornerRadius
                radiusY: Config.cornerRadius
                direction: PathArc.Clockwise
            }
        }
    }

    // Bottom-left concave fillet (smoothly joins BottomBar and Bar)
    Shape {
        visible: Config.enableFrameBars
        x: Config.leftBarWidth
        y: root.height - Config.bottomBarHeight - Config.cornerRadius
        width: Config.cornerRadius
        height: Config.cornerRadius
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            fillColor: Theme.bg
            strokeColor: "transparent"
            startX: 0
            startY: 0
            PathLine { x: 0; y: Config.cornerRadius }
            PathLine { x: Config.cornerRadius; y: Config.cornerRadius }
            PathArc {
                x: 0
                y: 0
                radiusX: Config.cornerRadius
                radiusY: Config.cornerRadius
                direction: PathArc.Clockwise
            }
        }
    }

    Item {
        anchors.fill: barBody
        anchors.topMargin: Config.enableFrameBars ? Math.max(12, Config.topBarHeight) : 12
        anchors.bottomMargin: Config.enableFrameBars ? Math.max(12, Config.bottomBarHeight) : 12
        anchors.leftMargin: 6
        anchors.rightMargin: 7

        // ================= Top Section (Launcher & Workspaces) =================
        Column {
            id: topSection
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            Launcher {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Tags {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            LayoutButton {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            FluoriteScratchpads {
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // ================= Center Section (Clock) =================
        Clock {
            id: centerSection
            anchors.centerIn: parent
        }

        // ================= Bottom Section (Status & Controls) =================
        Column {
            id: bottomSection
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            Tray {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Media {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Volume {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Network {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Battery {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Notifications {
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Commands {
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
