# list the
partBehaviour <- list.files("clean_participants_behaviour/")
trialDistances <- list.files("trial_order_distances/")

# get only the workerIds
workerIdBehaviour <- substr(partBehaviour,7,nchar(partBehaviour)-4)
workerIdTrialDistances <- substr(trialDistances,11,nchar(trialDistances)-4)

# intersect workerIds between the two sets (i.e., two folders)
workerId <- intersect(workerIdBehaviour,workerIdTrialDistances)

# create a text file with all workerIds that intersect between the two sets
for (i in 1:length(workerId)) {
  cat(paste0("module purge; module load R/4.1.0-foss-2020b; Rscript singleModelFit.R clean_participants_behaviour/clean_",
             workerId[i],".csv trial_order_distances/discsDist_",workerId[i],".csv\n"))
}
