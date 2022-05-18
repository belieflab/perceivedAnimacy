# script created by Santiago Castiello. This script is used to fit "good"
# artificial subjects in order to assess if we can recover the parameters which
# whom the artificial agents were simulated with.
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))
# add work directory
# setwd(file.path(dirname(rstudioapi::getActiveDocumentContext()$path)))



# # # # # # # # # # libraries # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 



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
simParticip <- unique(simPars$part)

range(simPars$mc)
range(simPars$theta)
range(simPars$eta)

# parameters for fitting algorithm based on mc, theta, and eta ranges
fitPars <- list(mcRange = c(20,100),
                thetaRange = c(50,200),
                etaRange = c(0.55,0.95),
                binsSize = data.frame(mc=5,theta=5,eta=30))

# add columns which will be filled with the fitting algorithm
simPars$negSumLog <- simPars$hitRate <- 
  simPars$eta_fit_var <- simPars$theta_fit_var <- simPars$mc_fit_var <- 
  simPars$eta_fit_wm <- simPars$theta_fit_wm <- simPars$mc_fit_wm <- NA
# create list to get posterior densities
posterior_densities <- list()

# get starting time
start_time <- Sys.time()
for (i in 1:length(simParticip)) {
  message(paste0("participant (",simParticip[i],"): ",i,"/",length(simParticip)))
  
  # get only one participant (i.e., set of parameters)
  onePartDat <- read.csv(paste0("sim_data/sim_",simParticip[i],".csv"))
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
  posterior_densities[[i]] <- temp$post_prob
}#; remove(temp)
# get end time
end_time <- Sys.time()
# total duration time
total_time <- end_time - start_time

# print fitted parameters
write.csv(simPars,"simParsWithParRecovery.csv",row.names = F)
