import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Text {
    id: bulletPoint
    Layout.fillWidth: true
    font.pixelSize: settings.baseFontSize
    wrapMode: Text.WordWrap
    text: "lorem ipsum"
    font.family: settings.fontFamily
}
