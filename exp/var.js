// trial counter
let trialIterator = 1;
let feedbackGenerator = '<div id="feedback" style="font-size:60px; color:white;">lol</div>';

//// (1) create a random sample sized numberTestTrials from numbers between 1 and 300
// array from 1 to 300 by 1
let posibleTrials = Array(300).fill().map((element, index) => index + 1);
// randomize posibleTrials vector
let randTrials = jsPsych.randomization.repeat(posibleTrials, 1); //shuffled array no repeats
// take only the firt numberTestTrials  
const randPracticeTrials = randTrials.slice(0, numberPracticeTrials);
const randTestTrials = randTrials.slice(numberPracticeTrials, numberPracticeTrials+numberTestTrials);


// # # # # (2) define trial videos location # # # # 
// practice trials
let chasePractice = [];
let noChasePractice = [];
for (let i = 0; i < randPracticeTrials.length; i++) {
    chasePractice.push("stim/chasing2/trial" + randPracticeTrials[i] + "mod.mp4")
    noChasePractice.push("stim/mirrorChasing2/trial" + randPracticeTrials[i] + "mod.mp4")
}
// test trials
let chaseTest = [];
let noChaseTest = [];
for (let i = 0; i < randTestTrials.length; i++) {
    chaseTest.push("stim/chasing2/trial" + randTestTrials[i] + "mod.mp4")
    noChaseTest.push("stim/mirrorChasing2/trial" + randTestTrials[i] + "mod.mp4")
}


// # # # # (3) create trials object # # # # 
let practiceTrials = [];
// add chase videos' location to practiceTrials array
for (let i = 0; i < chasePractice.length; i++) {
    practiceTrials.push({
        stimulus: [chasePractice[i]],
        data: {
            test_part: "chase",
            stim: chasePractice[i].slice(14,)
        }
    });
}
// add no chase videos' location to practiceTrials array
for (let i = 0; i < noChasePractice.length; i++) {
    practiceTrials.push({
        stimulus: [noChasePractice[i]],
        data: {
            test_part: "no_chase",
            stim: noChasePractice[i].slice(20,)
        }
    });
}

let testTrials = [];
// add chase videos' location to testTrials array
for (let i = 0; i < chaseTest.length; i++) {
    testTrials.push({
        stimulus: [chaseTest[i]],
        data: {
            test_part: "chase",
            stim: chaseTest[i].slice(14,)
        }
    });
}
// add no chase videos' location to testTrials array
for (let i = 0; i < noChaseTest.length; i++) {
    testTrials.push({
        stimulus: [noChaseTest[i]],
        data: {
            test_part: "no_chase",
            stim: noChaseTest[i].slice(20,)
        }
    });
}


// # # # # (4) randomize chase and no chase trials # # # # 
let randomizedPracticeTrials = jsPsych.randomization.repeat(practiceTrials, 1); //shuffled array no repeats
let randomizedTestTrials = jsPsych.randomization.repeat(testTrials, 1); 
