.import "http.js" as HTTP

// TODO: configure in .env file
//var apiUrl = 'http://tv-api-tv-api.1d35.starter-us-east-1.openshiftapps.com/api';
var apiUrl = 'http://192.168.0.7:3000/api';

function getPrograms(channel) {
    var url = [apiUrl, '/channels/', channel, '/programs'].join('');
    return HTTP.get(url);
}

function getChannels(country) {
    var url = [apiUrl, '/channels', '?country=', country].join('');
    return HTTP.get(url);
}

function getCountries() {
    var url = [apiUrl, '/countries'].join('');
    return HTTP.get(url);
}
