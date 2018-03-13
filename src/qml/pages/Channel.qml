import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Item {

    property var channel: ({})
    property bool loading: false
    property var currentProgram: ({})
    property bool initialized: false

    height: channelView.height
    width: channelView.width

    WorkerScript {
        id: worker
        source: "../js/programLoader.js"

        onMessage: postPopulate(messageObject)
    }

    function postPopulate(messageObject) {
        var currentIndex = messageObject.currentIndex;

        if (currentIndex) {
            listModel.get(currentIndex).currentProgram = true;
            currentProgram = listModel.get(currentIndex)
        }

        listView.positionViewAtIndex(currentIndex, ListView.Center)
        listView.currentIndex = currentIndex

        initialized = true
        loading = false
    }

    function populate(programs) {
        worker.sendMessage({ programs: programs, model: listModel })
    }

    function initialize() {
        loading = true
        TvApi.getPrograms(channel._id)
            .then(populate)
            .catch(populate)
    }

    Component.onDestruction: listModel.clear()

    ListModel {  id: listModel }

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: pageheader
            title: channel.name
        }

        SilicaListView {
            id: listView
            width: parent.width
            height: parent.height - pageheader.height
            anchors.top: pageheader.bottom
            model: listModel
            clip: true
            delegate: ListItem {
                width: parent.width
                contentHeight: Theme.itemSizeExtraSmall
                onClicked: pageStack.push(Qt.resolvedUrl("ProgramOverviewPage.qml"), {
                                              programName: name,
                                              programOverview: description,
                                              start: start,
                                              end: end
                                          })

                Column {
                    x: Theme.paddingLarge
                    width: parent.width - Theme.paddingLarge
                    anchors.centerIn: parent

                    Row {
                        width: parent.width

                        Label {
                            font.pixelSize: Theme.fontSizeSmall
                            color: currentProgram ? Theme.highlightColor : Theme.secondaryColor
                            text: start.toLocaleString(Qt.locale(), 'hh:mm')
                            width: 0.2 * parent.width
                        }

                        Label {
                            color: currentProgram ? Theme.highlightColor : Theme.primaryColor
                            text: name
                            font.pixelSize: Theme.fontSizeSmall
                            width: 0.8 * parent.width
                            truncationMode: TruncationMode.Fade
                        }
                    }
                }
            }

            VerticalScrollDecorator {
                id: decorator
                flickable: listView
            }

            ViewPlaceholder {
                enabled: listView.count === 0 && !loading
                text: qsTr("No programs")
                hintText: qsTr("Pull down to update or to select another channel")
            }

            ViewPlaceholder {
                enabled: loading
                text: qsTr("loading...")
            }
        }
    }
}
