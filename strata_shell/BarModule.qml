import QtQuick

// Base pill for bar modules: optional nerd-font icon + label, hover feedback,
// click/scroll signals. Extra content can be added as children.
Rectangle {
    id: root

    property string icon: ""
    property color iconColor: Theme.accent
    // some glyphs (e.g. Font Logos ) are missing from JetBrainsMono NF here
    property string iconFont: Theme.iconFontFamily
    property string label: ""
    property color labelColor: Theme.fg
    property bool interactive: true
    readonly property bool hovered: mouse.containsMouse

    // No hover-expanding labels: the right cluster is right-anchored, so
    // a module growing on hover shifts its neighbors out from under the
    // cursor mid-aim. Labels are static or event-flashed (Volume) only;
    // details live in each module's popup/app.

    // progress underline along the pill bottom: 0..1 shows it, negative hides
    property real progress: -1
    property bool active: false
    property color activeColor: Theme.accent
    property color activeIconColor: Theme.bg
    property real pillRadius: 6

    signal clicked(var mouse)
    signal scrolled(int dir)

    default property alias extraContent: row.data

    implicitHeight: root.label !== "" ? row.implicitHeight + Math.round(10 * Theme.barScale) : Math.round(34 * Theme.barScale)
    implicitWidth: Math.round(34 * Theme.barScale)
    radius: pillRadius
    color: active ? activeColor
         : (mouse.containsMouse && interactive ? Qt.alpha(Theme.fg, 0.14) : "transparent")
    scale: mouse.pressed && interactive ? 0.92 : 1

    property int iconOffsetX: 0
    property int iconOffsetY: 0

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 80; easing.type: Easing.OutQuad } }

    Column {
        id: row
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: root.iconOffsetX
        anchors.verticalCenterOffset: root.iconOffsetY
        spacing: Math.round(2 * Theme.barScale)

        Text {
            visible: root.icon !== ""
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.icon
            color: root.active ? root.activeIconColor : root.iconColor
            font.family: root.iconFont
            font.pixelSize: Theme.iconSize
            Behavior on color { ColorAnimation { duration: 250 } }
        }

        Text {
            visible: root.label !== ""
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: root.active ? root.activeIconColor : root.labelColor
            font.family: Theme.fontFamily
            font.pixelSize: Math.round(Theme.fontSize * 0.9)
            Behavior on color { ColorAnimation { duration: 250 } }
        }
    }

    Rectangle {
        visible: root.progress >= 0
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: root.radius
        anchors.bottomMargin: 2
        height: 2
        radius: 1
        width: Math.min(Math.max(root.progress, 0), 1) * (parent.width - 2 * root.radius)
        color: Theme.accent
        opacity: 0.9
        Behavior on width { NumberAnimation { duration: 300 } }
    }

    property int badgeCount: 0
    property bool showBadge: badgeCount > 0

    Rectangle {
        visible: root.showBadge
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 2
        anchors.rightMargin: 2
        width: Math.max(14, badgeText.implicitWidth + 6)
        height: 14
        radius: 7
        color: root.active ? Theme.bg : Theme.accent
        Behavior on color { ColorAnimation { duration: 150 } }

        Text {
            id: badgeText
            anchors.centerIn: parent
            text: String(Math.min(99, root.badgeCount))
            color: root.active ? Theme.accent : Theme.bg
            font.family: Theme.fontFamily
            font.pixelSize: 9
            font.bold: true
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: m => root.clicked(m)
        onWheel: w => root.scrolled(w.angleDelta.y > 0 ? 1 : -1)
    }
}
