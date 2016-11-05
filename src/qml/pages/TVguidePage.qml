import QtQuick 2.0
import Sailfish.Silica 1.0

import "tv-api.js" as TVAPI

Page {
    id: tvguidepage

    function initialize() {
        tv1.initialize("yle1");
        tv2.initialize("yle2");
        mtv3.initialize("mtv3");
        nelonen.initialize("nelonen");
        subtv.initialize("subtv");
        liv.initialize("liv");
        jim.initialize("jim");
        viisi.initialize("viisi");
        kutonen.initialize("kutonen");
        fox.initialize("fox");
        ava.initialize("mtv3ava");
        hero.initialize("hero");
        frii.initialize("frii");
        alfatv.initialize("alfatv");
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Päivitä kaikki kanavat")
                onClicked: initialize();
            }
        }

        SlideshowView {
            id: channelView
            width: parent.width
            height: parent.height
            itemWidth: width

            model: VisualItemModel {
                id: channels

                Channel { id: tv1 }
                Channel { id: tv2 }
                Channel { id: mtv3 }
                Channel { id: nelonen }
                Channel { id: subtv }
                Channel { id: liv }
                Channel { id: jim }
                Channel { id: viisi }
                Channel { id: kutonen }
                Channel { id: fox }
                Channel { id: ava }
                Channel { id: hero }
                Channel { id: frii }
                Channel { id: alfatv }
            }
        }

        Component.onCompleted: {
            TVAPI.getChannels();
            initialize();
        }
    }
}
