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

</head>

<body id='unload' onbeforeunload="return areYouSure()">


  <!-- <script>
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
    // Take the user to a random URL, selected from the pool below 
    var links = [];
    // const workerIdFromParamString = getParamFromURL('workerId');
    // const prolificPidFromParamString = getParamFromURL('PROLIFIC_PID');

    // if (workerIdFromParamString) {
    //   links[0] = "index.php" + "?workerId=" + workerIdFromParamString; // Expt 1: Paranoia Reversals 11-30-2017
    // }
    // if (prolificPidFromParamString) {
    //   links[0] = "index.php" + "?PROLIFIC_PID=" + prolificPidFromParamString; // Expt 1: Paranoia Reversals 11-30-2017
    // }
    var usernameFromParamString = getParamFromURL('workerId');

    links[0] = "index.php" + "?workerId=" + usernameFromParamString; // Expt 1: Paranoia Reversals 11-30-2017


    function randomizeURL(linkArray) {
      window.location = linkArray[Math.floor(Math.random() * linkArray.length)];
    }

    randomizeURL(links);
  </script> -->
  <?php
    // Get the params from the URL
    $workerId = $_GET['workerId'];
    $PROLIFIC_PID = $_GET['PROLIFIC_PID'];

    if ($workerId) {
      // Redirect to index.php with the workerId parameter
      header("Location: index.php?workerId=$workerId");
      exit; // Make sure to exit after the header redirect
    } else if ($PROLIFIC_PID) {
      // Redirect to index.php with the workerId parameter
      header("Location: index.php?PROLIFIC_PID=$PROLIFIC_PID");
      exit; // Make sure to exit after the header redirect
    } else {
      // Redirect to index.php with the workerId parameter
      echo"<h1>Ah! Ah! Ah!<h1>";
      echo"<h1>You didn't say the magic word!<h1/>";
      echo"<img src='magicword.gif'>";
      exit; // Make sure to exit after the header redirect
    }
  ?>

</body>

</html>