import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../storage.js" as Storage
import ".."

Page {
    id: page;

    SilicaListView {
        id: listView
        model: app.packages
        anchors.fill: parent
        header: PageHeader {
            title: "Packages list"
        }
        delegate: BackgroundItem {
            id: delegate

            Label {
                x: Theme.paddingLarge
                text: name
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            Label {
                anchors.right: parent.right
                text: Storage.countLevel(name) + " / " + packages.get(index).levels.count
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            onClicked: {
                app.currentPackage = index
                app.currentLevel = 0;
                pageStack.navigateBack();
                app.game.reload();
            }
        }
        VerticalScrollDecorator {}
    }
}
