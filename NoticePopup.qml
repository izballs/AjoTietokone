import QtQuick 2.10
import QtQuick.Controls 2.3

Item {
    width: parent.width;
    height: parent.height;
    id: noticyItem;
    Popup{
        width: noticyRec.width
        height: noticyRec.height
        id: nPopup;

        background: Rectangle {
            id: noticyRec
            radius: 50;
            width: noticeText.width + 100;
            height: 50;
            y: 40;
            x: noticyItem.width / 2 - width / 2;
            Text {
                id: noticeText;
                text: "";
                x: parent.width / 2 - width / 2;
                y: parent.height / 2 - height / 2;
            }
        }
    }

    Timer {
        id: noticeTimer;
        interval: 500; running: false; repeat: false;
        onTriggered: nPopup.close();
    }

    function noticy(text, time){
        noticeText.text = text;
        noticeTimer.interval = time;
        nPopup.open();
        noticeTimer.start();
    }
}
