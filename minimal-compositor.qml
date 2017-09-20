import QtQuick 2.0
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2

WaylandCompositor {
    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
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
    WlShell {
        onWlShellSurfaceCreated: shellSurfaces.append({"shellSurface": shellSurface })
    }
    XdgShellV5 {
        onXdgSurfaceCreated: shellSurfaces.append({"shellSurface": xdgSurface })
    }
    XdgShellV6 {
        onToplevelCreated: shellSurfaces.append({"shellSurface": xdgSurface })
    }
}
