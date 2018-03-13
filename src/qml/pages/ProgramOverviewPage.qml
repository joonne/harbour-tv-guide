import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: programoverviewpage

    property string programName
    property string programOverview
    property var start
    property var end

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingMedium

            PageHeader {
                id: header
                title: programName
            }

            Item {
                id: padding
                height: Theme.paddingLarge
                width: programoverviewpage.width
            }

            TextField {
                id: timeField
                text: start.toLocaleString(Qt.locale(), 'hh:mm') + " - " + end.toLocaleString(Qt.locale(), 'hh:mm')
                readOnly: true
                label: qsTr("Time")
                font.pixelSize: Theme.fontSizeSmall
                width: programoverviewpage.width
            }

            TextField {
                id: durationField
                text: ((end.getTime() - start.getTime()) / 1000) / 60 + " " + qsTr("minutes")
                readOnly: true
                label: qsTr("Duration")
                font.pixelSize: Theme.fontSizeSmall
                width: programoverviewpage.width
            }

            TextExpander {
                id: expander
                width: programoverviewpage.width
                textContent: programOverview
                textLabel: qsTr("Description")
            }
        }
    }
}

