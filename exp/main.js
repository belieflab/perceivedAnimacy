// main order in which things are pushed to timeline 
timeline.push(instructions0);
timeline.push(fixation);
// timeline.push(trial);

let procedure = {
    timeline: [fixation, trial],
    timeline_variables: randomizedTrials,
    choices: [48, 49],
};
// timeline.push(postTrial);
timeline.push(procedure);
timeline.push(dataSave);
timeline.push(end);