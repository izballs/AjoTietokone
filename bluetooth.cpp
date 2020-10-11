#include "bluetooth.h"
#include <QBluetoothDeviceDiscoveryAgent>
#include "QDebug"
#include "QStringList"
#include "QBluetoothLocalDevice"
#include "QProcess"
#include "QSettings"

Bluetooth::Bluetooth()
{
    QBluetoothLocalDevice *localDevice = new QBluetoothLocalDevice();
    all_devices = localDevice->connectedDevices();
    printAllDevices();
    loadDevices();
}

void Bluetooth::printAllDevices(){
    qDebug() << "\n\n\nPRINT ALL DEVICES!\n\n";
    for(int i= 0; i < all_devices.count(); i++){
        qDebug() << all_devices.at(i);
    }
}

void Bluetooth::connectDevice(QString device){
    qDebug() << "ConnectDevice " << device;
    for(int i=0; i<m_pairedDevices.count(); i++){
        if(m_pairedDevices.at(i).name() == device){
            QProcess pro;
            QStringList args;
            qDebug() << "ConnectDevice " << m_pairedDevices.at(i).name();

            args << "-c" << "echo -e \"connect " + m_pairedDevices.at(i).address().toString() + " \nquit\" | bluetoothctl";
            pro.start("bash", args);
            pro.waitForFinished();
        }
    }
}

QStringList Bluetooth::listMusicDevices(){
    qDebug() << "listMusicDevices";
    QProcess proc;
    proc.start("bash", QStringList() << "-c" << "pactl list sources short | grep bluez_source");
    proc.waitForFinished();
    qDebug() << proc.readAllStandardError();
    QString stdout = proc.readAllStandardOutput();
    qDebug() << stdout;
    QStringList devices = stdout.split("\n");
    devices.pop_back();
    qDebug() << devices.count();
    for (int x = 0; x < devices.count(); x++){
        int index = devices[x].indexOf(".") + 1;
        devices[x] = devices[x].mid(index, 17);
        devices[x] = devices[x].replace(QString("_"), QString(":"));
        qDebug() << m_pairedDevices.count();
        for(int i = 0; i < m_pairedDevices.count(); i++){
            qDebug() << "before if: " << m_pairedDevices[i].name();
            if(m_pairedDevices[i].address().toString() == devices[x]){
                qDebug() << "inside if: " << m_pairedDevices[i].name();
                devices[x] = m_pairedDevices[i].name() + " " + devices[x];
            }
        }
    }
    for(int i = 0; i < devices.count(); i++){
        qDebug() << devices[i];
    }
    return devices;
}

void Bluetooth::startDeviceDiscovery(){

    // Create a discovery agent and connect to its signals
    QBluetoothDeviceDiscoveryAgent *discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    connect(discoveryAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this, SLOT(deviceDiscovered(QBluetoothDeviceInfo)));
    connect(discoveryAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this, SIGNAL(devDiscovered()));
    // Clear List

    m_devices.clear();

    // Start a discovery
    qDebug() << "starting discovery";
    discoveryAgent->start();

    //...
}




void Bluetooth::pairDevice(QString name){
    for(int i = 0; i < m_devices.count(); i++){
        if(m_devices.at(i).name() == name){
        QBluetoothLocalDevice *localDevice = new QBluetoothLocalDevice();
        connect(localDevice, SIGNAL(deviceConnected(QBluetoothAddress)),
                this, SIGNAL(deviceConnected()));
        connect(localDevice, SIGNAL(pairingFinished(QBluetoothAddress,QBluetoothLocalDevice::Pairing)),
                this, SLOT(pairingFinished()));
        localDevice->requestPairing(m_devices.at(i).address(), QBluetoothLocalDevice::Paired);
        temp_int = i;
        temp_device = m_devices.at(i);
        }
    }
}

void Bluetooth::unPairDevice(QString name){
    for(int i = 0; i < m_devices.count(); i++){
        if(m_devices.at(i).name() == name){
        QBluetoothLocalDevice *localDevice = new QBluetoothLocalDevice();
        connect(localDevice, SIGNAL(deviceDisconnected(QBluetoothAddress)),
                this, SIGNAL(deviceDisconnected()));
        localDevice->requestPairing(m_devices.at(i).address(), QBluetoothLocalDevice::Unpaired);

        }
    }
}

void Bluetooth::unPairAll(){
    QSettings settings;
    for(int i= 0; i < m_pairedDevices.count(); i++){
        QBluetoothLocalDevice *localDevice = new QBluetoothLocalDevice();
        localDevice->requestPairing(m_pairedDevices.at(i).address(), QBluetoothLocalDevice::Unpaired);
        m_pairedDevices.removeAt(i);
    }
    settings.setValue("pairedDevicesCount", 0);
    emit unPaired();
}

void Bluetooth::deviceDiscovered(const QBluetoothDeviceInfo &device)
{
    qDebug() << "Found new device:" << device.name() << '(' << device.address() << ')';
    if(!all_devices.contains(device.address()))
        m_devices << device;
    else
        m_pairedDevices << device;
}

QStringList Bluetooth::listDevices(){
    QStringList temp;
    if(!m_devices.isEmpty())
    {
        for(int i= 0; i< m_devices.count(); i++)
        {
            temp << m_devices.at(i).name();
        }
    }
    else
    temp << "No Devices Found";
    return temp;
}

QStringList Bluetooth::listPairedDevices(){
    QStringList temp;
    if(!m_pairedDevices.isEmpty())
    {
        for(int i= 0; i< m_pairedDevices.count(); i++)
        {
            temp << m_pairedDevices.at(i).name();
        }
    }
    else
    temp << "No Paired Devices Found";
    return temp;
}

void Bluetooth::pairingFinished(){
    qDebug() << "PairingFINISHED: " << temp_device.name();
    qDebug() << m_pairedDevices.count();
    m_pairedDevices.append(temp_device);
    savePaired();
    qDebug() << m_pairedDevices.count();
    all_devices.append(temp_device.address());
    qDebug() << "PairingFINISHED!!!\n\n\n\n\n\n\n\n\n";
    m_devices.removeAt(temp_int);
    emit pairFinished();
}

void Bluetooth::savePaired(){
    QSettings settings;
    qDebug() << "savePaired";
    settings.setValue("pairedDevicesCount", m_pairedDevices.count());
    for(int i = 0; i < m_pairedDevices.count(); i++){
        QString id = "m_pairedDevice" + (QString)i;
        settings.setValue(id + "_address", m_pairedDevices[i].address().toString());
        settings.setValue(id + "_name", m_pairedDevices[i].name());
        settings.setValue(id + "_classof", 0);
    }
}

void Bluetooth::loadDevices(){
    QSettings settings;
    int devCount = settings.value("pairedDevicesCount", 0).toInt();
    for(int i = 0; i < devCount; i++){
        QString id = "m_pairedDevice" + (QString)i;
        QBluetoothAddress add = (QBluetoothAddress)settings.value(id + "_address").toString();
        QString name = settings.value(id + "_name").toString();
        quint32 classof = settings.value(id + "_classof").toUInt();
        QBluetoothDeviceInfo dev = QBluetoothDeviceInfo(add, name, classof);
        m_pairedDevices.append(dev);
    }
}

void Bluetooth::ecuDevice(QString dev){
    ecu_device = (QBluetoothAddress)dev;
}

void Bluetooth::ds4Device(QString dev){
    ds4_device = (QBluetoothAddress)dev;

}
