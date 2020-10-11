#include "network.h"
#include <QtNetwork>
#include <QProcess>
#include <QDebug>
#include <QTimer>
#include <QThread>
#include <QNetworkConfigurationManager>
#include "wlanconnection.h"
#include "QSettings"
#include "QList"
#include "unistd.h"
void Network::connectWlanNetwork(QString ssid, QString password){
    if(wlanThread->isRunning()){
        qDebug() << "TERMINATING";
        wlanThread->quit();
        usleep(200);
    }
    lastSSID = ssid;
    lastPASS = password;
    qDebug() << ssid << password;
    WlanConnection *con = new WlanConnection();
    con->setPASS(password);
    con->setSSID(ssid);
    connect(wlanThread, SIGNAL(started()), con, SLOT(connectToWlan()));
    connect(wlanThread, SIGNAL(finished()), con, SLOT(deleteLater()));
    connect(con, SIGNAL(wrongPassword()), this, SIGNAL(wrongPassword()));
    connect(con, SIGNAL(connectionSuccesful()) ,this, SIGNAL(connectionSuccesful()));
    con->moveToThread(wlanThread);
    wlanThread->start();
}

void Network::scanWlanNetworks(){
    QStringList wifilist;
    QProcess pro, pro2;
    QStringList args;

    args << "-c" << "iwlist wlan0 scan | grep ESSID";
    while(true){
    pro.start("bash", args);
    pro.waitForFinished();

    while(pro.canReadLine())
    {
        QString line = QString::fromLocal8Bit( pro.readLine());
        wifilist << line.split("\"")[1];
    }
    if(pro.readAllStandardError().contains("Network is down"))
        pro2.execute("bash", QStringList() << "-c" << "ip link set wlan0 up");
    else
        break;
    }
    wlanList = wifilist;
    emit scanCompleted();
}

QStringList Network::getWlanNetworks(){
    return wlanList;
}

void Network::setIp(QString dev, QStringList ip){
    if(dev == "wlan0")
        disableDHCPWlan();
    else
        disableDHCPWired();
    QProcess pro;
    QStringList args;
    QString broadcast;
    QString network;
    QStringList ipaddr = ip[0].split(".");
    QStringList subnet = ip[1].split(".");
    int last = subnet[3].toInt();
    QString bits;

    network = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "0";
    switch(last){
    case 0:
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "255";
        bits = "24";
        break;
    case 128:
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "127";
        bits = "25";
        break;
    case 192:
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "63";
        bits = "26";
        break;
    case 224:
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "31";
        bits = "27";
        break;
    case 240:
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "15";
        bits = "28";
        break;
    case 248:
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "7";
        bits = "29";
        break;
    case 252:
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "3";
        bits = "30";
        break;
    case 254:
        bits = "31";
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "1";
        break;
    case 255:
        bits = "32";
        broadcast = ipaddr[0] + "." + ipaddr[1] + "." + ipaddr[2] + "." + "1";
        break;
    }
    args << "-c" << "ifconfig " + dev + " " + ip[0] + " netmask " + ip[1] + " broadcast " + broadcast;
    pro.start("bash", args);
    pro.waitForFinished();
    args.clear();
    args << "-c" << "ip route add " + network + "/" + bits + " dev " + dev;
    pro.start("bash", args);
    pro.waitForFinished();
    args.clear();
    args << "-c" << "ip route del default";
    pro.start("bash", args);
    pro.waitForFinished();
    args.clear();
    args << "-c" << "ip route add default via " + ip[2];
    pro.start("bash", args);
    pro.waitForFinished();
    QSettings set;
    set.setValue("ipList-" + dev, ip);
    set.setValue("lastUsedDev", dev);
}

QStringList Network::getIp(QString dev){
    QList<QNetworkAddressEntry> list = QNetworkInterface::interfaceFromName(dev).addressEntries();
    QStringList temp;
    if(list.isEmpty()){
        temp = getIpFromMemory(dev);
    }
    else
    {
    QProcess pro;
    QStringList args;
    args << "-c" << "ip route show default dev " + dev;
    pro.start("bash", args);
    pro.waitForFinished();

    QString gw = pro.readAllStandardOutput();
    gw = gw.right(gw.length()-12);
    gw = gw.left(gw.indexOf(" "));
    qDebug() << gw;
    for(int i = 0; i < list.count(); i++){
        qDebug() << list[i].ip();
        temp << list[i].ip().toString();
        temp << list[i].netmask().toString();
        temp << gw;
    }
    }
    return temp;
}

QStringList Network::getIpFromMemory(QString dev){
    QSettings set;
    return set.value("ipList-" + dev).toStringList();
}

void Network::saveWlanConnection(){
              wlanPassList[lastSSID].setValue(lastPASS);
              QSettings *set = new QSettings();
              set->setValue("wlanPassList", wlanPassList);
              set->setValue("lastWlan", lastSSID);
}

bool Network::testNetwork(){
    QProcess pro;
    QStringList args;
    args << "-c" << "ping -c 1 www.google.com";
    pro.start("bash", args);
    pro.waitForFinished();
    qDebug() << pro.readAllStandardError();
    if(pro.readAllStandardError().isEmpty())
        return true;
    else
        return false;
}

void Network::checkNetwork(){
    QSettings *settings = new QSettings();
    wlanPassList = settings->value("wlanPassList").toMap();
    QString dev = settings->value("lastUsedDev").toString();
    if(dev == "eth0"){
        if(settings->value("wiredDHCP") == true)
            qDebug() << "DHCP FOR ETH0!";
        else{
            setIp(dev, getIpFromMemory(dev));
        }
    }
    else if(dev == "wlan0"){
        qDebug() << "CHECK NETWORK WLAN0";
        QString ssid = settings->value("lastWlan").toString();
        QString pass = wlanPassList[ssid].toString();
        connectWlanNetwork(ssid, pass);
        qDebug() << "wirelessDHCP checking";
        if(settings->value("wirelessDHCP") == true)
            qDebug() << "DHCP FOR WLAN0!";
        else
            setIp(dev, getIpFromMemory(dev));
    }
}

void Network::enableDHCPWlan(){
    QSettings set;
    set.setValue("wirelessDHCP", true);
    proDHCPwlan.execute("bash", QStringList() << "-c" << "pkill -F " + dhcpWlanPid);
    proDHCPwlan.execute("bash", QStringList() << "-c" << "dhcpcd -P wlan0");
    proDHCPwlan.start("bash", QStringList() << "-c" << "dhcpcd -b wlan0");
    emit WlanDHCPEnabled();
}

void Network::disableDHCPWlan(){
    QSettings set;
    set.setValue("wirelessDHCP", false);

    proDHCPwlan.execute("bash", QStringList() << "-c" << "pkill -F " + dhcpWlanPid);

    dhcpWlanPid.clear();
    emit WlanDHCPDisabled();
}

void Network::enableDHCPWired(){
    QSettings set;
    set.setValue("wiredDHCP", true);
    proDHCPwired.execute("bash", QStringList() << "-c" << "pkill -F " + dhcpWiredPid);
    proDHCPwired.execute("bash", QStringList() << "-c" << "dhcpcd -P eth0");
    proDHCPwired.start("bash", QStringList() << "-c" << "dhcpcd -b eth0");

    emit WiredDHCPEnabled();
}

void Network::disableDHCPWired(){
    QSettings set;
    set.setValue("wiredDHCP", false);
    proDHCPwired.execute("bash", QStringList() << "-c" << "pkill -F " + dhcpWiredPid);
    emit WiredDHCPDisabled();
}
