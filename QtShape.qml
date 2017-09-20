import QtQuick 2.8
import QtQuick.Shapes 1.0

Rectangle {
    id: shape
    property int triangleWidth: shape.width/16
    property color triangleColor: "#41cd52"
    color: "transparent"

    Shape {
        anchors.fill: parent
        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: shape.triangleColor
            startX: 0; startY: 0
            PathLine { x: shape.triangleWidth; y: 0 }
            PathLine { x: 0; y: shape.triangleWidth }
        }
        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: shape.triangleColor
            startX: shape.width; startY: shape.height
            PathLine { x: shape.width - shape.triangleWidth; y: shape.height }
            PathLine { x: shape.width; y: shape.height - shape.triangleWidth }
        }
    }
}
