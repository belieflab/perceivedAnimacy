let instructions0 = {
  type: "html-keyboard-response",
  stimulus: "<p> Hello and thank you for taking part in our experiment! </p>" +
    "<p> It should take about 30 minutes. First you will play a Chasing Detection Task and then respond some questionnaires. </p>" +
    "<p> <i> Press spacebar to continue </i> </p>",
  choices: [32],
};

let instructions1 = {
  type: "html-keyboard-response",
  stimulus: "<p> Please ensure the following: </p>" +
    "<p> (1) That you are in a room with no distractions (no people, music, phones etc) </p>" +
    "<p> (2) That for the next 30 minutes, you will be able to stay focused on the task and questionnaires </p>" +
    "<p> As the study progresses, you may find that you start to feel tired or bored. Please do your best to stay focused throughout, since our research depends on it! </p>" +
    "<p> <i> Press spacebar to continue </i> </p>",
  choices: [32],
};

let instructions2 = {
  type: "html-keyboard-response",
  stimulus: "<p> Chasing Detection Task (30 minutes) </p>" +
    "<p> In this task, you will see a series of displays containing several moving white discs. </p>" +
    "<p> Half of the displays will be <i>Chasing</i> displays, in which one disc will <i>chase</i> another disc by following it around the screen. </p>" +
    "<p> The other half of the displays will be <i>No Chasing</i> displays, in which there is no chasing. </p>" +
    "<p> Your job is to detect if there is a <i>chase</i> or not on each display. </p>" +
    "<p> For each display, please respond as quickly as possible to report whether you saw chasing. </p>" +
    "<p> Chasing: Press '1' </p>" +
    "<p> No Chasing: Press '0' </p>" +
    // "<p> While you are seeing a video and you believe there is a chase going on, you should press 1 otherwise press 0. </p>" +
    "<p> If you made a choice before the end of a display, the display will end. </p>" + 
    "<p> Feedback will be provided at the end of each of your choices, you will see a 'correct' or an 'incorrect' words on the screen. </p>" + 
    // "<p>Feedback will be provided always after you made a response (1=chase or 0=no chase).</p>" +
    // "<p>Feedback will be a 'correct' or an 'incorrect' words on the screen.</p>" +
    "<p> <i> Press spacebar to start</i> </p>",
  choices: [32],
};

let instructions3 = {
  type: "html-keyboard-response",
  stimulus: "<p> After this screen you will start the task. </p>" +
    "<p> If you are ready to invest the next 30 minutes conducting the study and responding the questionnares then: </p>" +
    "<p> <i> Press spacebar to start</i> </p>",
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
    data.version = version;
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

let procedureNoFeedback = {
  timeline: [fixation, trial],
  timeline_variables: randomizedTrials,
  choices: [48, 49],
};

let procedureFeedback = {
  timeline: [fixation, trial, feedback],
  timeline_variables: randomizedTrials,
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
    "<p style='color:white;'>To proceed to the next section of this experiment, please click the following link:</p>"+
    "<p style='color:white;'><a href="+feedbackLink+">Continue to questionnaires!</a></p>",
    // "<p style='color:white;'>Please wait for the experimenter to continue.</p>"+
    // "<p style='color:white;'><i>You may now close the expriment window at anytime.</i></p>",
  choices: jsPsych.NO_KEYS,
  // on_load: function() {
  // alert(reward);
  // }
};



$.getScript("exp/main.js");