// // // // jsWrapper default functions // // // //
// main order in which things are pushed to timeline 
// timeline.push(instructions0);
// timeline.push(dataSave);
// timeline.push(end);


// // // // Joan's code functions // // // //
if (forceFullscreen){
    timeline.push(FullScreenWarning);
}
// if (show_boilerplate) {
//     timeline.push(consent);
//     timeline.push(welcome_prompt);
// }

if (expt_name == 'sheep'){
    timeline.push(instructions_sheep0);
    timeline.push(instructions_sheep1);
    timeline.push(instructions_sheep2);
    timeline.push(instructions_sheep3);
    timeline.push(blank);
    timeline.push(show_animacy_sheep(-1, 1, "chase", true));
    timeline.push(begin_prac_promptS);
  
    trial_count = 0
    for (i=0; i<num_practice; i++){
      timeline.push(fixation);
      timeline.push(show_animacy_sheep(i+90, trial_list[trial_count], condition_list[i], true));
      trial_count = trial_count + 1;
    }
    
    timeline.push(begin_expt_promptS);
    
    for (i=0; i<num_trials; i++){
      timeline.push(fixation);
      timeline.push(show_animacy_sheep(i, trial_list[trial_count], condition_list[i], false));
      trial_count = trial_count + 1;
    }
  
    timeline.push(redirect_qualtrics2);
    timeline.push(begin_learning2);
    timeline.push({
      type: 'fullscreen',
      fullscreen_mode: true,
      button_label: 'Enter Fullscreen',
      message: "You are about to begin the final part of this experiment.<br>",
      on_finish: function (data) {
          viewport_width = get_viewport_size().width;
          viewport_height = get_viewport_size().height;
          data.screen_width = viewport_width;
          data.screen_height = viewport_height;
          console.log("ID", subj_name, "W", viewport_width, "H", viewport_height)
      }
    });
  
    // timeline.push(instructions_wolf0);
    timeline.push(instructions_nextpart);
    timeline.push(instructions_wolf1);
    timeline.push(instructions_wolf2);
    timeline.push(instructions_wolf3);
    timeline.push(blank);
    timeline.push(show_animacy_wolf(-1, 1, "chase", true));
    timeline.push(begin_prac_promptW);
  
    trial_count = 0
    for (i=0; i<num_practice; i++){
      timeline.push(fixation);
      timeline.push(show_animacy_wolf(i+90, trial_list[trial_count], condition_list[i], true));
      trial_count = trial_count + 1;
    }
    
    timeline.push(begin_expt_promptW);
    
    for (i=0; i<num_trials; i++){
      timeline.push(fixation);
      timeline.push(show_animacy_wolf(i, trial_list[trial_count], condition_list[i], false));
      trial_count = trial_count + 1;
    }
} else if (expt_name == 'wolf'){
    timeline.push(instructions_wolf0);
    timeline.push(instructions_wolf1);
    timeline.push(instructions_wolf2);
    timeline.push(instructions_wolf3);
    timeline.push(blank);
    timeline.push(show_animacy_wolf(-1, 1, "chase", true));
    timeline.push(begin_prac_promptW);
  
    trial_count = 0
    for (i=0; i<num_practice; i++){
      timeline.push(fixation);
      timeline.push(show_animacy_wolf(i+90, trial_list[trial_count], condition_list[i], true));
      trial_count = trial_count + 1;
    }
    
    timeline.push(begin_expt_promptW);
    
    for (i=0; i<num_trials; i++){
      timeline.push(fixation);
      timeline.push(show_animacy_wolf(i, trial_list[trial_count], condition_list[i], false));
      trial_count = trial_count + 1;
    }
  
    timeline.push(redirect_qualtrics2);
    timeline.push(begin_learning2);
    timeline.push({
      type: 'fullscreen',
      fullscreen_mode: true,
      button_label: 'Enter Fullscreen',
      message: "You are about to begin the final part of this experiment.<br>",
      on_finish: function (data) {
          viewport_width = get_viewport_size().width;
          viewport_height = get_viewport_size().height;
          data.screen_width = viewport_width;
          data.screen_height = viewport_height;
          console.log("ID", subj_name, "W", viewport_width, "H", viewport_height)
      }
    });
  
    // timeline.push(instructions_sheep0);
    timeline.push(instructions_nextpart);
    timeline.push(instructions_sheep1);
    timeline.push(instructions_sheep2);
    timeline.push(instructions_sheep3);
    timeline.push(blank);
    timeline.push(show_animacy_sheep(-1, 1, "chase", true));
    timeline.push(begin_prac_promptS);
  
    trial_count = 0
    for (i=0; i<num_practice; i++){
      timeline.push(fixation);
      timeline.push(show_animacy_sheep(i+90, trial_list[trial_count], condition_list[i], true));
      trial_count = trial_count + 1;
    }
    
    timeline.push(begin_expt_promptS);
    
    for (i=0; i<num_trials; i++){
      timeline.push(fixation);
      timeline.push(show_animacy_sheep(i, trial_list[trial_count], condition_list[i], false));
      trial_count = trial_count + 1;
    }
}

// DEBRIEFING SECTION
timeline.push({
  type: 'fullscreen',
  fullscreen_mode: false,
  button_label: 'Exit Fullscreen',
  message: '<p>You can now exit full screen mode.</p>',
  on_finish: function (data) {
      viewport_width = get_viewport_size().width;
      viewport_height = get_viewport_size().height;
      data.screen_width = viewport_width;
      data.screen_height = viewport_height;
      console.log("ID", subj_name, "W", viewport_width, "H", viewport_height)
  }
});
timeline.push(check_debrief_response);
timeline.push(get_code_prompt);
timeline.push(show_code_prompt);
timeline.push(close_prompt);
console.log(timeline);