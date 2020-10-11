#ifndef NETWORK_H
#define NETWORK_H

#include "QObject"
#include "QStringList"
#include "QtNetwork"
#include "wlanconnection.h"
#include "QQmlEngine"
#include "QJSEngine"

class Network : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList wlanList READ getWlanNetworks NOTIFY scanCompleted)
public:
    Network(QObject* parent = nullptr) : QObject(parent) { connect(this, SIGNAL(connectionSuccesful()), this, SLOT(saveWlanConnection()));
                                                         }
    ~Network(){}
    Q_INVOKABLE QStringList getIp(QString dev);
    Q_INVOKABLE QStringList getIpFromMemory(QString dev);
    Q_INVOKABLE void setIp(QString dev, QStringList ip);
    Q_INVOKABLE bool testNetwork();
    Q_INVOKABLE void checkNetwork();
public slots:
    Q_INVOKABLE QStringList getWlanNetworks();
    Q_INVOKABLE void scanWlanNetworks();
    Q_INVOKABLE void connectWlanNetwork(QString ssid, QString password);
    void saveWlanConnection();
    void enableDHCPWlan();
    void disableDHCPWlan();
    void enableDHCPWired();
    void disableDHCPWired();
signals:
    void scanCompleted();
    void WlanDHCPEnabled();
    void WlanDHCPDisabled();
    void WiredDHCPEnabled();
    void WiredDHCPDisabled();
    void wrongPassword();
    void connectionSuccesful();

private:
    QString lastSSID, lastPASS;
    QThread *wlanThread = new QThread();
    QStringList wlanList;
    QMap<QString, QVariant> wlanPassList;
    QString dhcpWlanPid = "/var/run/dhcpcd-wlan0.pid"
    , dhcpWiredPid = "/var/run/dhcpcd-eth0.pid";
    QProcess proDHCPwlan, proDHCPwired;
};

static QObject *networkProvider(QQmlEngine *engine, QJSEngine *scriptEngine){
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    Network *net = new Network();
    return net;
}

#endif // NETWORK_H
