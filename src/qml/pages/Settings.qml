import QtQuick 2.2
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Page {
    property var country: ({ name: "Not set" })
    property var channels: ([])
    property var appWindow

    Column {
        anchors.fill: parent
        spacing: Theme.paddingLarge

        PageHeader {
            title: qsTr("Settings")
        }

        SectionHeader { text: qsTr("Country") }

        DetailItem {
            label: qsTr("Selected")
            value: country.name
        }

        Button {
            text: qsTr("Select country")
            anchors {
                left: parent.left
                leftMargin: (parent.width - width) / 2
            }

            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("SelectCountryDialog.qml"), { country: country })
                dialog.accepted.connect(function() {
                    country = Object.assign({}, dialog.country)
                    appWindow.changeCountry(country)
                    console.log("country", JSON.stringify(country))
                })
            }
        }

        SectionHeader { text: qsTr("Channels") }

        DetailItem {
            label: qsTr("Selected")
            value: qsTr("%1 channels").arg(channels.length)
        }

        Button {
            text: qsTr("Select channels")
            anchors {
                left: parent.left
                leftMargin: (parent.width - width) / 2
            }

            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("SelectChannelsDialog.qml"), { country: country, selectedChannels: channels })
                dialog.accepted.connect(function() {
                    channels = dialog.selectedChannels.slice(0)
                    appWindow.changeChannels(channels)
                    console.log("channels", JSON.stringify(channels))
                })
            }
        }
    }
}
