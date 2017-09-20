import QtQuick 2.0
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

WaylandCompositor {
    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            id: win
            visible: true
            color: "gray"
            Repeater {
                model: shellSurfaces
                ShellSurfaceItem {
                    shellSurface: modelData
                    onSurfaceDestroyed: shellSurfaces.remove(index)
                }
            }
        }
    }
    ListModel { id: shellSurfaces }
    IviApplication {
        onIviSurfaceCreated: {
            shellSurfaces.append({shellSurface: iviSurface});
            iviSurface.sendConfigure(Qt.size(win.width, win.height));
        }
    }
}
