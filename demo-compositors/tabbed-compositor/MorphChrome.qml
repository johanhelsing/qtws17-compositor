import QtQuick 2.0
import QtWayland.Compositor 1.0

Item {
    id: chrome
    property alias shellSurface: ssItem.shellSurface
    property alias shellSurfaceItem: ssItem
    signal destroyAnimationFinished
    implicitWidth: ssItem.width
    implicitHeight: ssItem.height
    ShellSurfaceItem {
        id: ssItem
        visible: !morphAnimation.running
        onSurfaceDestroyed: {
            bufferLocked = true;
            morphAnimation.start();
        }
    }
    ShaderEffectSource {
        id: shaderSource
        sourceItem: ssItem
    }
    ShaderEffect {
        id: morphEffect
        visible: morphAnimation.running
        property real t: 0.0
        property variant source: shaderSource
        anchors.fill: ssItem
        transform: [
            Scale { id: scale; origin.x: ssItem.width / 2 },
            Rotation { id: rot; origin.x: ssItem.width / 2; origin.y: ssItem.height / 2 },
            Translate { id: trans; }
        ]
        fragmentShader: "
                #define PI 3.1415926535897932384626433832795
                uniform lowp sampler2D source;
                uniform lowp float t;
                uniform lowp float qt_Opacity;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    vec2 pos = qt_TexCoord0 * 2.0 - vec2(1.0);
                    float theta = atan(pos.y, pos.x);
                    float r = length(pos);
                    //a square in polar coordinates
                    float sqrR = r / cos(mod(theta + PI/4.0, PI/2.0) - PI/4.0);
                    float morphedR = mix(r, sqrR, t);
                    vec2 morphedPos = morphedR * vec2(cos(theta), sin(theta));
                    morphedPos = morphedPos / 2.0 + vec2(0.5);
                    lowp vec4 p = texture2D(source, morphedPos);
                    float clip = step(0.0, min(morphedPos.x, morphedPos.y)) * step(-1.0, -max(morphedPos.x, morphedPos.y));
                    gl_FragColor = p * qt_Opacity * clip;
                }"
    }
    SequentialAnimation {
        id: morphAnimation
        ParallelAnimation {
            NumberAnimation { target: morphEffect; property: "t"; to: 1; duration: 300; easing.type: Easing.InBack}
            NumberAnimation { target: scale; property: "xScale"; to: ssItem.height/ssItem.width; duration: 300; easing.type: Easing.InBack}
        }
        NumberAnimation { target: chrome; property: "scale"; to: 0.5; duration: 200; easing.type: Easing.OutBack}
        ParallelAnimation {
            NumberAnimation { target: trans; property: "x"; to: parent.width*2; duration: 1000; easing.type: Easing.InOutBack }
            NumberAnimation { target: rot; property: "angle"; to: parent.width/ssItem.height*360; duration: 1000; easing.type: Easing.InOutBack }
        }
        ScriptAction { script: { destroyAnimationFinished(); } }
    }
}
