import QtQuick 2.0
import QtQuick.Controls 2.2
import PLAYER 1.0
Rectangle {
    width: 600
    height: 380
    color: "transparent";
    Commands {
        id: commands;
    }

    Text {
        y: 50;
        text: "Information";
    }

    TextArea {
        y: 80
        enabled: false;
        wrapMode: TextEdit.Wrap;
        height: 300;
        width: parent.width;
        text: "ProjectKITT is a raspberry based driving computer to your car.
It can be plugged straight into the ODB-2 socket to get great
information of the car. It can also play music from SD-Card,
Digital Radio, Bluetooth and Youtube. ProjectKITT has integrated
Navigation system that uses Nokia Here Maps to get you where you want.
ProjectKIT is developed by Juuso Yli-Sorvari";
    }
    Row {
        x: parent.width - 250;
        y: parent.height - 70;
    Button {

        id: rebootButton;
        text: "Reboot";
        onClicked: commands.reboot();
    }
    Button {
        id: shutdownButton;
        text: "Shutdown";
        onClicked:  commands.shutdown();
    }
}
}

