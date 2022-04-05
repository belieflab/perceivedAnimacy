# Perceived Animacy

## Configuration

If you want no feedback then activate:
"const version = 'noFeedback';"
If you want feedback then activate:
"const version = 'feedback';"
feedbackDuration: duration of "correct" or "incorrect" display to praticipants after each trial (in miliseconds).
numberTrials: number of trials per trial type (max = 300).

## Development Guide

#### Install and configure XAMPP:
1. [Download XAMPP](https://www.apachefriends.org/download.html) with PHP version 7.3.19
2. Open XAMPP and click "Start" to boot the XAMPP application.
3. Navigate to "Services" and click "Start All" button.
4. Navigate to "Network", select localhost:8080, and click "Enable".
5. Navigate to "Volumes" and click "Mount".

#### Clone the git repository:
6. Open Terminal and navigate to the htdocs directory:

    Mac/Linux:

        cd ~/.bitnami/stackman/machines/xampp/volumes/root/htdocs
    Windows:

        cd C://xampp//htdocs

7. Clone into htdocs:

        git clone https://github.com/santiagocdo/perceivedAnimacy.git

#### Modifty permissions:
8. Copy this text into your terminal from the htdocs folder (the folder you are already in).

        sudo chmod -R 777 perceivedAnimacy/
        
#### Start experiment:     
9. Click this URL: [http://localhost/perceivedAnimacy/?workerId](http://localhost/perceivedAnimacy/?workerId)
      
      
      
### BRAVO! You're a XAMPP master.
