// // // // jsWrapper default functions // // // //
trialIterator = 1;



// // // // Joan's code functions // // // // 
var trial_list = range(2, 300);
var practice_list = Array(numberTrialsPractice).fill('chase');
var condition_list = Array(numberTrialsTest).fill('chase').concat(Array(numberTrialsTest).fill('mirror'));
var num_practice = numberTrialsPractice;
var num_trials = condition_list.length
shuffle(trial_list);
shuffle(condition_list);

trial_count = 0

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

var redirect_qualtrics2 = {
    type: 'jo-html-keyboard-response',
    wait_duration: 0,
    choices: ['space'],
    on_start: function(trial){
      workerId = getParameterByName("workerId");
      if (workerId!=""){
        trial.stimulus="You are now halfway through the experiment!  You will now complete several surveys before continuing with this experiment.  By clicking the link below, you will be redirected to a Qualtrics page. Please complete all the questions there in order to obtain the code that will allow you to continue.<p><a href='https://yalesurvey.ca1.qualtrics.com/jfe/form/SV_3rtAPMG3HZkxXee?workerId=" + workerId + "' target='_blank'>CLICK HERE</a>";
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