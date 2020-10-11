#ifndef COMMANDS_H
#define COMMANDS_H

#include "QObject"

class Commands : public QObject
{
    Q_OBJECT

public:
    Commands();
    Q_INVOKABLE void shutdown();
    Q_INVOKABLE void reboot();
    Q_INVOKABLE void saveLocation(QString name, QString adr, QString post, QString city);
    Q_INVOKABLE QList<QStringList> getLocations();
};

#endif // COMMANDS_H
