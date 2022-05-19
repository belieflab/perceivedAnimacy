# script created by Santiago Castiello. This script clean participants 
# behavioural data and create csvs with the discs distances per participant
# in the exact order they experience the trials. Output folders will be:
# clean_participants_behaviour and trial_order_distances
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# get artificial agents simulated with "good" parameters 
discsDistances <- read.csv("../modelParametersRecovery/figures_tables/discsDistances.csv")

# get artificial agents simulated with "good" parameters 
behDataFilesNames <- list.files("../../data/behaviour")
# workerId vector
workerIds <- substr(behDataFilesNames,9,nchar(behDataFilesNames)-4)

# number of participants
nSubj <- length(behDataFilesNames)

# filter by relevant columns
relCols <- c("workerId","trialType","stim","trialCond","index","rt","chaseR",
             "response","cells")

# print celan csv?
print_clean_csv <- 1

# print clean participants data
for (i in 1:nSubj) {
  message(paste0("participant ",workerIds[i],": ",i,"/",nSubj))
  
  # get only one participant (i.e., set of parameters)
  onePartDat <- read.csv(paste0("../../data/behaviour/",behDataFilesNames[i]))
  # remove irrelevant columns
  onePartDat <- onePartDat[!is.na(onePartDat$index),]
  # code responses: 1 = chase, 0 = no chase (mirror)
  onePartDat$chaseR <- as.integer(ifelse(onePartDat$key_press == "49",1,0))
  # reaction time to numeric
  onePartDat$rt <- as.numeric(onePartDat$rt)
  
  # trialType instead of test_part
  onePartDat$test_part <- ifelse(onePartDat$test_part == "chase","chase","mirror")
  colnames(onePartDat)[grepl("test_part",colnames(onePartDat))] <- "trialType"
  # identify which specific video was played at trial t
  
  # trial type and number
  onePartDat$trialCond <- paste0(substr(onePartDat$stim,6,nchar(onePartDat$stim)-7),
                                 "_",onePartDat$trialType)
  # get the cells for the SDT contingency table (pressed key and trial type)
  onePartDat$cells <- paste0("R",onePartDat$chaseR,"_TT",onePartDat$trialType)
  
  # filter
  onePartDat <- onePartDat[,relCols]
  
  # print csv
  if (print_clean_csv == 1) {
    write.csv(onePartDat, paste0("clean_participants_behaviour/clean_",
                                 workerIds[i],".csv"),row.names = F)
  }
  
  # # # # # print disc distances in order given onePartDat # # # # #
  for (j in 1:nrow(onePartDat)) {
    temp <- discsDistances[discsDistances$trialCond == onePartDat$trialCond[j],]
    if (j == 1) {
      onePartDistances <- data.frame(index=j,temp)
    } else {
      onePartDistances <- rbind(onePartDistances,data.frame(index=j,temp))
    }
  } # end j loop
  # sum(unique(onePartDistances$trialCond) == onePartDat$trialCond)
  
  # add workerId
  onePartDistances <- data.frame(workerId=workerIds[i],onePartDistances)
  
  # print csv
  if (print_clean_csv == 1) {
    write.csv(onePartDistances, paste0("trial_order_distances/discsDist_",
                                 workerIds[i],".csv"),row.names = F)
  }
} # end i loop
