#ifndef BLUETOOTH_H
#define BLUETOOTH_H

#include "QObject"
#include <QBluetoothDeviceDiscoveryAgent>
#include "QStringList"
#include <QBluetoothLocalDevice>
#include <QDebug>

class Bluetooth : public QObject
{
Q_OBJECT
public:
    Bluetooth();
    Q_INVOKABLE void startDeviceDiscovery();
    Q_INVOKABLE QStringList listDevices();
    Q_INVOKABLE void pairDevice(QString name);
    Q_INVOKABLE void unPairDevice(QString name);
    Q_INVOKABLE void unPairAll();
    Q_INVOKABLE QStringList listPairedDevices();
    Q_INVOKABLE void printAllDevices();
    Q_INVOKABLE void connectDevice(QString name);
    Q_INVOKABLE QStringList listMusicDevices();
    void savePaired();
    Q_INVOKABLE void loadDevices();
    Q_INVOKABLE void ecuDevice(QString dev);
    Q_INVOKABLE void ds4Device(QString dev);

public slots:
    void deviceDiscovered(const QBluetoothDeviceInfo &device);
    void pairingFinished();

signals:
    void devDiscovered();
    void deviceConnected();
    void deviceDisconnected();
    void pairFinished();
    void unPaired();

private:
    int temp_int;
    QBluetoothDeviceInfo temp_device;
    QBluetoothAddress ecu_device;
    QBluetoothAddress ds4_device;
    QList<QBluetoothAddress> all_devices;
    QList<QBluetoothDeviceInfo> m_devices;
    QList<QBluetoothDeviceInfo> m_pairedDevices;
};

#endif // BLUETOOTH_H
