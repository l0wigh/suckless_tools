import QtQuick
import QtQuick.Shapes
import Quickshell

// Shared shell for every bar popup: a fullscreen transparent catcher
// window with the styled card anchored under its bar item. Clicking
// anywhere outside the card closes it; Escape too (when X grants the
// popup key focus). All popups use this, so chrome and behavior stay
// identical.
// Without a compositor the "transparent" catcher would render opaque
// black — blacking out the whole screen — so when picom isn't running
// (Sys.composited) the window degrades to card-only: same card, same
// spot, no catcher. Click-outside close is lost in that mode; Escape
// and the module's own toggle still close.
// Note: spans the primary screen — revisit offsets if a second monitor
// ever joins.
PopupWindow {
    id: root

    property Item anchorItem
    property real cardWidth: 300
    property real cardHeight: 300
    readonly property real cardPadding: 14
    // right-edge panel mode (control center) instead of centered-under-anchor
    property bool alignRight: false

    readonly property bool catcher: Sys.composited

    default property alias content: inner.data

    visible: false
    color: "transparent"

    property bool openOnHover: true
    property bool pinned: false

    property bool cardHovered: false
    readonly property bool anchorHovered: anchorItem?.hovered ?? false
    readonly property bool isHovered: cardHovered || anchorHovered
    readonly property bool isAtTop: card.isAtTop
    readonly property bool isAtBottom: card.isAtBottom

    anchor.item: anchorItem
    // catcher mode: stretch the window over the screen from the bar edge (x: 64)
    // so the bar itself is never obstructed by the catcher
    anchor.rect.x: catcher ? (anchorItem ? 58 - anchorItem.mapToGlobal(0, 0).x : 58)
                           : (anchorItem?.width ?? 0) + 12
    anchor.rect.y: catcher ? (anchorItem ? -anchorItem.mapToGlobal(0, 0).y : 0)
                           : 0
    implicitWidth: catcher
        ? (Quickshell.screens.length ? Quickshell.screens[0].width - 58 : 1920 - 58)
        : cardWidth
    implicitHeight: catcher
        ? (Quickshell.screens.length ? Quickshell.screens[0].height : 1080)
        : cardHeight

    // anchor's global position, captured at open time
    property real ax: 0
    property real ay: 0
    property bool closing: false

    Timer {
        id: openTimer
        interval: Popouts.hasActive ? 0 : 90
        onTriggered: {
            if (openOnHover && anchorHovered && !visible) {
                root.open()
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 220
        onTriggered: {
            if (!pinned && !root.isHovered && visible) {
                root.close()
            }
        }
    }

    Connections {
        target: anchorItem ? anchorItem : null
        function onHoveredChanged() {
            if (!openOnHover) return
            if (anchorItem && anchorItem.hovered) {
                closeTimer.stop()
                if (Popouts.hasActive) {
                    root.open()
                } else {
                    openTimer.restart()
                }
            } else {
                openTimer.stop()
                if (visible && !pinned) {
                    closeTimer.restart()
                }
            }
        }
    }

    function open() {
        if (visible && !closing) return
        if (closing) {
            exitAnim.stop()
            closing = false
        }
        visible = true
        Popouts.register(root)
    }

    function close() {
        if (!visible || closing) return
        pinned = false
        closing = true
        openTimer.stop()
        closeTimer.stop()
        enterAnim.stop()
        exitAnim.restart()
    }

    function toggle() {
        if (visible && !closing) {
            if (!pinned) {
                pinned = true
            } else {
                close()
            }
        } else {
            pinned = true
            open()
        }
    }

    onVisibleChanged: {
        if (visible) {
            closing = false
            if (anchorItem) {
                const p = anchorItem.mapToGlobal(0, 0)
                ax = p.x
                ay = p.y
            }
            inner.forceActiveFocus()
            exitAnim.stop()
            enterAnim.restart()
        } else {
            Popouts.unregister(root)
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    Item {
        id: clipContainer
        x: 0
        y: 0
        width: root.width
        height: root.height
        clip: true

        Rectangle {
            id: card

            readonly property real screenH: Quickshell.screens.length ? Quickshell.screens[0].height : 1200
            readonly property real minY: 10
            readonly property real maxY: screenH - 10 - height
            readonly property bool isAtBottom: y >= maxY - 1
            readonly property bool isAtTop: y <= minY + 1

            x: root.catcher ? 6 : 0
            y: !root.catcher ? 0
             : Math.max(minY, Math.min(maxY, root.ay + (root.anchorItem?.height ?? 0) / 2 - height / 2))

            transform: Translate { id: slide; x: 0 }

            readonly property alias enterAnim: enterAnim
            readonly property alias exitAnim: exitAnim

            ParallelAnimation {
                id: enterAnim
                NumberAnimation {
                    target: slide
                    property: "x"
                    from: -24
                    to: 0
                    duration: 180
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: card
                    property: "opacity"
                    from: 0.0
                    to: 1.0
                    duration: 160
                    easing.type: Easing.OutQuad
                }
            }

            ParallelAnimation {
                id: exitAnim
                NumberAnimation {
                    target: slide
                    property: "x"
                    to: -24
                    duration: 140
                    easing.type: Easing.InCubic
                }
                NumberAnimation {
                    target: card
                    property: "opacity"
                    to: 0.0
                    duration: 130
                    easing.type: Easing.InQuad
                }
                onFinished: {
                    root.visible = false
                    root.closing = false
                    slide.x = 0
                    card.opacity = 1.0
                }
            }
            width: root.cardWidth
            height: root.cardHeight
            topLeftRadius: !root.catcher ? 6 : 0
            bottomLeftRadius: !root.catcher ? 6 : 0
            topRightRadius: 6
            bottomRightRadius: 6
            color: Theme.bg

            // Top concave connector to sidebar (with 1px overlap to eliminate seam)
            Shape {
                visible: root.catcher && !card.isAtTop
                anchors.bottom: parent.top
                anchors.bottomMargin: -1
                anchors.left: parent.left
                width: 6
                height: 7
                layer.enabled: true
                layer.samples: 4
                ShapePath {
                    fillColor: Theme.bg
                    strokeColor: "transparent"
                    startX: 0; startY: 7
                    PathLine { x: 6; y: 7 }
                    PathLine { x: 6; y: 6 }
                    PathArc {
                        x: 0; y: 0
                        radiusX: 6; radiusY: 6
                        direction: PathArc.Clockwise
                    }
                    PathLine { x: 0; y: 7 }
                }
            }

            // Bottom concave connector to sidebar (with 1px overlap to eliminate seam)
            Shape {
                visible: root.catcher && !card.isAtBottom
                anchors.top: parent.bottom
                anchors.topMargin: -1
                anchors.left: parent.left
                width: 6
                height: 7
                layer.enabled: true
                layer.samples: 4
                ShapePath {
                    fillColor: Theme.bg
                    strokeColor: "transparent"
                    startX: 0; startY: 0
                    PathLine { x: 6; y: 0 }
                    PathLine { x: 6; y: 1 }
                    PathArc {
                        x: 0; y: 7
                        radiusX: 6; radiusY: 6
                        direction: PathArc.Counterclockwise
                    }
                    PathLine { x: 0; y: 0 }
                }
            }

            // Bottom corner patch: bridges into the bar's rounded bottom-right corner
            Rectangle {
                visible: root.catcher && card.isAtBottom
                anchors.right: parent.left
                anchors.bottom: parent.bottom
                width: 6
                height: 6
                color: Theme.bg
            }

            // Top corner patch: bridges into the bar's rounded top-right corner
            Rectangle {
                visible: root.catcher && card.isAtTop
                anchors.right: parent.left
                anchors.top: parent.top
                width: 6
                height: 6
                color: Theme.bg
            }

            Behavior on color { ColorAnimation { duration: 250 } }

            HoverHandler {
                id: cardHover
                onHoveredChanged: {
                    root.cardHovered = hovered
                    if (hovered) {
                        closeTimer.stop()
                    } else if (visible && !pinned && !anchorHovered) {
                        closeTimer.restart()
                    }
                }
            }

            // swallow card clicks so they don't fall through to the catcher
            MouseArea {
                anchors.fill: parent
            }

            Item {
                id: inner
                anchors.fill: parent
                anchors.margins: root.cardPadding
                clip: true
                focus: true
                Keys.onEscapePressed: root.close()
            }
        }
    }
}
