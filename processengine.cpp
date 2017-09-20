#include "processengine.h"

#include <QDebug>
#include <QQmlEngine>

ProcessEngine::ProcessEngine(QObject *parent)
    : QObject(parent)
{
}

Process *ProcessEngine::run(const QString &command, const QString &workingDirectory) {
    auto theProcess = new Process(this); // probably leaky?
    QProcessEnvironment env(QProcessEnvironment::systemEnvironment());
    env.remove("LD_LIBRARY_PATH");
    env.insert("QT_QPA_PLATFORM", "wayland-egl");
    env.insert("WAYLAND_DISPLAY", "wayland-qt-presentation");
    theProcess->setProcessEnvironment(env);
    if (!workingDirectory.isEmpty())
        theProcess->setWorkingDirectory(workingDirectory);
    theProcess->start(command);
    m_processes.append(theProcess);
    QQmlEngine::setObjectOwnership(theProcess, QQmlEngine::CppOwnership);
    return theProcess;
}

void ProcessEngine::killall()
{
    qDebug() << "Killing all processes";
    for (QProcess *process : qAsConst(m_processes)) {
        qDebug() << "Killing" << process->program() << "(" << process->processId() << ")";
        process->terminate();
    }
    m_processes.clear();
}
