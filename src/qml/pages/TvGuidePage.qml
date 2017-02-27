import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQml.Models 2.2

import "tvApi.js" as TvApi
import "channelFactory.js" as ChannelFactory

Page {
    id: tvguidepage

    function populate(channels) {
        channels.forEach(function(channel) {
            channelModel.append(ChannelFactory.createChannel(channel))
        })
    }

    function initialize() {
        TvApi.getChannels(populate)
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Päivitä kaikki kanavat")
                onClicked: initialize()
            }
        }

        SlideshowView {
            id: channelView
            width: parent.width
            height: parent.height
            itemWidth: width

            model: ObjectModel {
                id: channelModel
            }
        }

        Component.onCompleted: initialize()
    }
}
