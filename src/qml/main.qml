import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

import "./js/storage.js" as Storage

// Object.assign
import "./js/polyfills.js" as Polyfills

ApplicationWindow {
    id: appWindow

    readonly property string _APP_VERSION: appVersion
    readonly property string _APP_BUILD_NUMBER: appBuildNum

    Component.onCompleted: {
        Storage.dbInit()
        state = Storage.readState()
        guide.populateChannelModel(state.channels)
    }

    property var state: ({})

    function qObjectToObject(qObject) {
        return {
            _id: qObject._id,
            name: qObject.name,
            icon: qObject.icon,
            country: qObject.country,
        }
    }

    function changeCountry(country) {
        state = Object.assign({}, state, { country: country })
        Storage.writeState(state)
    }

    function changeChannel(channel) {
        state = Object.assign({}, state, { channel: channel })
        Storage.writeState(state)
    }

    function changeChannels(channels) {
        state = Object.assign({}, state, { channels: channels })
        Storage.writeState(state)
        // TODO: clear model correctly
         guide.populateChannelModel(state.channels)
    }

    initialPage: TvGuidePage { id: guide }
    cover: CoverPage { }
}


