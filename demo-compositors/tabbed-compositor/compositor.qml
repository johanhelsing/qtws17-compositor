import QtQuick 2.0
import QtWayland.Compositor 1.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0

WaylandCompositor {
    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            visible: true
            Page {
                anchors.fill: parent
                header: TabBar {
                    id: tabBar
                    currentIndex: swipeView.currentIndex
                    Repeater {
                        model: shellSurfaces
                        TabButton {
                            text: modelData.title
                            WaylandQuickItem {
                                surface: modelData.surface
                                width: 32
                                height: 32
                                sizeFollowsSurface: false
                                enabled: false
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                            }
                            ToolButton {
                                anchors.right: parent.right
                                text: "x"
                                onClicked: modelData.surface.client.close()
                            }
                        }
                    }
                }

                SwipeView {
                    id: swipeView
                    currentIndex: tabBar.currentIndex
                    anchors.fill: parent
                    Repeater {
                        model: shellSurfaces
                        MorphChrome {
                            shellSurface: modelData
                            onDestroyAnimationFinished: shellSurfaces.remove(index)
                        }
                    }
                }
            }
        }
    }

    ListModel { id: shellSurfaces }

    WlShell {
        onWlShellSurfaceCreated: {
            shellSurfaces.append({shellSurface: shellSurface});
            shellSurface.sendConfigure(Qt.size(swipeView.width, swipeView.height), WlShellSurface.NoneEdge)
        }
    }
}
