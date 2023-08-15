# script created by Santiago Castiello.
# 17/05/2022. Special thanks to Josh Kenney.

# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))



# # # # # # # # # # libraries and functions # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2) # ggplot
if (!require(ggpubr)) {install.packages("ggpubr")}; library(ggpubr) # ggarrange
if (!require(report)) {install.packages("report")}; library(report) # report_table
if (!require(dplyr)) {install.packages("dplyr")}; library(dplyr) # revalue
if (!require(reshape2)) {install.packages("reshape2")}; library(reshape2) # melt
# if (!require(RCurl)) {install.packages("RCurl")}; library(RCurl)
# oneSubj <- "https://belieflab.yale.edu/perceivedAnimacy/data/animacy_A1DUPOUC9RNU4L.csv"
# oneSubj <- getURL(oneSubj)
source("functions.R")



# # # # # # download data from terminal with: # # # # # #

# # # Specific # # # 
# only if we are in "C:\xampp\htdocs\perceivedAnimacy\data\behaviour"
# then
# scp sc3228@10.5.121.48:/var/www/belieflab.yale.edu/perceivedAnimacy/data/* .

# # # General # # # 
# scp sc3228@10.5.121.48:/var/www/belieflab.yale.edu/perceivedAnimacy/data/* C:\xampp\htdocs\perceivedAnimacy\data\behaviour


# test ID:
# A2FGKKWP33DFWS
# missing ID:
cloRes <- list.files("../../data/questionnaires/cloudResearch_details")
cloRes1 <- read.csv("../../data/questionnaires/cloudResearch_details/perceivedAnimacy_SC [Psychology Detection Game(_ 30 minutes)] (364564).csv")
cloRes1$sample <- "pilot"
cloRes2 <- read.csv("../../data/questionnaires/cloudResearch_details/perceivedAnimacy_SC100 [Psychology Detection Game(_ 30 minutes)] (364802).csv")
cloRes2$sample <- "experiment100"
cloRes3 <- read.csv("../../data/questionnaires/cloudResearch_details/perceivedAnimacy_SC50 [Psychology Detection Game(_ 30 minutes)] (366947).csv")
cloRes3$sample <- "experiment50"
cloRes <- rbind(cloRes1,cloRes2,cloRes3)
cloRes <- cloRes[cloRes$ApprovalStatus != "Not Submitted",]
cloRes <- cloRes[order(cloRes$AmazonIdentifier),]
javScr <- substr(list.files("../../data/behaviour"),9,nchar(list.files("../../data/behaviour"))-4)
workerIdCloudRes <- intersect(cloRes$AmazonIdentifier,javScr)
outersect(cloRes$AmazonIdentifier,javScr)
remove(javScr,cloRes3,cloRes2,cloRes1)



# # # # # # # # # # import data # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Chasing Detection Task - get data files names

# behaviour
behDataFilesNames <- list.files("../../data/behaviour")
behDataFilesNames <- behDataFilesNames[order(behDataFilesNames)]
workerIdBeh <- substr(behDataFilesNames,9,nchar(behDataFilesNames)-4)
sum(workerIdCloudRes[order(workerIdCloudRes)] == workerIdBeh[order(workerIdBeh)])

# number of participants
nSubj <- length(workerIdBeh)

# pool behavioural data
genChar <- data.frame(matrix(NA,nrow=nSubj,ncol=4))
colnames(genChar) <- c("workerId","sample","taskDurationMin","expDurMinCloudRes")
for (i in 1:nSubj) {
  temp <- read.csv(paste0("../../data/behaviour/",behDataFilesNames[i]))
  if (i == 1) {
    beh <- temp
  } else {
    beh <- rbind(beh,temp)
  }
  # read files
  genChar[i,1] <- unique(temp$workerId)[unique(temp$workerId) != ""]
  boolFilter <- cloRes$AmazonIdentifier == genChar[i,1]
  genChar[i,2] <- cloRes$sample[boolFilter]
  genChar[i,3] <- (sum(as.numeric(temp$rt[temp$rt != "null"]))/1000)/60
  genChar[i,4] <- strptime(substr(cloRes$CompletionTime[boolFilter],
                                  unlist(gregexpr("2022 ", cloRes$CompletionTime[boolFilter]))+5,
                                  nchar(cloRes$CompletionTime[boolFilter])),"%I:%M:%S %p") - 
    strptime(substr(cloRes$StartTime[boolFilter],
                    unlist(gregexpr("2022 ", cloRes$StartTime[boolFilter]))+5,
                    nchar(cloRes$StartTime[boolFilter])),"%I:%M:%S %p")
  
}; rm(temp,boolFilter)
genChar <- genChar[order(genChar$workerId),]

# questionnaires
questDataFilesNames <- list.files("../../data/questionnaires")
# read files
quest <- read.csv(paste0("../../data/questionnaires/",questDataFilesNames[3]))
quest <- quest[-(1:2),]
quest <- quest[16:nrow(quest),]
quest <- quest[order(quest$workerId),]
quest$questDurationMin <- as.numeric(as.POSIXlt(quest$EndDate) - as.POSIXlt(quest$StartDate))

# workerId vector the intersect between quest and bheaviour
workerId <- intersect(quest$workerId,workerIdBeh)
nSubj <- length(workerId)

if (sum(genChar$workerId == quest$workerId)==nSubj) {
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
columnsToInteger <- c(columnsToInteger,"demo_age")
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
# remove bad trials
beh <- beh[beh$rt > 500 & beh$rt < 8000,]

# trialType instead of test_part
beh$test_part <- ifelse(beh$test_part == "chase","chase","mirror")
colnames(beh)[grepl("test_part",colnames(beh))] <- "trialType"
# correct or incorrect
beh$response <- ifelse(beh$response == "correct",1,0)
colnames(beh)[grepl("response",colnames(beh))] <- "corr"

# trial conditions (i.e., which displays)
beh$trialCond <- paste0(substr(beh$stim,6,nchar(beh$stim)-7),"_",beh$trialType)
# get the cells for the SDT contingency table (pressed key and trial type)
beh$cells <- paste0("R",beh$chaseR,"_TT",beh$trialType)
# NOTE: events must be ordered as follows: hit, FA, Ms, CR
# name IN ORDER the cells
cells <- c("R1_TTchase","R1_TTmirror","R0_TTchase","R0_TTmirror")

# filter by relevant columns
relCols <- c("workerId","trialType","stim","trialCond","index","rt","chaseR",
             "corr","cells")
beh <- beh[,relCols]
# add questionnaires columns
beh$paranoia <- beh$rgpts_per <- beh$rgpts_ref <- NA



# # # # # # # # # # pooled # # # # # # # # # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# add behavioural columns
genChar$rt <- genChar$corr <- genChar$age <- genChar$sex <- NA 
genChar$corr1 <- genChar$corr2 <- NA
genChar$resCri1 <- genChar$resCri2 <- NA
genChar$sensit1 <- genChar$sensit2 <- NA

# add SDT columns
genChar$f <- genChar$h <- genChar$resCri <- genChar$sensit <- NA
genChar <- cbind(genChar,data.frame(R1_TTchase=NA, R1_TTmirror=NA, 
                                    R0_TTchase=NA, R0_TTmirror=NA))

# add questionnaires columns
genChar$paranoia <- genChar$rgpts_per <- genChar$rgpts_ref <- NA

for (i in 1:nSubj) {
  temp0 <- beh[beh$workerId == workerId[i],]
  # temp0 <- temp0[temp0$index <= 100,]
  genChar$rt[i] <- mean(temp0$rt)
  genChar$corr[i] <- mean(temp0$corr)
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  if (nrow(temp0[temp0$index<=50,]) > 1) {
    genChar$corr1[i] <- mean(temp0$corr[temp0$index<=100])
    temp1 <- f_SDTparam(temp0[temp0$index<=100,],cells)
    genChar$sensit1[i] <- temp1$sensit
    genChar$resCri1[i] <- temp1$resCri
  }
  if (nrow(temp0[temp0$index>150,]) > 1) {
    genChar$corr2[i] <- mean(temp0$corr[temp0$index>100])
    temp2 <- f_SDTparam(temp0[temp0$index>100,],cells)
    genChar$sensit2[i] <- temp2$sensit
    genChar$resCri2[i] <- temp2$resCri
  }
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # calculate SDT
  temp <- f_SDTparam(temp0,cells)
  genChar$sensit[i] <- temp$sensit
  genChar$resCri[i] <- temp$resCri
  genChar$h[i] <- temp$h
  genChar$f[i] <- temp$f
  genChar[i,grepl("TT",colnames(genChar))] <- temp$SDTtab
  
  # add questionnaire
  if (sum(genChar$workerId[i] == quest$workerId) > 0) {
    genChar$age[i] <- quest$demo_age[genChar$workerId[i] == quest$workerId]
    genChar$sex[i] <- quest$demo_sex[genChar$workerId[i] == quest$workerId]
    genChar$paranoia[i] <- quest$paranoia[genChar$workerId[i] == quest$workerId]
    genChar$rgpts_ref[i] <- quest$rgpts_ref[genChar$workerId[i] == quest$workerId]
    genChar$rgpts_per[i] <- quest$rgpts_per[genChar$workerId[i] == quest$workerId]
    beh$paranoia[beh$workerId == genChar$workerId[i]] <- genChar$paranoia[i] 
    beh$rgpts_ref[beh$workerId == genChar$workerId[i]] <- genChar$rgpts_ref[i]
    beh$rgpts_per[beh$workerId == genChar$workerId[i]] <- genChar$rgpts_per[i] 
  } else {warning(genChar$workerId[i])}
}; remove(temp0,temp)
genChar$rgpts_ref_high <- ifelse(genChar$rgpts_ref <= 5, "average","elevated")
genChar$rgpts_per_high <- ifelse(genChar$rgpts_per <= 9, "average","elevated")
# at least one subscale elevated
genChar$rgpts_high <- ifelse(genChar$rgpts_ref_high == "elevated" | 
                               genChar$rgpts_per_high == "elevated",1, 0)
# general characteristics
table(genChar$sex); (table(genChar$sex)/nrow(genChar)*100)
mean(genChar$age); sd(genChar$age); range(genChar$age)


# # # # # # # # # # remove bad participants # # # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
mean(genChar$corr,na.rm=T)
mean(genChar$corr1,na.rm=T)
mean(genChar$corr2,na.rm=T)
mean(genChar$sensit,na.rm=T)
mean(genChar$sensit1,na.rm=T)
mean(genChar$sensit2,na.rm=T)

plot(genChar$corr1,genChar$corr2)

plot(genChar$rt,genChar$sensit)
plot(genChar$taskDurationMin,genChar$sensit)
plot(genChar$taskDurationMin,genChar$rt)
plot(genChar$taskDurationMin,genChar$corr)
plot(genChar$corr,genChar$sensit)
plot(genChar$corr,genChar$rt)

# genChar$corr <- genChar$corr1
# genChar$sensit <- genChar$sensit1
# genChar$resCri <- genChar$resCri1

# good and bad participants
badParticipants <- union(genChar$workerId[genChar$corr <= 0.55 |
                                            genChar$taskDurationMin <= 7],
                         names(table(beh$workerId))[table(beh$workerId)<=50])
length(badParticipants)
goodParticipants <- intersect(genChar$workerId[genChar$corr > 0.55 &
                                                 genChar$taskDurationMin > 7],
                              names(table(beh$workerId))[table(beh$workerId)>50])
length(goodParticipants)



# remove trials from bad participants
genChar$remove <- T; beh$remove <- T 
for (i in 1:length(goodParticipants)) {
  genChar$remove[genChar$workerId == goodParticipants[i]] <- F
  beh$remove[beh$workerId == goodParticipants[i]] <- F
}
descrGuide <- f_suppTables(genChar,1)


genCharBad <- genChar[genChar$remove == T,]; genCharBad$remove <- NULL
genChar <- genChar[genChar$remove == F,]; genChar$remove <- NULL
behBad <- beh[beh$remove == T,]; behBad$remove <- NULL
beh <- beh[beh$remove == F,]; beh$remove <- NULL



# print data bases
print_csv <- 0
if (print_csv == 1) {
  write.csv(genChar,"figures_tables/genChar.csv",row.names = F)
  write.csv(beh, "figures_tables/beh.csv",row.names = F)
}



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
print_fig <- 0
if (print_fig == 1) {
  write.csv(genChar,"figures_tables/genChar.csv",row.names = F)
}



fig6 <- f_create_fig6(genChar)
# fig6

fig7 <- f_create_fig7(genChar)
# fig7

fig8 <- f_create_fig8(genChar)#[genChar$sample == "experiment50",])
# fig8



print_fig <- 0
if (print_fig == 1) {
  ggsave("figures_tables/fig6.png",
         plot = fig6, width = 16, height = 16, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
  ggsave("figures_tables/fig7.png",
         plot = fig7, width = 12, height = 16, units = "cm", 
         dpi = 1200, device='png', limitsize = T)
  ggsave("figures_tables/fig8_v2.png",
         plot = fig8, width = 14, height = 14, units = "cm", 
         dpi = 2400, device='png', limitsize = T)
}


# temp <- genChar[,c("R1_TTchase","R1_TTmirror","R0_TTchase","R0_TTmirror")]
# temp <- genChar
# temp$pChase <- rowSums(temp[,c("R1_TTchase","R1_TTmirror")])/rowSums(temp[,c("R1_TTchase","R1_TTmirror","R0_TTchase","R0_TTmirror")])
# hit, FA, Ms, CR
# .7100000 0.3434343
# h <- temp[1,1]/(temp[1,1]+temp[1,3])
# f <- temp[1,2]/(temp[1,2]+temp[1,4])
# plot(temp$pChase,temp$resCri)
# plot(temp$pChase,-qnorm(temp$f))
# # # # # # # # # # modelling elevated paranoia # # # # # # # # # # # # # # ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# univariate analysis
# ggplot2::ggplot(genChar, aes(x=rgpts_high,y=f)) + stat_summary()
summary(glm(rgpts_high~corr, data = genChar, family = "binomial"))
summary(glm(rgpts_high~rt, data = genChar, family = "binomial"))
summary(glm(rgpts_high~sensit, data = genChar, family = "binomial"))
summary(glm(rgpts_high~resCri, data = genChar, family = "binomial"))
summary(glm(rgpts_high~h, data = genChar, family = "binomial"))
summary(glm(rgpts_high~f, data = genChar, family = "binomial"))
summary(glm(rgpts_high~mc, data = genChar, family = "binomial"))
summary(glm(rgpts_high~theta, data = genChar, family = "binomial"))
summary(glm(rgpts_high~eta, data = genChar, family = "binomial"))

summary(glm(corr~rgpts_high, data = genChar, family = "gaussian"))
summary(glm(rt~rgpts_high, data = genChar, family = "gaussian"))
summary(glm(sensit~rgpts_high, data = genChar, family = "gaussian"))
summary(glm(resCri~rgpts_high, data = genChar, family = "gaussian"))
summary(glm(h~rgpts_high, data = genChar, family = "gaussian"))
summary(glm(f~rgpts_high, data = genChar, family = "gaussian"))
summary(glm(mc~rgpts_high, data = genChar, family = "gaussian"))
summary(glm(theta~rgpts_high, data = genChar, family = "gaussian"))
summary(glm(eta~rgpts_high, data = genChar, family = "gaussian"))


# create vector with all combination of possible regressors
covars <- c("corr","sensit","resCri","f","eta")
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
  if (i <= 26) {
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
# write.csv(modComp,"figures_tables/modelComparisons.csv",row.names=F)



# models multicolinearity (Variance Inflation Factor)
if (!require(regclass)) {install.packages("regclass")}; library(regclass) # VIF
regclass::VIF(m[[23]])



# change regressors parameters labels
factorLabels <- t(matrix(c("corr","corr", "sensit","d'", "resCri","C", "f","far", 
                           "eta","eta"),nrow=2))
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
y_x <- glm(rgpts_high~resCri, data = genChar, family = "binomial"); summary(y_x)
y_xm <- glm(rgpts_high~resCri+mc, data = genChar, family = "binomial"); summary(y_xm)
x_m <- glm(resCri~mc, data = genChar, family = "gaussian"); summary(x_m)

y_x <- glm(rgpts_high~sensit, data = genChar, family = "binomial"); summary(y_x)
y_xm <- glm(rgpts_high~sensit+mc, data = genChar, family = "binomial"); summary(y_xm)
x_m <- glm(sensit~mc, data = genChar, family = "gaussian"); summary(x_m)

y_x <- glm(rgpts_high~f, data = genChar, family = "binomial"); summary(y_x)
y_xm <- glm(rgpts_high~f+mc, data = genChar, family = "binomial"); summary(y_xm)
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
             resCri ~ a*mc
             rgpts_high ~ b*resCri
           # indirect effect (a*b)
             ab := a*b
           # total effect
             total := c + (a*b)'
mod1 <- "# a path
           theta ~ a * resCri
         # b path
           rgpts_high ~ b * theta
         # c prime path
           rgpts_high ~ cp * resCri

         # indirect and total effects
         ab := a * b
         total := cp + ab"
# estimator = "WLSMV" from https://www.researchgate.net/post/How-to-deal-with-dichotomous-endogenous-variables-in-Lavaan-R-package
fit <- lavaan::sem(model, data = genChar, ordered = c("rgpts_high"), 
                   estimator = "WLSMV")
summary(fit, standardized = TRUE)

if (!require(tidySEM)) {install.packages("tidySEM")}; library(tidySEM)
graph_sem(model = fit)


