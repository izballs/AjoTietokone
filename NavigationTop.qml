import QtQuick 2.10
import QtQuick.Controls 2.3
import QtMultimedia 5.9
import PLAYER 1.0
import QtWebEngine 1.5
import QtPositioning 5.8
import QtLocation 5.9
import QtQuick.VirtualKeyboard 2.1


Page {
    id: topPageNavigation
    width: 800;
    height: 480;

    Rectangle {
    width: 760;
    height: 200;
    anchors.top: parent.top;
    anchors.topMargin: 30;
    x: parent.width/2 - width/2;
    color: "transparent";
    Rectangle {
        anchors.fill: parent;
        color: "black";
        opacity: 0.4
    }
    Column{
    Row{
    Text{
        text: "Set Address";
        font.pixelSize: 20;
        font.bold: true;
        topPadding: 10;
        leftPadding: 20;
        rightPadding: 20;
        color: "white";
    }
    TextField{
        id:addressField;
        height: 40;
        font.pixelSize: 20;
        width: 600;
        focus: true;
        placeholderText: "new address...";
        onEditingFinished: {
            console.log(suggestionModel.columnCount());
            console.log(suggestionModel.hasChildren());
        }
    }

    PlaceSearchSuggestionModel {
        id: suggestionModel

        plugin: midPageNavigation.plugin
        searchTerm: addressField.text;
        // Brisbane
        searchArea: QtPositioning.circle(QtPositioning.coordinate(62.7562402,22.8692497))

        onSearchTermChanged: {update(); console.log("term changed")}
    }

    }

    ListView {
        height: 125;
        width: 700;
        model: suggestionModel
        delegate: Rectangle{
                color: "white";
                opacity: 0.7
                height: 25;
                border.color: "black";
                border.width: 0.5;
                width: parent.width
            Text { text: suggestion; font.pixelSize: 20; }
            MouseArea{
                anchors.fill: parent;
                onClicked:{midPageNavigation.search(suggestion); console.log(suggestion)}
            }
        }
    }

    }

    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: applicationWindow.height
        width: applicationWindow.width
        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: applicationWindow.height - inputPanel.height
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
