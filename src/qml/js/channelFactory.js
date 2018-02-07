function createChannel(channel) {
    var component = Qt.createComponent(Qt.resolvedUrl("../pages/Channel.qml"));
    var channelObject = component.createObject(appWindow, { "channel": channel });

    if (channelObject === null) {
        console.log("Error creating object");
    }

    return channelObject;
}
