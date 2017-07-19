import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQml.Models 2.2

import "../components"

import "../js/tvApi.js" as TvApi
import "../js/channelFactory.js" as ChannelFactory

Page {
    id: tvguidepage

    function populate(channels) {
        channelModel.clear()
        console.log(channels)
        channels.forEach(function(channel) {
            channelModel.append(ChannelFactory.createChannel(channel))
        })
    }

    function initialize() {
        TvApi.getChannels()
            .then(populate)
            .catch(populate)
    }

    SilicaFlickable {
        anchors.fill: parent

        SlideshowViewNew {
            id: channelView
            anchors.fill: parent
            itemWidth: width

            onFlickEnded: {
                appWindow.channelName = channelView.currentItem.channelName
            }

            model: ObjectModel {
                id: channelModel
            }
        }

        Component.onCompleted: initialize()
    }
}
