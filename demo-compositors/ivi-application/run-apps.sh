#!/bin/bash
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_WAYLAND_SHELL_INTEGRATION=ivi-shell
unset QT_IVI_SURFACE_ID
wiggly &
qmlscenedev ../../demo-apps/map.qml &
~/dev/qt/build/dev/qtdeclarative/examples/quick/demos/samegame/samegame &
~/dev/qt/build/dev/qtdeclarative/examples/quick/demos/photoviewer/photoviewer
#env QT_IVI_SURFACE_ID=1338 wiggly &
#env QT_IVI_SURFACE_ID=1337 qmlscenedev ../../demo-apps/map.qml
