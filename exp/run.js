// LOAD TIMELINE
if (forceFullscreen){
  timeline.push({
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
  });
}
if (show_boilerplate) {
    timeline.push(consent);
    timeline.push(welcome_prompt);

    if (expt_name == 'sheep'){
      timeline.push(instructions_sheep0);
      timeline.push(instructions_sheep1);
      timeline.push(instructions_sheep2);
      timeline.push(instructions_sheep3);
    } else if (expt_name == 'wolf'){
      timeline.push(instructions_wolf0);
      timeline.push(instructions_wolf1);
      timeline.push(instructions_wolf2);
      timeline.push(instructions_wolf3);
    }
    timeline.push(blank);
    timeline.push(show_animacy(-1, 1, "chase", true));
    timeline.push(begin_prac_prompt);
}


// MAIN EXPERIMENT
var trial_list = range(2, 300);
var practice_list = Array(10).fill('chase');
var condition_list = Array(50).fill('chase').concat(Array(50).fill('mirror'));
shuffle(trial_list);
shuffle(condition_list);

trial_count = 0

for (i=0; i<10; i++){
  timeline.push(fixation);
  timeline.push(show_animacy(i+90, trial_list[trial_count], condition_list[i], true));
  trial_count = trial_count + 1;
}

timeline.push(begin_expt_prompt);

for (i=0; i<condition_list.length; i++){
  timeline.push(fixation);
  timeline.push(show_animacy(i, trial_list[trial_count], condition_list[i], false));
  trial_count = trial_count + 1;
}

var num_rgptsb = 18;
timeline.push(rgptsb_intro)
var item_count = 1;
for (i = 0; i < num_rgptsb; i++) {
  timeline.push(rgptsb_prompt(rgptsb_item_sequence[item_count], item_count));
  item_count++;
};

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


// START EXPERIMENT
if (limitToGoogle) {
    let browserInfo = getBrowserInfo();
    if (browserInfo.browser !== 'Chrome') {
      Message = "This experiment is only supported by Google Chrome. Please reopen the experiment in Google Chrome."
      let wrong_browser = {
        type: 'html-keyboard-response',
        stimulus: ['<p style="font-size: 26px;">' + Message + '</p>'],
        choices: jsPsych.NO_KEYS,
      };
      jsPsych.init({
        timeline: [wrong_browser]
      });
    } else {
      if (limitToDesktop) {
        let mobileCheck = mobileAndTabletCheck();
        if (mobileCheck) {
          Message =
            "This experiment is only supported by desktop browsers, and cannot be run on a tablet or a phone. Please reopen the experiment in a desktop browser.  If you can only use a tablet or a phone, and are unable to switch to a desktop browser, please quit the experiment and return the HIT."
          let wrong_browser = {
            type: 'html-keyboard-response',
            stimulus: ['<p style="font-size: 26px;">' + Message + '</p>'],
            choices: jsPsych.NO_KEYS,
          };
          jsPsych.init({
            timeline: [wrong_browser]
          });
        } else if (
          /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i
            .test(navigator.userAgent) ||
          /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i
            .test(navigator.userAgent.substr(0, 4))) {
          Message =
            "This experiment is only supported by desktop browsers, and cannot be run on a tablet or a phone. Please reopen the experiment in a desktop browser.  If you can only use a tablet or a phone, and are unable to switch to a desktop browser, please quit the experiment and return the HIT."
          let wrong_browser = {
            type: 'html-keyboard-response',
            stimulus: ['<p style="font-size: 26px;">' + Message + '</p>'],
            choices: jsPsych.NO_KEYS,
          };
          jsPsych.init({
            timeline: [wrong_browser]
          });
        } else {
          let mobile_prompt = {
            type: 'html-keyboard-response',
            choices: ['space'],
            stimulus: '<p>This experiment requires you to be using a desktop browser. The program should have automatically detected whether you are using a phone or a tablet.<p><strong>If you are using a phone or tablet and it has still allowed you to continue, please reopen the experiment in a desktop browser now.</strong><p>If you can only use a tablet or a phone, and are unable to switch to a desktop browser, please quit the experiment and return the HIT.</p><p>If you are on a desktop browser -- great!  Press the spacebar to continue.</p>'
          };
          startExpt();
        };
      } else {
        startExpt();
      };
    }
  } else {
    if (limitToDesktop) {
      let mobileCheck = mobileAndTabletCheck();
      if (mobileCheck) {
        Message =
          "This experiment is only supported by desktop browsers, and cannot be run on a tablet or a phone. Please reopen the experiment in a desktop browser.  If you can only use a tablet or a phone, and are unable to switch to a desktop browser, please quit the experiment and return the HIT."
        let wrong_browser = {
          type: 'html-keyboard-response',
          stimulus: ['<p style="font-size: 26px;">' + Message + '</p>'],
          choices: jsPsych.NO_KEYS,
        };
        jsPsych.init({
          timeline: [wrong_browser]
        });
      } else if (
        /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i
          .test(navigator.userAgent) ||
        /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i
          .test(navigator.userAgent.substr(0, 4))) {
        Message =
          "This experiment is only supported by desktop browsers, and cannot be run on a tablet or a phone. Please reopen the experiment in a desktop browser.  If you can only use a tablet or a phone, and are unable to switch to a desktop browser, please quit the experiment and return the HIT."
        let wrong_browser = {
          type: 'html-keyboard-response',
          stimulus: ['<p style="font-size: 26px;">' + Message + '</p>'],
          choices: jsPsych.NO_KEYS,
        };
        jsPsych.init({
          timeline: [wrong_browser]
        });
      } else {
        let mobile_prompt = {
          type: 'html-keyboard-response',
          choices: ['space'],
          stimulus: '<p>This experiment requires you to be using a desktop browser. The program should have automatically detected whether you are using a phone or a tablet.<p><strong>If you are using a phone or tablet and it has still allowed you to continue, please reopen the experiment in a desktop browser now.</strong><p>If you can only use a tablet or a phone, and are unable to switch to a desktop browser, please quit the experiment and return the HIT.</p><p>If you are on a desktop browser -- great!  Press the spacebar to continue.</p>'
        };
        startExpt();
      };
    } else {
      startExpt();
    };
  }