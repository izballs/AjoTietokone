import QtQuick 2.0

import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4

Gauge {
       anchors.fill: parent;
       id: fuelGauge
       minimumValue: 0;
       maximumValue: 100;
       tickmarkStepSize: 5;
       property string color;
       property string type;
       value: 0

       Behavior on value {
           NumberAnimation {
               duration: 1000
           }
       }

       style: GaugeStyle {
           tickmarkLabel: Text{
               text: {return styleData.value.toFixed(0);}
               color: {if(fuelGauge.type === "speed"){if(styleData.value >= 180) return "red"; else return fuelGauge.color;} else if(fuelGauge.type === "fuel") {if(styleData.value <= 15) return "red"; else return fuelGauge.color;} else return fuelGauge.color;}
           }

           valueBar: Rectangle {
               implicitWidth: 16
               color: Qt.rgba(fuelGauge.value / fuelGauge.maximumValue, 0, 1 - fuelGauge.value / fuelGauge.maximumValue, 1)
           }

           tickmark: Item {
               implicitWidth: 18
               implicitHeight: 1

               Rectangle {
                   color: fuelGauge.color;
                   anchors.fill: parent
                   anchors.leftMargin: 3
                   anchors.rightMargin: 3
               }
           }
           minorTickmark: Item {
               implicitWidth: 8
               implicitHeight: 1

               Rectangle {
                   color: fuelGauge.color;
                   anchors.fill: parent
                   anchors.leftMargin: 2
                   anchors.rightMargin: 4
               }
           }

       }
   }
