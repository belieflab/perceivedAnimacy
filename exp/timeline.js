// // // // Joan's code functions // // // //
let timeline = [];

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
        version: "sheep-and-wolf",
        interview_date: today,
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
        version: "sheep-and-wolf",
        interview_date: today,
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

let debrief_text =
    "<div style='width: 50%; text-align: left; margin: 0 auto'><p style='text-align: center'>(You should have been returned to the normal size of your browser.)<br>Finally, we just have a couple questions for you!<br>Please note that you must answer <strong>ALL</strong> the questions before pressing the CONTINUE button below.</p>" +
    '<p>Age: <br><input name="age" type="number" style="width: 20%; border-radius: 4px; padding: 10px 10px; margin: 8px 0; border: 1px solid #ccc; font-size: 15px"/>' +
    '<p>Please indicate your gender:<br><input type="radio" id="male" name="gender" value="male"><label for="male">Male</label><br><input type="radio" id="female" name="gender" value="female"><label for="female">Female</label><br><input type="radio" id="other" name="gender" value="other"><label for="other">Other</label><br><input type="radio" id="NA" name="gender" value="NA"><label for="NA">I prefer not to say</label><br>' +
    '<p>In 1-2 sentences, what do you think the experiment is about?<br><input name="what_about" type="text" size="50" style="width: 100%; border-radius: 4px; padding: 10px 10px; margin: 8px 0; border: 1px solid #ccc; font-size: 15px"/>' +
    '<p>In 1-2 sentences, did you have any strategies for completing the task?<br><input name="what_strategies" type="text" size="50" style="width: 100%; border-radius: 4px; padding: 10px 10px; margin: 8px 0; border: 1px solid #ccc; font-size: 15px"/>' +
    '<p>Have you ever, to your knowledge, participated in an experiment similar to this one?  If yes, please describe this experiment in 1-2 sentences.  If no, please just type "No" in the text box.<br><input name="prev_exp" type="text" size="50" style="width: 100%; border-radius: 4px; padding: 10px 10px; margin: 8px 0; border: 1px solid #ccc; font-size: 15px"/>' +
    '<p>Did you encounter any problems in the experiment? <br><input name="problems" type="text" size="50" style="width: 100%; border-radius: 4px; padding: 10px 10px; margin: 8px 0; border: 1px solid #ccc; font-size: 15px"/></p>' +
    '<p>Anything else to share? <br><input name="addl" type="text" size="50" style="width: 100%; border-radius: 4px; padding: 10px 10px; margin: 8px 0; border: 1px solid #ccc; font-size: 15px"/></p>' +
    '<p>We know it is generally difficult to stay focused in these online experiments.  On a scale of 1-100 (with 1 being very distracted, and 100 being very focused), how well did you pay attention to the experiment?  (This will not affect whether you receive credit or compensation.) <br><input name="attn" type="number" max="100" style="width: 20%; border-radius: 4px; padding: 10px 10px; margin: 8px 0; border: 1px solid #ccc; font-size: 15px"></p></div>';

let debrief_prompt = [{
    html: debrief_text,
    data: {
        subj_id: subj_name,
        test_part: 'debrief'
    },
}];

let check_debrief_response = {
  type: 'survey-html-form',
  data: {
      subj_id: subj_name,
      test_part: 'debrief',
      completion_code: completion_code
  },
  check_blanks: true,
  on_finish: function (data) {
      console.log("Responses:", data.responses);
      let respObj = JSON.parse(data.responses);
      data.resp_age = respObj["age"];
      data.resp_gender = respObj["gender"];
      data.resp_expt = respObj["what_about"];
      data.resp_strategies = respObj["what_strategies"];
      data.resp_experience = respObj["prev_exp"];
      data.resp_problems = respObj["problems"];
      data.resp_final = respObj["addl"];
      data.resp_attention = respObj["attn"];
      // data.interview_date = today;
      // data.workerId = workerId;
      // data.version = "sheep-and-wolf";
      let interaction_data = jsPsych.data.getInteractionData();
      let interaction_filename = 'interactions_' + subj_name;
      saveData(interaction_filename, jsPsych.data.getInteractionData().csv());
      saveData(subj_name, jsPsych.data.get().csv());

  },
  timeline: debrief_prompt
};

let get_code_prompt = {
  type: 'html-keyboard-response',
  choices: ['space'],
  stimulus: '<p>Great, you have completed this experiment.  Please press spacebar to proceed to the next page, and get your code.</p>',
  data: {
      subj_id: subj_name,
      test_part: 'instruct_prompt'
  },
  on_finish: function (data) {
      saveData(subj_name, jsPsych.data.get().csv());
  }
};

let show_code_prompt = {
  type: 'html-keyboard-response',
  choices: ['space'],
  stimulus: '<p>Here is your completion code, copy it because the platorm will need it later:</p><p style="font-size: 140%; color: white"><strong>' + completion_code + 
      '</strong></p>' + '<p>Press the spacebar to continue.</p>',
  data: {
      subj_id: subj_name,
      test_part: 'instruct_prompt'
  }
};

let close_prompt = {
  type: 'html-keyboard-response',
  choices: ['space'],
  stimulus: '<p>Thank you for helping!  You are all set.  You can now close the window!</p>',
  data: {
      subj_id: subj_name,
      test_part: 'instruct_prompt'
  },
  on_finish: function (data) {
      // data.interview_date = today;
      // data.workerId = workerId;
      // data.version = "sheep-and-wolf";
      let interaction_data = jsPsych.data.getInteractionData();
      let interaction_filename = 'interactions_' + subj_name;
      saveData(interaction_filename, jsPsych.data.getInteractionData().csv());
      saveData(subj_name, jsPsych.data.get().csv());
  }
};



// // // // jsWrapper default functions // // // //
// let timeline = [];
// 
// let instructions0 = {
//   type: "html-keyboard-response",
//   stimulus: "<p> Hello and thank you for taking part in our experiment!</p>" +
//     "<p>It should take about 30 minutes.</p>" +
//     "<p> <i> Press spacebar to continue</i> </p>",
//   choices: [32],
//   on_finish: function (data) {
//     data.index = 'lol';
//   }
// };
// 
// let dataSave = {
//   type: "html-keyboard-response",
//   stimulus: "<p style='color:white;'>Data saving...</p>" +
//     '<div class="sk-cube-grid">' +
//     '<div class="sk-cube sk-cube1"></div>' +
//     '<div class="sk-cube sk-cube2"></div>' +
//     '<div class="sk-cube sk-cube3"></div>' +
//     '<div class="sk-cube sk-cube4"></div>' +
//     '<div class="sk-cube sk-cube5"></div>' +
//     '<div class="sk-cube sk-cube6"></div>' +
//     '<div class="sk-cube sk-cube7"></div>' +
//     '<div class="sk-cube sk-cube8"></div>' +
//     '<div class="sk-cube sk-cube9"></div>' +
//     '</div>' +
//     "<p style='color:white;'>Do not close this window until the text dissapears.</p>",
//   choices: jsPsych.NO_KEYS,
//   trial_duration: 5000,
//   on_finish: function () {
//     saveData("task_" + workerId, jsPsych.data.get().csv()); //function with file name and which type of file as the 2 arguments
//     document.getElementById("unload").onbeforeunload = ''; //removes popup (are you sure you want to exit) since data is saved now
//     // returns cursor functionality
//     $(document).ready(function () {
//       $("body").addClass("showCursor"); // returns cursor functionality
//       closeFullscreen(); // kill fullscreen
//     });
//   }
// };
// 
// let end = {
//   type: "html-keyboard-response",
//   stimulus: "<p style='color:white;'>Thank you!</p>" +
//     "<p style='color:white;'>You have successfully completed the experiment and your data has been saved.</p>" +
//     // "<p style='color:white;'>To leave feedback on this task, please click the following link:</p>"+
//     // "<p style='color:white;'><a href="+feedbackLink+">Leave Task Feedback!</a></p>"+
//     // "<p style='color:white;'>Please wait for the experimenter to continue.</p>"+
//     "<p style='color:white;'><i>You may now close the expriment window at anytime.</i></p>",
//   choices: jsPsych.NO_KEYS,
//   // on_load: function() {
//   //   alert(reward);
//   // }
// };

$.getScript("exp/main.js");