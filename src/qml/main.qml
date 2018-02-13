import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

import "./js/storage.js" as DB

// Object.assign
import "./js/polyfills.js" as Polyfills

ApplicationWindow {
    id: appWindow

    readonly property string _APP_VERSION: appVersion
    readonly property string _APP_BUILD_NUMBER: appBuildNum

    Component.onCompleted: {
        DB.init()
        state = DB.readState()
        selectedChannel = state.channels[0] || {}
    }

    property var state: ({})
    property var selectedChannel: ({})

    onStateChanged: {
        if (!Object.keys(state).length) {
            return
        }

        DB.writeState(state)
        guide.populateChannelModel(state.channels)
    }

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
    }

    function changeChannel(channel) {
        selectedChannel = Object.assign({}, channel)
    }

    function changeChannels(channels) {
        state = Object.assign({}, state, { channels: channels })
    }

    initialPage: TvGuidePage { id: guide }
    cover: CoverPage { }
}
