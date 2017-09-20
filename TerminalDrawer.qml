import QtQuick 2.8
import QtQuick.Window 2.2
import QtWayland.Compositor 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Drawer {
    id: terminalDrawer
    width: parent.width / 2
    onOpened: terminalLauncher.takeFocus()
    Shortcut { sequence: "F1"; onActivated: terminalDrawer.close() }
    background: IviApplicationLauncher {
        id: terminalLauncher
        color: "black"
        application: "konsole --profile qtws17"
        environment: ({QT_WAYLAND_DISABLE_WINDOWDECORATION: "1"})
    }
}
