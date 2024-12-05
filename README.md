# Perceived Animacy
```
 git clone --recurse-submodules -j4 --branch chase-confidence git@github.com:belieflab/perceivedAnimacy.git && cd perceivedAnimacy && git submodule foreach --recursive 'git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo main)' && git update-index --assume-unchanged exp/conf.js
 ```
 
## Configuration

feedbackDuration: duration of "correct" or "incorrect" feedback words  after each trial (in miliseconds).

numberPracticeTrials: number of displays for the practice block, i.e., with feedback (in natural numbers).

numberTestTrials: number of displays for the test block, i.e., without feedback (in natural numbers).

The sum of numberPracticeTrials and numberTestTrials should be no larger than 300 (number of different displays per trial type).

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
