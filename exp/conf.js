//***********************************//
//   EXPERIMENT CONFIGURATION FILE   //
//***********************************//

"use strict";

// Debug Mode
// Options: true, false
let debug = true; // Default debug mode setting for the experiment

// Experiment Version
// Options: "standard"
const version = "chase_confidence"; // Current version of the experiment

// General Settings
const experimentName = "Chase Detection Task";
const experimentAlias = `animacyConfidence_${version}`;

// Experiment Language
const language = "english"; // Language setting for the experiment

// User Interface Theme
// Options: "light", "dark", "gray", "white" (useful for images with white backgrounds)
const theme = "dark"; // Default theme setting for the user interface

// Manual Intake Form
// set these options to control the lists of sites and phenotypes on the manual intake form
const sites = ["Yale", "UChicago", "MPRC"];
const phenotypes = ["hc"];

// Number of repetitions for each procedure
// reference in main procedures object repetitions property:
// e.g. repetitions: getRepetitions().learning
const repetitions = {
    production: 0,
    debug: 0,
};

// Contact Information
const adminEmail = undefined;

// Intake Settings
const intake = {
    subject: {
        minLength: 5,
        maxLength: 5,
    },
    sites: ["Vanderbilt"],
    phenotypes: ["hc"],
};

// Redirect and Counterbalance Configuration

// choose true if you would like to counterbalance the surveys based on the participant's subjectId
const counterbalance = true;

let phase = undefined;

// Redirect Configuration (Daisy Chaining)
const urlConfig = {
    // redirect only
    chase_confidence: "https://yalesurvey.ca1.qualtrics.com/jfe/form/SV_XXX",
};

// // specific config parameters for perceivedAnimacy[chase-confidence]
const feedbackDuration = 500;
const numberTestTrials = 90; // 90 is default value
const numberPracticeTrials = 10; // 10 is default value
