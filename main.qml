import QtQuick 2.8
import QtQuick.Window 2.2
import QtWayland.Compositor 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

WaylandCompositor {
    id: rootCompositor
    socketName: "wayland-qt-presentation"
    ListModel { id: shellSurfaces }

    function runApplication(application, environment, workingDirectory) {
        environment = environment || {};
        environment.WAYLAND_DISPLAY = environment.WAYLAND_DISPLAY || rootCompositor.socketName;
        var cmd = "";
        for (var envVar in environment) {
            cmd += "env " + envVar + "=" + environment[envVar] + " ";
        }
        cmd += application;
        console.log("Running command: " + cmd);
        return processEngine.run(cmd, workingDirectory || settings.srcDir);
    }

    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            id: presentationWindow
            Shortcut { sequence: "ctrl+f"; onActivated: presentationWindow.toggleFullscreen() }
            function toggleFullscreen() {
                visibility = visibility === Window.FullScreen ? Window.AutomaticVisibility : Window.FullScreen;
            }
            QtObject {
                id: settings
                property real vw: presentationWindow.width / 100.0
                property real vh: presentationWindow.height / 100.0
                property real baseFontSize: 4 * vh
                property string fontFamily: "Titillium web" //TODO
                property real slideMargin: 5 * settings.vh
                property string qmlscene: "/home/johan/dev/qt/build/dev/qtbase/bin/qmlscene"
                property string srcDir: "/home/johan/dev/qtws17-compositor/"
            }
            visible: true
            width: 1920
            height: 1080
            title: "Qt World Summit 2017 Compositor - " + rootCompositor.socketName
            SwipeView {
                id: deck
                anchors.fill: parent
                interactive: false // use keyboard to switch slides instead
                Shortcut { sequence: "ctrl+left"; onActivated: deck.decrementCurrentIndex() }
                Shortcut { sequence: "ctrl+right"; onActivated: deck.incrementCurrentIndex() }
                //currentIndex: 6
                TitleSlide { }
                WaylandSlide { }
                QtWaylandCompositorSlide {
                    workingDirectory: settings.srcDir + "demo-compositors/minimal/"
                    qmlfile: "compositor.qml"
                }
                NiceEditorSlide {
                    workingDirectory: settings.srcDir + "demo-compositors/shell-extensions/"
                    qmlfile: "compositor.qml"
                    title: "Shell extensions"
                }
                NiceEditorSlide {
                    workingDirectory: settings.srcDir + "demo-compositors/ivi-application/"
                    qmlfile: "compositor.qml"
                    title: "Not a desktop"
                }
                NiceEditorSlide {
                    workingDirectory: settings.srcDir + "demo-compositors/overview-compositor/"
                    qmlfile: "compositor.qml"
                    title: "Example: App overview"
                }
                NiceEditorSlide {
                    workingDirectory: settings.srcDir + "demo-compositors/tabbed-compositor/"
                    qmlfile: "compositor.qml"
                    title: "Example: Tabs"
                }
                FullScreenCompositorSlide {
                    id: physicsCompositorSlide
                    workingDirectory: settings.srcDir + "demo-compositors/physics-compositor/"
                    qmlfile: "main.qml"
                    compositorApplication: "./build/physics-compositor"
                    Timer {
                        interval: 1000
                        repeat: true
                        running: physicsCompositorSlide.SwipeView.isCurrentItem
                        onTriggered: {
                            var environment = {
                                WAYLAND_DISPLAY: "wayland-0",
                                QT_WAYLAND_DISABLE_WINDOWDECORATION: "0"
                            };
                            rootCompositor.runApplication("wiggly", environment);
                        }
                    }
                    BulletPoint {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: parent.height * 0.77
                        text: "#qt-lighthouse on freenode"
                    }
                    BulletPoint {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: parent.height * 0.82
                        text: "johan.helsing@qt.io"
                    }
                    BulletPoint {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: parent.height * 0.87
                        text: "github.com/johanhelsing/qtws17-compositor"
                    }
                }
            }
            QtShape {
                enabled: false
                anchors.fill: parent
                triangleWidth: settings.vh * 4
            }
            Runner { anchors.fill: parent }
            Shortcut { sequence: "F1"; onActivated: terminalDrawer.open() }
            TerminalDrawer {
                id: terminalDrawer
                height: parent.height
            }
        }
    }

    WlShell {
        onWlShellSurfaceCreated: {
            console.log("rootCompositor wlShellSurfaceCreated", shellSurface)
            shellSurfaces.append({shellSurface: shellSurface})
        }
    }

    IviApplication {
        id: iviApplication
        property int nextIviId: 1337
        function getUniqueIviId() { return nextIviId++; }
    }
}
