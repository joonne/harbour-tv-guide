import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

// Object.assign
import "./js/polyfills.js" as Polyfills

ApplicationWindow {
    id: appWindow

    readonly property string _APP_VERSION: appVersion
    readonly property string _APP_BUILD_NUMBER: appBuildNum

    // TODO: load state from LocalStorage / DB on start
    property var state: ({
                             channel: { name: "TV-GUIDE" },
                             country: { abbreviation: "fi" },
                             channels: [{
                                     _id: "jim.nelonen.fi",
                                     name: "JIM",
                                     icon: "http://chanlogos.xmltv.se/jim.nelonen.fi.png",
                                     country: "fi"
                                 }]
                         })

    function changeCountry(country) {
        state = Object.assign({}, state, { country: country });
    }

    function changeChannel(channel) {
        state = Object.assign({}, state, { channel: channel });
    }

    function changeChannels(channels) {
        state = Object.assign({}, state, { channels: channels });
        guide.populateChannelModel(state.channels)
    }

    initialPage: TvGuidePage { id: guide }
    cover: CoverPage { }
}


