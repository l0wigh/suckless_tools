import QtQuick
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
        top: 10
        bottom: 10
        left: 10
    }
    implicitWidth: 54
    color: "transparent"
    visible: Theme.barStateReady

    // 6px rounded solid background without border
    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        radius: 6
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: 12
        anchors.bottomMargin: 12
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
