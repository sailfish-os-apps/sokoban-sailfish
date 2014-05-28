import QtQuick 2.0
import Sailfish.Silica 1.0
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
            x: Theme.paddingLarge
            text: app.packages.get(app.currentPackage).description
            color: Theme.primaryColor
        }
        Label {
            x: Theme.paddingLarge
            text: app.packages.get(app.currentPackage).mail
            font.pixelSize: Theme.fontSizeSmall;
            color: Theme.primaryColor
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

            Label {
                x: Theme.paddingLarge
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
