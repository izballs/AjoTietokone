import QtQuick 2.0
import QtQuick.Controls 2.2
import PLAYER 1.0
import QtQuick.VirtualKeyboard 2.1
Rectangle {
    width: 600
    height: 380
    color: "transparent";
    Commands {
        id: commands;
    }

    Button {
        y: 50
        x: 100
        text: "Add Location"
    }
    Text {
        y: 50;
        text: "Navigation";
    }
    Text {
        y: 80
        text: "Add new location";
        font.pixelSize: 16;
    }
    Column{
        width: parent.width
        y: 100;
    Row {
        x: 50
        spacing: 90;
        Text {
            text: "Name";
            font.pixelSize: 14;
            width: 50;
        }
        Text {
            text: "Address"
            font.pixelSize: 14;
            width: 50;
        }
        Text {
            text: "Postcode";
            font.pixelSize: 14;
            width: 50;
        }
        Text {
            text: "City";
            font.pixelSize: 14;
            width: 50;
        }
    }
    Row {
        width: parent.width;
        TextField {
            width: parent.width / 4 - 5;
            id: name;
        }
        TextField {
            width: parent.width / 4 - 5;
            id: address;
        }
        TextField {
            width: parent.width / 4 - 5;
            id: postcode;
        }
        TextField {
            width: parent.width / 4 - 5;
            id: city;
        }
    }
}

    ListView{
        id: locationList
        model: commands.getLocations();

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

