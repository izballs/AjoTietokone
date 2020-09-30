import QtQuick 2.10
import QtQuick.Controls 2.3
import Qt.labs.folderlistmodel 2.1

Item {
Popup {
    id:settings;
    width: 600
    height: 380
    modal: true;
    focus: true;
    x: parent.width/2 - width/2;
    y: parent.height/2 - height/2;
    Column{
        ComboBox {
            id: wallpaperInput;
            currentIndex: 0;
            textRole: "fileName";
            displayText: currentText;
            model: FolderListModel {
                    folder: "file:///home/izba/Pictures/wallpapers/";
                    nameFilters: ["*.jpg", "*.png"]
                }
            delegate: ItemDelegate{
                    text: fileName;
            }
            }
    Rectangle{

        Text{
            text: "Bluetooth Settings"
        }
        ListView{
            id: pairedList
        }

    }

    Row{
        Button {
            id: saveSettings;
            text: "Save";
            onClicked: {settingsComp.wallpaper = "file:///home/izba/Pictures/wallpapers/" + wallpaperInput.currentText; console.log(wallpaperInput.currentText); settings.close();}
        }
        Button {
            id: cancelSettings;
            text: "Cancel";
            onClicked: settings.close();
        }
    }
    }

}
Rectangle {
    id: controlPanel;
    width: applicationWindow.width;
    height: 25
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
        height: 24;
        width: 24;
        Image {
            width: 20;
            height: 20;
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
        height: 25;
        to: items.length-1;
        up.indicator: Rectangle{
            color:"gray";
            width: 40;
            height: 25;
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
            width: 40;
            height: 25;
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
        height: 25;
        up.indicator: Rectangle{
            color:"gray";
            width: 40;
            height: 25;
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
            width: 40;
            height: 25;
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
        height: 24;
        width: 24;
        Text{
            x: parent.width/2-width/2;
            y: parent.height/2-height/2;
            text: "AC";
            color: applicationWindow.ac?"green":"black";
        }
        onClicked: {
            applicationWindow.ac = !applicationWindow.ac;
        }
    }

    Text{
        text: "Speed: "
        font.pixelSize: 16;
    }
    Text{

        text: "0 km/h"
        font.pixelSize: 16;
        font.bold: true;
    }

    }
}


}
