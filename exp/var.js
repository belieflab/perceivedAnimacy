trialIterator = 1;

// (1) define variables
let chase = [];
let noChase = [];
for (let i = 1; i <= 300; i++) {
    chase.push("stim/chasing/trial" + i + ".mp4")
    noChase.push("stim/mirrorChasing/trial" + i + ".mp4")
}

let trials = [];

for (let i = 0; i < chase.length; i++) {
    trials.push({
        stimulus: [chase[i]],
        data: {
            test_part: "chase",
            stim: chase[i]
        }
    }); //creating csv file "baseline_ratings" with liking ratings data saved
}

for (let i = 0; i < noChase.length; i++) {
    trials.push({
        stimulus: [noChase[i]],
        data: {
            test_part: "no_chase",
            stim: noChase[i]
        }
    }); //creating csv file "baseline_ratings" with liking ratings data saved
}

let randomizedTrials = jsPsych.randomization.repeat(trials, 1); //shuffled array no repeats

let practiceTrial = [{
    stimulus: ["stim/chasing/trial1.mp4"],
    data: {
        test_part: "no_chase",
        stim: "stim/chasing/trial1.mp4"
    }
}];