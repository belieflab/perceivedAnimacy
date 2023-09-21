//******************************************/
//   EXPERIMENT CONFIGURATION FILE          /
//******************************************/

// // // // jsWrapper default functions // // // //
let workerId = getParamFromURL('workerId');

const numberTrialsTest = 1;
const numberTrialsPractice = 1;



// // // // Joan's code functions // // // // 
let subj_name = workerId;
let consent_duration = 16;
let consent_pay = "$" + (consent_duration * .15).toFixed(2).toString();
let completion_code = 'lH7vUsB6qxVm';

let shortVersion = false;
let forceFullscreen = true;

function get_random_value(array) {
    return jsPsych.randomization.sampleWithoutReplacement(array, 1)[0]
};
