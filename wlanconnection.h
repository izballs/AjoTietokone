#ifndef WLANCONNECTION_H
#define WLANCONNECTION_H

#include "QString"
#include "QObject"
#include "QProcess"
class WlanConnection : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ssid READ getSSID WRITE setSSID)
    Q_PROPERTY(QString pass READ getPASS WRITE setPASS)

public:
    WlanConnection();
    QString getSSID();
    QString getPASS();
    void setSSID(QString s);
    void setPASS(QString p);

public slots:
    void connectToWlan();
    void disconnectWlan();
    void enableDHCP();
    void disableDHCP();

signals:
    void wrongPassword();
    void connectionSuccesful();

private:
    bool succesful;
    QString ssid;
    QString pass;
    QProcess pro;
    QString dhcpPid;

};

#endif // WLANCONNECTION_H
