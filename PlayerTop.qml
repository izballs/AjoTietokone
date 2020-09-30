import QtQuick 2.10
import QtQuick.Controls 2.3
import QtMultimedia 5.9
import PLAYER 1.0
import QtWebEngine 1.5
import QtQuick.VirtualKeyboard 2.1

Page {
    id: topPagePlayer
    width: 800;
    height: 480;
    onEnabledChanged: { rek.visible = true;  }

    Rectangle{
        height: 400;
        width: 750;
        anchors.centerIn: parent;
    WebEngineView{
        anchors.fill:parent;
        id: webview;
        settings.javascriptEnabled: true;
        url: "http://www.youtube.com";
        }




        MouseArea {
        anchors.fill: parent;
        hoverEnabled: true
        propagateComposedEvents: true

        onClicked: mouse.accepted = false;
        onPressed: mouse.accepted = false;
        onReleased: mouse.accepted = false;
        onDoubleClicked: mouse.accepted = false;
        onPositionChanged: mouse.accepted = false;
        onPressAndHold: mouse.accepted = false;
        onEntered: { console.log("pressed"); mainView.interactive = false; musicView.interactive = false; }
        onExited: { console.log("released"); mainView.interactive = true; musicView.interactive = true; }
    }
    }
    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: applicationWindow.height
        width: applicationWindow.width
        visible: false;
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
