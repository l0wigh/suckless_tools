pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    // ==========================================
    // Bar Geometry & Dimensions
    // ==========================================
    property int leftBarWidth: 54
    property int topBarHeight: 12
    property int bottomBarHeight: 12
    property int rightBarWidth: 12
    property int cornerRadius: 6
    readonly property int leftBarImplicitWidth: leftBarWidth + cornerRadius
    readonly property int rightBarImplicitWidth: rightBarWidth + cornerRadius

    // ==========================================
    // Bar Visibility & Frame Mode
    // ==========================================
    property bool enableLeftBar: true
    property bool enableFrameBars: true // Master toggle for Top, Bottom, Right framing bars & corner fillets

    readonly property bool enableTopBar: enableFrameBars
    readonly property bool enableBottomBar: enableFrameBars
    readonly property bool enableRightBar: enableFrameBars

    property int topBarDelay: 100
    property int bottomBarDelay: 150
    property int rightBarDelay: 200

    // ==========================================
    // Popout Settings
    // ==========================================
    property int popoutDefaultWidth: 300
    property int popoutDefaultHeight: 300
    property int popoutPadding: 14
    property int popoutCornerRadius: cornerRadius

    // ==========================================
    // Animations & Timing (ms)
    // ==========================================
    property int animDuration: 250
}
