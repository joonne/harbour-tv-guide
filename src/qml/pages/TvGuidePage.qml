import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQml.Models 2.2

import "../components"

import "../js/tvApi.js" as TvApi
import "../js/channelFactory.js" as ChannelFactory

Page {
    id: tvguidepage

    function populateChannelModel(channels) {
        channels.forEach(function(channel) {
            channelModel.append(ChannelFactory.createChannel(channel))
        })
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
                appWindow.changeChannel(appWindow.qObjectToObject(channelView.currentItem.channel))
            }

            model: ObjectModel {
                id: channelModel
            }
        }
    }
}
