import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import Qt.labs.folderlistmodel 2.1
import PLAYER 1.0
    Rectangle{
        width: 600
        height: 380
        color: "transparent";
    Text{
        y:50;
        text: "Bluetooth Settings"
    }
    Bluetooth{
        id:bluetooth;
        Component.onCompleted: pairedList.model = this.listPairedDevices();
        onDevDiscovered: { if(!pairingList.model === "undefined") pairingList.model.clear(); pairingList.model = this.listDevices(); console.log(pairingList.count)   }
        onUnPaired: { pairingList.model = this.listDevices(); pairedList.model = this.listPairedDevices();}
        onDeviceConnected: {
            var button = pairingList.children[pairingList.currentIndex].children[0].children[0].children[1];
            button.text = "pairing";
            button.enabled = false;
        }
        onPairFinished: {
            console.log("Pairing Finished!!!\n\n\n\n\n");
            pairingList.model = this.listDevices();
            pairedList.model = this.listPairedDevices();
            this.printAllDevices();

        }
        onDeviceDisconnected: {
            var button = pairingList.children[pairingList.currentIndex].children[0].children[0].children[1];
            button.text = "pair";
            button.enabled = true;
            console.log("DeviceDisconnected");
            button.status = 0;
        }
    }
    Text {
        text: "Pairing List";
        y: 75;
        font.pixelSize: 12;
    }
    Text {
        text: "Paired List";
        y: 75;
        x: parent.width/2;
        font.pixelSize: 12;
    }

    ListView{
        y: 90;
        id: pairingList
        height: 250;
        spacing: 10;
        width: parent.widht / 2 - 40;
        delegate:ItemDelegate{
            id: pairrectangle
            width:parent.width;
            height: 16;
            Row{
                id:pairrow;
            Text{
                id: pairtext;
                text:modelData;
                font.pixelSize: 16;
            }
            Button {
                height: 20;
                visible: if(modelData === "No Devices Found")
                             return false;
                         else
                             return true;
                id: pairbutton;
                text:"Pair";
                property int status: 0;
                onClicked: if(status === 0)
                               bluetooth.pairDevice(modelData);
                            else
                               bluetooth.unPairDevice(modelData);
            }
            }
        }
    }
    ListView{
        y: 90;
        x: parent.width / 2;
        id: pairedList

        height: 250;
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true;
        width: parent.width / 2 - 40;
        delegate:Rectangle{
            id: pairedrectangle
            width:parent.width;
            height: 20;
            color: "transparent";
            Row{
                height: 25;
                id:pairedrow;
                spacing: 5;
            Text{
                id: pairedtext;
                text:modelData;
                font.pixelSize:16
                }
            Text{
                id: ecuStatus;
                text: "";
                font.pixelSize: 12
            }

            Text{
                id: ds4Status;
                text: "";
                font.pixelSize: 12
            }
            Text{
                id: connectedStatus;
                text: "";
                font.pixelSize: 12
            }
            }

            MouseArea {
                anchors.fill:parent;

                onClicked: {console.log("pressed");pairedList.currentIndex = index;}
            }
        }
    }
    Row{
        y: 50;
        x: 285;
        Button {
            height: 20;
            width: 100;
            id: connectbutton;
            text:"Connect";
            property int status: 0;
            onClicked: {
                if(pairedList.currentItem.children[0].children[0].text !== "No Paired Devices Found"){
                bluetooth.connectDevice(pairedList.currentItem.children[0].children[0].text);
                pairedList.currentItem.children[0].children[3].text = "CON";
                }
            }
        }
        Button {
            height: 20;
            width: 100;
            id: ecubutton;
            text:"Make ECU";
            property int status: 0;
            onClicked: {
                if(pairedList.currentItem.children[0].children[0].text !== "No Paired Devices Found"){
                bluetooth.ecuDevice(pairedList.currentItem.children[0].children[0].text);
                pairedList.currentItem.children[0].children[1].text = "ECU";
            }
                }
        }
        Button {
            height: 20;
            width: 100;
            id: ds4button;
            text:"Make DS4";
            property int status: 0;
            onClicked: {
                if(pairedList.currentItem.children[0].children[0].text !== "No Paired Devices Found"){
                bluetooth.ds4Device(pairedList.currentItem.children[0].children[0].text);
                pairedList.currentItem.children[0].children[2].text = "DS4";
                }
            }
        }

    }
    Button {
        y:300;
        x:300;
        text: "Unpair All";
        onClicked: {bluetooth.unPairAll();}
    }

    Button {
        y:300;
        id: scan;
        text: "Scan Devices";
        onClicked: {bluetooth.startDeviceDiscovery();}
    }
}

