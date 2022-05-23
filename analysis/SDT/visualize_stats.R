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
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2) # ggplot
if (!require(ggpubr)) {install.packages("ggpubr")}; library(ggpubr) # ggarrange
if (!require(report)) {install.packages("report")}; library(report) # report_table
if (!require(dplyr)) {install.packages("dplyr")}; library(dplyr) # revalue
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
workerIdBeh <- substr(behDataFilesNames,9,nchar(behDataFilesNames)-4)

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
genChar <- genChar[order(genChar$workerId),]

# questionnaires
questDataFilesNames <- list.files("../../data/questionnaires")
# read files
quest <- read.csv(paste0("../../data/questionnaires/",questDataFilesNames[4]))
quest <- quest[-(1:2),]
quest <- quest[16:nrow(quest),]
quest <- quest[order(quest$workerId),]
quest$questDurationMin <- as.numeric(as.POSIXlt(quest$EndDate) - as.POSIXlt(quest$StartDate))


# workerId vector the intersect between quest and bheaviour
workerId <- intersect(quest$workerId,workerIdBeh)

if (sum(genChar$workerId == quest$workerId)==length(workerId)) {
  genChar$questDurationMin <- quest$questDurationMin
  genChar$expDurationMin <- genChar$taskDurationMin + genChar$questDurationMin
}
# mean(genChar$expDurationMin)
# median(genChar$expDurationMin)
# range(genChar$expDurationMin)



# # # # # # # # # # clean data# # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

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
relCols <- c("workerId","trialType","stim","trialCond","index","rt","chaseR",
             "response","cells")
beh <- beh[,relCols]



# # # # # # # # # # pooled # # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# add behavioural columns
genChar$rt <- NA 

# add SDT columns
genChar$f <- genChar$h <- genChar$resCri <- genChar$sensit <- NA
sdtFreq <- data.frame(R1_TTchase=NA, R1_TTmirror=NA, R0_TTchase=NA, R0_TTmirror=NA)
genChar <- cbind(genChar,sdtFreq)

# add questionnaires columns
genChar$paranoia <- genChar$rgpts_per <- genChar$rgpts_ref <- NA

for (i in 1:nSubj) {
  genChar$rt[i] <- mean(beh$rt[beh$workerId == workerId[i]])
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
genChar$rgpts_ref_high <- ifelse(genChar$rgpts_ref <= 5, "average","elevated")
genChar$rgpts_per_high <- ifelse(genChar$rgpts_per <= 9, "average","elevated")
# at least one subscale elevated
genChar$rgpts_high <- ifelse(genChar$rgpts_ref_high == "elevated" | 
                               genChar$rgpts_per_high == "elevated",1, 0)

print_csv <- 0
if (print_csv == 1) {
  write.csv(genChar,"figures_tables/genChar.csv")
}



# # # # # # # # # # remove bad participants # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# plot(genChar$rt,genChar$sensit)
# plot(genChar$taskDurationMin,genChar$sensit)
# plot(genChar$taskDurationMin,genChar$rt)
# genChar <- genChar[genChar$taskDurationMin >= 4,]



# # # # # # # # # # visualization # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
fig1 <- f_create_fig1(genChar) 
# fig1

fig2 <- f_create_fig2(genChar)
# fig2

fig3 <- f_create_fig3(genChar) 
# fig3

fig4 <- f_create_fig4(genChar) 
# fig4

fig5 <- f_create_fig5(beh,genChar)
# fig5



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
  ggsave("figures_tables/fig5.png",
         plot = fig5, width = 14, height = 7, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
}



# # # # # # # # # # model fit # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# model fit
modFitFilesNames <- paste0("../participantModelFit/outputs/",
                           list.files("../participantModelFit/outputs"))
# model fit worker ID
modFitWorkerId <- substr(modFitFilesNames,32,nchar(modFitFilesNames)-13)

for (i in 1:length(modFitFilesNames)) {
  if (sum(modFitWorkerId[i] == genChar$workerId) > 0) {
    load(modFitFilesNames[i])
    temp <- data.frame(modFitWorkerId[i],t(output$params$wMean),output$modPerformance)
    colnames(temp)[1:4] <- c("workerId", rownames(output$params))
    if (i == 1) {
      modelFit <- temp
    } else {
      modelFit <- rbind(modelFit,temp)
    }
  } # only if is included in genChar
}



# add fitted parameters from the Distance Windows Integration model
if (sum(genChar$workerId == modelFit$workerId) == nrow(genChar)) {
  genChar <- cbind(genChar,modelFit[!grepl("workerId",colnames(modelFit))])
}



fig6 <- f_create_fig6(genChar)
# fig6

fig7 <- f_create_fig7(genChar)
# fig7



print_fig <- 0
if (print_fig == 1) {
  ggsave("figures_tables/fig6.png",
         plot = fig6, width = 16, height = 16, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
  ggsave("figures_tables/fig7.png",
         plot = fig7, width = 12, height = 16, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
}



# univariate analysis
summary(glm(rgpts_high~sensit, data = genChar, family = "binomial"))
summary(glm(rgpts_high~resCri, data = genChar, family = "binomial"))
summary(glm(rgpts_high~h, data = genChar, family = "binomial"))
summary(glm(rgpts_high~f, data = genChar, family = "binomial"))
summary(glm(rgpts_high~mc, data = genChar, family = "binomial"))
summary(glm(rgpts_high~theta, data = genChar, family = "binomial"))
summary(glm(rgpts_high~eta, data = genChar, family = "binomial"))


# create vector with all combination of possible regressors
covars <- c("sensit","resCri","f","mc")
for (i in 1:length(covars)) {
  temp <- t(combn(covars,i))
  if (ncol(temp) == 1) {
    allModels <- temp
  } else if (ncol(temp) == 2) {
    allModels <- c(allModels,paste(temp[,1],"+",temp[,2]),paste(temp[,1],"*",temp[,2]))
  } else if (ncol(temp) == 3) {
    allModels <- c(allModels,paste(temp[,1],"+",temp[,2],"+",temp[,3]),
                   paste(temp[,1],"*",temp[,2],"*",temp[,3]))
  } else if (ncol(temp) == 4) {
    allModels <- c(allModels,paste(temp[,1],"+",temp[,2],"+",temp[,3],"+",temp[,4]),
                   paste(temp[,1],"*",temp[,2],"*",temp[,3],"*",temp[,4]))
  }
  # } else if (ncol(temp) == 5) {
  #   allModels <- c(allModels,paste(temp[,1],"+",temp[,2],"+",temp[,3],"+",temp[,4],"+",temp[,5]),
  #                  paste(temp[,1],"*",temp[,2],"*",temp[,3],"*",temp[,4],"*",temp[,5]))
  # }
}; remove(temp)



m <- list()
for (i in 1:length(allModels)) {
  m[[i]] <- glm(as.formula(paste0("rgpts_high ~ ",allModels[i])), 
                data=genChar, family="binomial")
  if (i <= 16) {
    temp <- report::report_table(glm(as.formula(paste0("rgpts_high ~ ",
                                                       allModels[i])), 
                             data=genChar, family="binomial"))
    temp <- temp[!is.na(temp$Coefficient),]
    if (i == 1) {
      estimates <- data.frame(model=allModels[i],
                              temp[,c("Parameter","Std_Coefficient","p")])
    } else {
      estimates <- rbind(estimates,data.frame(model=allModels[i],
                                              temp[,c("Parameter","Std_Coefficient","p")]))
    }
  }
}
# remove intercept
estimates <- estimates[estimates$Parameter != "(Intercept)",]



# create model comparison table
modComp <- data.frame(allModels,matrix(NA,ncol=4,nrow=length(m)))
colnames(modComp) <- c("model","BIC","AIC","logLik","hitRate")
for (i in 1:length(m)) {
  modComp$BIC[i] <- BIC(m[[i]])
  modComp$AIC[i] <- AIC(m[[i]])
  modComp$logLik[i] <- sum(log((genChar$rgpts_high*sigmoid(predict(m[[i]])))+
                               ((1-genChar$rgpts_high)*(1-sigmoid(predict(m[[i]]))))))
  modComp$hitRate[i] <- sum(genChar$rgpts_high==
                              ifelse(sigmoid(predict(m[[i]]))>0.5,1,0))/nrow(genChar)
}
modComp
write.csv(modComp,"figures_tables/modelComparisons.csv",row.names=F)



# change regressors parameters labels
factorLabels <- t(matrix(c("sensit","d'", "resCri","C", "f","far", "mc","tau"),nrow=2))
for (i in 1:nrow(factorLabels)) {
  estimates$Parameter <- gsub(factorLabels[i,1],factorLabels[i,2],estimates$Parameter)
  estimates$model <- gsub(factorLabels[i,1],factorLabels[i,2],estimates$model)
  modComp$model <- gsub(factorLabels[i,1],factorLabels[i,2],modComp$model) 
}
estimates$Parameter <- factor(estimates$Parameter, levels = unique(estimates$Parameter))
estimates$model <- factor(estimates$model, levels = rev(unique(estimates$model)))


estimates$sig <- ifelse(estimates$p < 0.05, "*", "")
ggplot2::ggplot(estimates, aes(x=Parameter,y=model,size=abs(Std_Coefficient),
                      fill=Std_Coefficient,label=sig)) +
  labs(x="Covariates coefficients",y="Logistic Model (1 = elevated paranoia)",
       fill="Logit \nEffect \nSize") +
  # geom_hline(yintercept = 10.5) +
  geom_point(shape=c(21)) + 
  geom_text(col="red", size=10) +
  scale_size(range = c(2,15), breaks=seq(-1,1,by=0.5)) +
  scale_fill_gradient2(mid = "white", low = viridis::cividis(7)[2], 
                       high = viridis::cividis(7)[6],
                       limits=range(estimates$Std_Coefficient), 
                       breaks=seq(-10,10,by=0.5)) +
  guides(fill = guide_colourbar(barwidth = 1.2, barheight = 10, ticks = T),
         size = "none") + 
  annotate("text", x=7.5,y=7, label="p < 0.05", col="red", size=4) +
  annotate("text", x=7.5,y=16, label="d' = sensitivity (SDT)", col="black", size=2.5) +
  annotate("text", x=7.5,y=15, label="C = response bias (SDT)", col="black", size=2.5) +
  annotate("text", x=7.5,y=14, label="far = false alarm rate (SDT)", col="black", size=2.5) +
  annotate("text", x=7.5,y=13, label="tau = windows integration (DWIM)", col="black", size=2.5) +
  theme_classic() + theme(axis.text.x = element_text(angle = 30, hjust = 1))



# mediation analysis
# https://data.library.virginia.edu/introduction-to-mediation-analysis/
y_x <- glm(rgpts_high~mc, data = genChar, family = "binomial"); summary(y_x)
y_xm <- glm(rgpts_high~mc+f, data = genChar, family = "binomial"); summary(y_xm)
x_m <- glm(f~mc, data = genChar, family = "gaussian"); summary(x_m)

# # # # # Mediation analysis with Lavaan # # # # #
# categorical (binary) variables
# https://lavaan.ugent.be/tutorial/cat.html
# mediation
# https://lavaan.ugent.be/tutorial/mediation.html # example here
if (!require(lavaan)) {install.packages("lavaan")}; library(lavaan)
model <- ' # direct effect
             rgpts_high ~ c*mc
           # mediator
             f ~ a*mc
             rgpts_high ~ b*f
           # indirect effect (a*b)
             ab := a*b
           # total effect
             total := c + (a*b)'
# mod1 <- "# a path
#            f ~ a * mc
#          # b path
#            rgpts_high ~ b * f
#          # c prime path 
#            rgpts_high ~ cp * mc
# 
#          # indirect and total effects
#          ab := a * b
#          total := cp + ab"
# estimator = "WLSMV" from https://www.researchgate.net/post/How-to-deal-with-dichotomous-endogenous-variables-in-Lavaan-R-package
fit <- lavaan::sem(model, data = genChar, ordered = c("rgpts_high"), 
                   estimator = "WLSMV")
summary(fit, standardized = TRUE)

if (!require(tidySEM)) {install.packages("tidySEM")}; library(tidySEM)
graph_sem(model = fit)





