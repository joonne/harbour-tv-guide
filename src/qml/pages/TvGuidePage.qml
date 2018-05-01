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

    property var initializer: undefined

    Item { id: dummy }

    function clearItem(index) {
        channelModel.get(index).destroy()
        channelModel.remove(index)
    }

    function populateChannelModel(channels) {
        while (channelModel.get(0)) {
            clearItem(0)
        }

        channels.forEach(function(channel) {
            channelModel.append(dummy)
        })

        initializer = handleInitialization(channels)
        initializer()
    }

    function handleInitialization(channels) {
        var channels_ = channels

        var initializeChannel = function(index) {
            if (channelModel.get(index) && channelModel.get(index).toString().indexOf('Channel') > -1) {
                return;
            }

            console.log(channelModel.get(index - 1), channelModel.get(index), channelModel.get(index + 1))

            channelModel.insert(index, ChannelFactory.createChannel(channels_[index]))

            if (channelModel.get(index + 1) && channelModel.get(index + 1).toString().indexOf('QQuickItem') > -1) {
                console.log('remove', channelModel.get(index + 1))
                channelModel.remove(index + 1); // clear the dummy item
            }

            if (channelModel.get(index - 1) && channelModel.get(index - 1).toString().indexOf('QQuickItem') > -1) {
                console.log('remove', channelModel.get(index - 1))
                channelModel.remove(index - 1); // clear the dummy item
            }
        }

        return function() {

            if (channelView.currentIndex > 2) {

                initializeChannel(channelView.currentIndex - 3)
                initializeChannel(channelView.currentIndex - 2)
                initializeChannel(channelView.currentIndex - 1)

            } else {

                initializeChannel(channelModel.count - 3)
                initializeChannel(channelModel.count - 2)
                initializeChannel(channelModel.count - 1)
            }

            console.log('channelView has', channelView.count, 'items')
            console.log('channelModel has', channelModel.count, 'items')
            initializeChannel(channelView.currentIndex)
            initializeChannel(channelView.currentIndex + 1)
            console.log('channelView has', channelView.count, 'items')
            console.log('channelModel has', channelModel.count, 'items')
            initializeChannel(channelView.currentIndex + 2)
            initializeChannel(channelView.currentIndex + 3)
        }
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
                enabled: channelView.currentItem !== null && typeof channelView.currentItem.initialize === 'function'
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
                initializer()
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
