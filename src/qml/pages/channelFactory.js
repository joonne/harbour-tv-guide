var component;
var channel;

function createChannel(channelName) {
    component = Qt.createComponent(Qt.resolvedUrl("Channel.qml"));
    channel = component.createObject(appWindow, { "channelName": channelName });

    if (channel === null) {
        console.log("Error creating object");
    }

    return channel;
}
