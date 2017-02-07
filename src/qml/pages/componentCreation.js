
var component;
var channel;

function createSpriteObjects() {
    component = Qt.createComponent(Qt.resolvedUrl("Channel.qml"));
    channel = component.createObject(channelView);

    if (channel === null) {
        console.log("Error creating object");
    }
}
