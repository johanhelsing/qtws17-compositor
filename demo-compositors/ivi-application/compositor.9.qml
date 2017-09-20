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
            SwipeView {
                id: swipeView
                anchors.fill: parent
                Repeater {
                    model: shellSurfaces
                    ShellSurfaceItem {
                        shellSurface: modelData
                        onSurfaceDestroyed: shellSurfaces.remove(index)
                    }
                }
            }
            Component.onCompleted: drawer.open()
            Drawer {
                id: drawer
                width: win.width * 0.3
                height: win.height
                ListView {
                    anchors.fill: parent
                    model: shellSurfaces
                    spacing: 5
                    delegate: WaylandQuickItem {
                        inputEventsEnabled: false
                        sizeFollowsSurface: false
                        surface: modelData.surface
                        width: parent.width
                        height: win.height * 0.3
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                drawer.close()
                                swipeView.currentIndex = index;
                            }
                        }
                        Button {
                            text: "x"
                            anchors.right: parent.right
                            onClicked: modelData.surface.client.close()
                        }
                    }
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
