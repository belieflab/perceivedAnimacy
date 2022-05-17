# script created by Santiago Castiello.
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
# Chasing Detection Task - get data files names
behDataFilesNames <- list.files("../../data/behaviour")

# read files
beh <- read.csv("../../data/behaviour/animacy_A2FGKKWP33DFWS.csv")

# workerId vector
workerId <- unique(beh$workerId)[unique(beh$workerId) != ""]

# Chasing Detection Task - get data files names
questDataFilesNames <- list.files("../../data/questionnaires")

# read files
quest <- read.csv("../../data/questionnaires/perceivedAnimacy_May 17, 2022_12.30.csv")



# # # # # # # # # # clean data# # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # Questionnaires # # # #
# remove questionnaires with no workerId
quest$keep <- F
for (i in 1:length(workerId)) {
  if (sum(quest$workerId == workerId[i]) > 0) {
    quest$keep[quest$workerId == workerId[i]] <- T
  }
}
quest <- quest[quest$keep == T,] 

columnsToInteger <- colnames(quest)[grepl("rgpts",colnames(quest))][1:18]
for (i in 1:length(columnsToInteger)) {
  quest[,columnsToInteger[i]] <- as.integer(quest[,columnsToInteger[i]])
}

quest$rgpts_ref <- rowSums(quest[,grepl("rgpts_ref",colnames(quest))])
quest$rgpts_per <- rowSums(quest[,grepl("rgpts_per",colnames(quest))])



# # # # Behaviour # # # #
# remove irrelevant columns
beh <- beh[!is.na(beh$index),]
# code responses: 1 = chase, 0 = no chase (mirror)
beh$chaseR <- ifelse(beh$key_press == "49",1,0)
beh$test_part <- ifelse(beh$test_part == "chase","chase","mirror")
colnames(beh)[grepl("test_part",colnames(beh))] <- "trialType"
# identify which specific video was played at trial t

beh$trialCond <- paste0(substr(beh$stim,6,nchar(beh$stim)-7),"_",beh$trialType)
# get the cells for the SDT contingency table (pressed key and trial type)
beh$cells <- paste0("R",beh$chaseR,"_TT",beh$trialType)
# NOTE: events must be ordered as follows: hit, FA, Ms, CR
# name IN ORDER the cells
cells <- c("R1_TTchase","R1_TTmirror","R0_TTchase","R0_TTmirror")



# # # # # # # # # # analysis# # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

f_SDTparam(beh,cells)


# fit my model
# fitPars <- list(mcRange = c(20,100),
#                 thetaRange = c(50,200),
#                 etaRange = c(0.55,0.95),
#                 binsSize = data.frame(mc=10,theta=10,eta=30))
# temp <- f_fitDetMod(randDist, onePartDat, fitPars, plotFigure = F, progress_bar = T)
