function createChannel(channelName) {
    var component = Qt.createComponent(Qt.resolvedUrl("../pages/Channel.qml"));
    var channel = component.createObject(appWindow, { "channelName": channelName });

    if (channel === null) {
        console.log("Error creating object");
    }

    return channel;
}
