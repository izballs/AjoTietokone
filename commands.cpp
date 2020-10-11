#include "commands.h"
#include "QProcess"
#include "QDebug"
#include "QSettings"
#include "QList"
#include "QStringList"
Commands::Commands()
{
}

void Commands::shutdown(){
    QProcess::execute("shutdown -P now");
}

void Commands::reboot(){
    QProcess::execute("reboot");
}

void Commands::saveLocation(QString name, QString adr, QString post, QString city){
    QSettings *set = new QSettings();
    QStringList stlist;
    stlist << name << adr << post << city;
    if(set->value("locCount").isNull()){
        set->setValue("location0", stlist);
        set->setValue("locCount", 1);
    }
    else
    {
        QString count = set->value("locCount").toString();
        set->setValue("location" + count , stlist);
        int cou = count.toInt();
        cou++;
        set->setValue("locCount", cou);
    }
}

QList<QStringList> Commands::getLocations(){
    QSettings *set = new QSettings();
    QList<QStringList> list;
    int count = set->value("locCount").toInt();
    for(int i = 0; i < count; i++)
        list.append(set->value("location"+QString::number(i)).toStringList());
    return list;
}
