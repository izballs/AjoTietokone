#include "wlanconnection.h"
#include "QStringList"
#include "QProcess"
#include "QDebug"
#include "QSettings"
WlanConnection::WlanConnection()
{

}

void WlanConnection::connectToWlan(){
    QStringList args;
    if(pro.state() == QProcess::Running){
        pro.close();
    }
    qDebug() << "ConnectToWlan()";
    qDebug() << "ssid=" << ssid << " pass=" << pass;
    QString wpas = "wpa_supplicant -i wlan0 -c <(wpa_passphrase \"" + ssid + "\" \"" + pass + "\")";
    qDebug() << wpas;
    args << "-c" << wpas;
    qDebug() << args;
    pro.start("bash", args);
    bool loop = true;
    while(loop){
    pro.waitForFinished(100);
    while(pro.canReadLine()){
        QString line = QString::fromLocal8Bit(pro.readLine());
        qDebug() << line ;
        if(line.contains("wlan0: WPA: Key negotiation completed with"))
        {
            qDebug() << "SSSSSSSSSS" << "SUCCESFUL!" << "SSSSSSSSS";
            emit connectionSuccesful();
            loop = false;
            break;
        }
        if(line == "wlan0: WPA: 4-Way Handshake failed - pre-shared key may be incorrect\n"){
            qDebug() << "WWWWWWWWWW" << "WRONG PASSWORD" << "WWWWWWWWWW";
            emit wrongPassword();
            loop = false;
            break;
            }
        }
    }
    QSettings set;
    set.setValue("lastUsedDev", "wlan0");
}

void WlanConnection::enableDHCP(){
    QProcess pr;
    if(!dhcpPid.isEmpty()){
    pr.execute("bash", QStringList() << "-c" << "kill " + dhcpPid);
    }
    pr.start("bash", QStringList() << "-c" << "dhcpcd wlan0");
    while(true){
    pr.waitForFinished(100);
    if(pr.canReadLine()){
    QString line = QString::fromLocal8Bit(pr.readLine());
    qDebug() << line;
    if(line.contains("child pid")){
        line = line.left(line.length()-2);
        dhcpPid = line.right(line.length() - 32);
        qDebug() << dhcpPid;
        break;
    }
    }
    }
}

void WlanConnection::disableDHCP(){
    if(!dhcpPid.isEmpty()){
    QProcess pro;
    pro.execute("bash", QStringList() << "-c" << "kill " + dhcpPid);
    }
    dhcpPid.clear();
}

void WlanConnection::disconnectWlan(){
    pro.kill();
    qDebug() << "process killed!";
}

void WlanConnection::setSSID(QString s){
    ssid = s;
}

void WlanConnection::setPASS(QString p){
    pass = p;
}

QString WlanConnection::getSSID(){
    return ssid;
}

QString WlanConnection::getPASS(){
    return pass;
}
