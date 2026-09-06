pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property var list: []
    readonly property int count: list.length

    property var popups: []
    signal notificationArrived(var item)

    NotificationServer {
        id: server

        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notif => {
            notif.tracked = true

            const item = {
                notifObj: notif,
                id: notif.id,
                summary: notif.summary || "Notification",
                body: notif.body || "",
                appName: notif.appName || "System",
                appIcon: notif.appIcon || "",
                urgency: notif.urgency,
                time: new Date()
            }

            // Connect closed signal from sender
            notif.closed.connect(reason => {
                root.list = root.list.filter(n => n.id !== item.id)
                root.popups = root.popups.filter(n => n.id !== item.id)
            })

            // Add to history (newest first)
            root.list = [item, ...root.list]

            root.notificationArrived(item)
        }
    }

    function dismiss(item) {
        if (!item) return
        try { item.notifObj?.dismiss() } catch(e) {}
        root.list = root.list.filter(n => n !== item)
        root.popups = root.popups.filter(n => n !== item)
    }

    function dismissPopup(item) {
        root.popups = root.popups.filter(n => n !== item)
    }

    function clearAll() {
        for (const item of root.list) {
            try { item.notifObj?.dismiss() } catch(e) {}
        }
        root.list = []
        root.popups = []
    }
}
