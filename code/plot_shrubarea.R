setwd("~/Shrubs-Seedlings/Rdata")
load(file="master_data.Rdata")
library(nlme)
df <- subset(df, df$Species != "CADE")


dfPinus <- df[df$Species%in%c("PIPO","PILA") & !df$Fire %in% c("PLKN","WRTS"),]
varPower <- varPower(form=~Ht.cm)
M1F.pipo <- gls(LastYearGrth.cm ~ Ht.cm + Fire + Ht.cm*Fire + Ht1.3 + Ht1.3*Ht.cm,
                weights = varPower,
                data= dfPinus, method = "ML")
AIC(M1F.pipo)

dfPinus$shrubvol <- dfPinus$Ht1.2*(dfPinus$Cov1.2^2)

M.interact <- gls(LastYearGrth.cm ~ Ht.cm + Fire + Ht.cm*Fire + shrubvol*Ht.cm + shrubvol,
                weights = varPower,
                data= dfPinus, method = "ML")
AIC(M.interact)
summary(M.interact)

###
### AIC for 1-3 meters, cover squared: 587.6655
### AIC for 1-2 meters, cover squared: 587.6485
### AIC for 1 meter, cover squared: 590.1969

E <- resid(M.interact, type="normalized")
coplot(E ~ Ht.cm | Fire, data=dfPinus, ylab="Normalized residuals", col=dfPinus$Fire)

plot(dfPinus$Cov1.2, resid(M.interact))
hist(resid(M.interact))



dfPinus$shrubarea <- dfPinus$Ht1.2*(dfPinus$Cov1.2)
M.interact2 <- gls(LastYearGrth.cm ~ Ht.cm + Fire + Ht.cm*Fire + shrubarea*Ht.cm + shrubarea,
                  weights = varPower,
                  data= dfPinus, method = "ML")
AIC(M.interact2)
summary(M.interact2)

###
### AIC for 1-3 meters, cover squared: 587.8378
### AIC for 1-2 meters, cover squared: 587.8073
### AIC for 1 meter, cover squared:  591.0605

E2 <- resid(M.interact2, type="normalized")
coplot(E2 ~ Ht.cm | Fire, data=dfPinus, ylab="Normalized residuals", col=dfPinus$Fire)

plot(dfPinus$Cov1.2, resid(M.interact))
plot(dfPinus$Ht1.2, resid(M.interact))
plot(dfPinus$shrubvol, resid(M.interact))
hist(resid(M.interact))



Ht.cm <- c(rep(seq(0,300,5),4))
length(Ht.cm)
fakedata <- as.data.frame(Ht.cm)
fakedata$shrubarea <- c(rep(c( 44375,88750,133125,177500 ),61))
fakedata$Fire <- as.factor(rep("AMCR",244))
predicted <- predict(M.interact2, fakedata)

pred <- as.data.frame(predicted)
pred$shrubarea <- fakedata$shrubarea
pred$Ht.cm <- fakedata$Ht.cm
pred$Fire <- fakedata$Fire

dfAMCR <- subset(dfPinus, dfPinus$Fire=="AMCR")
dfCLVD <- subset(dfPinus, dfPinus$Fire=="CLVD")
dfSTAR <- subset(dfPinus, dfPinus$Fire=="STAR")
dfFRDS <- subset(dfPinus, dfPinus$Fire=="FRDS")


plotAMCR <- ggplot(pred[pred$Ht.cm<max(dfAMCR$Ht.cm) & pred$shrubarea<=max(dfAMCR$shrubarea) & pred$shrubarea>=min(dfAMCR$shrubarea),])+
  geom_line(aes(y= predicted ,group=shrubarea,x=Ht.cm,col=shrubarea))+
  scale_color_gradient(low="blue",high="red",limits=c(0,max(dfPinus$shrubarea)))+
  labs(title = "Seedling growth ~ \nHt, shrub area, AMRC fire")+
  ylim(0,55)+
  xlim(0,300)+
  xlab("Seedling height (cm)")+
  ylab("Seedling growth (cm)")+
  geom_point(data=dfAMCR, aes(x=Ht.cm,y=LastYearGrth.cm,col=shrubarea))
  

plotAMCR


Ht.cm <- c(rep(seq(0,300,5),4))
length(Ht.cm)
fakedata <- as.data.frame(Ht.cm)
fakedata$shrubarea <- c(rep(c( 44375,88750,133125,177500 ),61))
fakedata$Fire <- as.factor(rep("FRDS",244))
predicted <- predict(M.interact2, fakedata)

pred <- as.data.frame(predicted)
pred$shrubarea <- fakedata$shrubarea
pred$Ht.cm <- fakedata$Ht.cm
pred$Fire <- fakedata$Fire

plotFRDS <- ggplot(pred[pred$Ht.cm<max(dfFRDS$Ht.cm) & pred$shrubarea<=max(dfFRDS$shrubarea) & pred$shrubarea>=min(dfFRDS$shrubarea),])+
  geom_line(aes(y= predicted ,group=shrubarea,x=Ht.cm,col=shrubarea))+
  scale_color_gradient(low="blue",high="red",limits=c(0,max(dfPinus$shrubarea)))+
  labs(title = "Seedling growth ~ \nHt, shrub area, Freds Fire")+
  ylim(0,55)+
  xlim(0,300)+
  xlab("Seedling height (cm)") +
  ylab("Seedling growth (cm)")+
  geom_point(data=dfFRDS, aes(x=Ht.cm,y=LastYearGrth.cm,col=shrubarea))

plotFRDS


Ht.cm <- c(rep(seq(0,300,5),4))
length(Ht.cm)
fakedata <- as.data.frame(Ht.cm)
fakedata$shrubarea <- c(rep(c( 44375,88750,133125,177500 ),61))
fakedata$Fire <- as.factor(rep("STAR",244))
predicted <- predict(M.interact2, fakedata)

pred <- as.data.frame(predicted)
pred$shrubarea <- fakedata$shrubarea
pred$Ht.cm <- fakedata$Ht.cm
pred$Fire <- fakedata$Fire


plotSTAR <- ggplot(pred[pred$Ht.cm<max(dfSTAR$Ht.cm) & pred$shrubarea<=max(dfSTAR$shrubarea) & pred$shrubarea>=min(dfSTAR$shrubarea),])+
  geom_line(aes(y= predicted ,group=shrubarea,x=Ht.cm,col=shrubarea))+
  scale_color_gradient(low="blue",high="red", limits=c(0,max(dfPinus$shrubarea)))+
  labs(title = "Seedling growth ~ \nHt, shrub area, Star Fire")+
  ylim(0,55)+
  xlim(0,300)+
  xlab("Seedling height (cm)") +
  ylab("Seedling growth (cm)")+
  geom_point(data=dfSTAR, aes(x=Ht.cm,y=LastYearGrth.cm,col=shrubarea))

plotSTAR


Ht.cm <- c(rep(seq(0,300,5),4))
length(Ht.cm)
fakedata <- as.data.frame(Ht.cm)
fakedata$shrubarea <- c(rep(c(10000,50000,80000,110000 ),61))
fakedata$Fire <- as.factor(rep("CLVD",244))
predicted <- predict(M.interact2, fakedata)

pred <- as.data.frame(predicted)
pred$shrubarea <- fakedata$shrubarea
pred$Ht.cm <- fakedata$Ht.cm
pred$Fire <- fakedata$Fire


plotCLVD <- ggplot(pred[pred$Ht.cm<max(dfCLVD$Ht.cm) & pred$shrubarea<=max(dfCLVD$shrubarea) & pred$shrubarea>=min(dfCLVD$shrubarea),])+
  geom_line(aes(y= predicted ,group=shrubarea,x=Ht.cm,col=shrubarea))+
  scale_color_gradient(low="blue",high="red",limits=c(0,max(dfPinus$shrubarea)))+
  labs(title = "Seedling growth ~ \nHt, shrub area, CLVD Fire")+
  ylim(0,55)+
  xlim(0,300)+
  xlab("Seedling height (cm)") +
  ylab("Seedling growth (cm)")+
  geom_point(data=dfCLVD, aes(x=Ht.cm,y=LastYearGrth.cm,col=shrubarea))

plotCLVD


require(gridExtra)
grid.arrange(plotAMCR, plotFRDS,plotSTAR,plotCLVD,nrow=2,ncol=2 )
