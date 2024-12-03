let timeline = [];
let workerId = "";

// SPONTANEITY TEST
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

var begin_prac_promptS = {
    type: 'jo-html-keyboard-response',
    wait_duration: 5000,
    choices: ['space'],
    stimulus: "<p>Great.  This task is designed to be difficult!  Sometimes, you'll be sure of which disc was being chased by another disc.  Sometimes, you won't be confident at all.  This is okay.  Just give your best guess each time!</p><p>That's it for the instructions!  You are now about to begin the experiment.  Please take a moment to get comfortable.</p><p>Place your hand on your mouse to prepare." +
      "</div>",
    prompt: "Press SPACE to practice.",
    data: {
      subj_id: subj_name,
      test_part: 'instruct_prompt'
    }
  };

var begin_expt_promptS = {
  type: 'jo-html-keyboard-response',
  wait_duration: 5000,
  choices: ['space'],
  stimulus: "<p>The practice section is complete.  For the rest of the experiment, you will no longer be told the right answer.<p>Again, sometimes, you'll be sure of which disc was being chased by another disc.  Sometimes, you won't be confident at all.  This is okay.  Just give your best guess each time!!<p>I know it is also difficult to stay focused for so long, especially when you are doing the same thing over and over.  But remember, the experiment will be all over in less than 10 minutes.  Please do your best to remain focused! <b>Your responses will only be useful to us if you do.</b>" +
    "</div>",
  prompt: "Press SPACE to begin.",
  data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
  }
};

var begin_prac_promptW = {
  type: 'jo-html-keyboard-response',
  wait_duration: 5000,
  choices: ['space'],
  stimulus: "<p>Great.  This task is designed to be difficult!  Sometimes, you'll be sure of which disc was chasing another disc.  Sometimes, you won't be confident at all.  This is okay.  Just give your best guess each time!</p><p>That's it for the instructions!  You are now about to begin the experiment.  Please take a moment to get comfortable.</p><p>Place your hand on your mouse to prepare." +
    "</div>",
  prompt: "Press SPACE to practice.",
  data: {
    subj_id: subj_name,
    test_part: 'instruct_prompt'
  }
};

var begin_expt_promptW = {
type: 'jo-html-keyboard-response',
wait_duration: 5000,
choices: ['space'],
stimulus: "<p>The practice section is complete.  For the rest of the experiment, you will no longer be told the right answer.<p>Again, sometimes, you'll be sure of which disc was chasing another disc.  Sometimes, you won't be confident at all.  This is okay.  Just give your best guess each time!!<p>I know it is also difficult to stay focused for so long, especially when you are doing the same thing over and over.  But remember, the experiment will be all over in less than 10 minutes.  Please do your best to remain focused! <b>Your responses will only be useful to us if you do.</b>" +
  "</div>",
prompt: "Press SPACE to begin.",
data: {
  subj_id: subj_name,
  test_part: 'instruct_prompt'
}
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

var rgptsb_item_sequence = {
  1: "I spent time thinking about friends gossiping about me.",
  2: "I often heard people referring to me.",
  3: "I have been upset by friends and colleagues judging me critically.",
  4: "People definitely laughed at me behind my back.",
  5: "I have been thinking a lot about people avoiding me.",
  6: "People have been dropping hints for me.",
  7: "I believed that certain people were not what they seemed.",
  8: "People talking about me behind my back upset me.",
  9: "Certain individuals have had it in for me.",
  10: "People wanted me to feel threatened, so they stared at me.",
  11: "I was certain people did things in order to annoy me.",
  12: "I was convinced there was a conspiracy against me.",
  13: "I was sure someone wanted to hurt me.",
  14: "I couldn't stop thinking about people wanting to confuse me.",
  15: "I was distressed by being persecuted.",
  16: "It was difficult to stop thinking about people wanting to make me feel bad.",
  17: "People have been hostile towards me on purpose.",
  18: "I was angry that someone wanted to hurt me."
};

var rgptsb_intro = {
  type: 'jo-html-keyboard-response',
  wait_duration: 4000,
  choices: ['space'],
  stimulus: "<div style='position: absolute; margin: 0 auto; top: 20%; left: 10%; width: 75%'><p style='text-align: left'>Now, we will move on to the next section.<br><br>Please read each of the following statements carefully. They refer to <strong>thoughts and feelings</strong> you may have had <strong>about others</strong> in the <strong>last month.</strong><br><br>Think about the <strong>last month</strong> and indicate the extent of these feelings from <strong>1 (Not at all)</strong> to <strong>5 (Totally).</strong><br><br><strong>Please do not rate items according to any experiences you may have had under the influence of drugs.</strong></div>",
  prompt: "Press the spacebar to begin.",
  data: {
    subj_id: subj_name,
    test_part: 'rgptsb_intro'
  }
};

var rgptsb_prompt = function(rgptsb_item, rgptsb_id) {
  var trial_prompt = {
    type: 'jo-html-button-response',
    stimulus: '',
    on_start: function(trial){ trial.stimulus="<p>"+rgptsb_id+"/18<br>"+rgptsb_item+"</p>"},
    choices: ['1 - Not at all', '2', '3', '4', '5 - Totally'],
    wait_duration: 1500,
    data: {
      subj_id: subj_name,
      test_part: 'rgptsb',
      rgptsb_id: rgptsb_id
    },
    on_finish: function(data) {
      data.rgptsb_response = parseInt(data.button_pressed) + 1;
    }
  };
  return trial_prompt;
};

let redirect_qualtrics = {
  type: 'external-html',
  on_start: function(){
    let interaction_filename = 'interactions_' + subj_name;
    saveData(interaction_filename, jsPsych.data.getInteractionData().csv());
    saveData(subj_name, jsPsych.data.get().csv());
  },
  prompt: 'Almost there! You have reached the final section. By clicking the link below, you will be redirected to a Qualtrics page. Please complete all the questions there in order to obtain your completion code.',
  url: 'https://yalesurvey.ca1.qualtrics.com/jfe/form/SV_3rtAPMG3HZkxXee',
}

function getParameterByName(name, url = window.location.href) {
  name = name.replace(/[\[\]]/g, '\\$&');
  var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
      results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, ' '));
}


var redirect_qualtrics2 = {
  type: 'jo-html-keyboard-response',
  wait_duration: 0,
  choices: ['space'],
  on_start: function(trial){
    workerId = getParameterByName("PROLIFIC_PID");
    if (workerId!=""){
      trial.stimulus="You are now halfway through the experiment!  You will now complete several surveys before continuing with this experiment.  By clicking the link below, you will be redirected to a Qualtrics page. Please complete all the questions there in order to obtain the code that will allow you to continue.<p><a href='https://yalesurvey.ca1.qualtrics.com/jfe/form/SV_3rtAPMG3HZkxXee?PROLIFIC_PID=" + workerId + "' target='_blank'>CLICK HERE</a>";
    }
    let interaction_filename = 'interactions_' + subj_name;
    saveData(interaction_filename, jsPsych.data.getInteractionData().csv());
    saveData(subj_name, jsPsych.data.get().csv());
  },
  prompt: "Press SPACE to continue",
  data: {
    subj_id: subj_name,
    test_part: 'final_link'
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