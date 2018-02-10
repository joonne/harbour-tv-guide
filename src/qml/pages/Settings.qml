import QtQuick 2.2
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Page {
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
            value: appWindow.state.country.name
        }

        Button {
            text: qsTr("Select country")
            anchors {
                left: parent.left
                leftMargin: (parent.width - width) / 2
            }

            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("SelectCountryDialog.qml"), { country: appWindow.state.country })
                dialog.accepted.connect(function() {
                    appWindow.changeCountry(Object.assign({}, dialog.country))
                    appWindow.changeChannels([])
                })
            }
        }

        SectionHeader { text: qsTr("Channels") }

        DetailItem {
            label: qsTr("Selected")
            value: qsTr("%1 channels").arg(appWindow.state.channels.length)
        }

        Button {
            text: qsTr("Select channels")
            anchors {
                left: parent.left
                leftMargin: (parent.width - width) / 2
            }

            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("SelectChannelsDialog.qml"), { country: appWindow.state.country, selectedChannels: appWindow.state.channels })
                dialog.accepted.connect(function() {
                    appWindow.changeChannels(dialog.selectedChannels.slice(0))
                    appWindow.changeChannel(dialog.selectedChannels.slice(0)[0])
                })
            }
        }
    }
}
