# 🧠 Perceived Animacy

This psychological task investigates the [Perceived Animacy]([https://en.wikipedia.org/wiki/Blocking_effect](https://perception.yale.edu/papers/13-Scholl-Gao-Chapter.pdf)). Prof. Brian Scholl at Yale has widely studied this phenomenon. The 600 displays used in this task were developed by Ben van Buren and Brian Scholl. Ben shared them with us, and Santiago Castiello added one last frame, where the question "Chase or No Chase?" is displayed.

## 🚀 Getting Started

### Clone the Repository
To clone the repository with all necessary submodules, run:
```bash
 git clone --recurse-submodules -j4 --branch chase-confidence git@github.com:belieflab/perceivedAnimacy.git && cd perceivedAnimacy && git submodule foreach --recursive 'git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo main)' && git update-index --assume-unchanged exp/conf.js
```

### Version Information
- **Version**: the 'corrected' version was created after an error was discovered in `testing_stimuli`. The "consistent-allergy" condition had a stimulus 2 pairing, which should never have been the case. Per Phil Corlett, previous data is not compromised for key trial types. However, low-level controls (I-, J+) should not be used in combined analysis of tasks without ensuring the version variable is equal to 'correct'!

## 🎯 Task Description
Participants are exposed to ~4 sec displays and asked to identify whether one disc was 'chasing' another or not (see example [here](https://www.youtube.com/watch?v=JWGMmfFf4F0&list=PL-9PGvTjkpCcxXPpfWnhQvafeYR3b6Top&ab_channel=SantiagoCastiellodeObeso)) and to report their confidence. The task consist in two phases: practice and test. In the practice phase, participant reports chase or no chase and feedback is provided in the form: correct/incorrect. In the test phase, participant detect chase and report confidence between 1 and 5, and no feedback is provide.

## 📊 Configuration

feedbackDuration: duration of "correct" or "incorrect" feedback words  after each trial (in miliseconds).
numberPracticeTrials: number of displays for the practice block, i.e., with feedback (in natural numbers).
numberTestTrials: number of displays for the test block, i.e., without feedback (in natural numbers).
The sum of numberPracticeTrials and numberTestTrials should be no larger than 300 (number of different displays per trial type).

## 🛠 Development Guide

### Install and Configure XAMPP
1. [Download XAMPP](https://www.apachefriends.org/download.html) with PHP version 7.3.19
2. Open XAMPP and click "Start" to boot the application.
3. Navigate to "Services" and click "Start All".
4. Navigate to "Network", select localhost:8080, and click "Enable".
5. Navigate to "Volumes" and click "Mount".

### Clone the Git Repository
6. Open Terminal and navigate to the `htdocs` directory:
   - **Mac/Linux:**
     ```bash
     cd ~/.bitnami/stackman/machines/xampp/volumes/root/htdocs
     ```
   - **Windows:**
     ```bash
     cd C:\xampp\htdocs
     ```
7. Clone into `htdocs`:
   ```bash
   git clone https://github.com/belieflab/perceivedAnimacy.git
   ```

### Modify Permissions
8. Copy this text into your terminal from the `htdocs` folder:
   ```bash
   sudo chmod -R 777 perceivedAnimacy/
   ```
        
### Start Experiment
9. Click this URL: [http://localhost/kaminBlocking](http://localhost/perceivedAnimacy)
      
### View the Source Code
10. Open the `kaminBlocking` directory in a text editor of your choice. We prefer [Visual Studio Code](https://code.visualstudio.com/):
    - **Mac/Linux:**
      ```bash
      cd ~/.bitnami/stackman/machines/xampp/volumes/root/htdocs/perceivedAnimacy
      ```
    - **Windows:**
      ```bash
      cd C:\xampp\htdocs\perceivedAnimacy
      ```

## 🌐 Hosting Guide  

### Clone the Git Repository
1. Open Terminal and navigate to your server's default directory:
   - **Apache Linux default directory:**
     ```bash
     cd /var/www/html
     ```
2. Clone the repository:
   ```bash
   git clone https://github.com/belieflab/perceivedAnimacy.git
   ```

### Modify Permissions
3. Execute these two `chmod` commands in terminal from `/var/www/html`:
   ```bash
   sudo chmod -R 755 perceivedAnimacy/
   sudo chmod -R 777 perceivedAnimacy/data
   ```

> **Note:** This version is correct!
