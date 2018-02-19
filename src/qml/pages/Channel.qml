import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Item {
    property var channel: ({})
    property bool loading: false
    property var currentProgram: ({})

    height: channelView.height
    width: channelView.width

    function populateProgramModel(programs) {
        var dateNow = new Date();
        var currentIndex = 0;

        programs.forEach(function(program, index) {
            var start = new Date(program.data.start * 1000);
            var end = new Date(program.data.end * 1000);

            if (dateNow >= start && dateNow <= end) {
                currentIndex = index;
            }

            listModel.append({
                                 name: program.data.name,
                                 start: start,
                                 end: end,
                                 description: program.data.description,
                                 currentProgram: false,
                             });
        });

        if (currentIndex) {
            listModel.get(currentIndex).currentProgram = true;
            currentProgram = listModel.get(currentIndex)
        }

        listview.positionViewAtIndex(currentIndex, ListView.Beginning);
        listview.currentIndex = currentIndex;
        loading = false
    }

    function initialize() {
        listModel.clear()
        loading = true
        TvApi.getPrograms(channel._id)
            .then(populateProgramModel)
            .catch(populateProgramModel)
    }

    Component.onCompleted: initialize()

    ListModel {  id: listModel }

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: pageheader
            title: channel.name
        }

        SilicaListView {
            id: listview
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
                flickable: listview
            }

            ViewPlaceholder {
                enabled: listview.count === 0 && !loading
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
