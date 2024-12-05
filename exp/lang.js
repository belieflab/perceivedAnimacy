"use strict";
// Translation
// This file contains the instructions for the experiment,
// which will be translated to the language specified in exp/conf.js

let instructions = [];

// Switch version to determine the instructions for the experiment and language
/**
 * Translates the text of instuctions, buttons, etc. based on the selected language.
 *
 * @param {string} version - The version of the task defined in exp/conf.js.
 *                           Default version is "standard".
 */

// declare endgame variable
var endgame = () => {
    return `
        <div class="body-white-theme">
            <p>Thank you!</p>
            <p>You have successfully completed this task and your data has been saved.</p>
            ${
                !src_subject_id
                    ? `<p>You will be redirected to the next part of the experiment. If you are not redirected, please click <a href="${redirectLink}">here</a>.</p>`
                    : ""
            }
        </div>`;
};

// Aggregate the instructions of your language choice
// These will be bassed to the translate function
/**
 * Translates the text of instuctions, buttons, etc. based on the selected language.
 *
 * @param {language} version - The language of the task defined exp/conf.js.
 *                             Default language is English.
 */

switch (language) {
    default:
        instructions = [
            (score, earnings) => endgame(score, earnings), // Store it as a function that accepts score
        ];
        break;
}

// Translate the instructions to the specified language
translate(language, ...instructions);
