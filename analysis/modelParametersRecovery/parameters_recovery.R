# script created by Santiago Castiello. In this script we used the simulated
# "good" artificial subjects to recover their parameters whom which they were
# simulated.
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))
# add work directory
setwd(file.path(dirname(rstudioapi::getActiveDocumentContext()$path)))



# # # # # # # # # # functions # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
source("functions.R")



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# get artificial agents simulated with "good" parameters 
if (sum(list.files("figures_tables") == "simPars.csv" |
        list.files("figures_tables") == "simRandDist.csv") > 0) {
  simPars <- read.csv("figures_tables/simPars.csv")
  randDist <- read.csv("figures_tables/simRandDist.csv")
} else {
  warning("Run script simulate_good_parameters.R")
}


# # # # # # # # # # parameters recovery # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# get all "participants" vector (i.e., set of parameters)
simFilesNames <- list.files("sim_data/") 
simCode <- unique(simPars$part)

range(simPars$mc)
range(simPars$theta)
range(simPars$eta)

# parameters for fitting algorithm based on mc, theta, and eta ranges
fit_posterior_space  <- list(mcRange = c(15,105),
                             thetaRange = c(40,210),
                             etaRange = c(0.52,0.98),
                             # binsSize = data.frame(mc=50,theta=50,eta=50))
                             binsSize = data.frame(mc=30,theta=30,eta=30))

# add columns which will be filled with the fitting algorithm
simPars$negSumLog <- simPars$hitRate <- 
  simPars$eta_fit_var <- simPars$theta_fit_var <- simPars$mc_fit_var <- 
  simPars$eta_fit_wm <- simPars$theta_fit_wm <- simPars$mc_fit_wm <- NA
# create list to get posterior densities
posterior_densities <- list()

# get starting time
start_time <- Sys.time()
for (i in 1:length(simCode)) {
  message(paste0("participant (",simCode[i],"): ",i,"/",length(simCode)))
  
  # get only one participant (i.e., set of parameters)
  onePartDat <- read.csv(paste0("sim_data/",simFilesNames[i]))
  # onePartDat <- simTrials[simTrials$part == simParticip[i],]
  # unique(randDist$trialCond) == onePartDat$trialCond
  
  # fit one participant (i.e., set of parameters)
  temp <- f_fit_one(randDist, chaseResp=onePartDat$chaseR, 
                    fit_posterior_space,fitParallel = F)
  
  # extract fitted parameters
  simPars$negSumLog[simPars$part == simCode[i]] <- temp$modPerformance$negSumLog
  simPars$hitRate[simPars$part == simCode[i]] <- temp$modPerformance$hitRate
  simPars[simPars$part == simCode[i],grepl("wm",colnames(simPars))] <- 
    temp$params$wMean
  simPars[simPars$part == simCode[i],grepl("var",colnames(simPars))] <- 
    temp$params$var
  posterior_densities[[i]] <- temp$post_prob
}#; remove(temp)
# get end time
end_time <- Sys.time()
# total duration time
total_time <- end_time - start_time; total_time

# print fitted parameters
write.csv(simPars,"figures_tables/simParsRecoveryOneBatch.csv")
