let instructions0 = {
  type: "html-keyboard-response",
  stimulus: "<p> Hello and thank you for taking part in our experiment!</p>" +
    "<p>It should take about 10 minutes.</p>" +
    "<p> <i> Press spacebar to continue</i> </p>",
  choices: [32],
};

let instructions1 = {
  type: "html-keyboard-response",
  stimulus: "<p>In this experiment you will see videos with 8 moving white discs.</p>" +
    "<p>In half of the videos one disc will chase anohter disc, in the second half of the videos no disc is being chased.</p>" +
    "<p>Your job is to detect if there is a chase ocurring on each video, this is, one disc following another.</p>" +
    "<p>While you are seeing a video and you beliefe there is a chase going on, you should press 1 otherwise press 0.</p>" +
    "<p>If you made a choise before the end of the video, this will end the video and feedback will be provided.</p>" + 
    "<p>Feedback will be provided always after you made a response (1=chase or 0=no chase).</p>" +
    "<p>Feedback will be a 'correct' or an 'incorrect' words on the screen.</p>" +
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