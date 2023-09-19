<?php
require_once 'db/data.php';
require_once 'db/config.php';
?>

<!DOCTYPE html>
<html>

<head>
  <title>Human Detection Task</title>
  <script>
    //onbeforeunload in body
    function areYouSure() {
      return "Write something clever here...";
    }
    areYouSure();
  </script>
  <!-- set js language variable from php variable in config.php -->
  <script>
    const language = "<?php echo $language ?>";
  </script>
  <script type="text/javascript" src="db/validate.js"></script>
  <script type="text/javascript" src="jQuery/jquery-3.5.1.min.js"></script>
  <script type="text/javascript" src="jsPsych/jspsych.js"></script>
  <script type="text/javascript" src="jsPsych/plugins/jspsych-html-keyboard-response.js"></script>
  <script type="text/javascript" src="jsPsych/plugins/jspsych-image-keyboard-response.js"></script>
  <!-- these are the plug ins required in joanPerceivedAnimacy -->
  <script type="text/javascript" src="jsPsych/plugins/jspsych-fullscreen.js"></script>
  <script type="text/javascript" src="jsPsych/plugins/joan/jo-html-keyboard-response.js"></script>
  <script type="text/javascript" src="jsPsych/plugins/joan/jo-html-button-response.js"></script>
  <script type="text/javascript" src="jsPsych/plugins/joan/jo-show-animacy-sheep.js"></script>
  <script type="text/javascript" src="jsPsych/plugins/joan/jo-show-animacy-wolf.js"></script>
  <script type="text/javascript" src="jsPsych/plugins/joan/jo-input-code.js"></script>

  <script src="stim/chasing_output/dist1X.js"></script>
  <script src="stim/chasing_output/dist1Y.js"></script>
  <script src="stim/chasing_output/dist2X.js"></script>
  <script src="stim/chasing_output/dist2Y.js"></script>
  <script src="stim/chasing_output/dist3X.js"></script>
  <script src="stim/chasing_output/dist3Y.js"></script>
  <script src="stim/chasing_output/dist4X.js"></script>
  <script src="stim/chasing_output/dist4Y.js"></script>
  <script src="stim/chasing_output/dist5X.js"></script>
  <script src="stim/chasing_output/dist5Y.js"></script>
  <script src="stim/chasing_output/dist6X.js"></script>
  <script src="stim/chasing_output/dist6Y.js"></script>
  <script src="stim/chasing_output/sheepX.js"></script>
  <script src="stim/chasing_output/sheepY.js"></script>
  <script src="stim/chasing_output/wolfX.js"></script>
  <script src="stim/chasing_output/wolfY.js"></script>
  <script src="stim/mirror_chasing_output/dist1X.js"></script>
  <script src="stim/mirror_chasing_output/dist1Y.js"></script>
  <script src="stim/mirror_chasing_output/dist2X.js"></script>
  <script src="stim/mirror_chasing_output/dist2Y.js"></script>
  <script src="stim/mirror_chasing_output/dist3X.js"></script>
  <script src="stim/mirror_chasing_output/dist3Y.js"></script>
  <script src="stim/mirror_chasing_output/dist4X.js"></script>
  <script src="stim/mirror_chasing_output/dist4Y.js"></script>
  <script src="stim/mirror_chasing_output/dist5X.js"></script>
  <script src="stim/mirror_chasing_output/dist5Y.js"></script>
  <script src="stim/mirror_chasing_output/dist6X.js"></script>
  <script src="stim/mirror_chasing_output/dist6Y.js"></script>
  <script src="stim/mirror_chasing_output/sheepX.js"></script>
  <script src="stim/mirror_chasing_output/sheepY.js"></script>
  <script src="stim/mirror_chasing_output/wolfX.js"></script>
  <script src="stim/mirror_chasing_output/wolfY.js"></script>

  <link href="jsPsych/css/jspsych.css" rel="stylesheet" type="text/css">
  </link>
  <link rel="stylesheet" type="text/css" href="css/style.css">
</head>

<body id='unload' onbeforeunload="return areYouSure()">
  <?php
  if ($turkprime_online == true) {
    switch ($language) {
      case 'english':
        include_once "include/consent/english.php";
        break;

      case 'french':
        include_once "include/consent/french.php";
        break;

      case 'german':
        include_once "include/consent/german.php";
        break;
    }
    // echo'<br>';
    // echo'connected';
  } else if ($db_connection_status == true) {
    include_once "include/nda.php";
    // echo'<br>';
    // echo'connected';
  } else if ($db_connection_status == false) {
    include_once "include/intake.php";
    // echo'<br>';
    // echo'not connected';
  }
  ?>
</body>
<footer>
  <!-- the order of srcing must remain -->
  <script type="text/javascript" src="exp/fn.js"></script>
  <script type="text/javascript" src="exp/rand.js"></script>
  <script type="text/javascript" src="exp/conf.js"></script>  
  <script type="text/javascript" src="exp/lang.js"></script>
  <script type="text/javascript" src="exp/var.js"></script>
  <script>
    // show page when loaded 
    window.onload = function() {
      $(".loading").css({
        display: "none"
      });
      $(".consent").css({
        display: "block"
      });
      $(".buttonHolder").css({
        display: "block"
      });
    };
  </script>
  <script type="text/javascript">
    // declare NDA required variables
    // let GUID;
    // let subjectID;
    // let sexAtBirth;
    // let siteNumber;
    // let ageAtAssessment;
    // let feedbackLink;
    // let visit;
    // let week;
    if (workerId != "") {
      GUID = "";
      subjectID = "";
      sexAtBirth = "";
      siteNumber = "";
      ageAtAssessment = "";
      feedbackLink = "";
      visit = "";
      week = "";
    } else {
      if (db_connection == false) {
        GUID = "";
        subjectID = "";
        sexAtBirth = "";
        siteNumber = "";
        ageAtAssessment = "";
        feedbackLink = "";
        visit = "";
        week = "";
      } else if (db_connection == true) {
        GUID = "<?php echo $subjectKey ?>";
        subjectID = "<?php echo $consortId ?>";
        workerId = "<?php echo $consortId ?>";
        labId = "<?php echo $labId ?>";
        sexAtBirth = "<?php echo $sexAtBirth ?>";
        siteNumber = "<?php echo $institutionAlias ?>";
        ageAtAssessment = "<?php echo $ageInMonths ?>";
        groupStatus = "<?php echo $groupStatus ?>";
        //feedbackLink = "https://belieflab.yale.edu/omnibus/eCRFs/feedback/tasks/prl.php?candidateId=<?php echo $candidateId ?>&studyId=<?php echo $studyId ?>";
        visit = "<?php echo $visit ?>";
        week = "<?php echo $week ?>";
        feedbackLink = "https://yalesurvey.ca1.qualtrics.com/jfe/form/SV_5BB0Y7nlPJ3Nw1g?interview_age=<?php echo $ageInMonths ?>&src_subject_id=<?php echo $consortId ?>&study_id=<?php echo $labId ?>&subjectkey=<?php echo $subjectKey ?>&site=<?php echo $institutionAlias ?>&sex=<?php echo $sexAtBirth ?>&phenotype=<?php echo $groupStatus ?>&candidateId=<?php echo $candidateId ?>&visit=<?php echo $visit ?>";
      }
    }

    if (turkprime_online === true) {

    } else if (db_connection === false) {
      GUID = "";
      subjectID = "";
      sexAtBirth = "";
      siteNumber = "";
      ageAtAssessment = "";
      feedbackLink = "";
      visit = "";
      week = "";
    } else if (db_connection === true) {
      GUID = "<?php echo $subjectKey ?>";
      workerId = "<?php echo $consortId ?>"; // this is necessary so that the data save with the correct id
      subjectID = "<?php echo $consortId ?>";
      sexAtBirth = "<?php echo $sexAtBirth ?>";
      siteNumber = "<?php echo $institutionAlias ?>";
      ageAtAssessment = "<?php echo $ageInMonths ?>";
      //feedbackLink = "https://belieflab.yale.edu/omnibus/eCRFs/feedback/tasks/kamin.php?candidateId=<?php echo $candidateId ?>&studyId=<?php echo $studyId ?>";
      visit = "<?php echo $visit ?>";
      week = "<?php echo $week ?>";
      feedbackLink = "https://yalesurvey.ca1.qualtrics.com/jfe/form/SV_5BB0Y7nlPJ3Nw1g?interview_age=<?php echo $ageInMonths ?>&src_subject_id=<?php echo $consortId ?>&study_id=<?php echo $labId ?>&subjectkey=<?php echo $subjectKey ?>&site=<?php echo $institutionAlias ?>&sex=<?php echo $sexAtBirth ?>&phenotype=<?php echo $groupStatus ?>&candidateId=<?php echo $candidateId ?>&visit=<?php echo $visit ?>";

    }
  </script>
</footer>

</html>