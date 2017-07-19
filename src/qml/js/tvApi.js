.import "http.js" as HTTP

var baseUrl = 'http://tvapi-mashupjonne.rhcloud.com/api';

function getPrograms(channel) {
    var url = baseUrl + '/programs/' + channel;
    return HTTP.get(url);
}

function getChannels() {
    var url = baseUrl + '/channels';
    return HTTP.get(url);
}
