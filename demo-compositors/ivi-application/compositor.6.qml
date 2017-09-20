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
                interactive: false
                Repeater {
                    model: shellSurfaces
                    ShellSurfaceItem {
                        shellSurface: modelData
                        onSurfaceDestroyed: shellSurfaces.remove(index)
                    }
                }
            }
            Drawer {
                id: drawer
                Component.onCompleted: open()
                width: win.width * 0.3
                height: win.height
                ListView {
                    anchors.fill: parent
                    model: shellSurfaces
                    delegate: ShellSurfaceItem {
                        shellSurface: modelData
                        sizeFollowsSurface: false
                        inputEventsEnabled: false
                        width: win.width * 0.3
                        height: win.height * 0.3
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                swipeView.currentIndex = index;
                                drawer.close();
                            }
                        }
                        Button {
                            text: "X"
                            anchors.right: parent.right
                            onClicked: modelData.surface.client.close();
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
