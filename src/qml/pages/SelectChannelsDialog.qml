import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Dialog {
    property var country: ({})
    property var selectedChannels: ([])

    Component.onCompleted: {
        TvApi.getChannels(country.abbreviation)
            .then(function(result) {
                result.forEach(function(item) {
                    channels.append(item)
                })
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
        model: channels
        spacing: Theme.paddingLarge
        clip: true

        header: DialogHeader { title: qsTr("Channels") }

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
                        selectedChannels.push(channels.get(index))
                    } else {
                        selectedChannels = selectedChannels.filter(function(channel) {
                            return channel._id !== _id
                        })
                    }

                    console.log(selectedChannels)
                }
            }
        }
    }
}
