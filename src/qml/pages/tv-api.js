function getPrograms(channel) {
    listModel.clear();
    var xhr = new XMLHttpRequest();

    var url = "http://tvapi-mashupjonne.rhcloud.com/api/programs/" + channel;
    xhr.open("GET", url, true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === xhr.DONE) {
            if (xhr.status === 200) {
                var programs = JSON.parse(xhr.responseText);
                populateModel(programs);
            }
        }
    }
    xhr.send();
}

function getChannels() {
    var xhr = new XMLHttpRequest();

    var url = "http://tvapi-mashupjonne.rhcloud.com/api/channels";
    xhr.open("GET", url, true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === xhr.DONE) {
            if (xhr.status === 200) {
                var channels = JSON.parse(xhr.responseText);
                console.log("channels", channels);
            }
        }
    }
    xhr.send();
}

function populateModel(programs) {
    var dateNow = new Date();
    var currentIndex = 0;

    programs.forEach(function(program, index) {
        var currentProgram = false;

        var name = program.data.name;
        var start = new Date(program.data.start).toLocaleString(Qt.locale(), "hh:mm");
        var end = new Date(program.data.end).toLocaleString(Qt.locale(), "hh:mm");
        var description = program.data.description;

        var startDate = new Date();
        var startTime = start.split(":");
        startDate.setHours(startTime[0]);
        startDate.setMinutes(startTime[1]);

        var endDate = new Date();
        var endTime = end.split(":");
        endDate.setHours(endTime[0]);
        endDate.setMinutes(endTime[1]);

        // same end hour
        if(dateNow.getHours() >= startDate.getHours() && dateNow.getHours() === endDate.getHours()) {
            if(dateNow.getMinutes() >= startDate.getMinutes() && dateNow.getMinutes() < endDate.getMinutes()) {
                currentIndex = index;
                currentProgram = true;
                console.log("same end hour: ", program.channelName, name);
            }
        }

        // FIX
        // end hour > current hour
        if(dateNow.getHours() >= startDate.getHours() && dateNow.getHours() < endDate.getHours()) {
            if((dateNow.getHours() * 3600 + dateNow.getMinutes() * 60) >= (startDate.getHours() * 3600 + startDate.getMinutes() * 60) &&
                    (dateNow.getHours() * 3600 + dateNow.getMinutes() * 60) < (endDate.getHours() * 3600 + endDate.getMinutes() * 60)) {
                currentIndex = index;
                currentProgram = true;
                console.log("end hour > current hour: ", program.channelName, name);
            }
        }

        listModel.append({
                             "name": name,
                             "start": start,
                             "end": end,
                             "description": description,
                             "currentProgram": currentProgram
                         });
    });

    listview.positionViewAtIndex(currentIndex, listview.Beginning);
    listview.currentIndex = currentIndex;
}
