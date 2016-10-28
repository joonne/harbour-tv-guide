import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: tvguidepage

    SlideshowView {
        id: channelView
        width: tvguidepage.width
        height: tvguidepage.height - container.height
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
        }
    }

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
        ava.initialize("ava");
        hero.initialize("hero");
    }

//    Rectangle {
//        id: container
//        width: tvguidepage.width
//        height: 5 * Theme.paddingLarge
//        anchors {
//            top: channelView.bottom
//        }
//        border.width: 5
//        opacity: 0.2

//        Label {
//            text: "yle1"
//            anchors {
//                centerIn: container
//            }
//            color: Theme.primaryColor
//        }

//        Component.onCompleted: {
//            console.log(channelView.itemAt(0,0).data)
//            console.log(channelView.itemAt(1,0).data)
//            console.log(channelView.itemAt(2,0).data)
//        }
//    }



    Component.onCompleted: {
        initialize()
    }
}
