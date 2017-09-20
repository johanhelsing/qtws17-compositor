import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Label {
    id: heading
    color: "black"
    font.pixelSize: 1.8 * settings.baseFontSize
    font.family: settings.fontFamily
    wrapMode: Text.WordWrap
    Layout.fillWidth: true
}
