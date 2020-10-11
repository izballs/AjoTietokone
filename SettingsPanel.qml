import QtQuick 2.10
import QtQuick.Controls 2.3
import Qt.labs.folderlistmodel 2.1
import PLAYER 1.0

Item {
    width: parent.width;
    height: parent.height;
Popup {
    id:settings;
    width: 600
    height: 380
    modal: true;
    focus: true;
    x: parent.width/2 - width/2;
    y: parent.height/2 - height/2;
    property int panel: 0;
    background: Rectangle{
        anchors.fill: parent;
        color: "lightgray";
    }

    Row {
        y: parent.parent.height - parent.height - height;
        Button {
            id: display;
            width: 50;
            height: 50;
            Image {
                width: 40;
                height: 40;
                anchors.fill: parent;
                source: "img/display.png";
                fillMode: Image.PreserveAspectFit;
            }
            onClicked: { sv.replace("displayView.qml");}
        }
        Button {
            id: network;
            width: 50;
            height: 50;
            onClicked: { sv.replace("networkView.qml"); console.log(sv.depth)}
            Image {
                width: 40;
                height: 40;
            anchors.centerIn: parent;
            source: "img/network.png";
            fillMode: Image.PreserveAspectFit;

        }
        }
        Button {
            id: bluetooth;
            width: 50;
            height: 50;
            onClicked: {sv.replace("bluetoothView.qml"); console.log(sv.depth)}
            Image {
                width: 40;
                height: 40;
            anchors.centerIn: parent;
            source: "img/bluetooth.png";
            fillMode: Image.PreserveAspectFit;

        }
        }
        Button {
            id: navigation;
            width: 50;
            height: 50;
            onClicked: {sv.replace("navigationSettings.qml"); console.log(sv.depth)}
            Image {
            width: 40;
            height: 40;
            anchors.centerIn: parent;
            source: "img/navigation.png";
            fillMode: Image.PreserveAspectFit;

        }
        }
        Button {
            id: about;
            width: 50;
            height: 50;
            onClicked: {sv.replace("informationView.qml"); console.log(sv.depth)}
            Image {
            width: 40;
            height: 40;
            anchors.centerIn: parent;
            source: "img/information.png";
            fillMode: Image.PreserveAspectFit;

        }
        }
    }
StackView {
    id: sv;

    anchors.fill: parent;
    initialItem: "displayView.qml";
    replaceEnter:  Transition {

        PropertyAnimation {
            property: "opacity"
            from: 0
            to:1
            duration: 200
        }
    }

    replaceExit: Transition {
        PropertyAnimation {
            property: "opacity"
            from: 1
            to:0
            duration: 200
        }

}
}
}
Rectangle {
    id: controlPanel;
    width: applicationWindow.width;
    height: 35
    visible: true;
    z: 10;
    y: applicationWindow.height-height;
    color: "transparent";
    Rectangle{
        anchors.fill: parent;
        color: "white";
        opacity: 0.7
    }

    Row{
        spacing: 20
    RoundButton{
        height: 34;
        width: 34;
        Image {
            width: 30;
            height: 30;
            anchors.centerIn: parent;
            source: "img/settings.png";
            fillMode: Image.PreserveAspectFit;

        }

        onClicked: settings.open();
    }
    SpinBox{
        id: fanSpeed;
        from: 0
        width: 150;
        height: 34;
        to: items.length-1;
        up.indicator: Rectangle{
            color:"gray";
            width: 34;
            height: 34;
            x:110;
            Text{
                text:"+";
                anchors.centerIn: parent;
            }

            MouseArea {
                anchors.fill:parent;
                onClicked: fanSpeed.increase();
            }

        }
        down.indicator: Rectangle{
            color:"gray";
            width: 34;
            height: 34;
            x:0
            Text{
                anchors.centerIn: parent;
                text:"-";
            }
            MouseArea {
                anchors.fill:parent;
                onClicked: fanSpeed.decrease();
            }
        }

        property var items: ["OFF", "LOW", "MEDIUM", "HIGH", "MAX"];

        validator: RegExpValidator {
            regExp: new RegExp("(Small|Medium|Large)", "i")
        }

        textFromValue: function(value) {
            return items[value];
        }

        valueFromText: function(text) {
            for (var i = 0; i < items.length; ++i) {
                if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                    return i
            }
            return sb.value
        }


    }
    SpinBox{
        id: temperatureSpin
        from: 0

        to: items.length-1;
        width: 150;
        height: 34;

        up.indicator: Rectangle{
            color:"gray";
            width: 34;
            height: 34;
            x:108;
            Text{
                text:"+";
                anchors.centerIn: parent;
            }

            MouseArea {
                anchors.fill:parent;
                onClicked: temperatureSpin.increase();
            }

        }
        down.indicator: Rectangle{
            color:"gray";
            width: 34;
            height: 34;
            x:0
            Text{
                anchors.centerIn: parent;
                text:"-";
            }
            MouseArea {
                anchors.fill:parent;
                onClicked: temperatureSpin.decrease();
            }
        }

        property var items: ["COLDEST", "COLDER", "COLD", "MILD", "WARM", "WARMER", "WARMEST"];

        validator: RegExpValidator {
            regExp: new RegExp("(COLDEST|COLDER|COLD|MILD|WARM|WARMER|WARMEST)", "i")
        }

        textFromValue: function(value) {
            return items[value];
        }

        valueFromText: function(text) {
            for (var i = 0; i < items.length; ++i) {
                if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                    return i
            }
            return sb.value
        }
    }
    RoundButton{
        height: 35;
        width: 35;
        Text{
            x: parent.width/2-width/2;
            y: parent.height/2-height/2;
            text: "AC";
            font.pixelSize: 20;
            color: applicationWindow.ac?"green":"black";
        }
        onClicked: {
            applicationWindow.ac = !applicationWindow.ac;
        }
    }

    Text{
        y: parent.height / 2 - height / 2;
        text: "Speed: "
        font.pixelSize: 20;
    }
    Text{
        y: parent.height / 2 - height / 2;
        text: "0 km/h"
        font.pixelSize: 20;
        font.bold: true;
    }

    }
}


}
