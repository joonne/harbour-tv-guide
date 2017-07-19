import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQml.Models 2.2

import "../components"

import "../js/tvApi.js" as TvApi
import "../js/channelFactory.js" as ChannelFactory

Page {
    id: tvguidepage

    function populateChannelModel(channels) {
        channelModel.clear()
        console.log(channels)
        channels.forEach(function(channel) {
            channelModel.append(ChannelFactory.createChannel(channel))
        })
    }

    SilicaFlickable {
        anchors.fill: parent

        SlideshowView {
            id: channelView
            anchors.fill: parent
            itemWidth: width
            /* allows to create channels dynamically */
            cacheItemCount: 100

            onFlickEnded: {
                appWindow.channelName = channelView.currentItem.channelName
            }

            model: ObjectModel {
                id: channelModel
            }
        }

        Component.onCompleted: {
            TvApi.getChannels()
                .then(populateChannelModel)
                .catch(populateChannelModel)
        }
    }
}
