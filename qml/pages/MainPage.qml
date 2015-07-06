/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../storage.js" as Storage
import "../GameComponent"


Page {
    id: page

    SilicaFlickable {
        id: flickable;
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "About";
                onClicked: pageStack.push("About.qml");
            }
            MenuItem {
                text: "Package (" + app.packages.get(app.currentPackage).name + ")";
                onClicked: pageStack.push("Packages.qml");
            }
            MenuItem {
                text: "Restart game";
                onClicked:  loadGame();
            }
        }

        Column {
            id: info
            spacing: Theme.paddingSmall
            anchors {
                left: parent.left;
                right: parent.right;
                margins: Theme.paddingLarge;
            }

            PageHeader {
                id: pageHeader;
                title: packages.get(currentPackage).levels.get(currentLevel).name
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter

                IconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: "image://theme/icon-m-left"
                    enabled: currentLevel > 0
                    onClicked: {
                        currentLevel--;
                        loadGame();
                    }
                }
                Column {
                    anchors.verticalCenter: parent.verticalCenter;
                    Label {
                        x: Theme.paddingSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeMedium
                        text: app.bestScore === 0 ? "unsolved" : "solved in " + app.bestScore;
                        color: Theme.highlightColor
                        wrapMode: Text.WordWrap
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter

                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            x: Theme.paddingSmall
                            font.pixelSize: Theme.fontSizeMedium
                            text: "moves : "
                            color: Theme.highlightColor
                            wrapMode: Text.WordWrap
                        }

                        IconButton {
                            anchors.verticalCenter: parent.verticalCenter
                            icon.source: "image://theme/icon-m-previous-song"
                            enabled: app.game.moves > 0
                            property bool isHold: false;

                            onClicked: {
                                app.game.undo();
                            }
                            onPressed: {
                                isHold = true;
                            }
                            onReleased: {
                                isHold = false
                            }

                            Timer {
                                interval: 300;
                                running: parent.isHold;
                                repeat: true
                                onTriggered: app.game.undo();
                            }
                        }

                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            x: Theme.paddingSmall
                            font.pixelSize: Theme.fontSizeMedium
                            text: app.game.moves + "     "
                            color: Theme.highlightColor
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                IconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: "image://theme/icon-m-right"
                    enabled: currentLevel < packages.get(currentPackage).levels.count - 1
                    onClicked: {
                        currentLevel++;
                        loadGame();
                    }
                }
            }

            BackgroundItem {
                height: columnLevels.height

                Column {
                    id: columnLevels
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: Theme.paddingSmall
                    Label {
                        anchors.left: parent.left;
                        anchors.right: parent.right;
                        font.pixelSize: Theme.fontSizeMedium
                        text: app.packages.get(app.currentPackage).name
                        color: Theme.highlightColor
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        maximumLineCount: 4;
                        anchors.left: parent.left;
                        anchors.right: parent.right;
                        font.pixelSize: Theme.fontSizeSmall
                        text: app.packages.get(app.currentPackage).description
                        color: Theme.primaryColor
                        wrapMode: Text.WordWrap
                        truncationMode: TruncationMode.Elide;
                    }

                }
                onClicked: {
                    pageStack.push("Levels.qml");
                }
            }
        }

    }

    Connections {
        target: app;
        onCurrentLevelChanged: { loadGame (); }
        onCurrentPackageChanged: { loadGame (); }
    }

    function loadGame() {
        if (app.game) {
            app.game.destroy();
            app.bestScore = 0;
        }
        var packageName = packages.get(currentPackage).name;
        var levelName = packages.get(currentPackage).levels.get(currentLevel).name
        Storage.initialize();
        app.bestScore = Storage.getBestScore(packageName, levelName);
        if (app.level) {
            app.game = gameComponent.createObject (gameContainer, {"level": app.level})
        }
        else {
            app.game = gameComponent.createObject (gameContainer, {})
        }
    }

    Item {
        id: gameContainer;
        height: parent.height - info.height;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            leftMargin: 10;
            rightMargin: 10;
            bottomMargin: 5;
            topMargin: 20;
        }
        Component.onCompleted: { loadGame (); }
    }
    Component {
        id: gameComponent;
        Sokoban {
            anchors.fill: parent
            moveThreshold: app.moveThreshold;
            signal reload;

            onReload: {
                loadGame();
            }

            onWin: {
                Storage.initialize();
                var packageName = packages.get(currentPackage).name;
                var levelName = packages.get(currentPackage).levels.get(currentLevel).name
                var score = Storage.getBestScore(packageName, levelName);
                console.debug(score, moves, app.bestScore);
                if (score === "0" || moves < score) {
                    Storage.setBestScore(packageName, levelName, moves)
                    app.bestScore = moves;
                }
                console.debug(score, moves, app.bestScore);
            }
        }
    }
}


