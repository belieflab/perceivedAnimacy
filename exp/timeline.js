let instructions0 = {
  type: "html-keyboard-response",
  stimulus: '<p style="font-size:26px;"> Hello and thank you for taking part in our experiment! </p>' +
    '<p style="font-size:24px;"> The experiment consists of a Chasing Detection Task followed by some questionnaires, and it takes around 30 minutes to complete. </p>' +
    '<p style="font-size:22px;"> <i> Press the spacebar to continue. </i> </p>',
  choices: [32],
};

let instructions1 = {
  type: "html-keyboard-response",
  stimulus: '<p style="font-size:26px;"> Please ensure the following: </p>' +
    '<p style="font-size:22px;"> (1) That you are in a room with no distractions (no people, music, phones, etc.), </p>' +
    '<p style="font-size:22px;"> (2) That for the next 30 minutes, you will be able to stay focused on the task and questionnaires, </p>' +
    '<p style="font-size:22px;"> As the study progresses, you may find that you start to feel tired. Please do your best to stay focused throughout, since our research depends on it! </p>' +
    '<p style="font-size:24px;"> <i> Press the spacebar to continue. </i> </p>',
  choices: [32],
};

let instructions2 = {
  type: "html-keyboard-response",
  stimulus: '<p style="font-size:26px;"> Chasing Detection Task </p>' +
    '<p style="font-size:22px;"> In this task, you will see a series of displays containing several moving white discs. </p>' +
    '<p style="font-size:22px;"> Half of the displays will be <i>Chasing</i> displays, in which one disc will <i>chase</i> another disc by following it around the screen. </p>' +
    '<p style="font-size:22px;"> The other half of the displays will be <i>No Chasing</i> displays, in which there is <i>no chasing</i>. </p>' +
    '<p style="font-size:22px;"> Your job is to detect if there is a <i>chase</i> or not on each display. </p>' +
    '<p style="font-size:22px;"> For each display, please respond as quickly as possible to report whether you saw a <i>chase</i>. </p>' +
    '<p style="font-size:22px;"> Chasing: Press "1" </p>' +
    '<p style="font-size:22px;"> No Chasing: Press "0" </p>' +
    '<p style="font-size:24px;"> <i> Press the spacebar to continue. </i> </p>',
  choices: [32],
};

let instructions3 = {
  type: "html-keyboard-response",
  stimulus: '<p style="font-size:22px;"> If you make a choice before the end of a display, the display will end. </p>' + 
    '<p style="font-size:22px;"> The first part of the Chasing Detection Task is a practice block. Here you will see 12 displays and feedback will be provided (you will see a "correct" or an "incorrect" word on the screen). </p>' + 
    '<p style="font-size:22px;"> The second part of the task is the testing block, you will see 188 displays, and no feedback will be provided. </p>' + 
    '<p style="font-size:24px;"> <i> Press the spacebar to continue. </i> </p>',

};

let instructions4 = {
  type: "html-keyboard-response",
  stimulus: '<p style="font-size:22px;"> Finally, after this screen you will start the task. </p>' +
    '<p style="font-size:22px;"> If you are ready to invest the next 30 minutes conducting the study and responding the questionnaires then: </p>' +
    '<p style="font-size:24px;"> <i> Press the spacebar to start. </i> </p>',
  choices: [32],
};

let fixation = {
  type: "html-keyboard-response",
  stimulus: '<div style="font-size:60px; color:white;">+</div>',
  choices: jsPsych.NO_KEYS,
  trial_duration: 1000
};

let trial = {
  type: "video-keyboard-response",
  // sources: ["stim/mirrorChasing/trial10.mp4"],
  sources: jsPsych.timelineVariable("stimulus"),
  data: jsPsych.timelineVariable("data"),
  choices: [48, 49],
  trial_ends_after_video: false,
  response_ends_trial: true,
  on_finish: function (data) {
    data.index = trialIterator;
    trialIterator ++;
    // data.version = version;
    let response = data.key_press;
    // console.log(response);
    let trialType = jsPsych.data.get().last(1).values()[0].test_part;
    // console.log(trialType);
    switch (response) {
      case 48: 
        if (trialType == "chase") {
          data.response = "incorrect";
        } else if (trialType == "no_chase") {
          data.response = "correct";
        } 
        break;

      case 49:
        if (trialType == "chase") {
          data.response = "correct";
        } else if (trialType == "no_chase") {
          data.response = "incorrect";
        } 
        break;
    }
  }
};

let feedback = {
  type: "html-keyboard-response",
  stimulus: feedbackGenerator,
  choices: jsPsych.NO_KEYS,
  trial_duration: feedbackDuration,
  on_load: function (data) {
    let response = jsPsych.data.get().last(1).values()[0].key_press;
    // console.log(response);
    let trialType = jsPsych.data.get().last(1).values()[0].test_part;
    // console.log(trialType);
    switch (response) {
      case 48: 
        if (trialType == "chase") {
          document.getElementById("feedback").innerHTML = "incorrect";
        } else if (trialType == "no_chase") {
          document.getElementById("feedback").innerHTML = "correct";
        } 
        break;

      case 49:
        if (trialType == "chase") {
          document.getElementById("feedback").innerHTML = "correct";
        } else if (trialType == "no_chase") {
          document.getElementById("feedback").innerHTML = "incorrect";
        } 
        break;
    }
  },

};

let procedurePractice = {
  timeline: [fixation, trial, feedback],
  timeline_variables: randomizedPracticeTrials,
  choices: [48, 49],
};

let instructions5 = {
  type: "html-keyboard-response",
  stimulus: '<p style="font-size:26px;"> Practice trials are over. </p>' +
    '<p style="font-size:22px;"> In the next set of testing trials you will not have feedback. </p>' +
    '<p style="font-size:24px;"> <i> Press the spacebar to continue. </i> </p>',
  choices: [32],
};

let procedureTest = {
  timeline: [fixation, trial],
  timeline_variables: randomizedTestTrials,
  choices: [48, 49],
};

let dataSave = {
  type: "html-keyboard-response",
  stimulus: "<p style='color:white;'>Data saving...</p>" +
    '<div class="sk-cube-grid">' +
    '<div class="sk-cube sk-cube1"></div>' +
    '<div class="sk-cube sk-cube2"></div>' +
    '<div class="sk-cube sk-cube3"></div>' +
    '<div class="sk-cube sk-cube4"></div>' +
    '<div class="sk-cube sk-cube5"></div>' +
    '<div class="sk-cube sk-cube6"></div>' +
    '<div class="sk-cube sk-cube7"></div>' +
    '<div class="sk-cube sk-cube8"></div>' +
    '<div class="sk-cube sk-cube9"></div>' +
    '</div>' +
    "<p style='color:white;'>Do not close this window until the text dissapears.</p>",
  choices: jsPsych.NO_KEYS,
  trial_duration: 5000,
  on_finish: function () {
    saveData("animacy_" + workerId, jsPsych.data.get().csv()); //function with file name and which type of file as the 2 arguments
    document.getElementById("unload").onbeforeunload = ''; //removes popup (are you sure you want to exit) since data is saved now
    // returns cursor functionality
    $(document).ready(function () {
      $("body").addClass("showCursor");
    });
  }
};

let end = {
  type: "html-keyboard-response",
  stimulus: "<p style='color:white;'>Thank you!</p>" +
    "<p style='color:white;'>You have successfully completed the experiment and your data has been saved.</p>" +
    "<p style='color:white;'>To proceed to the next section of this experiment, please click the following link:</p>",// +
    // "<p style='color:white;'><a href="+ feedbackLink +">Continue to questionnaires!</a></p>",
    // "<p style='color:white;'>Please wait for the experimenter to continue.</p>"+
    // "<p style='color:white;'><i>You may now close the expriment window at anytime.</i></p>",
  choices: jsPsych.NO_KEYS,
  // on_load: function() {
  // alert(reward);
  // }
};



$.getScript("exp/main.js");