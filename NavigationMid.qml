import QtQuick 2.10
import QtQuick.Controls 2.3
import QtMultimedia 5.9
import PLAYER 1.0
import QtWebEngine 1.5
import QtPositioning 5.2
import QtLocation 5.3

Page {
    id: midPageNavigation
    width: 800;
    height: 480;
    onEnabledChanged: { rek.visible = true;  }
    property variant plugin: mapPlugin

    Mygps{
        id:mygps;
        property double distance;
        onCoordinateChanged: {

        }

    }

    ListModel { id: routeInfoModel }

    Rectangle {
        anchors.centerIn: parent;
        width: 650;
        height: 380;

        Plugin {
            id: mapPlugin
            name: "here" // "mapboxgl", "esri", ...
            // specify plugin parameters if necessary
            locales: "fi_FI";

            PluginParameter {
                 name: "here.app_id"
                 value: "SwbtTZh9fPu7H6dReGXg"
             }
            PluginParameter {
                name: "here.token";
                value: "b0pqVYfFdoqJNejo1QS1gw";
            }
        }

        PositionSource {
            onPositionChanged: {
                map.center = mygps.m_coordinate;
            }
        }

        Map {
                id: map
                anchors.fill: parent
                plugin: mapPlugin
                center: fromCoordinate // Oslo
                zoomLevel: 14


                property variant fromCoordinate: QtPositioning.coordinate(62.7562402,22.8692497,17)
                property variant toCoordinate: QtPositioning.coordinate(63.8372805,23.139854,17)

                Rectangle{
                    anchors.left: parent.left;
                    anchors.bottom: parent.bottom;
                    anchors.leftMargin: 100;
                    width: parent.width - 200;
                    height: 25;
                    z: 25;
                    color: "gray";
                    Text{
                        anchors.centerIn: parent;
                        id: routeInfo;
                        font.pixelSize: 14;
                        text: routeInfoModel.get(0).instruction;
                    }
                }


                MapQuickItem {

                    id:positionIndicator;
                    anchorPoint.x: 24;
                    anchorPoint.y: 16;
                    sourceItem:
                        Image {
                            id: positionImage
                            source: "img/positionIndicator.png";
                            width: 35;
                            height: 35;
                        }
                    coordinate: mygps.m_coordinate;
                }

                Rectangle{
                    id: centerMap;
                    color: "transparent";
                    height: 40;
                    width: 40;
                    z:50;
                    x:parent.width - width;
                    y:parent.height - height - directions.height;
                    Image {
                        source: "img/centerMap.png";
                        width: 40;
                        height: 40;
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked:{ map.center = mygps.m_coordinate; console.log("Centering");
                                    }
                    }
                }


                Rectangle{
                    id: directions
                    anchors.right:parent.right;
                    anchors.bottom: parent.bottom;
                    width: 100;
                    height: 100;
                    color: "white";
                    Image{
                        width: 80;
                        height: 80;
                        id:directionArrow;

                    }
                    Text {
                        id:directionMeters;
                        anchors.bottom: parent.bottom;
                        x: parent.width/2 - width/2;
                        font.pixelSize: 18
                    }
                }




                function showRouteList(){
                    console.log("showRouteList");
                    routeInfoModel.clear()
                    if (routeModel.count > 0) {
                        for (var i = 0; i < routeModel.get(0).segments.length; i++) {
                            console.log("segment=" + i);
                            routeInfoModel.append({
                                "instruction": routeModel.get(0).segments[i].maneuver.instructionText,
                                "distance": routeModel.get(0).segments[i].maneuver.distanceToNextInstruction,
                                "direction": routeModel.get(0).segments[i].maneuver.direction
                            });
                            console.log(routeModel.get(0).segments[i].maneuver.distanceToNextInstruction)
                            console.log(routeModel.get(0).segments[i].maneuver.direction)
                        }
                    }
                }

                GeocodeModel {
                    id: toModel;
                    plugin: map.plugin;

                }

                RouteQuery {
                    id: mapQuery;
                    travelModes: RouteQuery.CarTravel
                }
                Location {
                    id: lastM_c;
                }

                Timer {
                    id:instructionTimer;
                    interval: 2000; running: false; repeat: true;
                    property int max;
                    property int current: 0;
                    property int dis: 0;
                    onTriggered:{
                        var path = routeModel.get(0).path;
                        max = path.length;
                        if(lastM_c.coordinate !== null){
                            dis += mygps.calculateDistance(mygps.m_coordinate, lastM_c.coordinate);
                        }
                        console.log("dis=" + dis);
                        console.log("routemodel.current=" + routeInfoModel.get(routeModel.current).distance)
                        lastM_c.coordinate = mygps.m_coordinate;
                        var distance = mygps.calculateDistance(mygps.m_coordinate, path[current])
                        var distanceTO = routeInfoModel.get(routeModel.current).distance - dis;
                        directionMeters.text = distanceTO.toFixed(0) + "m";
                        if(distance <= 30){
                            current++;
                            if(current === max)
                                instructionTimer.stop();
                        }
                        if((routeInfoModel.get(routeModel.current).distance - dis) <= 20){
                            routeModel.current++;
                        }

                    }
                }

                RouteModel {
                     id: routeModel
                     plugin: mapPlugin;
                     query: mapQuery;
                     autoUpdate: false;
                     property int current: 0;
                     onStatusChanged: {
                         if (status == RouteModel.Ready) {
                         switch(status){
                         case 0:
                             break;
                         case 1:
                             console.log(routeModel.get(current).segments.length);
                             map.showRouteList();
                             console.log(routeInfoModel.get(current));

                             routeInfo.text = routeInfoModel.get(current).instruction
                             directionMeters.text = routeInfoModel.get(current).distance
                             switch(routeInfoModel.get(current+1).direction){
                             case 0:
                                 break;
                             case 1:
                                 directionArrow.source = "img/upArrow.png";
                                 break;
                             case 2:
                                 directionArrow.source = "img/lightArrow.png";
                                 break;
                             case 3:
                                 directionArrow.source = "img/lightArrow.png";
                                 break;
                             case 4:
                                 directionArrow.source = "img/rightArrow.png";
                                 break;
                             case 5:
                                 directionArrow.source = "img/hardRightArrow.png";
                                 break;
                             case 6:
                                 directionArrow.source = "img/uturnRightArrow.png";
                                 break;
                             case 7:
                                 directionArrow.source = "img/uturnLeftArrow.png";
                                 break;
                             case 8:
                                 directionArrow.source = "img/hardLeftArrow.png";
                                 break;
                             case 9:
                                 directionArrow.source = "img/leftArrow.png";
                                 break;
                             case 10:
                                 directionArrow.source = "img/lightLeftArrow.png";
                                 break;
                             case 11:
                                 directionArrow.source = "img/lightLeftArrow.png";
                                 break;
                             }

                             break;
                         }
                         } else if (status == RouteModel.Error) {

                         }
                     }

                }
                 MapItemView {
                     model: routeModel
                     delegate: routeDelegate

                 }

                 Component {
                     id: routeDelegate

                     MapRoute {
                         route: routeData
                         line.color: "blue"
                         line.width: 5
                         smooth: true
                         opacity: 0.8
                     }
                 }
                 MouseArea {
                     anchors.fill: parent;
                     hoverEnabled: true
                     onEntered: { console.log("pressed"); mainView.interactive = false; naviView.interactive = false; }
                     onExited: { console.log("released"); mainView.interactive = true; naviView.interactive = true; }
             }

            }

    }

    Timer{

        //Timer tarvitaan tähän sillä toModelin ja fromModelin update Functio vie hetken aikaa.
        //0,5s on kuitenkin niin pieni aika, ettei käyttäjä edes tajua, että tälläinen timer on takana.
            id: naviTimer;
            interval: 500; running: false; repeat: false;
            onTriggered: mapQ()
            function mapQ(){
                mapQuery.clearWaypoints()
                console.log("ASD");
                console.log(mygps.m_coordinate);
                mapQuery.addWaypoint(mygps.m_coordinate)
                mapQuery.addWaypoint(toModel.get(0).coordinate)

                routeModel.update();
                map.center = mygps.m_coordinate
                mygps.stopReading();
            }
    }


function search(suggestion){
    mygps.startReading();
    toModel.query = suggestion;
    toModel.update();
    naviTimer.start();
    instructionTimer.start();
}

}
