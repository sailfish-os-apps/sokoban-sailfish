import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../storage.js" as Storage
import ".."

Page {
    id: page;


    PageHeader {
        id: pageHeader;
        title: app.packages.get(app.currentPackage).name
    }

    Column {
        id: info
        spacing: Theme.paddingSmall
        anchors {
            left: parent.left;
            right: parent.right;
            top: pageHeader.bottom;
        }

        Label {
            x: Theme.paddingSmall
            anchors.left: parent.left;
            anchors.right: parent.right;
            font.pixelSize: Theme.fontSizeSmall
            text: app.packages.get(app.currentPackage).description
            color: Theme.primaryColor
            wrapMode: Text.WordWrap
        }
    }

    SilicaListView {
        id: listView
        model: app.packages.get(app.currentPackage).levels
        anchors {
            top: info.bottom;
            topMargin: Theme.paddingLarge;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        delegate: BackgroundItem {
            id: delegate

            property bool won: Storage.getBestScore(app.packages.get(app.currentPackage).name, name) !== "0";

            IconButton {
                id: wonIcon;
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingSmall
                icon.source: "image://theme/icon-header-accept"
                visible: delegate.won;
            }

            Label {
                anchors.left: wonIcon.right;
                anchors.leftMargin: Theme.paddingLarge
                text: name
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            onClicked: {
                app.currentLevel = index;
                pageStack.navigateBack();
                app.game.reload();
            }
        }
        VerticalScrollDecorator {}
    }
}
