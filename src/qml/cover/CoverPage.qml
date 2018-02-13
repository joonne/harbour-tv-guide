import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: cover

    Column {
        anchors.centerIn: parent
        spacing: Theme.paddingLarge

        Image {
            source: appWindow.selectedChannel.icon
            sourceSize.width: parent.width
            anchors {
                left: parent.left
                leftMargin: (parent.width - width) / 2
            }
        }

        Label {
            id: placeholder
            text: appWindow.selectedChannel.name
            font.pixelSize: Theme.fontSizeTiny
            anchors {
                left: parent.left
                leftMargin: (parent.width - width) / 2
            }
        }
    }
}
