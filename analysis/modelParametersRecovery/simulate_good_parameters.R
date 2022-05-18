# script created by Santiago Castiello. In this script we used the parametric 
# space ran with function f_SDTparamExplor in the script: 
# visualize_parametric_space.R. Then we simulate N "participants" with a random
# decision rule "eta" parameter.
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))
# add work directory
setwd(file.path(dirname(rstudioapi::getActiveDocumentContext()$path)))



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
discsDistances <- read.csv("figures_tables/discsDistances.csv")
# discsAngles <- read.csv("figures_tables/discsAngles.csv")
# discsPositions <- read.csv("figures_tables/discsPositions.csv")
# get the simulated parametric space 
if (sum(list.files("figures_tables") == "sdtParameters.csv") > 0) {
  sdtParameters <- read.csv("figures_tables/sdtParameters.csv")
} else {
  warning("Run script visualize_parametric_space.R")
}



# # # # # # # # # # simulate with good parameters # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# select only the "good" parameters so we will recover those parameters
sdtParameters$goodPar <- ifelse(sdtParameters$sensit > 0.8 &
                                  (sdtParameters$resCri < 1.2 &
                                     sdtParameters$resCri > -1.2),"good","bad")
bestSdtPars <- sdtParameters[sdtParameters$goodPar == "good",]

# # # # create data frame with parameters that will be simulated (vert slow)
# params <- data.frame(mc=rep(bestSdtPars$mc,10),
#                      theta=rep(bestSdtPars$theta,each=10),
#                      eta=rep(seq(0.55,1,0.05),nrow(bestSdtPars)))

# # # # if you don't want to simulate with multiple eta values (slow)
params <- data.frame(mc=bestSdtPars$mc,
                     theta=bestSdtPars$theta,
                     eta=0.75) # eta won't be used

# # # # only one set of parameters (fast)
# params <- data.frame(mc = 52, theta = 90, eta = 0.75)

# select nTrialsPerCond trials per condition (chase/mirror)
nTrialsPerCond <- 100
randDist <- f_randNTrials(discsDistances,nTrialsPerCond)

# if randDist and simPars are already write, then just read the 
# files and not simulate nor write them again. 
if (sum(list.files("figures_tables") == "simPars.csv" |
        list.files("figures_tables") == "randDist.csv") == 0) {
  # for loop for parameters set
  for (p in 1:nrow(params)) {
    message(paste("set of parameters:",p))
    if (p == 1) {
      sim <- f_detMod(randDist, params[p,])
      simPars <- sim$params
      sim$dbTrials$part <- paste0(sim$params$mc,"_",
                                  sim$params$theta,"_",
                                  sim$params$eta)
      write.csv(sim$dbTrials,paste0("sim_data/sim_",sim$dbTrials$part[1],".csv"), 
                row.names = F)
    } else {
      sim <- f_detMod(randDist, params[p,])
      simPars <- rbind(simPars,sim$params)
      sim$dbTrials$part <- paste0(sim$params$mc,"_",
                                  sim$params$theta,"_",
                                  sim$params$eta)
      write.csv(sim$dbTrials,paste0("sim_data/sim_",sim$dbTrials$part[1],".csv"), 
                row.names = F)
    }
  }; remove(sim)
  
  # add participant (parameters set) ID
  simPars$part <- paste0(simPars$mc,"_",simPars$theta,"_",simPars$eta)

  # write the data.frames in csv inside "figures_tables" folder
  write.csv(simPars,"figures_tables/simPars.csv", row.names = F)
  write.csv(randDist,"figures_tables/simRandDist.csv", row.names = F)
} else {
  warning("Simulations with good parameters are already done. Use parameters_recovery.R")
}
