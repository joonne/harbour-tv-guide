.pragma library
.import QtQuick.LocalStorage 2.0 as Storage

function getHandle() {
    try {
        var db = Storage.LocalStorage.openDatabaseSync("harbour-tv-guide", "1.0", "state", 100000);
    } catch (err) {
        console.log("Error opening database: " + err);
    }

    return db;
}

function init() {
    var db = getHandle();
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS state (id integer PRIMARY KEY, state text)')
        });
    } catch (err) {
        console.log("Error creating table in database: " + err);
    }
}

function writeState(state) {
    var db = getHandle();
    try {
        db.transaction(function (tx) {
            tx.executeSql('INSERT OR REPLACE INTO state VALUES(?,?)', [1, JSON.stringify(state)]);
        })
    } catch (error) {
        console.log("Error inserting state in database: " + err);
    }
}

function readState() {
    var state;
    var db = getHandle();
    db.transaction(function (tx) {
        var results = tx.executeSql('SELECT * FROM state WHERE id = 1;');
        try {
            state = JSON.parse(results.rows.item(0).state);
        } catch (error) {
            console.log('readState: ', error);
            state = { channel: {}, country: {}, channels: [{}] };
        }
    })

    return state;
}
