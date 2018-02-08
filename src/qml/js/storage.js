.pragma library
.import QtQuick.LocalStorage 2.0 as Storage

var initialState = {
    channel: {
        _id: "jim.nelonen.fi",
        name: "JIM",
        icon: "http://chanlogos.xmltv.se/jim.nelonen.fi.png",
        country: "fi"
    },
    country: {
        _id: "5a78c818ba6fa20011a907f0",
        name: "Finland",
        abbreviation: "fi"
    },
    channels: [{
        _id: "jim.nelonen.fi",
        name: "JIM",
        icon: "http://chanlogos.xmltv.se/jim.nelonen.fi.png",
        country: "fi"
    }]
};

function getDatabase() {
    return Storage.LocalStorage.openDatabaseSync("harbour-tv-guide", "1.0", "state", 100000);
}

function dbInit()
{
    var db = getDatabase();
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS state (state text)');
        });
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle()
{
    try {
        var db = getDatabase();
    } catch (err) {
        console.log("Error opening database: " + err)
    }

    return db
}

function writeState(state)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO state VALUES(?)', [state])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })

    return rowid;
}

function readState()
{
    var db = dbGetHandle()
    db.transaction(function (tx) {
        var results = tx.executeSql('SELECT state FROM state')
        return results.rows.item(0) ? results.rows.item(0).state : initialState
    })
}
