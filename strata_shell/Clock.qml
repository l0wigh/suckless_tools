import QtQuick
import Quickshell

Rectangle {
    id: root

    implicitWidth: 36
    implicitHeight: 46
    radius: 6
    readonly property bool hovered: mouse.containsMouse
    color: calendar.visible ? Theme.accent : (mouse.containsMouse ? Qt.alpha(Theme.fg, 0.14) : "transparent")
    scale: mouse.pressed ? 0.92 : 1

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 80; easing.type: Easing.OutQuad } }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Column {
        anchors.centerIn: parent
        spacing: 0

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "HH")
            color: calendar.visible ? Theme.bg : Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "mm")
            color: calendar.visible ? Qt.alpha(Theme.bg, 0.8) : Theme.accent
            font.family: Theme.fontFamily
            font.pixelSize: 14
            font.bold: true
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: calendar.toggle()
    }

    CalendarPopup {
        id: calendar
        anchorItem: root
    }
}
