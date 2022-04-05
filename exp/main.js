let timeline = [];

timeline.push(instructions0);
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