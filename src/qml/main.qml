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

    property var state: Storage.readState()

    function changeCountry(country) {
        state = Object.assign({}, state, { country: country })
    }

    function changeChannel(channel) {
        state = Object.assign({}, state, { channel: channel })
    }

    function changeChannels(channels) {
        state = Object.assign({}, state, { channels: channels })
        // TODO: clear model correctly
        // guide.populateChannelModel(state.channels)
    }

    initialPage: TvGuidePage { id: guide }
    cover: CoverPage { }
}


