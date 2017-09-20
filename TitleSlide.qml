import QtQuick 2.8

Item {
    id: titleSlide
    Column {
        anchors.centerIn: parent
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 3 * settings.baseFontSize
            font.family: settings.fontFamily
            text: "Qt Wayland Compositor"
        }
        Text {
            topPadding: 0 * settings.vh
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 1.3 * settings.baseFontSize
            font.family: settings.fontFamily
            wrapMode: Text.WordWrap
            text: "Creating your own multi-process user interface"
        }
        Text {
            topPadding: 3 * settings.vh
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 0.8 * settings.baseFontSize
            font.family: settings.fontFamily
            text: "Johan Helsing"
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 0.8 * settings.baseFontSize
            font.family: settings.fontFamily
            color: "#41cd52"
            text: "johan.helsing@qt.io"
        }
    }
}
