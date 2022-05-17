# script created by Santiago Castiello. It is used to analyse the 600 stimulus
# created by Ben van Buren for a perceived animacy task. Also, in this script
# I developed a simple model to classify chasing and no chasing (mirror) videos
# 15/05/2022. Special thanks to Josh Kenney.

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

write.csv(matrix(NA),"hello.csv")