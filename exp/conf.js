//******************************************/
//   EXPERIMENT CONFIGURATION FILE          /
//******************************************/

// // // // Joan's code functions // // // // 
let subj_id = prompt("Please enter your participant ID:", "");
let subj_name = expt_name + "_" + subj_id.toString();
let consent_duration = 16;
let consent_pay = "$" + (consent_duration * .15).toFixed(2).toString();
let completion_code = 'lH7vUsB6qxVm';

let shortVersion = false;
let show_boilerplate = true;
let forceFullscreen = true;
let limitToDesktop = true;
let limitToGoogle = false;

function get_random_value(array) {
    return jsPsych.randomization.sampleWithoutReplacement(array, 1)[0]
};



// // // // jsWrapper default functions // // // //
let workerId = getParamFromURL('workerId');

const numberTrialsTest = 1;
const numberTrialsPractice = 1;
