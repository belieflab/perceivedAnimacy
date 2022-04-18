let timeline = [];

timeline.push(instructions0);
timeline.push(instructions1);
timeline.push(instructions2);
timeline.push(instructions3);
switch (version) {
    case 'feedback':
        // timeline.push(instructionsFeedback);
        timeline.push(procedureFeedback);
        break;
    case 'noFeedback':
        // timeline.push(instructionsNoFeedback);
        timeline.push(procedureNoFeedback);
        break;
}
timeline.push(dataSave);
timeline.push(end);