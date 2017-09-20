#!/bin/bash
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
wiggly &
~/dev/qt/build/dev/qtdeclarative/examples/quick/demos/samegame/samegame &
~/dev/qt/build/dev/qtdeclarative/examples/quick/demos/photoviewer/photoviewer &
qmlscenedev ../../demo-apps/map.qml
