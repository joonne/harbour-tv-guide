import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Dialog {
    property var country: ({})

    Component.onCompleted: {
        TvApi.getCountries()
            .then(function(result) {
                result.forEach(function(item) {
                    countries.append(item)
                })
            })
    }

    ListModel { id: countries }

    SilicaListView {
        id: listView
        anchors.fill: parent
        model: countries
        spacing: Theme.paddingLarge
        clip: true

        header: DialogHeader { title: qsTr("Country") }

        delegate: Label {
            id: countrydelegate
            anchors {
                left: parent.left
                leftMargin: (parent.width - width) / 2
            }
            text: name
            font.pixelSize: Theme.fontSizeMedium
            color: country && country._id === _id ? Theme.highlightColor : Theme.primaryColor

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    country = countries.get(index)
                    accept()
                }
            }
        }
    }
}
