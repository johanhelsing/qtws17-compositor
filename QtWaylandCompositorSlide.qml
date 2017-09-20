import QtQuick 2.8
import QtQuick.Window 2.2
import QtWayland.Compositor 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: slide
    property string qmlfile: "minimal-compositor.qml"
    property string workingDirectory: settings.srcDir
    property bool active: SwipeView.isCurrentItem || SwipeView.isNextItem

    function startOrKillClients() {
        if (active) {
            compositorLauncher.launch()
            editorLauncher.launch()
        } else {
            compositorLauncher.kill()
            editorLauncher.kill()
        }
    }

    onActiveChanged: startOrKillClients()

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

    RowLayout {
        anchors.fill: parent
        spacing: 0
        QtShape {
            color: "#f3f3f4"
            triangleWidth: settings.vh * 4
            triangleColor: "white"
            Layout.fillHeight: true
            Layout.fillWidth: true
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: settings.slideMargin
                spacing: 2 * settings.vh
                Heading { text: "Qt Wayland Compositor" }
                BulletPoint { text: "Qt APIs for writing a compositor" }
                IviApplicationLauncher {
                    id: editorLauncher
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    application: "nvim-qt --nofork " + qmlfile
                    environment: ({QT_WAYLAND_DISABLE_WINDOWDECORATION: "1"})
                    workingDirectory: slide.workingDirectory
                    autoLaunch: false
                }
            }
        }
        Rectangle {
            color: "#888"
            Layout.fillHeight: true
            Layout.fillWidth: true
            IviApplicationLauncher {
                id: compositorLauncher
                Shortcut { enabled: slide.SwipeView.isCurrentItem; sequence: "f5"; onActivated: compositorLauncher.launch() }
                x: image.height * 0.18
                y: image.height * 0.31
                width: image.width * 0.78
                height: image.width * 0.47
                application: settings.qmlscene + " " + qmlfile
                environment: ({QT_WAYLAND_DISABLE_WINDOWDECORATION: "1"})
                workingDirectory: slide.workingDirectory
                autoLaunch: false
            }
            Image {
                id: image
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: "imx6.png"
                enabled: false
            }
            QtShape {
                triangleColor: "white"
                anchors.fill: parent
                triangleWidth: settings.vh * 4
            }
        }
    }
}
