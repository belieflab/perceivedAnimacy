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

# transform radians to degrees
rad2deg <- function(rad) {return((180 * rad) / pi)}

# get the norm and angle from a vector
f_normAngle <- function (from,to) {
  difX <- to$x - from$x
  difY <- to$y - from$y
  norm <- sqrt(difX^2+difY^2)
  quadrant <- ifelse(difX >= 0 & difY >= 0, "Q1",
                     ifelse(difX <= 0 & difY >= 0, "Q2",
                            ifelse(difX <= 0 & difY <= 0, "Q3", "Q4")))
  extra <- as.integer(revalue(quadrant, c("Q1" = 0,"Q2" = 180,"Q3" = 180,"Q4" = 360)))
  subsum <- as.integer(revalue(quadrant, c("Q1" = +1,"Q2" = -1,"Q3" = +1,"Q4" = -1)))
  angle <- extra+(rad2deg(atan(abs(difY/difX)))*subsum)
  return(data.frame(norm,angle))
}

# obtain the absolute angle difference
f_angDiff <- function(a1,a2) {return(ifelse(abs(a1-a2)>180,360-abs(a1-a2),abs(a1-a2)))}


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
  resCri  <- -1*(qnorm(h) + qnorm(f)) / 2
  # prepare output
  names(SDTtab) <- events
  return(list(sensit=sensit,resCri=resCri,SDTtab=SDTtab,h=h,f=f))
}


# this function is used to explore the parametric space of the detection model
f_SDTparamExplor <- function (dist, params) {
  # NOTE: this function receives the distance data frame and a data frame of the
  # set of parameters (theta = threshold, mc = memory capacity)
  
  # create new columns (for SDT parameters)
  params$r0_m <- params$r0_c <- params$r1_m <- params$r1_c <- params$h <-
    params$f <- params$resCri <- params$sensit <- NA
  # event types ordered: hit  FA   Ms  CR
  events <- c("1_chase","1_mirror","0_chase","0_mirror")
  # run a detection algorithm based on memory capacity
  dbTrials <- data.frame(trialType=rep(c("chase","mirror"),each=300),
                         trial=rep(1:300,2),
                         trialCond=unique(dist$trialCond))
  # for loop each i is a set of parameters (theta and mc)
  for (p in 1:nrow(params)) {
    message(paste("set of parameters:",p))
    # create same size database to build Boolean
    distBool <- dist
    # Boolean given theta
    distBool[,-1:-4] <- ifelse(distBool[,-1:-4] < params$theta[p],1,0)
    
    # distBool_lf <- melt(distBool, id.vars = c("trialType","trial","frame","trialCond"))
    # ggplot(distBool_lf, aes(x=frame,y=value,col=variable)) + 
    #   stat_summary(geom = "line") + 
    #   facet_grid(. ~ trialType) +
    #   theme_classic()
    
    # detection as 0 for each set of parameters
    dbTrials$detect <- 0
    # dbTrials$detFrame <- NA
    # run all the trials loop to detect consecutive mc detected frames
    for (t in 1:length(unique(distBool$trialCond))) {
      temp <- distBool[distBool$trialCond == unique(distBool$trialCond)[t],-1:-4]
      for (w in 1:(nrow(temp)-params$mc[p])) {
        if (sum(colSums(temp[w:(w+params$mc[p]-1),]) == params$mc[p]) > 0) {
          dbTrials$detect[t] <- 1
          # if detection frame is an NA then fill it with the detection frame
          # i.e., (w+params$mc[p]-1)
          # if (is.na(dbTrials$detFrame[t])) {
          #   dbTrials$detFrame[t] <- (w+params$mc[p]-1)
          # }
        }
      } # end window w loop
    } # end trials i loop
    # table(dbTrials$trialType,dbTrials$detect)
    
    # SDT cell types
    dbTrials$cells <- paste0(dbTrials$detect,"_",dbTrials$trialType)
    # SDT estimation parameters
    SDTpar <- f_SDTparam(dbTrials,events)
    params$sensit[p] <- SDTpar$sensit
    params$resCri[p] <- SDTpar$resCri
    params$h[p] <- SDTpar$h
    params$f[p] <- SDTpar$f
    params[p,7:10] <- SDTpar$SDTtab
  } # end parameter p loop
  return(params)
}

# this function is used to simulate choices given a set of parameters
f_detMod <- function (randDist, params) {
  # NOTE: this function receives the distance data frame and a the three 
  # parameters (eta = explore/exploit, theta = threshold, mc = memory capacity).
  
  # event types ordered: hit  FA   Ms  CR
  events <- c("R1_TTchase","R1_TTmirror","R0_TTchase","R0_TTmirror")
  # run a detection algorithm based on memory capacity
  dbTrials <- data.frame(mc=params$mc,theta=params$theta,eta=params$eta,
                         trialType=gsub("[[:punct:]]|[[:digit:]]", "",
                                        unique(randDist$trialCond)),
                         trial=1:length(unique(randDist$trialCond)),
                         trialCond=unique(randDist$trialCond))
  
  # create same size database to build Boolean
  distBool <- randDist
  # Boolean given theta
  distBool[,-1:-4] <- ifelse(distBool[,-1:-4] < params$theta,1,0)
  
  # detection as 0 for each set of parameters
  dbTrials$detect <- dbTrials$chaseR <- 0
  
  # simulate detection in all 600 trials
  for (t in 1:length(unique(distBool$trialCond))) {
    temp <- distBool[distBool$trialCond == unique(distBool$trialCond)[t],-1:-4]
    # run within trials the mc window to detect consecutive detected frames
    for (w in 1:(nrow(temp)-params$mc)) {
      detection <- sum(colSums(temp[w:(w+params$mc-1),]) == params$mc)
      if (detection > 0) {
        dbTrials$detect[t] <- 1
      }
    } # end window w loop
    
    # simulate detection response (Sutton & Barto, 2018)
    if (dbTrials$detect[t] == 1) {
      dbTrials$chaseR[t] <- rbinom(1,1,params$eta)
    } else {
      dbTrials$chaseR[t] <- rbinom(1,1,1-params$eta)
    }
  } # end trials i loop
  # see SDT table for detection and for chase response
  # table(dbTrials$trialType,dbTrials$detect)
  # table(dbTrials$trialType,dbTrials$chaseR)
    
  # SDT cell types
  dbTrials$cells <- paste0("R",dbTrials$chaseR,"_TT",dbTrials$trialType)
  # SDT estimation parameters
  SDTpar <- f_SDTparam(dbTrials,events)
  params$sensit <- SDTpar$sensit
  params$resCri <- SDTpar$resCri
  params$h <- SDTpar$h
  params$f <- SDTpar$f
  params <- data.frame(params,t(SDTpar$SDTtab))
  return(list(params=params,dbTrials=dbTrials))
}


f_fitDetMod <- function (randDist,   # randomized trial distances
                         onePartDat, # one participant behaviour
                         fitPars,    # parameter fit specifications
                         plotFigure = FALSE, # plot figure 
                         progress_bar = TRUE) {
  
  # extract parameters from inputs
  
  # bins
  binsMc <- fitPars$binsSize$mc
  binsTheta <- fitPars$binsSize$theta
  binsEta <- fitPars$binsSize$eta
  
  # parameters' sequences
  seqMc <- seq(fitPars$mcRange[1],fitPars$mcRange[2],
               by=round((fitPars$mcRange[2]-fitPars$mcRange[1])/binsMc))
  seqTheta <- seq(fitPars$thetaRange[1],fitPars$thetaRange[2],
                  by=round((fitPars$thetaRange[2]-fitPars$thetaRange[1])/binsTheta))
  seqEta <- seq(fitPars$etaRange[1],fitPars$etaRange[2],
                by=(fitPars$etaRange[2]-fitPars$etaRange[1])/binsEta)
  
  # update bins due to round sequences size
  binsMc <- length(seqMc)
  binsTheta <- length(seqTheta)
  binsEta <- length(seqEta)
  
  # number of trials
  nTrials <- nrow(onePartDat)
  
  # create learning rate array
  ar_par_trials <- array(NA,dim=c(nTrials,binsMc,binsTheta))
  # for loop for memory capacity (mc)
  for(i in 1:binsMc) {
    # for loop for theta
    for (j in 1:binsTheta) {
      # show progress bar
      if (progress_bar == TRUE){
        Sys.sleep(0.1)
        setTxtProgressBar(txtProgressBar(min = 0, max = binsMc*binsTheta, style = 3), 
                          ((i-1)*binsMc)+j)
      }
      temp <- f_detMod(randDist, data.frame(mc=seqMc[i],theta=seqTheta[j],eta=0.75))
      ar_par_trials[,i,j] <- temp$dbTrials$detect
    }
  } # end lr
  # ar_par_trials2 <- ar_par_trials # be protected
  # add bins Eta dimension
  ar_par_trials <- array(rep(ar_par_trials,binsEta),
                         dim=c(nTrials,binsMc,binsTheta,binsEta))
  
  # create eta array
  ar_eta <- array(seqEta,dim=c(binsEta,binsTheta,binsMc,nTrials))
  ar_eta <- aperm(ar_eta, c(4,3,2,1))
  
  # probability of response array
  ar_pR <- (ar_par_trials*ar_eta) + ((1-ar_par_trials)*(1-ar_eta))
  
  # create choice array
  ar_ch <- array(onePartDat$chaseR, dim = c(nTrials,binsMc,binsTheta,binsEta)) 
  
  # likelihood array 
  ar_ll <- (ar_ch*ar_pR) + ((1-ar_ch)*(1-ar_pR))
  
  # likelihood 3d distribution
  likelihood_dist <- apply(ar_ll,c(2,3,4),prod)#*10^200
  
    # sum of -log evidence
  negSumLog <- -max(apply(log(ar_ll),c(2,3,4),sum))
  
  # hit rate 
  hitRate <- max(apply(ar_ll,c(2,3,4),mean)) 
  
  # obtain posterior probability with uniform prior
  posterior_prob <- (likelihood_dist*1)/sum(likelihood_dist)
  
  
  # mc marginal
  mc_marg <- apply(posterior_prob,1,sum)
  # mc weighted mean (scaling seqMc then reversing it to normal scale)
  mc_wm <- as.vector((scale(seqMc)[1:binsMc]%*% mc_marg)
                     *sd(seqMc)+mean(seqMc))
  # mc variance
  mc_var <- as.vector(((scale(seqMc)[1:binsMc] - ((mc_wm-mean(seqMc))/sd(seqMc)))^2
                       %*% mc_marg)*sd(seqMc)+mean(seqMc))
  
  # theta marginal
  theta_marg <- apply(posterior_prob,2,sum)
  # theta weighted mean (scaling seqTheta then reversing it to normal scale)
  theta_wm <- as.vector((scale(seqTheta)[1:binsTheta]%*% theta_marg)
                        *sd(seqTheta)+mean(seqTheta))
  # theta variance
  theta_var <- as.vector(((scale(seqTheta)[1:binsTheta] -
                             ((theta_wm-mean(seqTheta))/sd(seqTheta)))^2
                          %*% theta_marg)*sd(seqTheta)+mean(seqTheta))
  
  # eta marginal
  eta_marg <- apply(posterior_prob,3,sum)
  # eta weighted mean (scaling seqTheta then reversing it to normal scale)
  eta_wm <- as.vector((scale(seqEta)[1:binsEta]%*% eta_marg)
                      *sd(seqEta)+mean(seqEta))
  # eta variance
  eta_var <- as.vector(((scale(seqEta)[1:binsEta] - 
                           ((eta_wm-mean(seqEta))/sd(seqEta)))^2
                        %*% eta_marg)*sd(seqEta)+mean(seqEta))
  
  # automatic plot
  if (plotFigure == TRUE) {
    # marginalize mc
    post_dist_mc <- apply(posterior_prob,c(2,3),sum)
    # image(post_dist_mc); contour(post_dist_mc,add=TRUE)
    # marginalize theta
    post_dist_theta <- apply(posterior_prob,c(1,3),sum)
    # image(post_dist_theta); contour(post_dist_theta,add=TRUE)
    # marginalize eta
    post_dist_eta <- apply(output$posterior_prob,c(1,2),sum)
    # image(post_dist_eta); contour(post_dist_eta,add=TRUE)
    
    if (!require(reshape2)) {install.packages("reshape2")}; library(reshape2)
    if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
    if (!require(viridis)) {install.packages("viridis")}; library(viridis)
    
    label_place_mc <- round(seq(binsMc/4,binsMc-1,binsMc/4))
    label_place_theta <- round(seq(binsTheta/4,binsTheta-1,binsTheta/4))
    label_place_eta <- round(seq(binsEta/4,binsEta-1,binsEta/4))
    
    output$p_theta_eta <- ggplot(data = melt(post_dist_mc), aes(x=Var1, y=Var2, fill=value)) + 
      geom_tile() + xlab(expression(theta)) + ylab(expression(eta)) +
      scale_fill_viridis(option = "D") +
      scale_x_continuous(limits = c(0, binsTheta), breaks = label_place_theta, 
                         labels = seqTheta[label_place_theta], minor_breaks = NULL) + 
      scale_y_continuous(limits = c(0, binsEta), breaks = label_place_eta,
                         labels = seqEta[label_place_eta], minor_breaks = NULL) +
      theme_classic() + theme(legend.position = "none")
    output$p_mc_eta <- ggplot(data = melt(post_dist_theta), aes(x=Var1, y=Var2, fill=value)) + 
      geom_tile() + xlab("memory capacity") + ylab(expression(eta)) +
      scale_fill_viridis(option = "D") +
      scale_x_continuous(limits = c(0, binsMc), breaks = label_place_mc, 
                         labels = seqMc[label_place_mc], minor_breaks = NULL) + 
      scale_y_continuous(limits = c(0, binsEta), breaks = label_place_eta,
                         labels = seqEta[label_place_eta], minor_breaks = NULL) +
      theme_classic() + theme(legend.position = "none")
    output$p_mc_theta <- ggplot(data = melt(post_dist_eta), aes(x=Var1, y=Var2, fill=value)) + 
      geom_tile() + xlab("memory capacity") + ylab(expression(theta)) +
      scale_fill_viridis(option = "D") +
      scale_x_continuous(limits = c(0, binsMc), breaks = label_place_mc, 
                         labels = seqMc[label_place_mc], minor_breaks = NULL) + 
      scale_y_continuous(limits = c(0, binsTheta), breaks = label_place_theta, 
                         labels = seqTheta[label_place_theta], minor_breaks = NULL) + 
      theme_classic() + theme(legend.position = "none")
  }
  
  # create output list
  output <- list() 
  output$pars <- data.frame(c(mc_wm,theta_wm,eta_wm),
                            c(mc_var,theta_var,eta_var))
  colnames(output$pars) <- c("wMean","var")
  rownames(output$pars) <- c("mc","theta","eta")
  output$mle <- data.frame(negSumLog,hitRate)
  output$marg <- list(mc=mc_marg,theta=theta_marg,eta=eta_marg)
  output$post_prob <- posterior_prob
  # return output list
  return(output)
}

