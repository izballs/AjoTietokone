import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    id: keyPad
    property var target
    property bool fokus;
    property int buttonWidth;
    property int buttonHeight;
    property int borderWidth;

    FocusScope{
        onFocusChanged: if(focus) fokus = true; else fokus = false;
    Row {
        width: keyPad.width
        height: keyPad.height
        Column {
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num1
                Text {
                    text: "1"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "1")

            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num4
                Text {
                    text: "4"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "4")

            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num7
                Text {
                    text: "7"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "7")

            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: dot
                Text {
                    text: "."
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, ".")

            }
        }
        Column {
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num2
                Text {
                    text: "2"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "2")

            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num5
                Text {
                    text: "5"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "5")

            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num8
                Text {
                    text: "8"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "8")
            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num0
                Text {
                    text: "0"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "0")
            }
        }
        Column {
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num3
                Text {
                    text: "3"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "3")
            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num6
                Text {
                    text: "6"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "6")
            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: num9
                Text {
                    text: "9"
                    anchors.centerIn: parent
                }
                onClicked: target.insert(target.cursorPosition, "9")
            }
            Button {
                background: Rectangle{
                    anchors.fill: parent;
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: keyPad.borderWidth
                    radius: 4
                }
                height: buttonHeight;
                width: buttonWidth;
                id: backspace
                Text {
                    text: "←"
                    anchors.centerIn: parent
                }
                onClicked: target.remove(target.cursorPosition - 1,
                                         target.cursorPosition)
            }
        }
    }
}
}
