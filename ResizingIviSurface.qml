import QtQuick 2.8
import QtWayland.Compositor 1.0

ShellSurfaceItem {
    property IviSurface iviSurface: modelData
    sizeFollowsSurface: false
    onWidthChanged: handleResize()
    onHeightChanged: handleResize()
    Component.onCompleted: handleResize()
    function handleResize() {
        iviSurface.sendConfigure(Qt.size(width, height))
    }
}
