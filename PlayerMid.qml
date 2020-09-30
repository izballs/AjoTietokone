import QtQuick 2.10
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.3
import QtMultimedia 5.9
import Qt.labs.settings 1.0
import PLAYER 1.0

Page {
    id: midPagePlayer;

    Settings{
        id: settings
        property int volumeState;
    }

    Player {
        id:pplayer
        volumeState: settings.volumeState;
    }
/*
    Audio {
        id: mediaPlayer;
        playlist: Playlist{
            id:playlist;
        }
        onPlaybackStateChanged: {
            console.log(mediaPlayer.playbackState);
            if(mediaPlayer.playbackState === 1) pstatus.text="Playing";
            else if (mediaPlayer.playbackState === 2) pstatus.text="Paused";
        }


    }*/
Rectangle{
    anchors.left: parent.left;
    anchors.leftMargin: 50;
    height: 360;
    width: speedGauge.width
    y: parent.height/2 - height/2;
    color: "transparent";
    Text{
        text: "Speed";
        anchors.top: parent.bottom;
        x: parent.width/2 - width/2;
    }
    Rectangle{
        z:-3
        anchors.fill: parent;
        color: "black";
        opacity: 0.4;
    }
    FuelGauge {
        id:speedGauge;
        color: "white"
        type: "speed"
        tickmarkStepSize: 10;
        maximumValue: 220;
        minimumValue: 0;
    }
}

Rectangle{
    anchors.right: parent.right;
    anchors.rightMargin: 50;
    height: 360;
    y: parent.height/2 - height/2;
    width: fuelGauge.width
    color: "transparent";
    Text{
        text: "Fuel";
        x: parent.width/2 - width/2;
        anchors.top: parent.bottom;
    }

    Rectangle{
        z:-3
        anchors.fill: parent;
        color: "black";
        opacity: 0.4;
    }

    FuelGauge{
    id: fuelGauge;
    color: "white";
    type: "fuel"
    }

}
    Rectangle {
        z: 3;
        id: rect;
        width: 480;
        height: 360;
        anchors.centerIn: parent;
        opacity: 1;
        color: "transparent";
        Rectangle {
            anchors.fill: parent;
            z: -4;
            color: "white";
            opacity: 0.4
        }

        Column {
            anchors.left: parent.left;
            anchors.leftMargin: 0;
            anchors.top: parent.top;
            anchors.topMargin: 120;
            Button {
                height: 50;
                font.pixelSize: 16;
                font.bold: true;
                id: mediaButton;
                text: "Media"
                width: 100;
                onClicked: {pplayer.setState(1); enabled = false; radioButton.enabled = true; bluetoothButton.enabled = true; botPagePlayer.showPlaylist()}
                enabled:{ if(pplayer.getState() === 1)return false; else return true;}
            }
            Button {
                height: 50;
                font.pixelSize: 16;
                font.bold: true;
                id: radioButton;
                text: "Radio"
                width: 100;
                onClicked: { pplayer.setState(2); enabled = false; mediaButton.enabled = true; bluetoothButton.enabled = true; botPagePlayer.showStationlist(pplayer.getStationList())}
                enabled: {if(pplayer.getState() === 2)return false; else return true;}
            }
            Button {
                height: 50;
                font.pixelSize: 16;
                font.bold: true;
                id: bluetoothButton;
                text: "Bluetooth"
                width: 100;
                onClicked: { pplayer.setState(3); enabled = false; mediaButton.enabled = true; radioButton.enabled = true; botPagePlayer.showStationlist(pplayer.getStationList())}
                enabled: {if(pplayer.getState() === 3)return false; else return true;}
            }
        }

        Slider {
            id:volumeSlider;
            anchors.top: parent.top;
            anchors.topMargin: 100
            anchors.right: parent.right;
            anchors.rightMargin: 30;
            from: 0
            to: 100

            stepSize: 1;
            value: settings.volumeState;
            onMoved: settings.volumeState = value;
            orientation: Qt.Vertical;
            Text{
                x:0;
                y:170
                text: volumeSlider.value;
                font.pixelSize: 16;
                font.bold: true;
            }
        }

        Column {
            anchors.centerIn: parent;
            Text{
                id: pstatus;
            }
            Text{
                id: psong;
                text: {console.log(pplayer.getTitle()); return pplayer.m_title;}


                font.pixelSize: 16;
            }
            Text{
                id: partist;
                text: pplayer.m_author;
                font.pixelSize: 14
            }
        }

        Row{
            anchors.margins: 0;
            x: 175;
            spacing: 2;

            RoundButton{
                id: previousbutton;
                font.pixelSize: 14;
                text: "|◄";
                onClicked: {
                    pplayer.prev();
                }
                y: 300;
            }
            RoundButton{
                id: playpausebutton;
                text: "►";
                onClicked: {
                    if(pplayer.playbackState() !== 1){
                        pplayer.play();
                        text = "‖";
                    }
                    else{
                        pplayer.pause();
                        text = "►";
                    }
                }
                font.bold: true;
                font.pixelSize: 16;
                y: 300
                x: 450;
            }
            RoundButton{
                id: nextbutton;
                font.pixelSize: 14;
                text: "►|";
                onClicked: {
                    pplayer.next();
                }
                y: 300;
                x: 500;
            }

        }
    }

    function playlistCount(){
        return pplayer.songCount();
    }

    function getIndex(ind){
        return pplayer.itemSource(ind);    }
    function nextSong(ind){
        pplayer.nextSong(ind);

    }
    function getSources(){
        console.log(pplayer.getSources());

        return pplayer.getSources();
    }
    function removeSource(index){
        pplayer.removeSource(index);
    }
    function addSource(source)
    {
        console.log(source);
        pplayer.setSource(source);
    }
}
