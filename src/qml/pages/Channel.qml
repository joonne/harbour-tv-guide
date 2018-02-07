import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Item {
    property var channel: ({})

    height: channelView.height
    width: channelView.width

    function populateProgramModel(programs) {
        var dateNow = new Date();
        var currentIndex = 0;

        programs.forEach(function(program, index) {
            if (dateNow >= new Date(program.data.start) && dateNow <= new Date(program.data.end)) {
                currentIndex = index;
            }

            listModel.append({
                                 name: program.data.name,
                                 start: new Date(program.data.start).toLocaleString(Qt.locale(), 'hh:mm'),
                                 end: new Date(program.data.end).toLocaleString(Qt.locale(), 'hh:mm'),
                                 description: program.data.description,
                                 currentProgram: false,
                             });
        });

        if (currentIndex) {
            listModel.get(currentIndex).currentProgram = true;
        }

        listview.positionViewAtIndex(currentIndex, ListView.Beginning);
        listview.currentIndex = currentIndex;
    }

    function initialize() {
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
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ProgramOverviewPage.qml"), {
                                       programName: name,
                                       programOverview: description,
                                       start: start,
                                       end: end
                                   })
                }

                Column {
                    x: Theme.paddingLarge
                    width: parent.width - Theme.paddingLarge

                    Label {
                        color: currentProgram ? Theme.highlightColor : Theme.primaryColor
                        text: name
                        width: parent.width
                        truncationMode: TruncationMode.Fade
                    }

                    Label {
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                        text: start + " - " + end

                    }
                }
            }

            VerticalScrollDecorator {
                id: decorator
            }

            ViewPlaceholder {
                enabled: listview.count === 0
                text: qsTr("Ei ohjelmia.")
            }
        }
    }
}
