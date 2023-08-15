# script created by Santiago Castiello.
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))



# # # # # # # # # # libraries and functions # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2) # ggplot
if (!require(ggpubr)) {install.packages("ggpubr")}; library(ggpubr) # ggarrange
if (!require(viridis)) {install.packages("viridis")}; library(viridis) # viridis
if (!require(lmerTest)) {install.packages("lmerTest")}; library(lmerTest) # lmer
source("functions.R")



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
beh <- read.csv("figures_tables/beh.csv")
genChar <- read.csv("figures_tables/genChar.csv")
discPos <- read.csv("../modelParametersRecovery/figures_tables/discsPositions.csv")



# # # # # # # # # # calculate features per trials # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
if (is.null(beh$Herror)) {
  # create entropy variables
  beh$HpathD1 <- beh$HpathD2 <- beh$HpathD3 <- beh$HpathD4 <- beh$HpathD5 <- 
    beh$HpathD6 <- beh$HpathS <- beh$HpathW <- beh$Herror <- NA
  for (i in 1:nrow(beh)) {
    # progress bar
    # Sys.sleep(0.01)
    setTxtProgressBar(txtProgressBar(min = 0, max = nrow(beh), style = 3, 
                                     width = 50, char = "="), i)
    # check one trial
    temp <- discPos[discPos$trialCond == beh$trialCond[i],]
    # trial stopped before the display ended?
    if (beh$rt[i] <= 4000) {
      # 4000 ms / 120 frames = ms per frame. Then RT/33.33 = last_seen_frame
      last_seen_frame <- floor(beh$rt[i]/(4000/120))
      temp <- temp[temp$frame < last_seen_frame,]
    }
    # calculate entropy
    beh$Herror[i] <- H_error(temp$wX,temp$wY,temp$sX,temp$sY)
    beh$HpathW[i] <- H_path(temp$wX,temp$wY)
    beh$HpathS[i] <- H_path(temp$sX,temp$sY)
    beh$HpathD1[i] <- H_path(temp$d1X,temp$d1Y)
    beh$HpathD2[i] <- H_path(temp$d2X,temp$d2Y)
    beh$HpathD3[i] <- H_path(temp$d3X,temp$d3Y)
    beh$HpathD4[i] <- H_path(temp$d4X,temp$d4Y)
    beh$HpathD5[i] <- H_path(temp$d5X,temp$d5Y)
    beh$HpathD6[i] <- H_path(temp$d6X,temp$d6Y)
  }
  # print data bases
  print_csv <- 1
  if (print_csv == 1) {
    write.csv(genChar,"figures_tables/genChar.csv",row.names = F)
    write.csv(beh, "figures_tables/beh.csv",row.names = F)
  }
} # end if we need to calculate entropies per trials  



# create variables with clear labeling 
beh$sdtTrials <- factor(beh$cells,levels=c("R1_TTchase","R1_TTmirror","R0_TTchase","R0_TTmirror"))
levels(beh$sdtTrials) <- c("hit","FA","miss","CR")
beh$respType <- factor(beh$chaseR,levels=c("1","0"))
levels(beh$respType) <- c("Chase","No Chase")
beh$scParanoia <- scale(beh$paranoia)[1:nrow(beh)]
# Dichotomous Paranoia
beh$rgpts_ref_high <- ifelse(beh$rgpts_ref <= 5, "average","elevated")
beh$rgpts_per_high <- ifelse(beh$rgpts_per <= 9, "average","elevated")
# at least one subscale elevated
beh$rgpts_high <- ifelse(beh$rgpts_ref_high == "elevated" |
                           beh$rgpts_per_high == "elevated", 1, 0)
# trial type order
beh$trialType <- factor(beh$trialType, levels = c("mirror","chase"))



# # # # # # # # # # Statistical Analysis# # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
mA0 <- lmer(Herror~chaseR*trialType+(1|workerId),data=beh, REML = FALSE)
mA <- lmer(Herror~rgpts_high*chaseR*trialType+(1|workerId),data=beh, REML = FALSE)
anova(mA0,mA)
mB0 <- lmer(HpathW~chaseR*trialType+(1|workerId),data=beh, REML = FALSE)
mB <- lmer(HpathW~rgpts_high*chaseR*trialType+(1|workerId),data=beh, REML = FALSE)
anova(mB0,mB)
mC0 <- lmer(HpathS~chaseR*trialType+(1|workerId),data=beh, REML = FALSE)
mC <- lmer(HpathS~rgpts_high*chaseR*trialType+(1|workerId),data=beh, REML = FALSE)
anova(mC0,mC)
mD0 <- lmer(rt~chaseR*trialType+(1|workerId),data=beh, REML = FALSE)
mD <- lmer(rt~rgpts_high*chaseR*trialType+(1|workerId),data=beh, REML = FALSE)
anova(mD0,mD)

sMA <- step(mA);sMA
summary(lmer(Herror ~ trialType + (1 | workerId), data=beh, REML = FALSE))
sMB <- step(mB);sMB
summary(lmer(HpathW ~ scParanoia * chaseR * trialType + (1 | workerId), 
             data=beh, REML = FALSE))
sMC <- step(mC);sMC
summary(lmer(HpathS ~ scParanoia + chaseR + trialType + (1 | workerId) + scParanoia:chaseR, 
             data=beh, REML = FALSE))
sMD <- step(mD);sMD
summary(lmer(rt ~ scParanoia * chaseR * trialType + (1 | workerId), 
             data=beh, REML = FALSE))

# summary(get_model(sMA))$call$formula
# summary(get_model(sMB))$call$formula
# summary(get_model(sMC))$call$formula
# summary(get_model(sMD))$call$formula




# # # # # # # # # # figures: visualization# # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
fig9 <- f_create_fig9(beh,sMA,sMB,sMC,sMD)
# fig9
fig9 <- f_create_fig9_v2(beh,sMA,sMB,sMC,sMD)
 

fig10 <- f_create_fig10(beh)
# fig10


print_png <- 0
if (print_png == 1) {
  ggsave("figures_tables/fig9_v2.png",
         plot = fig9, width = 14, height = 14, units = "cm", 
         dpi = 2400, device='png', limitsize = T)
  ggsave("figures_tables/fig10.png",
         plot = fig10, width = 14, height = 14, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
}


# detect trials with more false alarm rates
tab <- table(beh$trialCond,beh$cells)
# tab[max(tab[,4])==tab[,4],]
head(tab[tab[,4]==0,])
tab <- tab[order(-tab[,4]),]



y_x <- lmer(rt ~ HpathW + (1 | workerId), data = beh, REML = F); summary(y_x)
y_x <- lmer(rt ~ HpathS + (1 | workerId), data = beh, REML = F); summary(y_x)

y_x <- lmer(HpathW ~ scParanoia + (1 | workerId), data = beh, REML = F); summary(y_x)
y_xm <- lmer(HpathW ~ scParanoia + rt + (1 | workerId), data = beh, REML = F); summary(y_xm)
x_m <- lmer(rt ~ scParanoia + (1 | workerId), data = beh, REML = F); summary(x_m)

