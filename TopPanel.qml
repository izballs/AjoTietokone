import QtQuick 2.9

Item {
    id: root;
    anchors.top: applicationWindow.top;
    width: applicationWindow.width
    height: 25

    property string page;

    Rectangle{
        anchors.fill: parent;
        color: "white";
        opacity: 0.6
    }
        Text{
            id:date;
            text: Qt.formatDate(new Date(), "dd.MM.yyyy dddd")
            font.pixelSize: 18;
            function dateChanged(){
                text = Qt.formatDate(new Date(), "dd.MM.yyyy dddd")
            }
        }

        Text{
            anchors.centerIn: parent;

            id: clock
            text: Qt.formatDateTime(new Date(), "H:m:s a");
            font.pixelSize: 20;
            function timeChanged(){
                text = Qt.formatDateTime(new Date(), "H:m:s a");
            }
        }

        Timer {
            interval: 100; running: true; repeat: true;
            onTriggered: clock.timeChanged()
        }
        Timer {
            interval: 1000; running: true; repeat: true;
            onTriggered: date.dateChanged()
        }

        Text{
            text: page;
            anchors.right: parent.right;
            anchors.rightMargin: 0;
            font.pixelSize: 18;
        }
}
