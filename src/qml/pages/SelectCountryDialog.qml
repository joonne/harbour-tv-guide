import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/tvApi.js" as TvApi

Dialog {
    property var country: ({})

    function populateCountriesModel(result) {
        result.forEach(function(item) {
            countries.append(item)
        })
    }

    Component.onCompleted: {
        TvApi.getCountries()
            .then(populateCountriesModel)
            .catch(function(error) {
                console.log(JSON.stringify(error, null, 2))
                countries.clear()
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
                    country = {
                        _id: countries.get(index)._id,
                        name: countries.get(index).name,
                        abbreviation: countries.get(index).abbreviation,
                    }
                }
            }
        }

        VerticalScrollDecorator { flickable: listView }

        ViewPlaceholder {
             enabled: listView.count === 0
             text: qsTr("No countries")
             hintText: qsTr("Pull down to try to fetch countries again")
        }
    }
}
