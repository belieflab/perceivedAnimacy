# script created by Santiago Castiello.
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))


# # # # # # download data from terminal with: # # # # # #

# # # Specific # # # 
# only if we are in "C:\xampp\htdocs\perceivedAnimacy\data\behaviour"
# then
# scp sc3228@10.5.121.48:/var/www/belieflab.yale.edu/perceivedAnimacy/data/* .

# # # General # # # 
# scp sc3228@10.5.121.48:/var/www/belieflab.yale.edu/perceivedAnimacy/data/* C:\xampp\htdocs\perceivedAnimacy\data\behaviour



# # # # # # # # # # libraries and functions # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(ggpubr)) {install.packages("ggpubr")}; library(ggpubr)
# if (!require(RCurl)) {install.packages("RCurl")}; library(RCurl)
# oneSubj <- "https://belieflab.yale.edu/perceivedAnimacy/data/animacy_A1DUPOUC9RNU4L.csv"
# oneSubj <- getURL(oneSubj)
source("functions.R")



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Chasing Detection Task - get data files names

# behaviour
behDataFilesNames <- list.files("../../data/behaviour")

# number of participants
nSubj <- length(behDataFilesNames)

# pool behavioural data
genChar <- data.frame(matrix(NA,nrow=nSubj,ncol=2))
colnames(genChar) <- c("workerId","taskDurationMin")
for (i in 1:nSubj) {
  temp <- read.csv(paste0("../../data/behaviour/",behDataFilesNames[i]))
  if (i == 1) {
    beh <- temp
  } else {
    beh <- rbind(beh,temp)
  }
  # read files
  genChar[i,1] <- unique(temp$workerId)[unique(temp$workerId) != ""]
  genChar[i,2] <- (sum(as.numeric(temp$rt[temp$rt != "null"]))/1000)/60
}; rm(temp)

# questionnaires
questDataFilesNames <- list.files("../../data/questionnaires")
# read files
quest <- read.csv(paste0("../../data/questionnaires/",questDataFilesNames[3]))
quest <- quest[-(1:2),]
# quest$EndDate - quest$StartDate


# workerId vector
workerId <- unique(beh$workerId)[unique(beh$workerId) != ""]

# workerId vector
# workerIdQuest <- unique(quest$workerId)[unique(quest$workerId) != ""]
# genChar[i,3] <- F
# for (i in 1:length(workerIdBeh)) {
#   if (sum(workerIdBeh[i] == workerIdQuest) > 0) {
#     genChar[i,3] <- workerIdBeh[workerIdBeh[i] == workerIdQuest]
#   }
# }

# # # # # # # # # # clean data# # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # Questionnaires # # # #
# remove questionnaires with no workerId
quest$keep <- F
for (i in 1:nrow(quest)) {
  # exist in workerId vector
  if (sum(quest$workerId[i] == workerId) > 0) {
    # responded correctly the attention question "rgpts_attn_1"
    # if (quest$rgpts_attn_1[i] == "Extremely") {
      quest$keep[quest$workerId == workerId[i]] <- T
      # genChar$qualtrics[genChar$workerId == workerId[i]] <- T
    # }
  } else {
    print(workerId[i])
  }
}
# quest <- quest[quest$keep == T,] 
# remove practice and tests
quest <- quest[16:nrow(quest),]


columnsToInteger <- colnames(quest)[grepl("rgpts",colnames(quest))][1:18]
for (i in 1:length(columnsToInteger)) {
  quest[,columnsToInteger[i]] <- as.integer(quest[,columnsToInteger[i]])
}

# sum paranoia scores
quest$rgpts_ref <- rowSums(quest[,grepl("rgpts_ref",colnames(quest))])
quest$rgpts_per <- rowSums(quest[,grepl("rgpts_per",colnames(quest))])
quest$paranoia <- quest$rgpts_ref + quest$rgpts_per
# quest$rgpts_attn_1

# # # # Behaviour # # # #
# remove irrelevant columns
beh <- beh[!is.na(beh$index),]
# code responses: 1 = chase, 0 = no chase (mirror)
beh$chaseR <- as.integer(ifelse(beh$key_press == "49",1,0))
# reaction time to numeric
beh$rt <- as.numeric(beh$rt)

# trialType instead of test_part
beh$test_part <- ifelse(beh$test_part == "chase","chase","mirror")
colnames(beh)[grepl("test_part",colnames(beh))] <- "trialType"
# identify which specific video was played at trial t

beh$trialCond <- paste0(substr(beh$stim,6,nchar(beh$stim)-7),"_",beh$trialType)
# get the cells for the SDT contingency table (pressed key and trial type)
beh$cells <- paste0("R",beh$chaseR,"_TT",beh$trialType)
# NOTE: events must be ordered as follows: hit, FA, Ms, CR
# name IN ORDER the cells
cells <- c("R1_TTchase","R1_TTmirror","R0_TTchase","R0_TTmirror")

# filter by relevant columns
relCols <- c("workerId","trialType","index","rt","chaseR","response","cells")
beh <- beh[,relCols]



# # # # # # # # # # pooled # # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# add SDT columns
genChar$f <- genChar$h <- genChar$resCri <- genChar$sensit <- NA
sdtFreq <- data.frame(R1_TTchase=NA, R1_TTmirror=NA, R0_TTchase=NA, R0_TTmirror=NA)
genChar <- cbind(genChar,sdtFreq)

# add questionnaires columns
genChar$paranoia <- genChar$rgpts_per <- genChar$rgpts_ref <- NA

for (i in 1:nSubj) {
  # calculate SDT
  temp <- f_SDTparam(beh[beh$workerId == workerId[i],],cells)
  genChar$sensit[i] <- temp$sensit
  genChar$resCri[i] <- temp$resCri
  genChar$h[i] <- temp$h
  genChar$f[i] <- temp$f
  genChar[i,grepl("TT",colnames(genChar))] <- temp$SDTtab
  
  # add questionnaire
  if (sum(genChar$workerId[i] == quest$workerId) > 0) {
    genChar$paranoia[i] <- quest$paranoia[genChar$workerId[i] == quest$workerId]
    genChar$rgpts_ref[i] <- quest$rgpts_ref[genChar$workerId[i] == quest$workerId]
    genChar$rgpts_per[i] <- quest$rgpts_per[genChar$workerId[i] == quest$workerId]
  }
}



# # # # # # # # # # visualization # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
cor.test(genChar$resCri,genChar$sensit, method = "spearman")
fig1A <- ggplot2::ggplot(genChar, aes(x=resCri,y=sensit)) + 
  labs(title = "Signal Detection Theory (SDT) Parameters",
       x = "Response Criterion (C)", y = "Sensibility (d')") +
  geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
  geom_vline(xintercept = 0, col = "grey", alpha = 0.2) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic()
cor.test(genChar$rgpts_ref,genChar$rgpts_per, method = "spearman")
fig1B <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=rgpts_per)) + 
  labs(title = "Paranoid Thoughts Scale",
       x = "Ideas of Reference", y = "Ideas of Persecution") +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic()

fig1 <- ggpubr::ggarrange(fig1A,fig1B,ncol=2,labels=c("A","B"))
fig1



cor.test(genChar$paranoia,genChar$sensit, method = "spearman")
fig2A <- ggplot2::ggplot(genChar, aes(x=paranoia,y=sensit)) + 
  labs(x = "Paranoid", y = "d'") +
  geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$paranoia,genChar$resCri, method = "spearman")
fig2B <- ggplot2::ggplot(genChar, aes(x=paranoia,y=resCri)) + 
  labs(x = "paranoia", y = "C") +
  geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$paranoia,genChar$h, method = "spearman")
fig2C <- ggplot2::ggplot(genChar, aes(x=paranoia,y=h)) + 
  labs(x = "paranoia", y = "Hit rate") +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$rgpts_ref,genChar$f, method = "spearman")
cor.test(rank(genChar$rgpts_ref),rank(genChar$f))
fig2D <- ggplot2::ggplot(genChar, aes(x=paranoia,y=f)) + 
  labs(x = "paranoia", y = "False Alarm rate") +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())

fig2 <- ggpubr::annotate_figure(
  ggpubr::ggarrange(fig2A,fig2B,fig2C,fig2D,nrow=2,ncol=2,
                    labels=c("A","B","C","D"),align = "hv"),
  bottom = text_grob("Paranoia",face="bold",size=12))
fig2  



cor.test(genChar$rgpts_ref,genChar$sensit, method = "spearman")
fig3A <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=sensit)) + 
  labs(x = "Ideas of Reference", y = "d'") +
  geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$rgpts_ref,genChar$resCri, method = "spearman")
fig3B <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=resCri)) + 
  labs(x = "Ideas of Reference", y = "C") +
  geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$rgpts_ref,genChar$h, method = "spearman")
fig3C <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=h)) + 
  labs(x = "Ideas of Reference", y = "Hit rate") +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$rgpts_ref,genChar$f, method = "spearman")
fig3D <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=f)) + 
  labs(x = "Ideas of Reference", y = "False Alarm rate") +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())

fig3 <- ggpubr::annotate_figure(
  ggpubr::ggarrange(fig3A,fig3B,fig3C,fig3D,nrow=2,ncol=2,
                    labels=c("A","B","C","D"),align = "hv"),
  bottom = text_grob("Ideas of Reference",face="bold",size=12))
fig3  



cor.test(genChar$rgpts_per,genChar$sensit, method = "spearman")
fig4A <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=sensit)) + 
  labs(x = "Ideas of Reference", y = "d'") +
  geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$rgpts_per,genChar$resCri, method = "spearman")
fig4B <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=resCri)) + 
  labs(x = "Ideas of Persecution", y = "C") +
  geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$rgpts_per,genChar$h, method = "spearman")
fig4C <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=h)) + 
  labs(x = "Ideas of Persecution", y = "Hit rate") +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) +  
  theme_classic() + theme(axis.title.x = element_blank())
cor.test(genChar$rgpts_per,genChar$f, method = "spearman")
fig4D <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=f)) + 
  labs(x = "Ideas of Persecution", y = "False Alarm rate") +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  theme_classic() + theme(axis.title.x = element_blank())

fig4 <- ggpubr::annotate_figure(
  ggpubr::ggarrange(fig4A,fig4B,fig4C,fig4D,nrow=2,ncol=2,
                    labels=c("A","B","C","D"),align = "hv"),
  bottom = text_grob("Ideas of Persecution",face="bold",size=12))
fig4



print_fig <- 0
if (print_fig == 1) {
  ggsave("figures_tables/fig1.png",
         plot = fig1, width = 14, height = 7, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
  ggsave("figures_tables/fig2.png",
         plot = fig2, width = 14, height = 14, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
  ggsave("figures_tables/fig3.png",
         plot = fig3, width = 14, height = 14, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
  ggsave("figures_tables/fig4.png",
         plot = fig4, width = 14, height = 14, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
}

# annotate_figure(figure,
#                 top = text_grob("Visualizing Tooth Growth", color = "red", face = "bold", size = 14),
#                 bottom = text_grob("Data source: \n ToothGrowth data set", color = "blue",
#                                    hjust = 1, x = 1, face = "italic", size = 10),
#                 left = text_grob("Figure arranged using ggpubr", color = "green", rot = 90),
#                 right = text_grob(bquote("Superscript: ("*kg~NH[3]~ha^-1~yr^-1*")"), rot = 90),
#                 fig.lab = "Figure 1", fig.lab.face = "bold"
# )