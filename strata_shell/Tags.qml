import QtQuick

Item {
    id: root
    implicitWidth: 32
    implicitHeight: tagCol.implicitHeight

    WheelHandler {
        onWheel: ev => Wm.cycleTag(ev.angleDelta.y > 0 ? -1 : 1)
    }

    Column {
        id: tagCol
        spacing: 6
        anchors.centerIn: parent

        Repeater {
            model: Math.min(Wm.tagCount, 10)

            Rectangle {
                id: tag
                required property int index
                readonly property bool selected: (Wm.seltags & (1 << index)) !== 0
                readonly property bool occupied: (Wm.occtags & (1 << index)) !== 0
                readonly property bool urgent: (Wm.urgtags & (1 << index)) !== 0
                readonly property bool hovered: mouseArea.containsMouse && !selected

                anchors.horizontalCenter: parent.horizontalCenter
                width: selected ? 8 : (occupied || hovered) ? 8 : 5
                height: selected ? 22 : hovered ? 16 : occupied ? 8 : 5
                radius: width / 2

                color: urgent ? Theme.red
                     : selected ? Theme.accent
                     : hovered ? (occupied ? Qt.alpha(Theme.fg, 0.9) : Qt.alpha(Theme.fg, 0.5))
                     : occupied ? Qt.alpha(Theme.fg, 0.7)
                     : Qt.alpha(Theme.fg, 0.22)

                Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 180 } }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    anchors.margins: -4
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onClicked: m => {
                        if (m.button === Qt.MiddleButton)
                            Wm.sendToTag(tag.index)
                        else
                            Wm.viewTag(tag.index)
                    }
                }
            }
        }
    }
}
