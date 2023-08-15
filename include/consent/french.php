<div class="screening" style="background-color:darkgray; text-align:center; margin:35px; vertical-align:middle">
<br>

<div id = "consent">
<h1 id="hide" style="text-align:center;">Étudier le formulaire de consentement</h1>
<div class="loading centeredDiv">
    <h1 class="loading">Chargement...</h1>
  </div>
  <div id="consentHolder" class="consent centeredDiv">
  <h3 id="consentPreamble" class="consent">Pour que nous puissions effectuer ce essai en ligne, nous devons inclure le formulaire de consentement standard ci-dessous: <br /> <br /> </h3>

<div id="consentForm" class="consent consent-box"> 
    <h2 id="consentHeading" class="consent">
    CONSENTEMENT À LA PARTICIPATION À UN PROJET DE RECHERCHE 200 FR. 1 (2016-2)
      <br>
      YALE UNIVERSITY SCHOOL OF MEDICINE CONNECTICUT MENTAL HEALTH CENTER
    </h2> 

    <h2>
      
 </h2>
    <p id="consentInstructions" class="consent">
      <b>Titre de l'étude:</b> Croyances et traits de personnalité
      <br><br>
      <b>Chercheur principal:</b> Philip R. Corlett, PhD
      <br><br>
      <b>Source de financement:</b> fonds de la faculté
      <br><br>
      <u><b>Invitation à participer et description du projet</b></u>
      <br>
      Vous êtes invité à participer à une étude de recherche qui concerne les processus psychologiques liés aux croyances et aux traits de personnalité. En raison de la nature des expériences de psychologie, nous ne pouvons expliquer le but précis de l'expérience qu'après la fin de la session. Ensuite, l'expérimentateur se fera un plaisir de répondre à toutes les questions que vous pourriez avoir sur le but de l'étude.
      <br><br>
      <u><b>Description des procédures</b></u>
      <br>
      Si vous acceptez de participer à cette étude, cette tâche d'intelligence humaine (TIH) vous demandera de (1) jouer à un jeu informatique en utilisant la souris ou les touches de votre clavier et (2) répondre à des questions simples sur vos données démographiques, votre santé (y compris santé mentale), les croyances et la personnalité grâce à une enquête Web interactive. On ne vous demandera jamais des informations personnellement identifiables telles que votre nom, adresse ou date de naissance. 
      <br>
      L'expérience est conçue pour durer environ 1 heure. Vous aurez jusqu'à six heures pour terminer l'expérience et soumettre des codes de crédit. 
      <br><br>
      <u><b>Risques et inconvénients</b></u>
      <br>
      Il y a peu ou pas de risques associés à cette étude. Certaines personnes peuvent éprouver un léger ennui. 
      <br><br>
      <u><b>Considérations économiques</b></u>
      <br>
      Vous recevrez la récompense spécifiée sur le Mechanical-Turk TIH pour avoir rempli à la fois le jeu et le questionnaire. Le paiement pour l'achèvement du TIH est de 6,00 $ avec un bonus de 2,00 $ pour les personnes qui se classent parmi les 25% supérieurs au jeu de cartes. Après avoir terminé le jeu et soumis le questionnaire, vous recevrez un numéro de code d'enquête. Veuillez enregistrer ce numéro de code et les soumettre pour paiement. 
      <br><br>
      <u><b>Confidentialité</b></u>
      <br>
      Nous ne vous demanderons jamais votre nom, votre date de naissance, votre email ou toute autre information d'identification. Vos données seront mises en commun avec celles des autres et vos réponses seront totalement anonymes. Nous conserverons ces données indéfiniment pour une utilisation éventuelle dans des publications et présentations scientifiques. 
      <br>
      Le chercheur ne connaîtra pas votre nom et aucune information d'identification ne sera liée de quelque manière que ce soit à vos réponses à l'enquête. L'enquête est donc anonyme. Cependant, votre compte est associé à un numéro mTurk que le chercheur doit pouvoir voir pour vous payer, et dans certains cas, ces numéros sont associés à des profils publics qui pourraient, en théorie, être recherchés. Pour cette raison, bien que le chercheur ne regardera pas les profils publics de qui que ce soit, le fait de votre participation à la recherche (par opposition à vos réponses réelles à l'enquête) est techniquement considéré comme "confidentiel" plutôt que vraiment anonyme.
      <br><br>
      <u><b>Participation volontaire</b></u>
      <br>
      Votre participation dans cette étude est complètement volontaire. Vous êtes libre de refuser de participer ou de mettre fin à la participation à tout moment en fermant simplement la fenêtre de votre navigateur. Cependant, veuillez noter que vous devez soumettre à la fois le jeu informatique et le questionnaire pour recevoir le paiement. Vous pouvez refuser de répondre à toute question en sélectionnant la réponse alternative désignée (par exemple, «Je ne souhaite pas répondre»). Les questions refusées n'affecteront pas le paiement.
      <br><br>
      <u><b>Questions ou préoccupations</b></u>
      <br>
      Si vous avez des questions ou des préoccupations concernant l'expérience, vous pouvez nous contacter ici au laboratoire en envoyant un e-mail à BLAMLabRequester@gmail.com Si vous avez des questions générales sur vos droits en tant que participant à la recherche, vous pouvez contacter le comité d'enquête humaine de l'Université de Yale au 203 -785-4688 ou human.subjects@yale.edu (HSC # 2000022111).

    </p>
  </div>
  </div>
  <button style="float:center; margin:35px; vertical-align:middle" id="submitButton" class="loadMain" onclick="validateConsent()" type="button"><script>consent</script></button></div>
  
<div id="validation" style="display: none">
    <br>
    <form>
</form>
</div>
<div>

<div id="load" style="display: none">
<h3 id='pass'>Toutes les règles de validation ont été passées avec succès. Cliquez pour charger l'expérience.</h3>
<button id="nextButton" class="noCursor" onclick="startExperiment()"><script>load</script></button>
<!-- <p id="nextButton" style="display: none" >please make sure you are in a quiet place. When you are ready to begin, click 'START'</p> -->
<br>
</div>
<script type="text/javascript" src="jQuery/jquery-3.5.1.min.js"></script>
<script>$("button.loadMain").click(function(){
      $.getScript("exp/timeline.js");
      // $.getScript("exp/main.js"); 
    }); </script>


  