#ifndef PROCESSENGINE_H
#define PROCESSENGINE_H

#include <QObject>
#include <QVector>
#include <QProcess>

class Process : public QProcess {
    Q_OBJECT
    Q_PROPERTY(QString standardError READ standardError NOTIFY standardErrorChanged)
public:
    QString standardError() const { return m_stderr; }
    Process(QObject *parent = nullptr) : QProcess(parent) {
        connect(this, &QProcess::readyReadStandardError, [&](){
            m_stderr+=readAllStandardError();
            standardErrorChanged();
        });
    }
Q_SIGNALS:
    void standardErrorChanged();
private:
    QString m_stderr;
};

class ProcessEngine : public QObject {
    Q_OBJECT
public:
    ProcessEngine(QObject *parent = nullptr);
    Q_INVOKABLE Process *run(const QString &command, const QString &workingDirectory = "");
    Q_INVOKABLE void killall();
private:
    QVector<QProcess *> m_processes;
};

#endif // PROCESSENGINE_H
