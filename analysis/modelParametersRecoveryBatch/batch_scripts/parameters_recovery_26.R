# script created by Santiago Castiello. This script is used to fit one "good"
# artificial subject. We fit one subject by using one batch each. See the master
# code named: paramters_recovery.R
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))
# add work directory
# setwd(file.path(dirname(rstudioapi::getActiveDocumentContext()$path)))



# # # # # # # # # # global elements # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
i=26



# # # # # # # # # # functions # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
source("../functions.R")



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# get artificial agents simulated with "good" parameters 
if (sum(list.files("../figures_tables") == "simPars.csv" |
        list.files("../figures_tables") == "simTrials.csv" |
        list.files("../figures_tables") == "simRandDist.csv") > 0) {
  simPars <- read.csv("../figures_tables/simPars.csv")
  simTrials <- read.csv("../figures_tables/simTrials.csv")
  randDist <- read.csv("../figures_tables/simRandDist.csv")
} else {
  warning("Run script simulate_good_parameters.R")
}



# # # # # # # # # # parameters recovery # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# get all "participants" vector (i.e., set of parameters)
simParticip <- unique(simPars$part)

# getting only one participant
simPars <- simPars[simPars$part == simParticip[i],]

# range(simPars$mc)
# range(simPars$theta)
# range(simPars$eta)

# parameters for fitting algorithm based on mc, theta, and eta ranges
fitPars <- list(mcRange = c(20,100),
                thetaRange = c(50,200),
                etaRange = c(0.55,0.95),
                binsSize = data.frame(mc=30,theta=30,eta=30))

# add columns which will be filled with the fihtting algorithm
simPars$negSumLog <- simPars$hitRate <- 
  simPars$eta_fit_var <- simPars$theta_fit_var <- simPars$mc_fit_var <- 
  simPars$eta_fit_wm <- simPars$theta_fit_wm <- simPars$mc_fit_wm <- NA
# create list to get posterior densities
# posterior_densities <- list()

# get starting time
start_time <- Sys.time()
# for (i in 1:length(simParticip)) {
  # message(paste0("participant (",simParticip[i],"): ",i,"/",length(simParticip)))
  
  # get only one participant (i.e., set of parameters)
  onePartDat <- simTrials[simTrials$part == simParticip[i],]
  # unique(randDist$trialCond) == onePartDat$trialCond
  
  # fit one participant (i.e., set of parameters)
  temp <- f_fitDetMod(randDist, onePartDat, fitPars, plotFigure = F, progress_bar = T)
  
  # extract fitted parameters
  simPars$negSumLog[simPars$part == simParticip[i]] <- temp$mle$negSumLog
  simPars$hitRate[simPars$part == simParticip[i]] <- temp$mle$hitRate
  simPars[simPars$part == simParticip[i],grepl("wm",colnames(simPars))] <- 
    temp$pars$wMean
  simPars[simPars$part == simParticip[i],grepl("var",colnames(simPars))] <- 
    temp$pars$var
  # posterior_densities[[i]] <- temp$post_prob
# }#; remove(temp)
# get end time
end_time <- Sys.time()
# total duration time
total_time <- end_time - start_time

# add total time
simPars$total_time <- total_time

# print fitted parameters
write.csv(simPars,paste0("../figures_tables/simParsWithParRecovery_",i,".csv"),
          row.names = F)
