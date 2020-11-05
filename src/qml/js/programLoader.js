WorkerScript.onMessage = function(msg) {
    var dateNow = new Date();
    var currentIndex = 0;

    msg.model.clear();
    msg.model.sync();

    msg.programs.forEach(function(program, index) {
        var start = new Date(program.data.start * 1000);
        var end = new Date(program.data.end * 1000);

        if (dateNow >= start && dateNow <= end) {
            currentIndex = index;
        }

        msg.model.append({
                             name: program.data.name,
                             start: start,
                             end: end,
                             description: program.data.description,
                             currentProgram: false,
                         });

    });

    msg.model.sync();
    WorkerScript.sendMessage({ currentIndex: currentIndex });
}
