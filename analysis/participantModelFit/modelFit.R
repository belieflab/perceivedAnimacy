# script created by Santiago Castiello. In this script we fit n=100 participants
# ran for my short-scholar visit at Yale 2022. We used a model with 3 free
# parameters: tau ("memory capacity"), theta (proximity), and eta (exploration/
# explotation)
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))



# # # # # # # # # # functions # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
source("../modelParametersRecovery/functions.R")



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# get artificial agents simulated with "good" parameters 
behaviourCsv <- list.files("clean_participants_behaviour/")
distancesCsv <- list.files("trial_order_distances/")
# workerIds <- substr(behaviourCsv,7,nchar(behaviourCsv)-4)
workerIds <- substr(distancesCsv,11,nchar(distancesCsv)-4) # should be the same as previous

# number of participants
nSubj <- length(workerIds)



# # # # # # # # # # fitting participants# # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# parameters for fitting algorithm based on mc, theta, and eta ranges
fit_posterior_space  <- list(mcRange = c(15,105),
                             thetaRange = c(40,210),
                             etaRange = c(0.52,0.98),
                             binsSize = data.frame(mc=50,theta=50,eta=50))
                             # binsSize = data.frame(mc=2,theta=2,eta=2))

# add columns which will be filled with the fitting algorithm
fittedParameters <- data.frame(matrix(NA,nrow=nSubj,ncol=9)) 
colnames(fittedParameters) <- c("workerId","mc_fit_wm","mc_fit_var",
                                "theta_fit_wm","theta_fit_var",
                                "eta_fit_wm","eta_fit_var","negSumLog","hitRate")
fittedParameters$workerId <- workerIds

# create list to get posterior densities
posterior_densities <- list()

# get starting time
start_time <- Sys.time()
for (i in 1:nSubj) {
  message(paste0("participant ",workerIds[i],": ",i,"/",nSubj))
  
  # get only one participant (i.e., set of parameters)
  onePartData <- read.csv(paste0("clean_participants_behaviour/",behaviourCsv[i]))
  onePartDists <- read.csv(paste0("trial_order_distances/",distancesCsv[i]))
  # unique(onePartDists$trialCond) == onePartData$trialCond
  
  
  # fit one participant (i.e., set of parameters)
  temp <- f_fit_one(onePartDists, chaseResp=onePartData$chaseR, 
                    fit_posterior_space,fitParallel = F)
  
  # # # # # extract fitted parameters # # # # #
  # negative sum log liklihood (model evidence)
  fittedParameters$negSumLog[fittedParameters$workerId == workerIds[i]] <- 
    temp$modPerformance$negSumLog
  # hit rate
  fittedParameters$hitRate[fittedParameters$workerId  == workerIds[i]] <- 
    temp$modPerformance$hitRate
  # weighted means
  fittedParameters[fittedParameters$workerId  == workerIds[i],
                   grepl("wm",colnames(fittedParameters))] <- temp$params$wMean
  # variances
  fittedParameters[fittedParameters$workerId  == workerIds[i],
                   grepl("var",colnames(fittedParameters))] <- temp$params$var
  
  # posterior density
  posterior_densities[[i]] <- temp$post_prob
}#; remove(temp)
# get end time
end_time <- Sys.time()
# total duration time
total_time <- end_time - start_time

# print fitted parameters
print_csv <- 1
if (print_csv == 1) {
  write.csv(fittedParameters,"fittedParameters.csv",row.names = F)
}
