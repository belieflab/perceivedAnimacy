// // // // Joan's code functions // // // //
let FullScreenWarning = {
  type: 'fullscreen',
  fullscreen_mode: true,
  button_label: 'Enter Fullscreen',
  message: "<p>This experiment will automatically switch into full-screen mode when you press the button below.  And once you are in full-screen mode, it is important that you do not exit it (e.g. to switch to other windows or tabs).</p><p>(Don't worry: we'll bring you back out of full-screen mode as soon as the experiment is over.)</p>  <p>If you do you exit full-screen mode at any point during the experiment, <span style='color:red'><b>it will automatically end and we will not be able to compensate you</b></span>, so please only accept this study if you are able to stay in full-screen mode for the full duration (of approximately 10 mins).<br><br><br><br>",
  on_finish: function (data) {
      viewport_width = get_viewport_size().width;
      viewport_height = get_viewport_size().height;
      data.screen_width = viewport_width;
      data.screen_height = viewport_height;
      console.log("ID", subj_name, "W", viewport_width, "H", viewport_height)
  }
}

let consent = {
  type: 'html-keyboard-response',
  choices: ['y'],
  stimulus: "<div style='width: 100%; text-align: center'>" + '<h5>In order to run this study, we need to include the standard consent form below.</h5><h3>Please read and press the Y key to continue.</h3><h2 id="consentHeading" class="consent">CONSENT FOR PARTICIPATION IN A RESERCH PROJECT 200 FR. 1 (2016-2)<br>YALE UNIVERSITY SCHOOL OF MEDICINE CONNECTICUT MENTAL HEALTH CENTER</h2><h2></h2><p id="consentInstructions" class="consent" style="color: black"><b>Study Title:</b> Beliefs and Personality Traits<br><br><b>Principal Investigator:</b> Philip R. Corlett, PhD<br><br><b>Funding Source:</b> department funds<br><br><u><b>Invitation to Participate and Description of Project</b></u><br>You are invited to participate in a research study that concerns psychological processes related to beliefs and personality traits. Due to the nature of psychology experiments, we cannot explain the precise purpose of the experiment until after the session is over. Afterwards, the experimenter will be happy to answer any questions you might have about the purpose of the study.<br><br><u><b>Description of Procedures</b></u><br>If you agree to participate in this study, this Human Intelligence Task (HIT) will require you to (1) play a computer game using the computer mouse or keys on your keyboard and (2) answer simple questions about your demographics, health (including mental health), beliefs, and personality through an interactive web survey. You will never be asked for personally identifiable information such as your name, address, or date of birth. <br>The experiment is designed to take approximately 1 hour. You will have up to six hours to complete the experiment and submit codes for credit. <br><br><u><b>Risks and Inconveniences</b></u><br>There are little to no risks associated with this study. Some individuals may experience mild boredom. <br><br><u><b>Economic Considerations</b></u><br>You will receive the reward specified on the Mechanical-Turk HIT for completing both the game and the questionnaire. Payment for completion of the HIT is $6.00 with a $2.00 bonus to individuals who score in the top 25% on the card game. Upon finishing the game and submitting the questionnaire, you will receive code numbers. Please record these two code numbers and submit them for payment. <br><br><u><b>Confidentiality</b></u><br>We will never ask for your name, birth date, email or any other identifying piece of information. Your data will be pooled with those of others, and your responses will be completely anonymous. We will keep this data indefinitely for possible use in scientific publications and presentations. <br>The researcher will not know your name, and no identifying information will be connected to your survey answers in any way. The survey is therefore anonymous. However, your account is associated with an mTurk number that the researcher has to be able to see in order to pay you, and in some cases these numbers are associated with public profiles which could, in theory, be searched. For this reason, though the researcher will not be looking at anyones public profiles, the fact of your participation in the research (as opposed to your actual survey responses) is technically considered confidential rather than truly anonymous.<br><br><u><b>Voluntary Participation</b></u><br>Your participation in this study is completely voluntary. You are free to decline to participate or to end participation at any time by simply closing your browser window. However, please note that you must submit both the computer game and questionnaire in order to receive payment. You may decline answering any question by selecting the designated alternative response (e.g., “I do not wish to answer”). Declining questions will not affect payment.<br><br><u><b>Questions or Concerns</b></u><br>If you have any questions or concerns regarding the experiment, you may contact us here at the lab by emailing BLAMLabRequester@gmail.com If you have general questions about your rights as a research participant, you may contact the Yale University Human Investigation Committee at 203-785-4688 or human.subjects@yale.edu (HSC# 2000022111).</p><h2 style="text-align: center">PRESS THE Y KEY TO CONSENT</h2>',
  data: {
      subj_id: subj_name,
      test_part: 'consent'
  },
  on_finish: function (data) {
      viewport_width = get_viewport_size().width;
      viewport_height = get_viewport_size().height;
      data.screen_width = viewport_width;
      data.screen_height = viewport_height;
      data.url = window.location.href;
      console.log(data.url);
      let file_name = 'partial_' + subj_name
      saveData(file_name, jsPsych.data.get().csv());
  }
};

let welcome_prompt = {
  type: 'jo-html-keyboard-response',
  wait_duration: 5000,
  choices: ['space'],
  stimulus: "<p>Hi! Thank you for volunteering to help out with our study.  Please take a moment to adjust your seating so that you can comfortably watch the monitor and use the keyboard.  Feel free to dim the lights as well.</p><p>Close the door or do whatever is necessary to minimize disturbance during the experiment.  Please also take a moment to silence your phone so that you are not interrupted by any messages mid-experiment.</p><p>Throughout this experiment, you will see greyed out text as in the last line below.</p><p>And a quick note: This text will contain the instructions for how to move to the next page -- which will typically involve pressing the spacebar.  You will not be able to press the spacebar until after a brief period of time has elapsed.  Please use that time to read the instructions on the given page.  Once the greyed out text has turned black, and you have finished reading the instructions, you will then be able to proceed by pressing the relevant key.",
  prompt: "Press SPACE to continue.",
  data: {
      subj_id: subj_name,
      test_part: 'instruct_prompt'
  }
};

let instructions_wolf0 = {
  type: 'jo-html-keyboard-response',
  wait_duration: 0,
  choices: ['space'],
  stimulus: "<div style='margin: auto 0'><p>In this experiment, you will complete the same task multiple times. Each time, you will see many discs moving on the screen.</div>",
  prompt: "Press SPACE to continue.",
  data: {
      subj_id: subj_name,
      test_part: 'instruct_prompt'
  }
};

let instructions_wolf1 = {
type: 'jo-html-keyboard-response',
wait_duration: 0,
choices: ['space'],
stimulus: "<div style='margin: auto 0'><p>Sometimes, <b>one of the discs will look like it is <span style='color:purple'>chasing</span> another disc.</b><p>Your task is simply to identify which disc is chasing another disc.</div>",
prompt: "Press SPACE to continue.",
data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
}
};

let instructions_wolf2 = {
type: 'jo-html-keyboard-response',
wait_duration: 0,
choices: ['space'],
stimulus: "<div style='margin: auto 0'><p>You will be able to do so by clicking the relevant disc.<p>If your mouse click was registered, the disc you clicked on will turn <b>purple</b>.  <p>In the next practice trial, the correct answer will be revealed to you by the relevant disc turning green.</div>",
prompt: "Press SPACE to practice.",
data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
}
};

let instructions_wolf3 = {
type: 'jo-html-keyboard-response',
wait_duration: 0,
choices: ['1', '2', '3', '4', '5'],
stimulus: "<div style='margin: auto 0'><p>You will also be asked to rate how confident you were in your response.  <p>Using a scale of 1 to 5, you would press 1 for <b>NOT AT ALL</b>, and 5 for <b>VERY CONFIDENT</b>.</div>",
prompt: "How confident are you that you got the instructions?  (Press a number from 1 to 5!)",
data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
}
};

let instructions_sheep0 = {
type: 'jo-html-keyboard-response',
wait_duration: 0,
choices: ['space'],
stimulus: "<div style='margin: auto 0'><p>In this experiment, you will complete the same task multiple times. Each time, you will see many discs moving on the screen.</div>",
prompt: "Press SPACE to continue.",
data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
}
};

let instructions_sheep1 = {
type: 'jo-html-keyboard-response',
wait_duration: 0,
choices: ['space'],
stimulus: "<div style='margin: auto 0'><p>Sometimes, <b>one of the discs will look like it is <span style='color:purple'>being chased</span> another disc.</b><p>Your task is simply to identify which disc is being chased by another disc.</div>",
prompt: "Press SPACE to continue.",
data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
}
};

let instructions_sheep2 = {
type: 'jo-html-keyboard-response',
wait_duration: 0,
choices: ['space'],
stimulus: "<div style='margin: auto 0'><p>You will be able to do so by clicking the relevant disc.<p>If your mouse click was registered, the disc you clicked on will turn <b>purple</b>.  <p>In the next practice trial, the correct answer will be revealed to you by the relevant disc turning green.</div>",
prompt: "Press SPACE to practice.",
data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
}
};

let instructions_sheep3 = {
type: 'jo-html-keyboard-response',
wait_duration: 0,
choices: ['1', '2', '3', '4', '5'],
stimulus: "<div style='margin: auto 0'><p>You will also be asked to rate how confident you were in your response.  <p>Using a scale of 1 to 5, you would press 1 for <b>NOT AT ALL</b>, and 5 for <b>VERY CONFIDENT</b>.</div>",
prompt: "How confident are you that you got the instructions?  (Press a number from 1 to 5!)",
data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
}
};

let blank = {
  type: 'html-keyboard-response',
  stimulus: '<div style="font-size:60px;"></div>',
  choices: jsPsych.NO_KEYS,
  trial_duration: 500,
  data: {
      subj_id: subj_name,
      test_part: 'blank'
  }
};

let show_animacy_sheep = function(trial_num, trial_id, condition, feedback){
  var block = {
    type: 'jo-show-animacy-sheep',
    trial_id: trial_id,
    condition: condition,
    give_feedback: feedback,
    data: {
        subj_id: subj_name,
        test_part: 'show_animacy',
        trial_num: trial_num
    },
    on_finish: function (data) {
        var filename = subj_name
        saveData(filename, jsPsych.data.get().csv());
    }
  }
  return block;
};

let show_animacy_wolf = function(trial_num, trial_id, condition, feedback){
  var block = {
    type: 'jo-show-animacy-wolf',
    trial_id: trial_id,
    condition: condition,
    give_feedback: feedback,
    data: {
        subj_id: subj_name,
        test_part: 'show_animacy',
        trial_num: trial_num
    },
    on_finish: function (data) {
        var filename = subj_name
        saveData(filename, jsPsych.data.get().csv());
    }
  }
  return block;
};

let fixation = {
  type: 'html-keyboard-response',
  stimulus: '<div style="font-size:60px;">+</div>',
  choices: jsPsych.NO_KEYS,
  trial_duration: 500,
  data: {
      subj_id: subj_name,
      test_part: 'fixation'
  }
};

let begin_learning2 = {
  type: 'jo-input-code',
  stimulus: "Please type in the 8-character code that you obtained from completing the surveys to continue.",
  data: {
      subj_id: subj_name,
      test_part: 'instruct_prompt'
  }
};

let instructions_nextpart = {
  type: 'jo-html-keyboard-response',
  wait_duration: 0,
  choices: ['space'],
  stimulus: "<div style='margin: auto 0'><p>In this next part, you will now see animations similar to what you saw before.  But you will have a slightly different task.</div>",
  prompt: "Press SPACE to continue.",
  data: {
      subj_id: subj_name,
      test_part: 'instruct_prompt'
  }
};


// // // // jsWrapper default functions // // // //
let timeline = [];

let instructions0 = {
  type: "html-keyboard-response",
  stimulus: "<p> Hello and thank you for taking part in our experiment!</p>" +
    "<p>It should take about 30 minutes.</p>" +
    "<p> <i> Press spacebar to continue</i> </p>",
  choices: [32],
  on_finish: function (data) {
    data.index = 'lol';
  }
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
    saveData("task_" + workerId, jsPsych.data.get().csv()); //function with file name and which type of file as the 2 arguments
    document.getElementById("unload").onbeforeunload = ''; //removes popup (are you sure you want to exit) since data is saved now
    // returns cursor functionality
    $(document).ready(function () {
      $("body").addClass("showCursor"); // returns cursor functionality
      closeFullscreen(); // kill fullscreen
    });
  }
};

let end = {
  type: "html-keyboard-response",
  stimulus: "<p style='color:white;'>Thank you!</p>" +
    "<p style='color:white;'>You have successfully completed the experiment and your data has been saved.</p>" +
    // "<p style='color:white;'>To leave feedback on this task, please click the following link:</p>"+
    // "<p style='color:white;'><a href="+feedbackLink+">Leave Task Feedback!</a></p>"+
    // "<p style='color:white;'>Please wait for the experimenter to continue.</p>"+
    "<p style='color:white;'><i>You may now close the expriment window at anytime.</i></p>",
  choices: jsPsych.NO_KEYS,
  // on_load: function() {
  //   alert(reward);
  // }
};

$.getScript("exp/main.js");