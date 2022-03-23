/* start the experiment */
function startExperiment() {
  jsPsych.init({
    timeline: timeline,
    show_progress_bar: true,
  });
}

/* write to data/.csv */
function saveData(name, data) {
  let xhr = new XMLHttpRequest();
  xhr.open('POST', 'index.php'); // 'index.php' contains the php script described above
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.send(JSON.stringify({
    filename: name,
    filedata: data
  }));
}

//onbeforeunload in body
function areYouSure() {
  return "Write something clever here...";
}
areYouSure();


// Checks if string is empty, null, or undefined
function isEmpty(str) {
  return (!str || !str.length);
}

// BELOW COURTESY OF GARY LUPYAN -- COPIED FROM
//  http://sapir.psych.wisc.edu/wiki/index.php/MTurk
function getParamFromURL(name) {
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
  var regexS = "[\?&]" + name + "=([^&#]*)";
  var regex = new RegExp(regexS);
  var results = regex.exec(window.location.href);
  if (results == null)
    return "";
  else
    return results[1];
}

// Translate consent button
function translate() {
  let consent;
  let load;
  switch (language) {

    case 'english':
      consent = 'CONSENT';
      load = 'LOAD';
      break

    case 'french':
      consent = 'CONSENTEMENT';
      load = 'CHARGE';
      break

    case 'german':
      consent = 'ZUSTIMMUNG';
      load = 'BELASTUNG';
      break

  }

  document.getElementById('submitButton').innerHTML = consent;
  document.getElementById('nextButton').innerHTML = load;
}