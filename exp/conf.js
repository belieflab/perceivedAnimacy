//***********************************//
//   EXPERIMENT CONFIGURATION FILE   //
//***********************************//

// SET EXPERIMENT NAME
const experimentName = "Chase Detection Task";
const experimentAlias = "animacyConfidence";

// SET SUBJECT IDENTIFICATION
const workerId = getParamFromURL('workerId');
if (workerId != "") {
  var subjectId = workerId;
  var feedbackLink = "https://yalesurvey.ca1.qualtrics.com/jfe/form/SV_9L8MEILFrNBAF5I?workerId=" + subjectId;
}
const PROLIFIC_PID = getParamFromURL('PROLIFIC_PID');
if (PROLIFIC_PID != "") {
  var subjectId = PROLIFIC_PID;
  var feedbackLink = "https://yalesurvey.ca1.qualtrics.com/jfe/form/SV_9L8MEILFrNBAF5I?PROLIFIC_PID=" + subjectId;
}
// note: subjectId will be your unique indentifier that will be used in .js files

// // specific config parameters for perceivedAnimacy[chase-confidence]
const feedbackDuration = 500;
const numberTestTrials = 90; // 90 is default value
const numberPracticeTrials = 10; // 10 is default value