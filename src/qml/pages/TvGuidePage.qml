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
        while (channelModel.get(0)) {
            var channel = channelModel.get(0)
            channel.destroy()
            channelModel.remove(0)
        }

        channels.forEach(function(channel) {
            channelModel.append(ChannelFactory.createChannel(channel))
        })

        handleInitialization()
    }

    function initializeChannel(index) {
        if (channelModel.get(index) && !channelModel.get(index).initialized) {
            channelModel.get(index).initialize()
        }
    }

    function handleInitialization() {

        if (channelView.currentIndex > 2) {

            initializeChannel(channelView.currentIndex - 3)
            initializeChannel(channelView.currentIndex - 2)
            initializeChannel(channelView.currentIndex - 1)

        } else {

            initializeChannel(channelModel.count - 3)
            initializeChannel(channelModel.count - 2)
            initializeChannel(channelModel.count - 1)
        }

        initializeChannel(channelView.currentIndex)
        initializeChannel(channelView.currentIndex + 1)
        initializeChannel(channelView.currentIndex + 2)
        initializeChannel(channelView.currentIndex + 3)
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
                onClicked: channelView.currentItem.initialize()
                enabled: channelView.currentItem !== null
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
                handleInitialization()
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
