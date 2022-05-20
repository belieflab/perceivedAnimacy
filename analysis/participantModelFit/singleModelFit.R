# # # # # call functions # # # # #
source("../modelParametersRecovery/functions.R")

# 
commandLineArg <- commandArgs(trailingOnly = T)

# extract command line arguments
fileBehav <- commandLineArg[1]
fileTrial <- commandLineArg[2]

workerIdBehaviour <- substr(basename(fileBehav),7,nchar(basename(fileBehav))-4)
workerIdTrialDistances <- substr(basename(fileTrial),11,nchar(basename(fileTrial))-4)

# both worker IDs must be the same, otherwise error
if (workerIdBehaviour != workerIdTrialDistances) {
  
  warning("WorkerIds are not the same!")
  
} else {
  
  # one participant behaviour trial
  onePartData <- read.csv(fileBehav)
  print(paste0(fileBehav, "participants responses"))
  
  # one participants trials displays (distances)
  onePartDists <- read.csv(fileTrial)
  print(paste0(fileTrial, "participants displays distances"))
  
  
  
  # # # # # fitting posterior density parameters # # # # #
  # parameters for fitting algorithm based on mc, theta, and eta ranges
  fit_posterior_space  <- list(mcRange = c(15,105),
                               thetaRange = c(40,210),
                               etaRange = c(0.52,0.98),
                               binsSize = data.frame(mc=60,theta=60,eta=60))
  
  # # # # # fitting one participant # # # # #
  output <- f_fit_one(onePartDists, chaseResp=onePartData$chaseR,
                      fit_posterior_space,fitParallel = F)
  
  #save to Rdata file
  save(output, file = paste0("outputs/",workerIdBehaviour,"_output.Rdata"))
}
