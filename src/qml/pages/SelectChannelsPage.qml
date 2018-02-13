import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Page {
    property var country: ({})
    property var selectedChannels: ([])
    property var appWindow

    Component.onCompleted: init()

    Component.onDestruction: {
        appWindow.changeChannels(selectedChannels)
        appWindow.changeChannel(selectedChannels[0])
    }

    function init() {
        TvApi.getChannels(country.abbreviation)
            .then(function(result) {
                result.forEach(function(item) {
                    channels.append(item)
                })
            })
            .catch(function() {
                channels.clear()
            })
    }

    function isSelected(id) {
        return selectedChannels.some(function(channel) {
            return channel._id === id
        })
    }

    ListModel { id: channels }

    SilicaListView {
        id: listView
        anchors.fill: parent
        spacing: Theme.paddingLarge
        clip: true

        PullDownMenu {
            MenuItem {
                text: qsTr("Update")
                onClicked: init()
            }
        }

        header: PageHeader {
            id: header
            title: qsTr("Channels")
        }

        model: channels

        delegate: Label {
            anchors {
                left: parent.left
                leftMargin: (parent.width - width) / 2
            }
            text: name
            font.pixelSize: Theme.fontSizeMedium
            color: isSelected(_id) ? Theme.highlightColor : Theme.primaryColor

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!isSelected(_id)) {
                        selectedChannels.push(appWindow.qObjectToObject(channels.get(index)))
                    } else {
                        selectedChannels = selectedChannels.filter(function(channel) {
                            return channel._id !== _id
                        })
                    }

                    console.log(selectedChannels.length, 'channels selected')
                }
            }
        }

        VerticalScrollDecorator { flickable: listView }

        ViewPlaceholder {
             enabled: listView.count === 0
             text: qsTr("No channels")
             hintText: qsTr("Pull down to try to fetch channels again")
        }
    }
}
