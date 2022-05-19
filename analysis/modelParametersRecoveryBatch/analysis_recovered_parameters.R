# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE))



#### # # # # libraries # # # # #### 
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(ggpubr)) {install.packages("ggpubr")}; library(ggpubr)



#### # # # # import data # # # # #### 
# state max loop value
fileNames <- list.files("../modelParametersRecoveryBatch/figures_tables/")
fileNames <- fileNames[grepl("simParsWithParRecovery_",fileNames)]

for (i in 1:length(fileNames)) {
  temp <- read.csv(paste0("figures_tables/",fileNames[i]))
  if (i == 1) {
    simParsWithParRecovery <- temp
  } else {
    simParsWithParRecovery <- rbind(simParsWithParRecovery,temp)
  }
}; rm(temp)



#### # # # # visualize # # # # #### 
fig1A <- ggplot2::ggplot(simParsWithParRecovery, aes(x=mc,y=mc_fit_wm)) + 
  labs(title = expression(Memory~Capacity~(tau)),
       x = expression(Simulated~tau), 
       y = expression(Recovered~tau)) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  coord_fixed(xlim = c(20,100),ylim = c(20,100)) +
  theme_classic()

fig1B <- ggplot2::ggplot(simParsWithParRecovery, aes(x=theta,y=mc_fit_wm)) + 
  labs(title = expression(Proximity~(theta)),
       x = expression(Simulated~theta), 
       y = expression(Recovered~theta)) +
  geom_smooth(method="lm",se=F,col="grey") +
  geom_point(alpha=0.75) + 
  coord_fixed(xlim = c(40,200),ylim = c(40,200)) +
  theme_classic() 

fig1 <- ggpubr::ggarrange(fig1A,fig1B,ncol=2)
fig1

print_fig <- 0
if (print_fig == 1) {
  ggsave("figures_tables/fig1.jpg",
         plot = fig1, width = 18, height = 12, units = "cm", 
         dpi = 900, device='png', limitsize = T)
}

