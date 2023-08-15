# script created by Santiago Castiello.
# 07/02/2023. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))

# read functions
source("functions.R")

# # # # optimal trials for SDT parameters # # # # 
beh <- read.csv("figures_tables/beh.csv")

# subjects
subjs <- unique(beh$workerId)

# number of subjects
nSubj <- length(subjs)

# cells
cells <- c("R1_TTchase","R1_TTmirror","R0_TTchase","R0_TTmirror")

# how many trials to explore?
window <- 200

# create output matrix 
sensit <- resCri <- hit <- far <- matrix(NA,nrow=nSubj,ncol=window)

# estimate parameters
for (i in 1:nSubj) {
  temp <- beh[beh$workerId == subjs[i],]
  # windowing
  for (j in 2:(window+1)) {
    if (nrow(temp) >= j) {
      sensit[i,j-1] <- f_SDTparam(temp[1:j,],cells)$sensit
      resCri[i,j-1] <- f_SDTparam(temp[1:j,],cells)$resCri
      hit[i,j-1] <- f_SDTparam(temp[1:j,],cells)$h
      far[i,j-1] <- f_SDTparam(temp[1:j,],cells)$f
    }
  }
}

# visualize
if (!require(reshape2)) {install.packages("reshape2")}; library(reshape2) # melt
sensit2 <- melt(sensit); colnames(sensit2) <- c("subj","trials","sensit")
resCri2 <- melt(resCri); colnames(resCri2) <- c("subj","trials","resCri")
hit2 <- melt(hit); colnames(hit2) <- c("subj","trials","hit")
far2 <- melt(far); colnames(far2) <- c("subj","trials","far")



if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2) # ggplot
figA <- ggplot(sensit2,aes(x=trials,y=sensit)) + 
  labs(x="Cummulative Trials",y="Sensitivity (d')") +
  geom_vline(xintercept = c(25,50,100,200), col="red",alpha=0.1) +
  geom_hline(yintercept = mean(sensit2$sensit,na.rm=T), col="blue",alpha=0.1) +
  stat_summary(fun.data="mean_cl_boot",geom = "errorbar",alpha=0.1) +
  stat_summary(geom = "line") +
  scale_x_continuous(breaks = c(0,25,50,100,200)) +
  theme_classic()
figB <- ggplot(resCri2,aes(x=trials,y=resCri)) +
  labs(x="Cummulative Trials",y="Response Criterion (C)") +
  geom_vline(xintercept = c(25,50,100,200), col="red",alpha=0.1) +
  geom_hline(yintercept = mean(resCri2$resCri,na.rm=T), col="blue",alpha=0.1) +
  stat_summary(fun.data="mean_cl_boot",geom = "errorbar",alpha=0.1) +
  stat_summary(geom = "line") +
  scale_x_continuous(breaks = c(0,25,50,100,200)) +
  theme_classic()
figC <- ggplot(hit2,aes(x=trials,y=hit)) + 
  labs(x="Cummulative Trials",y="Hit Rate") +
  geom_vline(xintercept = c(25,50,100,200), col="red",alpha=0.1) +
  geom_hline(yintercept = mean(hit2$hit,na.rm=T), col="blue",alpha=0.1) +
  stat_summary(fun.data="mean_cl_boot",geom = "errorbar",alpha=0.1) +
  stat_summary(geom = "line") +
  scale_x_continuous(breaks = c(0,25,50,100,200)) +
  theme_classic()
figD <- ggplot(far2,aes(x=trials,y=far)) + 
  labs(x="Cummulative Trials",y="False Alarm Rate") +
  geom_vline(xintercept = c(25,50,100,200), col="red",alpha=0.1) +
  geom_hline(yintercept = mean(far2$far,na.rm=T), col="blue",alpha=0.1) +
  stat_summary(fun.data="mean_cl_boot",geom = "errorbar",alpha=0.1) +
  stat_summary(geom = "line") +
  scale_x_continuous(breaks = c(0,25,50,100,200)) +
  theme_classic()



if (!require(ggpubr)) {install.packages("ggpubr")}; library(ggpubr) # ggarrange
fig <- annotate_figure(ggarrange(figA,figB,figC,figD,nrow=2,ncol=2,
                                 labels = LETTERS[1:4], align = "hv"),
                       top = text_grob("N = 120 (good participants)", color = "black", 
                                       face = "bold", size = 14))
fig

print_fig <- 1
if (print_fig == 1) {
  ggsave("figures_tables/figureTestSdtParam.png",
         plot = fig, width = 15, height = 15, units = "cm", 
         dpi = 1800, device = 'png', limitsize = T)
}
