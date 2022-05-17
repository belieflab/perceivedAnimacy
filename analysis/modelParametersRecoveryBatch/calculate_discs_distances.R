# script created by Santiago Castiello. It is used to calculate distances
# and angles from the 600 stimulus (displays) created by Ben van Buren 
# for a perceived animacy task.
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))
# add work directory
setwd(file.path(dirname(rstudioapi::getActiveDocumentContext()$path)))



# # # # # # # # # # libraries # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2) # ggplot()
if (!require(reshape2)) {install.packages("reshape2")}; library(reshape2) # melt()



# # # # # # # # # # functions # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
source("functions.R")



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # import stimuli .txt data (from Ben van Buren) this are 600 8sec videos
db1 <- read.table("../../stim/van_Buren_stimuli/chasing_detection_stimuli/chasing/chasing_frames.txt")
db2 <- read.table("../../stim/van_Buren_stimuli/chasing_detection_stimuli/mirror_chasing/mirror_chasing_frames.txt")

# combine databases
db <- data.frame(trialType=c(rep("chase",nrow(db1)),
                             rep("mirror",nrow(db2))),
                 rbind(db1,db2))

# colomn names titles
colnames(db)[-1] <- c("trial","frame","wX","wY","sX","sY",
                      "d1X","d1Y","d2X","d2Y",
                      "d3X","d3Y","d4X","d4Y",
                      "d5X","d5Y","d6X","d6Y")



# # # # # # # # # # calculate norm and angles # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # in the next section we will get the distance from all the discs
# # in all the 600 videos

# create the trial condition variable
db$trialCond <- paste0(db$trial,"_",db$trialType)

# discs names (one wolf, one sheep, and 6 distractions)
elem <- c("w","s","d1","d2","d3","d4","d5","d6")

# create data.frame with the combinations of the 8 elements 
allRelations <- data.frame(t(combn(elem,2)))

# combine the name of each combination
allRelations$name <- paste0(allRelations[,1],"_",allRelations[,2])

# create distance (dist) and angle (angl) data frames
dist <- angl <- data.frame(trialType=db$trialType,trial=db$trial,
                           frame=db$frame,trialCond=db$trialCond)

# get distance and angle between all discs
for (i in 1:nrow(allRelations)) {
  from <- db[,grepl(allRelations[i,1],colnames(db))]
  to <- db[,grepl(allRelations[i,2],colnames(db))]
  colnames(from) <- colnames(to) <- c("x","y")
  ## ## f_normAngle is a function that is in "function.R"
  temp <- f_normAngle(from,to)
  
  # distances and angles
  dist <- data.frame(dist,temp$norm)
  colnames(dist)[ncol(dist)] <- paste0("d_",allRelations$name[i])
  angl <- data.frame(angl,temp$angl)
  colnames(angl)[ncol(angl)] <- paste0("a_",allRelations$name[i])
}; remove(from,to,temp,i)



# # # # # # # # plot distances # # # # # # # #
dist_lf <- reshape2::melt(dist, id.vars = c("trialType","trial","frame","trialCond"))
ggplot2::ggplot(dist_lf[,], aes(x=frame,y=value,col=variable)) +
  stat_summary(geom = "line") +
  facet_grid(. ~ trialType) +
  theme_classic()
ggplot2::ggplot(dist_lf[,], aes(x=value,y=variable,col=trialType)) +
  stat_summary() +
  theme_classic()

# # # # # # # # plot angles # # # #  # # # #
angl_lf <- reshape2::melt(angl, id.vars = c("trialType","trial","frame","trialCond"))
ggplot2::ggplot(angl_lf[,], aes(x=frame,y=value,col=variable)) +
  stat_summary(geom = "line") +
  facet_grid(. ~ trialType) +
  theme_classic()
ggplot2::ggplot(angl_lf[,], aes(x=value,y=variable,col=trialType)) +
  stat_summary() +
  theme_classic()


write_csv <- 0
if (write_csv == 1) {
  write.csv(dist, "figures_tables/discsDistances.csv", row.names = F)
  write.csv(angl, "figures_tables/discsAngles.csv", row.names = F)
  write.csv(db, "figures_tables/discsPositions.csv", row.names = F)
}
