function getDatabase() {
    return LocalStorage.openDatabaseSync("Sokoban", "1.0", "StorageDatabase", 100000);
}

function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS data(label TEXT UNIQUE, data TEXT)');
                });
}

function setData(label, data) {
    var db = getDatabase();
    var ret = false;
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO data VALUES (?,?);', [label,data]);
        if (rs.rowsAffected > 0) {
            ret = true;
        }
        else {
            ret = false;
        }
    }
    );
    return ret;
}

function getData(label) {
    var db = getDatabase();
    var ret = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT data FROM data WHERE label=?;', [label]);
        if (rs.rows.length > 0) {
            ret = rs.rows.item(0).data;
        } else {
            ret = "0";
        }
    })
    return ret;
}

function countLevel(packageName) {
    var db = getDatabase();
    var ret = "";
    if (packageName === undefined) { packageName = ""; }
    db.transaction(function(tx) {
        if (packageName.indexOf("'") !== -1) {
            packageName = packageName.slice(0, packageName.indexOf("'"))
        }

        var rs = tx.executeSql("SELECT COUNT(label) as count FROM data WHERE label like 'bestscore:" + packageName +"%';");
        if (rs.rows.length > 0) {
            ret = rs.rows.item(0).count;
        } else {
            ret = "0";
        }
    })
    return ret;
}

function destroyData() {
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('DROP TABLE data');
    });
}

function getBestScore(packageName, levelName) {
    return getData("bestscore:" + packageName + "=>" + levelName)
}

function setBestScore(packageName, levelName, bestscore) {
    setData("bestscore:" + packageName + "=>" + levelName, bestscore)
}

function getLastPackage() {
    return getData("lastPackage")
}

function setLastPackage(packageNumber) {
    setData("lastPackage", packageNumber)
}

function getLastLevel() {
    return getData("lastLevel")
}

function setLastLevel(level) {
    setData("lastLevel", level)
}
