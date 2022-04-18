// trial counter
let trialIterator = 1;
let feedbackGenerator = '<div id="feedback" style="font-size:60px; color:white;">lol</div>';

//// (1) create a random sample sized numberTrials from numbers between 1 and 300
// array from 1 to 300 by 1
let posibleTrials = Array(300).fill().map((element, index) => index + 1);
// randomize posibleTrials vector
let randTrials = jsPsych.randomization.repeat(posibleTrials, 1); //shuffled array no repeats
// take only the firt numberTrials  
const slicedRandTrials = randTrials.slice(0, numberTrials);

// (2) define variables
let chase = [];
let noChase = [];
for (let i = 1; i <= slicedRandTrials.length; i++) {
    chase.push("stim/chasing2/trial" + slicedRandTrials[i-1] + "mod.mp4")
    noChase.push("stim/mirrorChasing2/trial" + slicedRandTrials[i-1] + "mod.mp4")
}

// (3) create trials vector
let trials = [];
// add chase viceos' location to trials vector
for (let i = 0; i < chase.length; i++) {
    trials.push({
        stimulus: [chase[i]],
        data: {
            test_part: "chase",
            stim: chase[i].slice(14,)
        }
    }); //creating csv file "baseline_ratings" with liking ratings data saved
}
// add no chase videos' location to trials vector
for (let i = 0; i < noChase.length; i++) {
    trials.push({
        stimulus: [noChase[i]],
        data: {
            test_part: "no_chase",
            stim: noChase[i].slice(20,)
        }
    }); //creating csv file "baseline_ratings" with liking ratings data saved
}
// randomize chase and no chase trials
let randomizedTrials = jsPsych.randomization.repeat(trials, 1); //shuffled array no repeats
