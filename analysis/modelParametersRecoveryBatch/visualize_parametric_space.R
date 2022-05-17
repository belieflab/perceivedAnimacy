# script created by Santiago Castiello. It is used to visualize and simulate
# the parametric space from the Perceived Animacy model that I created. The
# simulations are based on the 600 displays created by Ben van Buren 
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))
# add work directory
setwd(file.path(dirname(rstudioapi::getActiveDocumentContext()$path)))



# # # # # # # # # # libraries # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
if (!require(dplyr)) {install.packages("dplyr")}; library(dplyr)



# # # # # # # # # # functions # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
source("functions.R")



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
discsDistances <- read.csv("figures_tables/discsDistances.csv")
discsAngles <- read.csv("figures_tables/discsAngles.csv")
discsPositions <- read.csv("figures_tables/discsPositions.csv")



# # # # # # # # # # simulate with the distance/memory model # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# vector with multiple memory capacities
mc <- seq(6,120,by=6)
# vector with multiple distance threshold
theta <- seq(15,300,by=15)
# create combinations of all previous parameters (mc and theta)
params <- data.frame(mc=rep(mc,length(theta)),theta=rep(theta,each=length(mc)))

# simulate with all the parametric space all the 600 videos. In order to explore
# which parameters combinations have a good classification of the videos

## ## f_SDTparamExplor is a function that is in "function.R" (NOTE: is slow)
# if there is already sdtParameters, then don't run
if (sum(list.files("figures_tables")=="sdtParameters.csv")==0) { 
  sdtParameters <- f_SDTparamExplor(discsDistances,params)
  # write the results in a csv
  write.csv(sdtParameters,"figures_tables/sdtParameters.csv",row.names = F)
} else {
  # if you have already saved the results, read the csv
  sdtParameters <- read.csv("figures_tables/sdtParameters.csv")
}



# obtain the marginals of the parametric space
# marginal for memory capacity (mc)
mcMarg <- sdtParameters %>% group_by(mc) %>% 
  summarize(mSensit=sum(sensit),mResCri=sum(resCri))
# marginal for distance threshold (theta)
thetaMarg <- sdtParameters %>% group_by(theta) %>% 
  summarize(mSensit=sum(sensit),mResCri=sum(resCri))

# get the set of parameters that have a larger SDT d' (sensitivity)
sdtParameters[sdtParameters$sensit==max(sdtParameters$sensit),]

# get the set of parameters that have a 'reasonable' (arbitrary 1.5 of d')
sdtParameters[sdtParameters$sensit>1.5,]


# # # # # # # # # # plot the parametric space # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# difference between d' (discrimination) and C (response criterion)
p_diff <- ggplot(sdtParameters, 
                 aes(x=as.factor(mc),y=as.factor(theta),fill=sensit-abs(resCri))) +
  labs(x = expression(Memory~Capacity~(tau)), 
       y = expression(Proximity~Threshold~(theta)),fill="d'-|C|") +
  geom_raster(interpolate = T) +
  scale_y_discrete(breaks = seq(15,300,by=30)) +
  scale_x_discrete(breaks = seq(6,120,by=12)) +
  scale_fill_gradient2(low="#0000FFFF",mid="#FFFFFFFF",high="#FF0000FF") + 
  coord_fixed() + 
  theme_classic()

# d' plot
p_dPrime <- ggplot(sdtParameters, 
                   aes(x=as.factor(mc),y=as.factor(theta),fill=sensit)) +
  labs(x = expression(Memory~Capacity~(tau)), 
       y = expression(Proximity~Threshold~(theta)),fill="d'") +
  geom_raster(interpolate = T) +
  scale_y_discrete(breaks = seq(15,300,by=30)) +
  scale_x_discrete(breaks = seq(6,120,by=12)) +
  scale_fill_gradient2(low="#0000FFFF",mid="#FFFFFFFF",high="#FF0000FF") + 
  coord_fixed() + 
  theme_classic()

# C plot
p_rCrite <- ggplot(sdtParameters, 
                   aes(x=as.factor(mc),y=as.factor(theta),fill=resCri)) +
  labs(x = expression(Memory~Capacity~(tau)), 
       y = expression(Proximity~Threshold~(theta)),fill="C") +
  geom_raster(interpolate = T) +
  scale_y_discrete(breaks = seq(15,300,by=30)) +
  scale_x_discrete(breaks = seq(6,120,by=12)) +
  scale_fill_gradient2(low="#0000FFFF",mid="#FFFFFFFF",high="#FF0000FF") + 
  coord_fixed() + 
  theme_classic()

# select the "good" parameters (i.e., not extreme C and high d')
sdtParameters$goodPar <- ifelse(sdtParameters$sensit > 1 &
                                  (sdtParameters$resCri < 1 & 
                                     sdtParameters$resCri > -1),
                                "good","bad")

# plot d' against C and visualize the "good" parameters
p_corPar <- ggplot(sdtParameters, aes(x=resCri,y=sensit,col=goodPar)) + 
  labs(x = "Response Criterion (C)", 
       y = "Sensibility (d')") +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  geom_point(size=1) +
  scale_y_continuous(breaks = seq(-5,5,by=0.5)) +
  scale_x_continuous(breaks = seq(-5,5,by=1)) +
  theme_classic()

# print the previous figures if print_fig <- 1 
print_fig <- 0
if (print_fig == 1) {
  ggsave("figures_tables/p_dPrime.jpg",
         plot = p_dPrime, width = 12, height = 12, units = "cm", 
         dpi = 900, device='png', limitsize = T)
  ggsave("figures_tables/p_rCrite.png",
         plot = p_rCrite, width = 12, height = 12, units = "cm", 
         dpi = 900, device='png', limitsize = T)
  ggsave("figures_tables/p_corPar.png",
         plot = p_corPar, width = 10, height = 8, units = "cm", 
         dpi = 900, device='png', limitsize = T)
}
