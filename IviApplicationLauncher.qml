import QtQuick 2.8
import QtQuick.Window 2.2
import QtWayland.Compositor 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtWS17Compositor 1.0

Rectangle {
    id: launcher
    color: "transparent"
    property string application: "wiggly"
    property variant environment: ({})
    property IviSurface iviSurface
    property int iviId: -1
    property bool autoLaunch: true
    property ResizingIviSurface shellSurfaceItem
    property Process process
    property string workingDirectory
    
    function launch() {
        kill();
        if (iviId === -1) iviId = iviApplication.getUniqueIviId();
        environment.QT_WAYLAND_SHELL_INTEGRATION = environment.QT_WAYLAND_SHELL_INTEGRATION || "ivi-shell";
        environment.QT_IVI_SURFACE_ID = environment.QT_IVI_SURFACE_ID || iviId;
        process = rootCompositor.runApplication(application, environment, workingDirectory);
    }

    function kill() {
        if (iviSurface) {
            iviSurface.surface.client.close();
            iviSurface = null;
        }
        if (process) {
            process.kill();
            process = null;
        }
    }

    function takeFocus() {
        if (shellSurfaceItem) {
            shellSurfaceItem.takeFocus();
        }
    }

    Component.onCompleted: if (autoLaunch) launch();

    Connections {
        target: iviApplication
        onIviSurfaceCreated: {
            if (iviSurface.iviId === iviId) {
                launcher.iviSurface = iviSurface;
            }
        }
    }

    Text {
        text: process ? process.standardError : ""
        font.pixelSize: 0.5 * settings.baseFontSize
        wrapMode: Text.WordWrap
        anchors.fill: parent
        font.family: "Monospace"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: launch()
    }

    Repeater {
        id: repeater
        model: iviSurface
        onItemAdded: shellSurfaceItem = item
        onItemRemoved: shellSurfaceItem = null
        ResizingIviSurface {
            id: surfaceItem
            anchors.fill: parent
            shellSurface: iviSurface
        }
    }
}
