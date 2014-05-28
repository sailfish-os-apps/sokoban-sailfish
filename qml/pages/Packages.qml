import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page;

    PackagesModel {
        id: packages;
    }

    SilicaListView {
        id: listView
        model: packages
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
            onClicked: {
                console.debug("packages", name, "selected")
            }
        }
        VerticalScrollDecorator {}
    }
}
