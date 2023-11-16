<?php

//***********************************//
//   EXPERIMENT CONFIGURATION FILE   //
//***********************************//

// SET EXPERIMENT NAME
$experimentName = 'Chase Detection Task';
$experimentAlias = 'animacyConfidence';

// SELECT LANGUAGE
$language = 'english';
// $language = 'french';
// $language = 'german';

// SET SUBJECT IDENTIFICATION
if (isset($_GET["workerId"])) {
  $workerId = $_GET["workerId"];
  $subjectId = $_GET["workerId"];
}

if (isset($_GET["PROLIFIC_PID"])) {
  $PROLIFIC_PID = $_GET["PROLIFIC_PID"];
  $subjectId = $_GET["PROLIFIC_PID"];
}

if (isset($_GET["src_subject_id"])) {
  $src_subject_id = $_GET["src_subject_id"];
  $subjectId = $_GET["src_subject_id"];
  
  // these are omnibus data base variables which will get passed from participant portal
  $studyId = $_GET["studyId"];
  $candidateId = $_GET["candidateId"];
  // these are NDA required variables which will get passed from participant portal
  $subjectKey = $_GET["subjectkey"];
  $consortId = $_GET["src_subject_id"];
  $sexAtBirth = $_GET["sex"];
  $institutionAlias = $_GET["site"];
  $ageInMonths = $_GET["interview_age"];
  $groupStatus = $_GET["phenotype"];
  $visit = $_GET["visit"];
}

/**
 * Get the hash of the current git HEAD
 * @param str $branch The git branch to check
 * @return mixed Either the hash or a boolean false
 */

function get_current_git_commit( $branch='master' ) {
  if ( $hash = file_get_contents( sprintf( '.git/refs/heads/%s', $branch ) ) ) {
    return "version: ".strval(substr(trim($hash),-7));
  } else {
    return false;
  }
}
?>

<script type="text/javascript">
  const experimentName = "<?php echo $experimentName; ?>";
  const experimentAlias = "<?php echo $experimentAlias; ?>";
  const workerId = "<?php echo $workserId; ?>";
  const PROLIFIC_PID = "<?php echo $PROLIFIC_PID; ?>";
  let src_subject_id = "<?php echo $src_subject_id; ?>";
  let subjectId = "<?php echo $subjectId; ?>";
  const language = "<?php echo $language; ?>";
  const adminEmail = "joshua.kenney@yale.edu";
  const feedbackLink = "https://belieflab.yale.edu/omnibus/eCRFs/feedback/tasks/kamin.php?candidateId=<?php echo $candidateId?>&studyId=<?php echo $studyId?>";
</script>