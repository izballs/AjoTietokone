
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtMultimedia 5.9
import Qt.labs.folderlistmodel 2.1
import Qt.labs.settings 1.0
import PLAYER 1.0;

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 800
    height: 480
    font.pixelSize: 16;
    title: qsTr("Tabs")
    property string wallpaper: if(settingsComp.wallpaper === "") return "file:///media/wallpapers/default.png"; else { console.log(settingsComp.wallpaper); return settingsComp.wallpaper;}
    property bool ac: settingsComp.ac;

    Component.onCompleted: Network.checkNetwork();

    MultiPointTouchArea {
        id: toucharea;
        z:0
        enabled: false;
        mouseEnabled: false;
        minimumTouchPoints: 2
        maximumTouchPoints: 3
        touchPoints: [
            TouchPoint { id: point1 },
            TouchPoint { id: point2 },
            TouchPoint { id: point3 }
        ]
        property double p1x;
        property double p1y;
        property double p2x;
        property double p2y;
        property bool press: false;
        anchors.fill:parent;
        onPressed: { p1x = point1.x; p1y = point1.y; p2x = point2.x; p2y = point2.y
                     console.log("PRESSED:p1x="+p1x+",p1y="+p1y+"|p2x="+p2x+",p2y="+p2y);
                     press = true;
                    }
        onReleased: {
                      if(press){
                      var x1, x2, y1, y2, x, y;
                      x1 = point1.x - p1x;
                      x2 = point2.x - p2x;
                      y1 = point1.y - p1y;
                      y2 = point2.y - p2y;
                      x = Math.abs(x1 + x2);
                      y = Math.abs(y1 + y2);
                      //console.log("x1="+x1+",x2="+x2+"|y1="+y1+",y2="+y2);
                      //console.log("x="+x+"|y="+y);
                      var veto = 60;
                      //console.log("Released:p1x="+p1x+",p1y="+p1y+"\np2x="+p2x+",p2y="+p2y);
                      //console.log("Released:point1.x="+point1.x+",point1.y="+point1.y+"\npoint2.x="+point2.x+",point2.y="+point2.y);
                      if(x > y){
                      if((p1x - veto) > point1.x && (p2x - veto) > point2.x) { console.log("swiped to left"); console.log(mainView.currentIndex); if(mainView.currentIndex < mainView.count-1) mainView.currentIndex += 1}
                      if((p1x + veto) < point1.x && (p2x + veto) < point2.x) { console.log("swiped to right"); console.log(mainView.currentIndex); if(mainView.currentIndex > 0) mainView.currentIndex -= 1}
                      }
                      else {
                      if((p1y - veto) > point1.y && (p2y - veto) > point2.y) { console.log("swiped to top");
                        switch(mainView.currentIndex){
                         case 0:
                             if(naviView.currentIndex < naviView.count - 1)
                                naviView.currentIndex += 1;
                             break;
                         case 1:
                             if(musicView.currentIndex < musicView.count - 1)
                                musicView.currentIndex += 1;
                             break;
                        }
                      }
                      if((p1y + veto) < point1.y && (p2y + veto) < point2.y) { console.log("swiped to bot");
                        switch(mainView.currentIndex){
                        case 0:
                            if(naviView.currentIndex > 0)
                                naviView.currentIndex -= 1;
                            break;
                        case 1:
                            if(musicView.currentIndex > 0)
                                musicView.currentIndex -= 1;
                            break;
                        }
                      }
                      }
                      press = false;
                      }
    }
    }

    NoticePopup{
        id: noticePopup;
    }

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
        interactive: true;
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

        Page{
        id: naviPage;
        SwipeView {
            interactive: true;
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
        interactive: true;
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

