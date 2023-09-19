/*
 * Example plugin template
 */

jsPsych.plugins["jo-input-code"] = (function() {

  var plugin = {};

  plugin.info = {
    name: "jo-input-code",
    parameters: {
      stimulus: {
        type: jsPsych.plugins.parameterType.STRING, // BOOL, STRING, INT, FLOAT, FUNCTION, KEYCODE, SELECT, HTML_STRING, IMAGE, AUDIO, VIDEO, OBJECT, COMPLEX
        default: undefined
      },
    }
  }

  plugin.trial = function(display_element, trial) {

    let html = trial.stimulus;

    html += "<form id='code_form'><p><input type='text' id='input_code'><p><input type='submit' value='Submit'></form>"
    display_element.innerHTML = html;

    display_element.querySelector('#code_form').addEventListener("submit", checkSubmitResponse);

    function checkSubmitResponse(e){
      display_element.querySelector('#code_form').removeEventListener("submit", checkSubmitResponse);
      e.preventDefault();
      if (display_element.querySelector('#input_code').value=="MLJ828AQ"){
        end_trial();
      } else {
        display_element.innerHTML += "<p style='color:red'>Oops, please input the correct code to proceed.</p>";
        display_element.querySelector('#code_form').addEventListener("submit", checkSubmitResponse);
      }
    }

    // data saving
    function end_trial(){
      var trial_data = {
        stimulus: trial.stimulus
      };
  
      // end trial
      jsPsych.finishTrial(trial_data);
    }

  };

  return plugin;
})();
