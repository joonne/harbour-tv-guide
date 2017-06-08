import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow {
    id: appWindow

    readonly property string _APP_VERSION: appVersion
    readonly property string _APP_BUILD_NUMBER: appBuildNum

    property string channelName: "TV-GUIDE"

    initialPage: TvGuidePage { }
    cover: CoverPage { }
}


