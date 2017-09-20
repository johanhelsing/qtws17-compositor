import QtQuick 2.7
import QtWayland.Compositor 1.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0

WaylandCompositor {
    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            id: win
            visible: true
            Grid {
                id: grid
                anchors.fill: parent
                columns: Math.ceil(Math.sqrt(shellSurfaces.count))
                property bool overview: true
                property int selected: 0
                property int selectedColumn: selected % columns
                property int selectedRow: selected / columns

                transform: [
                    Scale {
                        xScale: grid.overview ? (1.0/grid.columns) : 1
                        yScale: grid.overview ? (1.0/grid.columns) : 1
                        Behavior on xScale { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                        Behavior on yScale { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                    },
                    Translate {
                        x: grid.overview ? 0 : win.width * -grid.selectedColumn
                        y: grid.overview ? 0 : win.height * -grid.selectedRow
                        Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                        Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                    }
                ]

                Repeater {
                    model: shellSurfaces
                    Item {
                        width: win.width
                        height: win.height
                        WaylandQuickItem {
                            anchors.fill: parent
                            sizeFollowsSurface: false
                            surface: modelData.surface
                            onSurfaceDestroyed: shellSurfaces.remove(index)
                        }
                        MouseArea {
                            enabled: grid.overview
                            anchors.fill: parent
                            onClicked: {
                                grid.selected = index;
                                grid.overview = false;
                            }
                        }
                    }
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "Toggle overview";
                onClicked: grid.overview = !grid.overview
            }

            Shortcut { sequence: "space"; onActivated: grid.overview = !grid.overview }
            Shortcut { sequence: "right"; onActivated: grid.selected = Math.min(grid.selected+1, shellSurfaces.count-1) }
            Shortcut { sequence: "left"; onActivated: grid.selected = Math.max(grid.selected-1, 0) }
            Shortcut { sequence: "up"; onActivated: grid.selected = Math.max(grid.selected-grid.columns, 0) }
            Shortcut { sequence: "down"; onActivated: grid.selected = Math.min(grid.selected+grid.columns, shellSurfaces.count-1) }
        }
    }

    ListModel { id: shellSurfaces }

    WlShell {
        onWlShellSurfaceCreated: {
            shellSurfaces.append({shellSurface: shellSurface});
            shellSurface.sendConfigure(Qt.size(win.width, win.height), WlShellSurface.NoneEdge);
        }
    }
}
