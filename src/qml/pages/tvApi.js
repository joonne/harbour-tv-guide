function getPrograms(channel) {
    listModel.clear();
    var xhr = new XMLHttpRequest();

    var url = 'http://tvapi-mashupjonne.rhcloud.com/api/programs/' + channel;
    xhr.open('GET', url, true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === xhr.DONE) {
            if (xhr.status === 200) {
                var programs;
                try {
                    programs = JSON.parse(xhr.responseText);
                } catch(e) {
                    programs = [];
                }
                populateProgramModel(programs);
            }
        }
    }
    xhr.send();
}

function getChannels(populate) {
    var xhr = new XMLHttpRequest();

    var url = 'http://tvapi-mashupjonne.rhcloud.com/api/channels';
    xhr.open('GET', url, true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === xhr.DONE) {
            if (xhr.status === 200) {
                var channels;
                try {
                    channels = JSON.parse(xhr.responseText);
                } catch(e) {
                    channels = [];
                }
                populate(channels);
//                populate(channels.slice(0, 4));
            }
        }
    }
    xhr.send();
}

function populateProgramModel(programs) {
    var dateNow = new Date();
    var currentIndex = 0;

    programs.forEach(function(program, index) {
        var currentProgram = false;

        if (dateNow >= new Date(program.data.start) && dateNow <= new Date(program.data.end)) {
            currentIndex = index;
            currentProgram = true;
        }

        listModel.append({
                             name: program.data.name,
                             start: new Date(program.data.start).toLocaleString(Qt.locale(), 'hh:mm'),
                             end: new Date(program.data.end).toLocaleString(Qt.locale(), 'hh:mm'),
                             description: program.data.description,
                             currentProgram: currentProgram,
                         });
    });

    listview.positionViewAtIndex(currentIndex, listview.Beginning);
    listview.currentIndex = currentIndex;
}
