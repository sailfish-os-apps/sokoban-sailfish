# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-sokoban

CONFIG += sailfishapp

SOURCES += src/harbour-sokoban.cpp

OTHER_FILES += qml/harbour-sokoban.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-sokoban.changes.in \
    rpm/harbour-sokoban.spec \
    rpm/harbour-sokoban.yaml \
    harbour-sokoban.desktop \
    qml/GameComponent/Sokoban.qml \
    qml/GameComponent/Box.qml \
    qml/GameComponent/Floor.qml \
    qml/GameComponent/Goal.qml \
    qml/GameComponent/Player.qml \
    qml/GameComponent/SwipeArea.qml \
    qml/GameComponent/Wall.qml \
    qml/pages/MainPage.qml \
    qml/pages/Packages.qml \
    qml/PackagesModel.qml



# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n
#TRANSLATIONS += translations/harbour-sokoban-de.ts

