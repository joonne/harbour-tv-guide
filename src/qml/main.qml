import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow {

    readonly property string _APP_VERSION: appVersion
    readonly property string _APP_BUILD_NUMBER: appBuildNum

    initialPage: TVguidePage { version: _APP_VERSION; buildNum: _APP_BUILD_NUMBER }
    cover: CoverPage { }
}


