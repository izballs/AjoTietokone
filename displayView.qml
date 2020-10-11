import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick 2.11
import Qt.labs.folderlistmodel 2.1
import PLAYER 1.0
Rectangle{
  id: display_view;
  color: "transparent";

  width: 600
  height: 380
  Text {
            y: 40;
            text: "Select Wallpaper";
        }
        ListView {
            id: wallpaperInput;
            y: 100;
            x: parent.width / 2 - width / 2;
            onCurrentItemChanged: console.log("current item changed");
            width: parent.width - 20;
            height: 200;
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            orientation: "Horizontal";
            focus: true;
            clip: true;
            contentWidth: 160;
            flickableDirection: Flickable.AutoFlickDirection
            model: FolderListModel {
                folder: "file:///media/wallpapers/";
                nameFilters: ["*.jpg", "*.png"]

            }
            delegate: ItemDelegate{
                onClicked: wallpaperInput.currentIndex = index;
                height: 126;
                width: 160;
                Text {
                    text: fileName;
                    font.pixelSize: 14;
                }

                Image {

                source: "file:///media/wallpapers/" + fileName;
                width: 160;
                y: 30;
                height: 96;

                }

            }

        }


    Commands {
        id: commands;
    }
    Row{
        x: 100;
        y: 300;
        Button {
            id: saveSettings;
            text: "Save";
            onClicked: {settingsComp.wallpaper = "file:///media/wallpapers/" + wallpaperInput.currentItem.children[0].text; console.log(wallpaperInput.currentItem.fileName); settings.close(); noticePopup.noticy("Settings Saved!", 2000);
            }
        }
        Button {
            id: cancelSettings;
            text: "Cancel";
            onClicked: settings.close();
        }
    }

 }

