import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: textExpander

    property string textLabel: ''
    property string textContent: ''

    Item {
        id: textContainer
        width: parent.width
        height: expanded ? actualSize : Math.min(actualSize, collapsedSize)
        clip: true

        Behavior on height {
            NumberAnimation { duration: 200 }
        }

        property int actualSize: innerColumn.height
        property int collapsedSize: (Theme.paddingLarge * 10)
        property bool expanded: false

        Column {
            id: innerColumn
            width: parent.width

            TextArea {
                id: contentLabel
                label: textLabel
                width: parent.width
                text:  textContent
                readOnly: true
                onClicked: textContainer.expanded = !textContainer.expanded
            }
        }

        OpacityRampEffect {
            sourceItem: innerColumn
            enabled: !textContainer.expanded
            direction: OpacityRamp.TopToBottom
        }
    }

    Item {
        id: expanderToggle
        height: Theme.paddingLarge
        width: parent.width
        visible: textContainer.actualSize >= textContainer.collapsedSize && textContainer.expanded === false

        MoreIndicator {
            id: moreIndicator
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
        }
    }
}
