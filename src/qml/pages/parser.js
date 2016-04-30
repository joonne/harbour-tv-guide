function load(channel) {

    listModel.clear();
    var xhr = new XMLHttpRequest();

    var url = "http://tvapi-mashupjonne.rhcloud.com/api/channel/" + channel
    xhr.open("GET", url, true);

    xhr.onreadystatechange = function() {

        if(xhr.readyState === xhr.DONE) {
            if(xhr.status === 200) {
                var programs = JSON.parse(xhr.responseText);
                loaded(programs);
            }
        }
    }
    xhr.send();
}

function loaded(programs) {

    var date_now = new Date();
    var currentIndex = 0;

    for( var index in programs ) {

        var currentProgram = false;

        var name = programs[index].data.name;
        var start = new Date(Date.parse(programs[index].data.start)).toLocaleString(Qt.locale(), "hh:mm");
        var end = new Date(Date.parse(programs[index].data.end)).toLocaleString(Qt.locale(), "hh:mm");
        var description = programs[index].data.description;

        var start_date = new Date();
        var start_time = start.split(":");
        start_date.setHours(start_time[0]);
        start_date.setMinutes(start_time[1]);

        var end_date = new Date();
        var end_time = end.split(":");
        end_date.setHours(end_time[0]);
        end_date.setMinutes(end_time[1]);

        // same end hour
        if(date_now.getHours() >= start_date.getHours() && date_now.getHours() === end_date.getHours()) {
            if(date_now.getMinutes() >= start_date.getMinutes() && date_now.getMinutes() < end_date.getMinutes()) {
                currentIndex = index;
                currentProgram = true;
                console.log(name);
            }
        }

        // FIX
        // end hour > current hour
        if(date_now.getHours() >= start_date.getHours() && date_now.getHours() < end_date.getHours()) {
            if((date_now.getHours() * 3600 + date_now.getMinutes() * 60) >= (start_date.getHours() * 3600 + start_date.getMinutes() * 60) && (date_now.getHours() * 3600 + date_now.getMinutes() * 60) < (end_date.getHours() * 3600 + end_date.getMinutes() * 60)) {
                currentIndex = index;
                currentProgram = true;
                console.log(name);
            }
        }

        listModel.append({
                             "name": name,
                             "start": start,
                             "end": end,
                             "description": description,
                             "currentProgram": currentProgram
                         });
    }

    listview.positionViewAtIndex(currentIndex,listview.Beginning);
    listview.currentIndex = currentIndex;
}
