import QtQuick 2.0
import QtQuick.Controls 2.2
import PLAYER 1.0
import QtQuick.VirtualKeyboard 2.1
Rectangle {
    id: netRectangle;
    Component.onCompleted: refreshIp(settingsComp.lastUsedDev);
    width: 600
    height: 380
    color: "transparent";
    Connections {
        target: Network;
        onConnectionSuccesful: noticePopup.noticy("Wlan Connection Succesful!", 2000);
        onWrongPassword: noticePopup.noticy("Wrong Password!", 2000);
        onWlanDHCPEnabled:{ dhcpTimer.start(); noticePopup.noticy("Getting ip with DHCP...", 4000);}

    }

    Timer{
        id: dhcpTimer;
        interval: 5000;
        repeat: false;
        running: false;
        onTriggered: refreshIp(selectedDev.currentText);
    }

    Text{
        y:50;
        text: "Network Settings";
    }
    ComboBox {
        id: selectedDev
        y:80;
        height: 25;
        width: 100;
        model: ["eth0", "wlan0"];
        onCurrentTextChanged: refreshIp(currentText);
        Component.onCompleted: currentText = settingsComp.lastUsedDev;
    }
    Button
    {
        y: 20;
        x: 250;
        id:scanWlanNetworks;
        onClicked:{ Network.scanWlanNetworks();}
        text: "Scan Wifi"
        visible: if(selectedDev.currentText === "wlan0") return true; else return false;
    }

    ListView
    {
        width: 200;
        height: 300;
        y: 80;
        x: 250;
        id: wlanList;
        visible: if(selectedDev.currentText === "wlan0") return true; else return false;
        model: Network.wlanList;
        delegate: Rectangle{
            color: "gray";
            height: 40;
            width: parent.width;
            Text {
                font.pixelSize: 14;
                text: modelData;
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: { passPrompt.ssid = modelData; passPrompt.open(); }
            }
        }
    }

    Switch {
        id: dhcpSwitch;
        y: 70;
        x: 120;
        text: "DHCP";
        onCheckedChanged:
            if(this.checked){
                ip.enabled = false;
                netmask.enabled = false;
                gateway.enabled = false;
            }
            else {
                ip.enabled = true;
                netmask.enabled = true;
                gateway.enabled = true;
            }
    }

    KeyPad {
        id:keyPad
        y: 70;
        x: 300;
        buttonWidth: 80;
        buttonHeight: 50;
        borderWidth: 1;
        visible: false;
        onFokusChanged: if(!fokus && !foksko.focus ) visible = false; else visible = true;
    }

    Row{
        y: 120;
            Column{
                spacing: 25;
                y: 15;
                Text{
                    text: "Ip Address:"
                    font.pixelSize: 12
                }
                Text {
                    text: "Netmask:"
                    font.pixelSize: 12;
                }
                Text {
                    text: "Gateway:"
                    font.pixelSize: 12;
                }
            }
            FocusScope{
                id: foksko
                onFocusChanged: if(!focus && !keyPad.fokus) keyPad.visible = false; else keyPad.visible = true;
            Column{
                x: 80;
                TextField {
                    id: ip;
                    text: "";
                    width: 160;
                    onFocusChanged: if(focus){ keyPad.target = ip;}
                }
                TextField {
                    id: netmask;
                    text: "";
                    width: 160;
                    onFocusChanged: if(focus){keyPad.target = netmask;}
                }

                TextField {
                    id: gateway;
                    text: "";
                    width: 160;
                    onFocusChanged: if(focus){keyPad.target = gateway;}
                }
                }
            }
    }

    Row{
        x: 100;
        y: 300;
        Button {
            id: testConnection;
            text: "Test Network";
            onClicked: if(Network.testNetwork()) noticePopup.noticy("Connection works!", 2000); else noticePopup.noticy("Connection problem!", 2000);
        }

        Button {
            id: saveSettings;
            text: "Save";
            onClicked: saveNetworkSettings();
        }
        Button {
            id: closeSettings;
            text: "Close";
            onClicked: settings.close();
        }
    }


    Popup {
        id: passPrompt
        y: 20;
        x: (parent.width / 2) - (this.width / 2)
        width: 450;
        focus: true;
        height: 60;
        property string ssid;
        FocusScope{
            width: 0;
            height: 0;
        Row{
            anchors.fill:parent;
            Text{
                text: "Password:";
                y: 10;
                font.pixelSize: 16;
            }
            CheckBox{
                onCheckedChanged: if(!checked) pass.echoMode = TextInput.Password; else pass.echoMode= TextInput.Normal;
            }

            TextField{
                id:pass;
                echoMode: TextInput.Password
                width: 180;
            }
            Button{
                id:submit;
                onClicked: { noticePopup.noticy("Connecting to Wlan...", 2000); Network.connectWlanNetwork(passPrompt.ssid, pass.text);
                            passPrompt.ssid = ""; pass.clear(); passPrompt.close();}
                text: "Submit"
            }
        }
        }
        InputPanel {
            id: inputPanel
            z: 99
            x: -((applicationWindow.width -  netRectangle.width ) / 2 ) - 90
            y: applicationWindow.height
            width: applicationWindow.width
            states: State {
                name: "visible"
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    anchors.horizontalCenter: applicationWindow.center;
                    y: applicationWindow.height - inputPanel.height - passPrompt.height;
                }
            }
            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
    }
    }
    function testIp(ipaddr){
        return /^(?=\d+\.\d+\.\d+\.\d+$)(?:(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\.?){4}$/.test(ipaddr);
    }

    function refreshIp(dev){
        var strList = Network.getIp(dev);
        console.log(strList);
        ip.text = strList[0];
        netmask.text = strList[1];
        gateway.text = strList[2];
    }

    function saveNetworkSettings(){

                        var addressList = [ ip.text, netmask.text, gateway.text];
                        if(dhcpSwitch.checked){
                            if(selectedDev.currentText === "wlan0")
                                Network.enableDHCPWlan();
                            else
                                Network.enableDHCPWired();
                            noticePopup.noticy("Settings Saved!", 2000);
                        }
                        else{
                        if(testIp(ip.text))
                        {
                            if(testIp(netmask.text))
                            {
                                if(testIp(gateway.text)){
                                    Network.setIp(selectedDev.currentText, addressList);
                                    noticePopup.noticy("Settings Saved!", 2000);
                                }
                                else
                                {
                                    noticePopup.noticy("CHECK BROADCAST ADDRESS!", 2000);
                                }
                            }
                            else
                            {
                                noticePopup.noticy("CHECK NETMASK ADDRESS!", 2000);
                            }
                        }
                        else
                        {
                            noticePopup.noticy("CHECK IP ADDRESS!", 2000);
                        }
                        }
                    }

}
