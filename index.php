<?php
require_once 'db/data.php';
require_once 'exp/conf.php';
?>

<!DOCTYPE html>
<html>

<head>
  <!-- add the title of the experiment that would be seen in the browser -->
  <title><?php echo $experimentName; ?></title>
  <script>
    //onbeforeunload in body
    function areYouSure() {
      return "Write something clever here...";
    }
    areYouSure();
  </script>
  <!-- set js language variable from php variable in config.php -->
  <script>
    const language = "<?php echo $language; ?>";
  </script>
  <script type="text/javascript" src="db/validate.js"></script>
  <script type="text/javascript" src="jQuery/jquery-3.5.1.min.js"></script>
  <!-- add plugins that you need for your experiment -->
  <script type="text/javascript" src="jsPsych/jspsych.js"></script>
  <script type="text/javascript" src="jsPsych/plugins/jspsych-html-keyboard-response.js"></script>
  <!-- <script type="text/javascript" src="jsPsych/plugins/jspsych-image-keyboard-response.js"></script> -->
  <script type="text/javascript" src="jsPsych/plugins/jspsych-video-keyboard-response.js"></script>
  <link href="jsPsych/css/jspsych.css" rel="stylesheet" type="text/css">
  </link>
  <link rel="stylesheet" type="text/css" href="css/style.css">
</head>

<body id='unload' onbeforeunload="return areYouSure()">
<?php
    if (isset($_GET["workerId"]) || isset($_GET["PROLIFIC_PID"])) {
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
    } else if ($_GET["src_subject_id"]) {
      include_once "include/nda.php";
    } else {
      include_once "include/intake.php";
    }
  ?>
</body>
<footer>
  <script type="text/javascript" src="exp/fn.js"></script>
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
</footer>

</html>