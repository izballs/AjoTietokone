import QtQuick 2.10
import QtQuick.Controls 2.3
import QtMultimedia 5.9
import PLAYER 1.0
Page {
    id: botPagePlaylist
    header: Label {
        text: qsTr("Playlist")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }
    Component.onCompleted:{
        showPlaylist();
    }

    Popup {
        id: sourcesPopup;
        width: 600;
        height: 400;
        x: parent.width/2-width/2;
        y: parent.height/2-height/2;
        ListView {
            y:30;
            id: sources;
            height: 300;
            width: 400;
            delegate: ItemDelegate {
                        text:index + " " + modelData;
                }
            }

        Row{
        TextField{
            id: source;
            width: 200;
            placeholderText: "new source ex:C:/music";
        }
        RoundButton{
            id: addSource;
            text: "+";
            onClicked:{ midPagePlayer.addSource(source.text); sources.model = midPagePlayer.getSources();}
        }
        }
    }

    Player {
        id: pplayer;
    }

    RoundButton {
        id: sourcesButton;
        text:"Sources";
        onClicked: {sourcesPopup.open(); sources.model = midPagePlayer.getSources();}
    }

    ListView {
       x:100
       height: 380;
       width: 600;
       clip: true
        orientation: Qt.Vertical
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        interactive: true
        focus: true;
        id: list;
        Component.onCompleted:{ switch(midPagePlayer.getState()){
                               case 0:
                                   console.log("case 0");
                                   break;
                               case 1:
                                   console.log("case 1");
                                   showPlaylist();
                                   break;
                               case 2:
                                   console.log("case 2");
                                   showStationlist();
                                   break;
                               case 3:
                                   console.log("case 3");
                                   showBluetootDevices();
                                   break;
                               }}
        delegate: ItemDelegate {
                    background.opacity: 0.3;
                    width: 600;
                    Row{
                    Text{
                        color: "white";
                        text: index + ".  ";
                    }
                    Text{
                        color: "white";
                        font.pixelSize: 14;
                        x:20
                        text: { switch(midPagePlayer.getState()){
                            case 1:
                                var str = modelData;
                                var st = str.toString();
                                var strr = st.split("/");
                                var count = strr.length;
                                var dr = strr[count-2];
                                dr = dr + " " + strr[count-1];
                                return dr;
                            case 3:
                                return modelData;
                            }
                        }
                    }
                    }
                    onClicked:
                        switch(midPagePlayer.getState()){
                        case 3: return midPagePlayer.bluetoothDevice(modelData);
                        default: return midPagePlayer.nextSong(index);
                        }
            }
    }

    function showPlaylist(){
        console.info(midPagePlayer.playlistCount())
        var str = [];
        var dd = midPagePlayer.playlistCount();
        for(var i = 0; i < dd; i++){
            str.push(midPagePlayer.getIndex(i));
        }
    list.model = str;
    }

    function showStationlist(stations){
        list.model = stations;
    }
    function showBluetootDevices(){
        var listSTR = midPagePlayer.getBluetoothDeviceList();
        list.model = listSTR;
        console.log("listSTR");
        console.log(listSTR);
    }
}
