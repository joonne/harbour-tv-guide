import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    id: cover

    Label {
        id: placeholder
        text: qsTr("No programs today")
        font.pixelSize: Theme.fontSizeTiny
        anchors.centerIn: cover
        visible: listView.count === 0
    }
}
