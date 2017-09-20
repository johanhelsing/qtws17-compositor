import QtQuick 2.6
import QtQuick.Layouts 1.3

Rectangle {
    id: runner
    visible: false
    property string waylandDisplay: "wayland-0"
    Shortcut {
        sequence: "F2"
        onActivated: {
            runner.visible = true
            input.focus = true;
        }
    }
    color: Qt.rgba(0,0,0,0.4)
    ColumnLayout {
        spacing: settings.baseFontSize
        anchors.centerIn: parent
        Text {
            color: "white"
            text: "WAYLAND_DISPLAY=" + waylandDisplay
            Layout.alignment: Qt.AlignHCenter
        }
        TextInput {
            id: input
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 2 * settings.baseFontSize
            horizontalAlignment: TextInput.AlignHCenter
            onAccepted: {
                runner.visible = false;

                if (input.text === "k" || input.text === "killall") {
                    processEngine.killall();
                } else {
                    processEngine.run("env WAYLAND_DISPLAY=" + waylandDisplay + " " + input.text);
                }

                input.text = "";
            }
            Keys.onEscapePressed: {
                input.text = "";
                runner.visible = false;
            }
        }
    }
}
