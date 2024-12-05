timeline.push(instructions0);
timeline.push(instructions1);
timeline.push(instructions2);
timeline.push(instructions3);
timeline.push(procedurePractice);
timeline.push(instructions4);
timeline.push(instructions5);
timeline.push(procedureTest);
timeline.push(dataSave);
timeline.push(end);

// don't allow experiment to start unless subjectId is set
if (subjectId) {
    // New jsPsych 7.x syntax
    jsPsych.run(timeline);
}