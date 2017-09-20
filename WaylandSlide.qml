import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
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
                Heading { text: "Wayland" }
                BulletPoint { text: "Modern X Window System replacement" }
                BulletPoint { text: "Wayland clients pass their graphics buffers on to a compositor process for displaying it on the screen" }
                Spacer {}
            }
        }
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Image {
                height: 60 * settings.vh
                width: 60 * settings.vh
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                source: "wayland.svg"
                sourceSize: Qt.size(1080, 1080)
            }
        }
    }
}
