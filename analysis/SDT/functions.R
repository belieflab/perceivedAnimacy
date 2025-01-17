# calculate error entropy
H_error <- function(x,y,xref,yref) {
  x0 <- x-xref
  y0 <- y-yref
  xy0 <- matrix(x0,y0,nrow = length(x0), ncol=2)
  Sigma0 <- (1/(length(xy0[,1])-1))*(t(xy0) %*% xy0)
  eig0 <- eigen(Sigma0,only.values = T)
  ev0 <- eig0$values
  H.error <- log(ev0[1]*ev0[2])
  return(H.error)
}


# calculate path entropy
H_path <- function(x,y) {
  x0 <- x-mean(x)
  y0 <- y-mean(y)
  xy0 <- matrix(x0,y0,nrow =length(x0),ncol=2)
  Sigma0 <- (1/(length(xy0[,1])-1))*(t(xy0) %*%xy0)
  eig0 <- eigen(Sigma0,only.values = T)
  ev0 <- eig0$values
  H.path <- log(ev0[1]*ev0[2])
  return(H.path)
}



# calculate the outersect between between two vectors
outersect <- function(x, y) {
  sort(c(setdiff(x, y),
         setdiff(y, x)))
}



# signal detection theory analysis used in f_SDTparamExplor
f_SDTparam <- function (dbTrials, events) {
  # NOTE: events must be ordered as follows: hit, FA, Ms, CR
  # SDT cell frequencies 
  SDTtab <- colSums(dbTrials$cells==t(matrix(rep(events,nrow(dbTrials)),ncol=nrow(dbTrials))))
  h <- SDTtab[1]/(SDTtab[1]+SDTtab[3])
  f <- SDTtab[2]/(SDTtab[2]+SDTtab[4])
  # http://wise.cgu.edu/wise-tutorials/tutorial-signal-detection-theory/signal-detection-d-defined-2/
  if (h == 0 | is.nan(h)) h <- 1/nrow(dbTrials) else if (h == 1) h <- (nrow(dbTrials)-1)/nrow(dbTrials)
  if (f == 0 | is.nan(f)) f <- 1/nrow(dbTrials) else if (f == 1) f <- (nrow(dbTrials)-1)/nrow(dbTrials)
  # sensitivity (d')
  sensit <- qnorm(h) - qnorm(f)
  # response criterion
  resCri <- -1*(qnorm(h) + qnorm(f)) / 2
  # resCri <- resCri-qnorm(f)
  # prepare output
  names(SDTtab) <- events
  return(list(sensit=sensit,resCri=resCri,SDTtab=SDTtab,h=h,f=f))
}



# create correlation labels for plots
corLab <- function (vec1,vec2,method) {
  correl <- cor.test(vec1,vec2, method = method)
  if (correl$p.value < 0.001) {pVal <- "p < 0.001"
  } else if (correl$p.value > 0.001 & correl$p.value < 0.01) {pVal <- "p < 0.01"
  } else if (correl$p.value > 0.01 & correl$p.value < 0.05) {pVal <- "p < 0.05"
  } else {pVal <- "ns"}
  return(paste0("rho = ",round(correl$estimate,2),"; ",pVal))
}



# create figure 1
f_create_fig1 <- function(genChar) {
  fig1A <- ggplot2::ggplot(genChar, aes(x=resCri,y=sensit)) + 
    labs(title = "Signal Detection Theory (SDT) Parameters",
         subtitle = corLab(genChar$resCri,genChar$sensit,method="spearman"),
         x = "Response Criterion (C)", y = "Sensibility (d')") +
    geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
    geom_vline(xintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    theme_classic()
  fig1B <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=rgpts_per)) + 
    labs(title = "Paranoid Thoughts Scale",
         subtitle = corLab(genChar$rgpts_ref,genChar$rgpts_per,method="spearman"),
         x = "Ideas of Reference", y = "Ideas of Persecution") +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    theme_classic()
  
  fig1 <- ggpubr::ggarrange(fig1A,fig1B,ncol=2,labels=c("A","B")) + 
    bgcolor("white") + border("white")
  return(fig1)
}



# create figure 2
f_create_fig2 <- function(genChar) {
  fig2A <- ggplot2::ggplot(genChar, aes(x=paranoia,y=sensit)) + 
    labs(subtitle = corLab(genChar$paranoia,genChar$sensit,method="spearman"),
         x = "Paranoid", y = "d'") +
    geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.x = element_blank())
  
  fig2B <- ggplot2::ggplot(genChar, aes(x=paranoia,y=resCri)) + 
    labs(subtitle = corLab(genChar$paranoia,genChar$resCri,method="spearman"),
         x = "paranoia", y = "C") +
    geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.x = element_blank())
  
  fig2C <- ggplot2::ggplot(genChar, aes(x=paranoia,y=h)) + 
    labs(subtitle = corLab(genChar$paranoia,genChar$h,method="spearman"),
         x = "paranoia", y = "Hit rate") +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.x = element_blank())
  
  fig2D <- ggplot2::ggplot(genChar, aes(x=paranoia,y=f)) + 
    labs(subtitle = corLab(genChar$paranoia,genChar$f,method="spearman"),
         x = "paranoia", y = "False Alarm rate") +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.x = element_blank())
  
  fig2 <- ggpubr::annotate_figure(
    ggpubr::ggarrange(fig2A,fig2B,fig2C,fig2D,nrow=2,ncol=2,
                      labels=c("A","B","C","D"),align = "hv"),
    top = text_grob("Signal Detection Theory",face="bold",size=16),
    bottom = text_grob("Paranoia",face="bold",size=16)) + 
    bgcolor("white") + border("white")
  return(fig2)
}



f_create_fig3 <- function(genChar) {
  fig3A <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=sensit,col=rgpts_ref_high)) + 
    labs(subtitle = corLab(genChar$rgpts_ref,genChar$sensit,method="spearman"),
         x = "Ideas of Reference", y = "d'", col="Clinical Cutoff") +
    geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    scale_color_manual(values = viridis::inferno(5)[c(2,4)]) +
    theme_classic() + theme(axis.title.x = element_blank())
  fig3B <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=resCri,col=rgpts_ref_high)) + 
    labs(subtitle = corLab(genChar$rgpts_ref,genChar$resCri,method="spearman"),
         x = "Ideas of Reference", y = "C", col="Clinical Cutoff") +
    geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    scale_color_manual(values = viridis::inferno(5)[c(2,4)]) +
    theme_classic() + theme(axis.title.x = element_blank())
  fig3C <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=h,col=rgpts_ref_high)) + 
    labs(subtitle = corLab(genChar$rgpts_ref,genChar$h,method="spearman"),
         x = "Ideas of Reference", y = "Hit rate", col="Clinical Cutoff") +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    scale_color_manual(values = viridis::inferno(5)[c(2,4)]) +
    theme_classic() + theme(axis.title.x = element_blank())
  fig3D <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=f,col=rgpts_ref_high)) + 
    labs(subtitle = corLab(genChar$rgpts_ref,genChar$f,method="spearman"),
         x = "Ideas of Reference", y = "False Alarm rate", col="Clinical Cutoff") +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    scale_color_manual(values = viridis::inferno(5)[c(2,4)]) +
    theme_classic() + theme(axis.title.x = element_blank())
  
  fig3 <- ggpubr::annotate_figure(
    ggpubr::ggarrange(fig3A,fig3B,fig3C,fig3D,nrow=2,ncol=2,common.legend = T,
                      labels=c("A","B","C","D"),align = "hv"),
    bottom = text_grob("Ideas of Reference",face="bold",size=16)) + 
    bgcolor("white") + border("white")
  return(fig3)
}



f_create_fig4 <- function(genChar) {
  fig4A <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=sensit,col=rgpts_per_high)) + 
    labs(subtitle = corLab(genChar$rgpts_per,genChar$sensit,method="spearman"),
         x = "Ideas of Persecution", y = "d'", col="Clinical Cutoff") +
    geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    scale_color_manual(values = viridis::inferno(5)[c(2,4)]) +
    theme_classic() + theme(axis.title.x = element_blank())
  fig4B <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=resCri,col=rgpts_per_high)) + 
    labs(subtitle = corLab(genChar$rgpts_per,genChar$resCri,method="spearman"),
         x = "Ideas of Persecution", y = "C", col="Clinical Cutoff") +
    geom_hline(yintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    scale_color_manual(values = viridis::inferno(5)[c(2,4)]) +
    theme_classic() + theme(axis.title.x = element_blank())
  fig4C <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=h,col=rgpts_per_high)) + 
    labs(subtitle = corLab(genChar$rgpts_per,genChar$h,method="spearman"),
         x = "Ideas of Persecution", y = "Hit rate", col="Clinical Cutoff") +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    scale_color_manual(values = viridis::inferno(5)[c(2,4)]) +
    theme_classic() + theme(axis.title.x = element_blank())
  fig4D <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=f,col=rgpts_per_high)) + 
    labs(subtitle = corLab(genChar$rgpts_per,genChar$f,method="spearman"),
         x = "Ideas of Persecution", y = "False Alarm rate", col="Clinical Cutoff") +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    scale_color_manual(values = viridis::inferno(5)[c(2,4)]) +
    theme_classic() + theme(axis.title.x = element_blank())
  
  fig4 <- ggpubr::annotate_figure(
    ggpubr::ggarrange(fig4A,fig4B,fig4C,fig4D,nrow=2,ncol=2,common.legend = T,
                      labels=c("A","B","C","D"),align = "hv"),
    bottom = text_grob("Ideas of Persecution",face="bold",size=16)) + 
    bgcolor("white") + border("white")
  return(fig4)
}



f_create_fig5 <- function (beh,genChar) {fig5A <- ggplot2::ggplot(beh[beh$rt<8000,], aes(x=rt)) + 
  labs(title = "All Trials",x = "DT (ms)", y = "Frequency") +
  geom_vline(xintercept = 4000,col="red") +
  geom_histogram(bins = 50, color="black", fill="white") +
  scale_x_continuous(breaks = seq(0,10000,by=2000)) +
  annotate("text",x=3600,y=2000,label="Display End",angle=90,col="red") +
  theme_classic()

fig5B <- ggplot2::ggplot(genChar, aes(x=rt)) + 
  labs(title = "Participant Average",x = "DT (ms)", y = "Frequency") +
  geom_vline(xintercept = 4000,col="red") +
  geom_histogram(bins = 50, color="black", fill="white") +
  scale_x_continuous(breaks = seq(0,10000,by=2000)) +
  annotate("text",x=3600,y=10,label="Display End",angle=90,col="red") +
  theme_classic()

fig5 <- annotate_figure(ggpubr::ggarrange(fig5A,fig5B),
                        top = text_grob("Decision Time (DT) Distribution",
                                        face="bold",size=16)) + 
  bgcolor("white") + border("white")
return(fig5)
}


f_create_fig6 <- function (genChar) {
  fig6A <- ggplot2::ggplot(genChar, aes(x=paranoia,y=mc)) +
    labs(subtitle = corLab(genChar$paranoia,genChar$mc,method="spearman"),
         x = "Paranoia", y = expression(Integration~Window~(tau))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    theme_classic() + theme(axis.title.y = element_blank())
  fig6B <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=mc)) +
    labs(subtitle = corLab(genChar$rgpts_per,genChar$mc,method="spearman"),
         x = "Ideas of Persecution", y = expression(Integration~Window~(tau))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  fig6C <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=mc)) +
    labs(subtitle = corLab(genChar$rgpts_ref,genChar$mc,method="spearman"),
         x = "Ideas of Reference", y = expression(Integration~Window~(tau))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  
  fig6D <- ggplot2::ggplot(genChar, aes(x=paranoia,y=theta)) +
    labs(subtitle = corLab(genChar$paranoia,genChar$theta,method="spearman"),
         x = "Paranoia", y = expression(Distance~Sensitivity~(theta))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    theme_classic() + theme(axis.title.y = element_blank())
  fig6E <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=theta)) +
    labs(subtitle = corLab(genChar$rgpts_ref,genChar$theta,method="spearman"),
         x = "Ideas of Reference", y = expression(Distance~Sensitivity~(theta))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  fig6F <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=theta)) +
    labs(subtitle = corLab(genChar$rgpts_per,genChar$theta,method="spearman"),
         x = "Ideas of Persecution", y = expression(Distance~Sensitivity~(theta))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  
  fig6G <- ggplot2::ggplot(genChar, aes(x=paranoia,y=eta)) +
    labs(subtitle = corLab(genChar$paranoia,genChar$eta,method="spearman"),
         x = "Paranoia", y = expression(Explore~`/`~Explote~(eta))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) + 
    theme_classic() + theme(axis.title.y = element_blank())
  fig6H <- ggplot2::ggplot(genChar, aes(x=rgpts_ref,y=eta)) +
    labs(subtitle = corLab(genChar$rgpts_ref,genChar$eta,method="spearman"),
         x = "Ideas of Reference", y = expression(Explore~`/`~Explote~(eta))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  fig6I <- ggplot2::ggplot(genChar, aes(x=rgpts_per,y=eta)) +
    labs(subtitle = corLab(genChar$rgpts_per,genChar$eta,method="spearman"),
         x = "Ideas of Persecution", y = expression(Explore~`/`~Explote~(eta))) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  
  fig6 <- annotate_figure(ggpubr::ggarrange(
    NULL,
    annotate_figure(ggpubr::ggarrange(fig6A,fig6B,fig6C,ncol=3,labels = c("A","B","C")),
                    left = text_grob(expression(Integration~Window~(tau)),
                                     face="bold",size=12,rot=90)),
    NULL,
    annotate_figure(ggpubr::ggarrange(fig6D,fig6E,fig6F,ncol=3,labels = c("D","E","F")),
                    left = text_grob(expression(Distance~Sensitivity~(theta)),
                                     face="bold",size=12,rot=90)),
    NULL,
    annotate_figure(ggpubr::ggarrange(fig6G,fig6H,fig6I,ncol=3,labels = c("G","H","I")),
                    left = text_grob(expression(Explore~`/`~Explote~(eta)),
                                     face="bold",size=12,rot=90)),
    nrow=6,heights = c(1,10,1,10,1,10)),
    top=text_grob("Distance Window Integration Model (DWIM)",face="bold",size=18)) + 
    bgcolor("white") + border("white")
  return(fig6)
}


f_create_fig7 <- function(genChar) {
  fig7A <- ggplot2::ggplot(genChar, aes(x=sensit,y=mc)) +
    labs(subtitle = corLab(genChar$sensit,genChar$mc,method="spearman"),
         x = "d'", y = expression(Integration~Window~(tau))) +
    geom_vline(xintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  fig7B <- ggplot2::ggplot(genChar, aes(x=resCri,y=mc)) +
    labs(subtitle = corLab(genChar$resCri,genChar$mc,method="spearman"),
         x = "C", y = expression(Integration~Window~(tau))) +
    geom_vline(xintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  
  fig7C <- ggplot2::ggplot(genChar, aes(x=sensit,y=theta)) +
    labs(subtitle = corLab(genChar$sensit,genChar$theta,method="spearman"),
         x = "d'", y = expression(Distance~Sensitivity~(theta))) +
    geom_vline(xintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  fig7D <- ggplot2::ggplot(genChar, aes(x=resCri,y=theta)) +
    labs(subtitle = corLab(genChar$resCri,genChar$theta,method="spearman"),
         x = "C", y = expression(Distance~Sensitivity~(theta))) +
    geom_vline(xintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  
  fig7E <- ggplot2::ggplot(genChar, aes(x=sensit,y=eta)) +
    labs(subtitle = corLab(genChar$sensit,genChar$eta,method="spearman"),
         x = "d'",y = expression(Explore~`/`~Explote~(eta))) +
    geom_hline(yintercept = 0.5, col = "red", alpha = 0.2) +
    geom_vline(xintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  fig7F <- ggplot2::ggplot(genChar, aes(x=resCri,y=eta)) +
    labs(subtitle = corLab(genChar$resCri,genChar$eta,method="spearman"),
         x = "C", y = expression(Explore~`/`~Explote~(eta))) +
    geom_hline(yintercept = 0.5, col = "red", alpha = 0.2) +
    geom_vline(xintercept = 0, col = "grey", alpha = 0.2) +
    geom_smooth(method="lm",se=F,col="grey") +
    geom_point(alpha=0.75) +
    theme_classic() + theme(axis.title.y = element_blank())
  
  fig7 <- annotate_figure(ggpubr::ggarrange(
    NULL,
    annotate_figure(ggpubr::ggarrange(fig7A,fig7B,ncol=2,labels = c("A","B")),
                    left = text_grob(expression(Integration~Window~(tau)),
                                     face="bold",size=12,rot=90)),
    NULL,
    annotate_figure(ggpubr::ggarrange(fig7C,fig7D,ncol=2,labels = c("C","D")),
                    left = text_grob(expression(Distance~Sensitivity~(theta)),
                                     face="bold",size=12,rot=90)),
    NULL,
    annotate_figure(ggpubr::ggarrange(fig7E,fig7F,ncol=2,labels = c("E","F")),
                    left = text_grob(expression(Explore~`/`~Explote~(eta)),
                                     face="bold",size=12,rot=90)),
    nrow=6,heights = c(1,10,1,10,1,10)),
    top=text_grob("DWIM and SDT",face="bold",size=18)) + 
    bgcolor("white") + border("white")
  return(fig7)
}



f_create_fig8 <- function(genChar) {
  if (!require(reshape2)) {install.packages("reshape2")}; library(reshape2) # melt
  behPar <- c("corr","rt","sensit","resCri","h","f", "mc","theta","eta")
  genChar2 <- reshape2::melt(genChar, measure.vars = rev(behPar))
  
  sig <- as.vector(rep(NA,length(behPar)))
  for (i in 1:length(behPar)) {
    temp <- genChar2$value[genChar2$variable == behPar[i]]
    genChar2$value[genChar2$variable == behPar[i]] <- 
      (temp-min(temp))/max(temp-min(temp))
    temp2 <- summary(glm(rgpts_high~., family = "binomial",
                         data = genChar[,c("rgpts_high",behPar[i])]))
    sig[i] <- temp2$coefficients[2,4]
  }
  # summary(glm(behPar[i]~rgpts_high, family = "binomial",data = genChar))
  temp3 <- data.frame(behPar,sig,dich=
                        ifelse(sig<0.001,"p < 0.001",
                               ifelse(sig>0.001&sig<0.01,"p < 0.01",
                                      ifelse(sig>0.01&sig<0.05,"p < 0.05","NS"))))
  
  fig8 <- ggplot(genChar2, aes(x=value,y=variable,col=as.factor(rgpts_high))) +
    labs(title = "Perceived Animacy and Paranoia", col="Paranoia",
         subtitle = paste0("N = ",nrow(genChar),"; logistic model [paranoia ~ behaviour]"),
         x = "Normalized Scores", y = "Behavioural and Computational Parameters") +
    stat_summary(fun.data = mean_cl_normal, position = position_dodge(0.1)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    scale_y_discrete(labels = c('eta'=expression(Explotation*`:`~eta),
                                'theta'=expression(Closeness~Sensitivity*`:`~theta),
                                'mc'=expression(Integration~Window*`:`~tau),
                                'f'="False Alarm Rate",
                                'h'="Hit Rate",'resCri'="Response Criterion: C",
                                'sensit'="Sensitivity: d'",'rt'="Decision Time",
                                'corr'="Correctness")) +
    annotate("text",x=rev(c(0.3,0.45,0.22,0.4,0.5,0.3,0.5,0.35,0.3)),
             y=seq(1.3,9.3,1),label=rev(temp3$dich)) +
    theme_classic() + theme(legend.position = "bottom")
  fig8
  return(fig8)
}



sigmoid <- function (pred) {1/(1+exp(-pred))}



f_create_fig9 <- function(beh,sMA,sMB,sMC,sMD) {
  AfinModLab <- as.character(summary(get_model(sMA))$call$formula)[3]
  fig1A <- ggplot2::ggplot(beh, aes(x=paranoia,y=Herror,col=respType)) + 
    labs(title = "Error Entropy (W-->S)", #subtitle = paste("n_trials =",sum(!is.na(beh$Herror))),
         subtitle = substr(AfinModLab,1,nchar(AfinModLab)),
         x = "Paranoia", y = expression(H[error]),
         col = "Responses") +
    geom_smooth(method="lm", alpha=0.1) +
    scale_color_manual(values = viridis::viridis(7)[c(2,6)]) +
    facet_grid(. ~ trialType, labeller =
                 labeller(trialType = c(`chase`="Chase",`mirror`="No Chase"))) +
    theme_classic() + theme(plot.subtitle = element_text(size = 4))
  
  BfinModLab <- as.character(summary(get_model(sMB))$call$formula)[3]
  fig1B <- ggplot2::ggplot(beh, aes(x=paranoia,y=HpathW,col=respType)) + 
    labs(title = "Wolf Path Entropy", #subtitle = paste("n_trials =",sum(!is.na(beh$HpathW))),
         subtitle = substr(BfinModLab,1,nchar(BfinModLab)),
         x = "Paranoia", y = expression(H[path]),
         col = "Responses") +
    geom_smooth(method="lm", alpha=0.1) +
    scale_color_manual(values = viridis::viridis(7)[c(2,6)]) +
    facet_grid(. ~ trialType, labeller =
                 labeller(trialType = c(`chase`="Chase",`mirror`="No Chase"))) +
    theme_classic() + theme(plot.subtitle = element_text(size = 4))
  
  CfinModLab <- as.character(summary(get_model(sMC))$call$formula)[3]
  fig1C <- ggplot2::ggplot(beh, aes(x=paranoia,y=HpathS,col=respType)) + 
    labs(title = "Sheep Path Entropy", #subtitle = paste("n_trials =",sum(!is.na(beh$HpathS))), 
         subtitle = substr(CfinModLab,1,nchar(CfinModLab)),
         x = "Paranoia", y = expression(H[path]),
         col = "Responses") +
    geom_smooth(method="lm", alpha=0.1) +
    scale_color_manual(values = viridis::viridis(7)[c(2,6)]) +
    facet_grid(. ~ trialType, labeller =
                 labeller(trialType = c(`chase`="Chase",`mirror`="No Chase"))) +
    theme_classic() + theme(plot.subtitle = element_text(size = 4))
  
  DfinModLab <- as.character(summary(get_model(sMD))$call$formula)[3]
  fig1D <- ggplot2::ggplot(beh, aes(x=paranoia,y=rt,col=respType)) + 
    labs(title = "Decision Time (DT ms)", #subtitle = paste("n_trials =",sum(!is.na(beh$rt))),  
         subtitle = substr(DfinModLab,1,nchar(DfinModLab)),
         x = "Paranoia", y = "DT",
         col = "Responses") +
    geom_smooth(method="lm", alpha=0.1) +
    scale_color_manual(values = viridis::viridis(7)[c(2,6)]) +
    facet_grid(. ~ trialType, labeller =
                 labeller(trialType = c(`chase`="Chase",`mirror`="No Chase"))) +
    theme_classic() + theme(plot.subtitle = element_text(size = 4))
  
  fig1 <- ggpubr::ggarrange(fig1A,fig1B,fig1C,fig1D,nrow=2,ncol=2,
                            labels=c("A","B","C","D"),common.legend=T,align="hv") +
    bgcolor("white") + border("white")
  
  return(fig1)
}
f_create_fig9_v2 <- function(beh,sMA,sMB,sMC,sMD) {
  AfinModLab <- as.character(summary(get_model(sMA))$call$formula)[3]
  fig1A <- ggplot2::ggplot(beh, aes(x=respType,y=Herror,col=as.factor(rgpts_high))) + 
    labs(title = "Error Entropy (W-->S)", #subtitle = paste("n_trials =",sum(!is.na(beh$Herror))),
         #subtitle = substr(AfinModLab,1,nchar(AfinModLab)),
         x = "Detection", y = expression(H[error]),
         col = "Paranoia") +
    stat_summary(position = position_dodge(0.1)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    facet_grid(. ~ trialType, labeller =
                 labeller(trialType = c(`chase`="Trial: Chase",
                                        `mirror`="Trial: No Chase"))) +
    theme_classic() + theme(#plot.subtitle = element_text(size = 4),
                            axis.text.x = element_text(angle = 30, hjust = 1),
                            axis.title.x = element_blank())
  
  BfinModLab <- as.character(summary(get_model(sMB))$call$formula)[3]
  fig1B <- ggplot2::ggplot(beh, aes(x=respType,y=HpathW,col=as.factor(rgpts_high))) + 
    labs(title = "Wolf Path Entropy", #subtitle = paste("n_trials =",sum(!is.na(beh$HpathW))),
         #subtitle = substr(BfinModLab,1,nchar(BfinModLab)),
         x = "Detection", y = expression(H[path]),
         col = "Paranoia") +
    stat_summary(position = position_dodge(0.1)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    facet_grid(. ~ trialType, labeller =
                 labeller(trialType = c(`chase`="Trial: Chase",
                                        `mirror`="Trial: No Chase"))) +
    theme_classic() + theme(#plot.subtitle = element_text(size = 4),
                            axis.text.x = element_text(angle = 30, hjust = 1),
                            axis.title.x = element_blank())
  
  CfinModLab <- as.character(summary(get_model(sMC))$call$formula)[3]
  fig1C <- ggplot2::ggplot(beh, aes(x=respType,y=HpathS,col=as.factor(rgpts_high))) + 
    labs(title = "Sheep Path Entropy", #subtitle = paste("n_trials =",sum(!is.na(beh$HpathS))), 
         #subtitle = substr(CfinModLab,1,nchar(CfinModLab)),
         x = "Detection", y = expression(H[path]),
         col = "Paranoia") +
    stat_summary(position = position_dodge(0.1)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    facet_grid(. ~ trialType, labeller =
                 labeller(trialType = c(`chase`="Trial: Chase",
                                        `mirror`="Trial: No Chase"))) +
    theme_classic() + theme(#plot.subtitle = element_text(size = 4),
                            axis.text.x = element_text(angle = 30, hjust = 1),
                            axis.title.x = element_blank())
  
  DfinModLab <- as.character(summary(get_model(sMD))$call$formula)[3]
  fig1D <- ggplot2::ggplot(beh, aes(x=respType,y=rt,col=as.factor(rgpts_high))) + 
    labs(title = "Decision Time (DT ms)", #subtitle = paste("n_trials =",sum(!is.na(beh$rt))),  
         #subtitle = substr(DfinModLab,1,nchar(DfinModLab)),
         x = "Detection", y = "DT",
         col = "Paranoia") +
    stat_summary(position = position_dodge(0.1)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    facet_grid(. ~ trialType, labeller =
                 labeller(trialType = c(`chase`="Trial: Chase",
                                        `mirror`="Trial: No Chase"))) +
    theme_classic() + theme(#plot.subtitle = element_text(size = 4),
                            axis.text.x = element_text(angle = 30, hjust = 1),
                            axis.title.x = element_blank())
  
  fig1 <- annotate_figure(
    ggpubr::ggarrange(fig1A,fig1B,fig1C,fig1D,nrow=2,ncol=2,
                            labels=c("A","B","C","D"),common.legend=T,align="hv"),
    bottom = text_grob("Detection")) +
    bgcolor("white") + border("white")
  return(fig1)
}



f_create_fig10 <- function(beh) {
  fig2A <- ggplot(beh, aes(x=sdtTrials,y=Herror,col=as.factor(rgpts_high))) + 
    labs(title = "Error Entropy (W-->S)", subtitle = paste("n_trials =",sum(!is.na(beh$rt))),  
         x = "SDT event", y = expression(H[error]), col="Paranoia") +
    stat_summary(fun.data = mean_cl_boot, position = position_dodge(0.2)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    theme_classic()
  
  fig2B <- ggplot(beh, aes(x=sdtTrials,y=HpathW,col=as.factor(rgpts_high))) + 
    labs(title = "Wolf Path Entropy", subtitle = paste("n_trials =",sum(!is.na(beh$HpathW))),
         x = "SDT event", y = expression(H[path]), col="Paranoia") +
    stat_summary(fun.data = mean_cl_boot, position = position_dodge(0.2)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    theme_classic()
  
  fig2C <- ggplot(beh, aes(x=sdtTrials,y=HpathS,col=as.factor(rgpts_high))) + 
    labs(title = "Sheep Path Entropy", subtitle = paste("n_trials =",sum(!is.na(beh$HpathS))), 
         x = "SDT event", y = expression(H[path]), col="Paranoia") +
    stat_summary(fun.data = mean_cl_boot, position = position_dodge(0.2)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    theme_classic()
  
  fig2D <- ggplot(beh, aes(x=sdtTrials,y=rt,col=as.factor(rgpts_high))) + 
    labs(title = "Decision Time (DT ms)", subtitle = paste("n_trials =",sum(!is.na(beh$rt))),  
         x = "SDT event", y = "DT", col="Paranoia") +
    stat_summary(fun.data = mean_cl_boot, position = position_dodge(0.2)) +
    scale_color_manual(values = viridis::inferno(5)[c(2,4)],
                       labels = c("average","elevated")) +
    theme_classic()
  
  fig2 <- ggarrange(fig2A,fig2B,fig2C,fig2D,nrow=2,ncol=2,
                    labels=c("A","B","C","D"),common.legend=T,align="hv") +
    bgcolor("white") + border("white")
  
  return(fig2)
}


# categorical descriptive variable
f_descrCategorical <- function(vec) {return(paste0(levels(as.factor(vec)), ": ",table(vec), " (",round((table(vec) / length(vec)) * 100, 1), ")"))}
# continuous descriptive variable
f_descrContinuous <- function(vec) {return(c(paste0("M: ", round(mean(vec, na.rm = T), 2)),paste0("SD: ", round(sd(vec, na.rm = T), 2)),paste0(c("from: ", "to: "), round(range(vec, na.rm = T), 2))))}
# mean difference function
f_mean_difference <- function(sample1, sample2, paired){
  
  alpha <- 0.05 
  
  norm1 <- shapiro.test(sample1) # Shapiro-Wilk normality test
  norm2 <- shapiro.test(sample2) # Shapiro-Wilk normality test
  
  homoce <- var.test(sample1,sample2) # F test to compare two variances
  
  if (homoce$p.value > alpha) {var_equal = 1} else {var_equal = 0} 
  # there is a difference in t test depending homocedasticity. 
  # For var_equal: 1 = Two Sample t-test; 0 = Welch Two Sample t-test
  
  if (norm1$p.value > alpha  & norm2$p.value > alpha) {
    test <- t.test(sample1,sample2, paired = paired, var.equal = var_equal)
  } else {
    test <- wilcox.test(sample1,sample2, paired = paired)
  }
  return(test)
}
# built appendix (Table A1 and A3)
f_suppTables <- function (genChar,print_csvANDfig) {
  # # # # # # # # # # # # # # # # Supplementary Materials # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # difference in excluded and included participants
  sum(genChar$remove == TRUE); sum(genChar$remove == TRUE)/nrow(genChar)
  sum(genChar$remove == FALSE); sum(genChar$remove == FALSE)/nrow(genChar)
  
  descrGuide <- matrix(c("age","sex","corr","rt","sensit","resCri",
                         "rgpts_ref","rgpts_per","paranoia",
                         "rgpts_ref_high","rgpts_per_high","rgpts_high",
                         1,0,1,1,1,1,1,1,1,0,0,0),ncol=2)
  descrGuide <- cbind(descrGuide,matrix(NA,nrow=nrow(descrGuide),ncol=5))
  
  # excluded vs included
  for (i in 1:nrow(descrGuide)) {
    if (descrGuide[i,2] == 1) {
      descrGuide[i,3] <- paste(f_descrContinuous(genChar[genChar$remove == T,descrGuide[i,1]]),collapse = " ")
      descrGuide[i,4] <- paste(f_descrContinuous(genChar[genChar$remove == F,descrGuide[i,1]]),collapse = " ")
      temp <- f_mean_difference(genChar[genChar$remove == T,descrGuide[i,1]],
                                genChar[genChar$remove == F,descrGuide[i,1]],FALSE)
      descrGuide[i,5] <- temp$statistic
      if (!is.null(temp$parameter)) {descrGuide[i,6] <- temp$parameter}
      descrGuide[i,7] <- temp$p.value
    } else {
      descrGuide[i,3] <- paste(f_descrCategorical(genChar[genChar$remove == T,descrGuide[i,1]]),collapse = " ")
      descrGuide[i,4] <- paste(f_descrCategorical(genChar[genChar$remove == F,descrGuide[i,1]]),collapse = " ")
      temp <- chisq.test(table(genChar[,descrGuide[i,1]],genChar$remove))
      descrGuide[i,5] <- temp$statistic
      descrGuide[i,6] <- temp$parameter
      descrGuide[i,7] <- temp$p.value
    }
  }
  colnames(descrGuide) <- c("var","cont","badPart","goodPart","test","df","pValue")
  
  if (print_csvANDfig == 1) {
    write.csv(descrGuide,"figures_tables/table_A1.csv",row.names = F)
  }
  
  # function output
  return(list(descrGuide=descrGuide))
}
