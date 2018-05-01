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

    Component.onCompleted: {
        state = serializer.getState()
        selectedChannel = state.channels[0] || {}
    }

    property var state: ({})
    property var selectedChannel: ({})
    property var currentProgram : ({})

    onStateChanged: {
        if (!Object.keys(state).length) {
            return
        }

        console.log('setState start')
        serializer.setState(state)
        console.log('setState end')
        guide.populateChannelModel(state.channels)
    }

    function qObjectToObject(type, qObject) {
        switch (type) {
            case 'channel':
                return {
                    _id: qObject._id,
                    name: qObject.name,
                    icon: qObject.icon,
                    country: qObject.country,
                }
            case 'program':
                return {
                    _id: qObject._id,
                    name: qObject.name,
                    description: qObject.description,
                    start: qObject.start,
                    end: qObject.end,
                }
            default:
                return {}
        }
    }

    function changeCountry(country) {
        state = Object.assign({}, state, { country: country })
    }

    function changeChannels(channels) {
        state = Object.assign({}, state, { channels: channels })
    }

    function changeChannel(channel) {
        selectedChannel = Object.assign({}, channel)
    }

    function changeCurrentProgram(program) {
        currentProgram = Object.assign({}, qObjectToObject('program', program))
    }

    TvGuidePage {
        id: guide

        onChangeChannel: appWindow.changeChannel(channel)
        onChangeCurrentProgram: appWindow.changeCurrentProgram(program)
    }

    initialPage: guide
    cover: CoverPage { }
}
