.import "http.js" as HTTP

function getPrograms(channel) {
    var url = 'http://tvapi-mashupjonne.rhcloud.com/api/programs/' + channel;
    return HTTP.get(url);
}

function getChannels() {
    var url = 'http://tvapi-mashupjonne.rhcloud.com/api/channels';
    return HTTP.get(url);
}
