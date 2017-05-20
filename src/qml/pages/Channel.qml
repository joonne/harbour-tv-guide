import QtQuick 2.0
import Sailfish.Silica 1.0

import "tvApi.js" as TvApi

Item {
    property string channelName: ""

    height: channelView.height
    width: channelView.width

    function initialize() {
        TvApi.getPrograms(channelName)
    }

    Component.onCompleted: initialize()

    ListModel {  id: listModel }

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: pageheader
            title: channelName
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
                onClicked: pageStack.push(Qt.resolvedUrl("ProgramOverviewPage.qml"), {
                                              programName: name,
                                              programOverview: description,
                                              start: start,
                                              end: end
                                          })

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
