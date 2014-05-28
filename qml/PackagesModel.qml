import QtQuick 2.0

ListModel {
    id: packages;
    ListElement {
        name: "Birthday"
        description: "Birthday collection by Alberto Garcia"
        mail: "albertogarcia84@hotmail.com"
        levels:[
            ListElement {
                name: "Birthday 1 Welcome to my huge collection of levels...";
                level: "####\n# .#\n# .###\n# .$ ##\n# .$  #\n# .$  #\n## $$ #\n ###@ #\n   ####"
            },
            ListElement {
                name: "Birthday 2 Easy level"
                level: "   #######\n   #  #  #\n   #  $  #\n  ##$ $  #\n### $ $  #\n#   $ ####\n#     #\n#  ######\n## #..  #\n#  @..  #\n#  #..  #\n#  ######\n####"
            }
        ]
    }
}
