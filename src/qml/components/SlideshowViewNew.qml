import QtQuick 2.0
import Sailfish.Silica 1.0

PathView {
    id: view

    property real itemWidth: view.width
    property real itemHeight: view.height

    // half of the centre item, plus the number of items partially or fully
    // visible in half the view
    property real _multiplier: Math.ceil((view.width/2) / view.itemWidth) + (pathItemCount <= 2 ? 0 : 0.5)

    property real _prevOffset

    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.width
    preferredHighlightBegin: _multiplier / pathItemCount
    preferredHighlightEnd: _multiplier / pathItemCount
    snapMode: PathView.SnapOneItem
    cacheItemCount: 100

    onOffsetChanged: {
        if (snapMode == PathView.SnapOneItem && dragging) {
            var delta = Math.abs(Math.floor(_prevOffset) - Math.floor(offset))
            if (delta == 1 || delta == count - 1) {
                offset = _prevOffset
            }
        }
        _prevOffset = offset
    }

    // show as many items on the path as possible, given the number of items
    // we can fit in the view according to itemWidth
    // itemWidth < 1 check ensures we don't divide by itemWidth when it is 0
    pathItemCount: (itemWidth < 1 || (count <= 2 && itemWidth >= width)) ? 2 : Math.max(3, Math.ceil(width / itemWidth) + 1)

    interactive: count > 1

    path: Path {
        id: path
        startX: -(view.itemWidth * view._multiplier - view.width/2)
        startY: view.itemHeight / 2

        PathLine {
            x: (view.pathItemCount * view.itemWidth) + path.startX
            y: view.itemHeight / 2
        }
    }
}
