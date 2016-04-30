import QtQuick 2.0
import Sailfish.Silica 1.0
import "parser.js" as Parser

Item {

    property string channelName: "";

    height: channelView.height;
    width: channelView.width;

    function initialize(channel) {
        channelName = channel;
        Parser.load(channel);
    }

    ListModel {  id:listModel }

    SilicaListView {
        id: listview

        header: Component {
            PageHeader {
                id: pageheader
                title: channelName
            }
        }

        anchors.fill: parent
        model: listModel
        delegate: ListItem {

            width: parent.width
            onClicked: {
                pageStack.push(Qt.resolvedUrl("ProgramOverviewPage.qml"),
                               { programName: name,
                                 programOverview: description,
                                 start: start,
                                 end: end})
            }

            Column {
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge

                Label {
                    color: currentProgram ? Theme.highlightColor : Theme.primaryColor;
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
            text: "Ei ohjelmia."
        }
    }
}

