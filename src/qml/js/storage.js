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
}

function dbGetHandle()
{
    try {
        var db = Storage.LocalStorage.openDatabaseSync("harbour-tv-guide", "1.0", "state", 100000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }

    return db
}

function dbInit()
{
    var db = dbGetHandle();
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS state (id integer PRIMARY KEY, state text)')
        });
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function writeState(state)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT OR REPLACE INTO state VALUES(?,?)', [1, JSON.stringify(state)])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })

    return rowid;
}

function readState()
{
    var state;
    var db = dbGetHandle()
    db.transaction(function (tx) {
        var results = tx.executeSql('SELECT * FROM state WHERE id = 1;')
        try {
            state = JSON.parse(results.rows.item(0).state)
        } catch (error) {
            console.log('readState: ', error)
//            TODO: use this & make UI respond to empty initial state
//            state = { channel: {}, country: {}, channels: [{}] }
            state = initialState;
        }
    })

    return state
}
