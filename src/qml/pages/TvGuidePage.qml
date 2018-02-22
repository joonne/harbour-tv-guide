import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQml.Models 2.2

import "../components"

import "../js/tvApi.js" as TvApi
import "../js/channelFactory.js" as ChannelFactory

Page {
    id: tvguidepage

    signal changeChannel(var channel)
    signal changeCurrentProgram(var program)

    function populateChannelModel(channels) {
        channelView.model = 0

        while (channelModel.get(0)) {
            var channel = channelModel.get(0)
            channel.destroy()
            channelModel.remove(0)
        }

        channels.forEach(function(channel) {
            channelModel.append(ChannelFactory.createChannel(channel))
        })

        channelView.model = channelModel
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"), {
                                              appWindow: appWindow
                                          })
            }

            MenuItem {
                text: qsTr("Update")
                onClicked: channelView.currentItem && channelView.currentItem.initialize()
            }
        }

        SlideshowView {
            id: channelView
            anchors.fill: parent
            itemWidth: width
            /* allows to create channels dynamically, possibly bad practice */
            cacheItemCount: 1000
            /* prevent pageStack from showing next/previous items upon flick */
            clip: true

            onFlickEnded: {
                tvguidepage.changeChannel(channelView.currentItem.channel)
                tvguidepage.changeCurrentProgram(channelView.currentItem.currentProgram)
            }

            model: ObjectModel {
                id: channelModel
            }

            ViewPlaceholder {
                enabled: !appWindow.state.channels.length
                text: qsTr("No channels selected")
                hintText: qsTr("Pull down to select channels")
            }
        }
    }
}
