import QtQuick 2.8
import QtQuick.Window 2.2
import QtWayland.Compositor 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: slide
    property string qmlfile: "minimal-compositor.qml"
    property string workingDirectory: settings.srcDir
    property alias title: heading.text

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
                Heading { id: heading; visible: text !== "" }
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
        QtShape {
            triangleColor: "white"
            color: "black"
            triangleWidth: 4 * settings.vh
            Layout.fillWidth: true
            Layout.fillHeight: true
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4 * settings.vw
                IviApplicationLauncher {
                    id: compositorLauncher
                    color: "gray"
                    Layout.preferredHeight: 0.65 * width
                    Layout.fillWidth: true
                    application: settings.qmlscene + " " + qmlfile
                    environment: ({
                        QT_WAYLAND_DISABLE_WINDOWDECORATION: "1",
                        QT_QUICK_CONTROLS_STYLE: "material"
                    })
                    workingDirectory: slide.workingDirectory
                    autoLaunch: false
                    Shortcut { enabled: slide.SwipeView.isCurrentItem; sequence: "f5"; onActivated: compositorLauncher.launch() }
                    QtShape {
                        enabled: false
                        anchors.fill: parent
                        triangleColor: "black"
                        triangleWidth: 2 * settings.vh
                    }
                }
                Heading {
                    color: "gray"
                    text: "Terminal output";
                    font.pixelSize: settings.baseFontSize
                    topPadding: 3 * settings.vh
                }
                ScrollView {
                    clip: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentWidth: width
                    Text {
                        width: parent.width
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: compositorLauncher.process ? compositorLauncher.process.standardError : ""
                        color: "#f3f3f4"
                        font.pixelSize: 0.5 * settings.baseFontSize
                        font.family: "Monospace"
                    }
                }
            }
        }
    }
}
