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
    Column{
    y: 25
    width: 50;
    z: 25
        Button {
        width: 50;
        id: youtube;
        onClicked: webview.url = "http://m.youtube.com";
        text: "YOUTUBE";
        }
        Button{
            width: 50;
        id: nettiradio;
        onClicked: webview.url = "https://www.supla.fi/live/"
        text: "NetRadio"
    }
        Button {
            width: 50;
            enabled: false;
            id:soundcloud;
            onClicked: webview.url = "https://m.soundcloud.com/";
            text: "SoundCloud"
        }
    }
    Rectangle{
        x: 50;
        y: 25
        width: 750;
        height: 420;
    WebEngineView{

        anchors.fill:parent;
        id: webview;
        settings.javascriptEnabled: true;
        url: "http://m.youtube.com";
        profile:  WebEngineProfile{
                httpUserAgent: "Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36"
            }
        }




        MouseArea {
        z:0
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
