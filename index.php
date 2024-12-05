<?php
require_once './wrap/lib/ids.php';
?>

<!DOCTYPE html>
<html>

<head>
  <!-- add the title of the experiment that would be seen in the browser -->
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      document.title = `${experimentAlias.toUpperCase()}`;
    });
  </script>
  <!-- favicon -->
  <link rel="icon" type="image/ico" href="./wrap/favicon.ico">
  <!-- PHP wrapper libraries -->
  <script type="text/javascript" src="./wrap/lib/validate.js"></script>
  <script type="text/javascript" src="./wrap/lib/jquery-3.5.1.min.js"></script>
  <!-- jsPsych CDN (content delivery network) libraries -->
  <script src="https://unpkg.com/jspsych@7.3.3"></script>
  <link href="https://unpkg.com/jspsych@7.3.3/css/jspsych.css" rel="stylesheet" type="text/css"/>
  <!-- jsPsych Plugins (add more here) -->
  <script src="https://unpkg.com/@jspsych/plugin-preload@1.1.3"></script>
  <script src="https://unpkg.com/@jspsych/plugin-html-keyboard-response@1.1.2"></script>
  <script src="https://unpkg.com/@jspsych/plugin-survey-multi-choice@1.1.3"></script>
  <script src="https://unpkg.com/@jspsych/plugin-video-keyboard-response"></script>
  <!-- general styling -->
  <link rel="stylesheet" type="text/css" href="./wrap/lib/style.css">
  <!-- additional styling -->
  <!-- <link rel="stylesheet" type="text/css" href="./css/style.css"> -->

</head>

<body id='unload' onbeforeunload="return areYouSure()">
<?php
   if (isset($_GET["workerId"]) || isset($_GET["PROLIFIC_PID"]) || isset($_GET["participantId"])) {
    include_once "./wrap/include/start.php";
  }
  if (isset($_GET["src_subject_id"])) {
    include_once "./wrap/include/nda.php";
  } 
  if (!isset($_GET["workerId"]) && !isset($_GET["PROLIFIC_PID"]) && !isset($_GET["participantId"]) && !isset($_GET["src_subject_id"])) {
    include_once "./wrap/include/intake.php";
  }
  ?>
</body>
<footer>
  <!-- load config first! -->
  <script type="text/javascript" src="./wrap/lib/redirect.js"></script>
  <script type="text/javascript" src="./exp/conf.js"></script>
  <!-- load wrapper dependencies -->
  <script type="text/javascript" src="./wrap/lib/fn.js"></script>
  <!-- load experiment dependencies -->
  <script type="text/javascript" src="./exp/fn.js"></script>
  <script type="text/javascript" src="./exp/var.js"></script>
  <script type="text/javascript" src="./exp/lang.js"></script>
</footer>

</html>
