  //******************************************/
  //   EXPERIMENT CONFIGURATION FILE          /
  //******************************************/

  let workerId = getParamFromURL('workerId');

  // activate feedback or no feedback for the task
  // const version = 'noFeedback'; 
  // const version = 'feedback';

  const feedbackDuration = 1000;

  // number of trials per trial type, e.g., 100 will be a total of 200 (100 chase and 100 mirror)
  // practice trials always have feedback, test trials do not.
  const numberTestTrials = 6;
  const numberPracticeTrials = 94;