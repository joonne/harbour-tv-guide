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

    function isSelected(id) {
        return selectedChannels.some(function(channel) {
            return channel._id === id
        })
    }

    function populateChannels(result) {
        result.forEach(function(item) {
            var selected = false

            if (isSelected(item._id)) {
                selected = true
            }

            var channel = Object.assign({}, item, {
                                            selected: selected
                                        })

            channels.append(channel)
        })
    }

    function init() {
        TvApi.getChannels(country.abbreviation)
            .then(populateChannels)
            .catch(function() {
                channels.clear()
            })
    }

    function selectAll() {
        selectedChannels.length = 0
        for (var i = 0; i < listView.count; ++i) {
            selectedChannels.push(appWindow.qObjectToObject(channels.get(i)))
            channels.get(i).selected = true
        }
    }

    function unSelectAll() {
        selectedChannels.length = 0;
        for (var i = 0; i < listView.count; ++i) {
            channels.get(i).selected = false
        }
    }

    ListModel { id: channels }

    SilicaListView {
        id: listView
        anchors.fill: parent
        spacing: Theme.paddingLarge
        clip: true

        PullDownMenu {
            MenuItem {
                text: qsTr("Select all")
                onClicked: selectAll()
                enabled: selectedChannels.length !== listView.count
            }

            MenuItem {
                text: qsTr("Unselect all")
                onClicked: unSelectAll()
                enabled: selectedChannels.length === listView.count
            }

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
            color: selected ? Theme.highlightColor : Theme.primaryColor

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!isSelected(_id)) {
                        selectedChannels.push(appWindow.qObjectToObject(channels.get(index)))
                        channels.get(index).selected = true
                    } else {
                        selectedChannels = selectedChannels.filter(function(channel) {
                            return channel._id !== _id
                        })
                        channels.get(index).selected = false
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
