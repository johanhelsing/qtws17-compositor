import QtQuick 2.8
import QtQuick.Window 2.2
import QtWayland.Compositor 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: slide
    property string qmlfile: "main.qml"
    property string workingDirectory: settings.srcDir
    property alias compositorApplication: compositorLauncher.application

    function killOrLaunch() {
        if (SwipeView.isCurrentItem) {
            editorLauncher.launch();
            compositorLauncher.launch();
        } else {
            editorLauncher.kill();
            compositorLauncher.kill();
        }
    }

    SwipeView.onIsCurrentItemChanged: killOrLaunch()
    Component.onCompleted: killOrLaunch()

    Shortcut {
        enabled: slide.SwipeView.isCurrentItem
        sequence: "f6"
        onActivated: {
            var environment = {
                WAYLAND_DISPLAY: "wayland-0",
                QT_WAYLAND_DISABLE_WINDOWDECORATION: "0"
            };
            rootCompositor.runApplication("./run-apps.sh", environment, workingDirectory);
        }
    }

    Shortcut { sequence: "f3"; onActivated: editorDrawer.open() }
    Drawer {
        id: editorDrawer
        width: parent.width / 2
        height: parent.height
        onOpened: editorLauncher.takeFocus()
        Shortcut { sequence: "f3"; onActivated: editorDrawer.close() }
        background: IviApplicationLauncher {
            id: editorLauncher
            color: "black"
            application: "nvim-qt --nofork " + qmlfile
            environment: ({QT_WAYLAND_DISABLE_WINDOWDECORATION: "1"})
            workingDirectory: slide.workingDirectory
        }
    }

    IviApplicationLauncher {
        id: compositorLauncher
        color: "gray"
        anchors.fill: parent
        application: settings.qmlscene + " " + qmlfile
        environment: ({
                          QT_WAYLAND_DISABLE_WINDOWDECORATION: "1",
                          QT_QUICK_CONTROLS_STYLE: "material"
                      })
        workingDirectory: slide.workingDirectory
        autoLaunch: false
        Shortcut { enabled: slide.SwipeView.isCurrentItem; sequence: "f5"; onActivated: compositorLauncher.launch() }
    }
}
