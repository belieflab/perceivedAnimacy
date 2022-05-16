# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))
# add work directory
#setwd(file.path(dirname(rstudioapi::getActiveDocumentContext()$path)))



# # # # # # # # # # libraries # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2) # ggplot()
if (!require(ggpubr)) {install.packages("ggpubr")}; library(ggpubr) # ggarrange()
if (!require(reshape2)) {install.packages("reshape2")}; library(reshape2) # melt()
if (!require(viridis)) {install.packages("viridis")}; library(viridis) # viridis()
if (!require(plyr)) {install.packages("plyr")}; library(plyr) # revalue()
if (!require(dplyr)) {install.packages("dplyr")}; library(dplyr)
# if (!require(devtools)) {install.packages("devtools")}; library(devtools)
# if (!require(hmisc)) {install.packages("hmisc")}; library(hmisc)


# # # # # # # # # # functions # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
source("functions.R")



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# import stimuli .txt data (from Ben van Buren)
loc <- paste0(getwd(),"/van Buren stimuli/chasing_detection_stimuli")
db1 <- read.table(paste0(loc,"/chasing/chasing_frames.txt"))
db2 <- read.table(paste0(loc,"/mirror_chasing/mirror_chasing_frames.txt"))

# combine databases
db <- data.frame(trialType=c(rep("chase",nrow(db1)),
                             rep("mirror",nrow(db2))),
                 rbind(db1,db2))

# colnames titles
colnames(db)[-1] <- c("trial","frame","wX","wY","sX","sY",
                      "d1X","d1Y","d2X","d2Y",
                      "d3X","d3Y","d4X","d4Y",
                      "d5X","d5Y","d6X","d6Y")



# # # # # # # # # # calculate norm and angles # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# db$trial[db$trialType == "mirror"] <- db$trial[db$trialType == "mirror"] + 300
db$trialCond <- paste0(db$trial,"_",db$trialType)
# discs names
elem <- c("w","s","d1","d2","d3","d4","d5","d6")
# combinations of elemements
allRelations <- data.frame(t(combn(elem,2)))
allRelations$name <- paste0(allRelations[,1],"_",allRelations[,2])
# create dist and angl data frames
dist <- angl <- data.frame(trialType=db$trialType,trial=db$trial,
                           frame=db$frame,trialCond=db$trialCond)
# get distance and angle between all discs
for (i in 1:nrow(allRelations)) {
  from <- db[,grepl(allRelations[i,1],colnames(db))]
  to <- db[,grepl(allRelations[i,2],colnames(db))]
  colnames(from) <- colnames(to) <- c("x","y")
  temp <- f_normAngle(from,to)
  # dist and angl
  dist <- data.frame(dist,temp$norm)
  colnames(dist)[ncol(dist)] <- paste0("d_",allRelations$name[i])
  angl <- data.frame(angl,temp$angl)
  colnames(angl)[ncol(angl)] <- paste0("a_",allRelations$name[i])
}; remove(from,to,temp,i)


# # # # plot distances # # # #
dist_lf <- melt(dist, id.vars = c("trialType","trial","frame","trialCond"))
ggplot(dist_lf[,], aes(x=frame,y=value,col=variable)) + 
  stat_summary(geom = "line") + 
  facet_grid(. ~ trialType) +
  theme_classic()
ggplot(dist_lf[,], aes(x=value,y=variable,col=trialType)) + 
  stat_summary() + 
  theme_classic()

# # # # plot angles # # # #
# angl_lf <- melt(angl, id.vars = c("trialType","trial","frame","trialCond"))
# ggplot(angl_lf[,], aes(x=frame,y=value,col=variable)) + 
#   stat_summary(geom = "line") + 
#   facet_grid(. ~ trialType) +
#   theme_classic()
# ggplot(angl_lf[,], aes(x=value,y=variable,col=trialType)) + 
#   stat_summary() + 
#   theme_classic()



# # # # # # # # # # simulate with the distance/memory model # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# memory capacity
mc <- seq(6,120,by=6)
# distance threshold
theta <- seq(15,300,by=15)
# join parameters
params <- data.frame(mc=rep(mc,length(theta)),theta=rep(theta,each=length(mc)))

sdtPars <- f_SDTparamExplor(dist,params)
# write.csv(sdtPars,"sdtPars2.csv")
# sdtPars <- read.csv("sdtPars2.csv")

# marginals
mcMarg <- sdtPars %>% group_by(mc) %>% 
  summarize(mSensit=sum(sensit),mResCri=sum(resCri))
thetaMarg <- sdtPars %>% group_by(theta) %>% 
  summarize(mSensit=sum(sensit),mResCri=sum(resCri))
sdtPars[sdtPars$sensit==max(sdtPars$sensit),]
sdtPars[sdtPars$sensit>1.5,]

# figures
p_diff <- ggplot(sdtPars, aes(x=as.factor(mc),y=as.factor(theta),fill=sensit-abs(resCri))) +
  labs(x = expression(Memory~Capacity~(tau)), 
       y = expression(Proximity~Threshold~(theta)),fill="d'-|C|") +
  geom_raster(interpolate = T) +
  scale_y_discrete(breaks = seq(15,300,by=30)) +
  scale_x_discrete(breaks = seq(6,120,by=12)) +
  scale_fill_gradient2(low="#0000FFFF",mid="#FFFFFFFF",high="#FF0000FF") + 
  coord_fixed() + 
  theme_classic()
p_dPrime <- ggplot(sdtPars, aes(x=as.factor(mc),y=as.factor(theta),fill=sensit)) +
  labs(x = expression(Memory~Capacity~(tau)), 
       y = expression(Proximity~Threshold~(theta)),fill="d'") +
  geom_raster(interpolate = T) +
  scale_y_discrete(breaks = seq(15,300,by=30)) +
  scale_x_discrete(breaks = seq(6,120,by=12)) +
  scale_fill_gradient2(low="#0000FFFF",mid="#FFFFFFFF",high="#FF0000FF") + 
  coord_fixed() + 
  theme_classic()
p_rCrite <- ggplot(sdtPars, aes(x=as.factor(mc),y=as.factor(theta),fill=resCri)) +
  labs(x = expression(Memory~Capacity~(tau)), 
       y = expression(Proximity~Threshold~(theta)),fill="C") +
  geom_raster(interpolate = T) +
  scale_y_discrete(breaks = seq(15,300,by=30)) +
  scale_x_discrete(breaks = seq(6,120,by=12)) +
  scale_fill_gradient2(low="#0000FFFF",mid="#FFFFFFFF",high="#FF0000FF") + 
  coord_fixed() + 
  theme_classic()
sdtPars$goodPar <- ifelse(sdtPars$sensit > 1 & 
                            (sdtPars$resCri < 1 & sdtPars$resCri > -1), 
                          "good","bad")
p_corPar <- ggplot(sdtPars, aes(x=resCri,y=sensit,col=goodPar)) + 
  labs(x = "Response Criterion (C)", 
       y = "Sensibility (d')") +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  geom_point(size=1) +
  scale_y_continuous(breaks = seq(-5,5,by=0.5)) +
  scale_x_continuous(breaks = seq(-5,5,by=1)) +
  # coord_fixed() + 
  theme_classic()

print_fig <- 0
if (print_fig == 1) {
  ggsave("figures&tables/p_dPrime2.png",
         plot = p_dPrime, width = 12, height = 12, units = "cm", 
         dpi = 900, device='png', limitsize = T)
  ggsave("figures&tables/p_rCrite2.png",
         plot = p_rCrite, width = 12, height = 12, units = "cm", 
         dpi = 900, device='png', limitsize = T)
  ggsave("figures&tables/p_corPar.png",
         plot = p_corPar, width = 10, height = 8, units = "cm", 
         dpi = 900, device='png', limitsize = T)
}



# # # # # # # # # # parameters recovery # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
sdtPars <- read.csv("sdtPars2.csv")
# select the set of parameters that have a good SDT discrimination value (d')
sdtPars$goodPar <- ifelse(sdtPars$sensit > 1 & 
                            (sdtPars$resCri < 1 & sdtPars$resCri > -1), 
                          "good","bad")
bestSdtPars <- sdtPars[sdtPars$goodPar == "good",]

# create data frame with parameters that will be simulated
# params <- data.frame(mc=rep(bestSdtPars$mc,10),
#                      theta=rep(bestSdtPars$theta,each=10),
#                      eta=rep(seq(0.55,1,0.05),nrow(bestSdtPars)))
# if you don't want to simulate with multiple eta values
params <- data.frame(mc=bestSdtPars$mc,
                     theta=bestSdtPars$theta,
                     eta=0.75)
# only one set of parameters
# params <- data.frame(mc = 52, theta = 90, eta = 0.75)


# randomized 100 trials
randomTrials <- sample(1:300,80)
for (i in 1:length(randomTrials)) {
  if (i == 1) {
    randDist <- dist[dist$trial == randomTrials[i],]
  } else {
    randDist <- rbind(randDist,dist[dist$trial == randomTrials[i],])
  }
}

# # # # # # # # # # simulate with good parameters # # # # # # # # # # # # # ####
for (p in 1:nrow(params)) {
  message(paste("set of parameters:",p))
  if (p == 1) {
    sim <- f_detMod(randDist, params[p,])
    simPars <- sim$params
    simTrials <- sim$dbTrials
  } else {
    sim <- f_detMod(randDist, params[p,])
    simPars <- rbind(simPars,sim$params)
    simTrials <- rbind(simTrials,sim$dbTrials)
  }
}; remove(sim)

# add participant (parameters set) ID
simPars$part <- paste0(simPars$mc,"_",simPars$theta,"_",simPars$eta)
simTrials$part <- paste0(simTrials$mc,"_",simTrials$theta,"_",simTrials$eta)

write_csv <- 0
if (write_csv == 1) {
  write.csv(simPars,"simPars.csv")
  write.csv(simTrials,"simTrials.csv")
  write.csv(randDist,"randDist.csv")
}
simPars <- read.csv("simPars.csv")
simTrials <- read.csv("simTrials.csv")
randDist <- read.csv("randDist.csv")
plot(simPars$resCri,simPars$sensit)
plot(simPars$mc,simPars$theta)



# # # # # # # # # # fit simulated parameters # # # # # # # # # # # # # # # # ####
# get all participants vector (i.e., set of parameters)
simParticip <- unique(simPars$part)

range(params$mc)
range(params$theta)
range(params$eta)
fitPars <- list(mcRange = c(30,100),
                thetaRange = c(70,170),
                etaRange = c(0.55,0.95),
                binsSize = data.frame(mc=15,theta=15,eta=30))

simPars$negSumLog <- simPars$hitRate <- 
  simPars$eta_fit_var <- simPars$theta_fit_var <- simPars$mc_fit_var <- 
  simPars$eta_fit_wm <- simPars$theta_fit_wm <- simPars$mc_fit_wm <- NA
for (i in 1:length(simParticip)) {
  message(paste0("participant (",simParticip[i],"): ",i,"/",length(simParticip)))
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
}; remove(temp)
write.csv(simPars,"simParsWithParRecovery.csv")
