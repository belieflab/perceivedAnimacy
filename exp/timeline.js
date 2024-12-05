"use strict";

const jsPsych = initJsPsych({
    show_progress_bar: true,
});

let timeline = [];

let instructions0 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:
        '<p style="font-size:26px;"> Hello and thank you for taking part in our experiment! </p>' +
        '<p style="font-size:24px;"> The experiment consists of a Chasing Detection Task followed by some questionnaires, and it takes around 30 minutes to complete. </p>' +
        '<p style="font-size:22px;"> <i> Press the spacebar to continue. </i> </p>',
    choices: " ",
};

let instructions1 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:
        '<p style="font-size:26px;"> Please ensure the following: </p>' +
        '<p style="font-size:22px;"> (1) That you are in a room with no distractions (no people, music, phones, etc.), </p>' +
        '<p style="font-size:22px;"> (2) That for the next 30 minutes, you will be able to stay focused on the task and questionnaires, </p>' +
        '<p style="font-size:22px;"> As the study progresses, you may find that you start to feel tired. Please do your best to stay focused throughout, since our research depends on it! </p>' +
        '<p style="font-size:24px;"> <i> Press the spacebar to continue. </i> </p>',
    choices: " ",
};

let instructions2 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:
        '<p style="font-size:26px;"> Chasing Detection Task </p>' +
        '<p style="font-size:22px;"> In this task, you will see a series of displays containing several moving white discs. </p>' +
        '<p style="font-size:22px;"> Half of the displays will be <i>Chasing</i> displays, in which one disc will <i>chase</i> another disc by following it around the screen. </p>' +
        '<p style="font-size:22px;"> The other half of the displays will be <i>No Chasing</i> displays, in which there is <i>no chasing</i> disc. </p>' +
        '<p style="font-size:22px;"> Your job is to detect if there is a <i>chase</i> or not on each display. </p>' +
        '<p style="font-size:22px;"> For each display, please report as accurately as possible whether you saw a <i>chase</i>. </p>' +
        '<p style="font-size:22px;"> Chasing: Press "J" </p>' +
        '<p style="font-size:22px;"> No Chasing: Press "F" </p>' +
        '<p style="font-size:24px;"> <i> Press the J key to continue. </i> </p>',
    choices: "j",
};

let instructions3 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:
        '<p style="font-size:22px;"> If you make a choice before the end of a display, the display will end. Take your time to be as accurate as possible. </p>' +
        '<p style="font-size:22px;"> The first part of the Chasing Detection Task is a practice block. Here you will see 20 displays and feedback will be provided (you will see a "correct" or an "incorrect" word on the screen). </p>' +
        '<p style="font-size:22px;"> The second part of the task is the testing block, where you will see 180 displays with no feedback. </p>' +
        '<p style="font-size:24px;"> <i> Press the spacebar to continue. </i> </p>',
    choices: " ",
};

let fixation = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: '<div style="font-size:60px; color:white;">+</div>',
    choices: "NO_KEYS",
    trial_duration: 500,
};

let trial = {
    type: jsPsychVideoKeyboardResponse,
    // stimulus: ["stim/mirrorChasing/trial10mod.mp4"],
    stimulus: jsPsych.timelineVariable("stimulus"),
    data: jsPsych.timelineVariable("data"),
    choices: ["f", "j"],
    // response_allowed_while_playing: false, // for Josh 31/05/2022
    trial_ends_after_video: false,
    response_ends_trial: true,
    on_finish: function (data) {
        data.index = trialIterator;
        writeCandidateKeys(data);
        let response = data.response;
        let trialType = jsPsych.data.get().last(1).values()[0].test_part;
        switch (response) {
            case "f":
                if (trialType == "chase") {
                    data.response = "incorrect";
                } else if (trialType == "no_chase") {
                    data.response = "correct";
                }
                break;

            case "j":
                if (trialType == "chase") {
                    data.response = "correct";
                } else if (trialType == "no_chase") {
                    data.response = "incorrect";
                }
                break;
        }
    },
};

let feedback = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: () => {
        let lastTrial = jsPsych.data.get().last(1).values()[0];
        let computedResponse = lastTrial.response; // This will be "correct" or "incorrect"
        // console.log(computedResponse);
        // console.log(lastTrial.test_part);

        return `<div style="font-size:60px; color:white;">${computedResponse}</div>`;
    },
    choices: "NO_KEYS",
    trial_duration: feedbackDuration,
    on_load: () => {
        trialIterator++;
    },
};

let instructions4 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:
        '<p style="font-size:26px;"> Chasing Detection Task </p>' +
        '<p style="font-size:22px;"> Well done! For the testing block, in addition to detect a chase ("J") or not detecting it ("F"), you will be asked how confident you were with your choice. </p>' +
        '<p style="font-size:22px;"> Press 1, 2, 3, 4, or 5 on your keyboard to rate your confidence level, where 1 is not confident at all and 5 is very confident. </p>' +
        '<p style="font-size:24px;"> <i> Press the number 5 to continue. </i> </p>',
    choices: "5",
};

let instructions5 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:
        '<p style="font-size:22px;"> Finally, after this screen you will start the task. </p>' +
        '<p style="font-size:22px;"> If you are ready to invest the next 30 minutes completing the study and responding the questionnaires then: </p>' +
        '<p style="font-size:24px;"> <i> Press the spacebar to start. </i> </p>',
    choices: " ",
};

let confidence = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:
        '<div style="font-size:24px; color:white;">How confident are you? (from 1 to 5)</div>' +
        '<p style="font-size:24px;"> <i> 1 = Not confident at all, 5 = Very confident. </i> </p>',
    data: jsPsych.timelineVariable("data"),
    choices: ["1", "2", "3", "4", "5"],
    on_finish: function (data) {
        data.index = trialIterator;
        writeCandidateKeys(data);
        trialIterator++;
        let response = data.response;
        switch (response) {
            case "1":
                data.confidence = "1";
                break;
            case "2":
                data.confidence = "2";
                break;
            case "3":
                data.confidence = "3";
                break;
            case "4":
                data.confidence = "4";
                break;
            case "5":
                data.confidence = "5";
                break;
        }
    },
};

let procedurePractice = {
    timeline: [fixation, trial, feedback],
    timeline_variables: randomizedPracticeTrials,
};

let instructions6 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:
        '<p style="font-size:26px;"> The practice trials are now over, and the next trials are real. </p>' +
        '<p style="font-size:22px;"> In the next set of testing trials you will not have feedback. </p>' +
        '<p style="font-size:22px;"> Please do your best to pay attention throughout the experiment, since your data will be useful to us only if you stay focused and continue to respond as accurately as possible all the way until the end. </p>' +
        '<p style="font-size:24px;"> <i> Press the spacebar to begin. </i> </p>',
    choices: " ",
};

let procedureTest = {
    timeline: [fixation, trial, confidence],
    timeline_variables: randomizedTestTrials,
};

const dataSave = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: dataSaveAnimation,
    choices: "NO_KEYS",
    trial_duration: 5000,
    on_finish: writeCsvRedirect,
};

$.getScript("exp/main.js");
