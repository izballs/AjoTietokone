
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtMultimedia 5.9
import Qt.labs.folderlistmodel 2.1
import Qt.labs.settings 1.0


ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 800
    height: 480

    title: qsTr("Tabs")
    property string wallpaper: settingsComp.wallpaper;
    property bool ac: settingsComp.ac;

//    Component.onCompleted: applicationWindow.showFullScreen();

    TopPanel{
        id:topPanel
        z: 10;
    }


    Settings {
        id: settingsComp
        property string wallpaper
        property bool ac: false
        property int blowState
        property int heatState;

    }


    SwipeView{
        id: mainView
        orientation: Qt.Horizontal
        anchors.fill:parent;
        currentIndex: 1;
        onCurrentIndexChanged: {

                switch(currentIndex){
                case 0:
                   if(naviView.currentIndex === 0){
                       topPanel.page = "NaviSearch";
                   }
                   else if(naviView.currentIndex === 1){
                       topPanel.page = "Navigation";
                   }
                   else if(naviView.currentIndex === 2){
                       topPanel.page = "Most Used";
                   }
                   break;
                case 1:
                    if(musicView.currentIndex === 0){
                        topPanel.page = "Youtube";
                    }
                    else if(musicView.currentIndex === 1){
                        topPanel.page = "Player";
                    }
                    else if(musicView.currentIndex === 2){
                        topPanel.page = "Playlist";
                    }
                    break;
        }

        }

      /*  on {if(index === 0) {

                bgpBOT.visible = false;
                bgpMID.visible = false;
                bgpTOP.visible = false;
                switch(naviView.currentIndex){
                case 0:
                    bgnBOT.visible = false;
                    bgnMID.visible = false;
                    bgnTOP.visible = true;
                    break;
                case 1:
                    bgnBOT.visible = false;
                    bgnMID.visible = true;
                    bgnTOP.visible = false;
                    break;
                case 2:
                    bgnBOT.visible = true;
                    bgnMID.visible = false;
                    bgnTOP.visible = false;
                    break;

                }}
                else {
                bgnBOT.visible = false;
                bgnMID.visible = false;
                bgnTOP.visible = false;
                switch(musicView.currentIndex){
                case 0:
                    bgpBOT.visible = false;
                    bgpMID.visible = false;
                    bgpTOP.visible = true;
                    break;
                case 1:
                    bgpBOT.visible = false;
                    bgpMID.visible = true;
                    bgpTOP.visible = false;
                    break;
                case 2:
                    bgpBOT.visible = true;
                    bgpMID.visible = false;
                    bgpTOP.visible = false;
                    break;

                }
                }
        }*/
        Page{
        id: naviPage;
        SwipeView {
            onCurrentIndexChanged:  {
                switch(currentIndex){
                case 0:
                   topPanel.page = "NaviSearch";
                   break;
                case 1:
                    topPanel.page = "Navigation";
                    break;
                case 2:
                    topPanel.page = "Most Used";
                    break;
                   }
            }
            id: naviView
            currentIndex: 1

            orientation: Qt.Vertical
            anchors.fill:parent;
            NavigationTop {
                background: Image {
                    id: bgnTOP
                    z:-10;
                    x:0
                    y:0

                    width: applicationWindow.width
                    height: applicationWindow.height
                    opacity: 1;
                    fillMode: Image.Pad;
                    source: applicationWindow.wallpaper;
                }
                id: topPageNavisearch
            }


            NavigationMid {
                background: Image {
                    id: bgnMID
                    z:-10;
                    x:0
                    y:0

                    width: applicationWindow.width
                    height: applicationWindow.height
                    opacity: 1;
                    fillMode: Image.Pad;
                    source: applicationWindow.wallpaper;
                }
                id: midPageNavigation
            }

            Page {
                background: Image {

                    id: bgnBOT
                    z:-10;
                    x:0
                    y:0

                    width: applicationWindow.width
                    height: applicationWindow.height
                    opacity: 1;
                    fillMode: Image.Pad;
                    source: applicationWindow.wallpaper;
                }
                id: botPageNavimostused


            }
        }
        }
     Page{
         id: musicPage;
    SwipeView {
        onCurrentIndexChanged:  {
            switch(currentIndex){
            case 0:
               topPanel.page = "Youtube";
               break;
            case 1:
                topPanel.page = "Player";
                break;
            case 2:
                topPanel.page = "Playlist";
                break;
               }
        }
        id: musicView
        anchors.fill:parent;
        currentIndex: 1
        orientation: Qt.Vertical
        PlayerTop {
            background: Image {
                id: bgpTOP
                z:-10;
                x:0
                y:0

                width: applicationWindow.width
                height: applicationWindow.height
                opacity: 1;
                fillMode: Image.Pad;
                source: applicationWindow.wallpaper;
            }

            id: topPageYoutube
         }

        PlayerMid{
            background: Image {
                id: bgpMID
                z:-10;
                x:0
                y:0

                width: applicationWindow.width
                height: applicationWindow.height
                opacity: 1;
                fillMode: Image.Pad;
                source: applicationWindow.wallpaper;
            }
            id: midPagePlayer;
        }
        PlayerBot{
            background: Image {
                id: bgpBOT
                z:-10;
                x:0
                y:0

                width: applicationWindow.width
                height: applicationWindow.height
                opacity: 1;
                fillMode: Image.Pad;
                source: applicationWindow.wallpaper;
            }
            id: botPagePlayer;
        }
    }
     }

    }
    SettingsPanel{

    }
}
