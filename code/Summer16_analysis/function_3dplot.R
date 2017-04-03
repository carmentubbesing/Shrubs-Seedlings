library(plot3D)
library(nlme)
library(dplyr)
# Model
setwd("~/Shrubs-Seedlings/Rdata")
load(file="master_data.Rdata")
dfABCO <- df[df$Species=="ABCO" & !df$Fire %in% c("PLKN","FRDS"),]
dfABCO$shrubarea <- dfABCO$Ht1.2*(dfABCO$Cov1.2)
varPower <- varPower(form=~Ht.cm)
ABCO.M1 <- gls(LastYearGrth.cm ~ Ht.cm + Ht.cm*Fire + shrubarea*Ht.cm+shrubarea+Fire,
               weights = varPower,
               data= dfABCO, method = "REML")


# Create points data frame
Ht.cm <- c(rep(seq(0,150,length.out=61),4))
fakedata <- as.data.frame(Ht.cm)
fakedata$shrubarea <- c(rep(c( 44375,88750,133125,177500 ),61))
fakedata$Fire <- as.factor(rep("AMCR",244))
predicted <- predict(ABCO.M1, fakedata)

predpoints <- as.data.frame(predicted)
predpoints <- predpoints %>%
  select(shrubarea, Ht.cm,predicted)

summary(pred$Fire)

Ht.cm <- seq(0,150,length.out=60)
shrubarea <- seq(44375,177500,length.out=60)
Fire <- "AMCR"
xy <- expand.grid(Ht.cm=Ht.cm, shrubarea=shrubarea, Fire = Fire)

predmatrix <- matrix (nrow = 60, ncol = 60,  data = predict(ABCO.M1, newdata = data.frame(xy),interval = "prediction"))

data <-  cbind(predpoints,fakedata$Ht.cm,fakedata$shrubarea)
data <- data %>%
  rename(Ht.cm=`fakedata$Ht.cm`) %>%
  rename(shrubarea=`fakedata$shrubarea`) %>%
  rename(LastYearGrth.cm = predicted)

model = ABCO.M1
Ht_range = seq(0,150,length.out=60)
shrub_range = seq(44375,177500,length.out=60)
Fire = "AMCR"

plot3D <- function(data, model, Ht_range, shrub_range, Fire){
  xy <- expand.grid(Ht.cm=Ht_range, shrubarea=shrub_range, Fire = Fire)
  predmatrix <- matrix (nrow = 60, ncol = 60,  data = predict(model, newdata = data.frame(xy),interval = "prediction"))
  scatter3D(z=data$LastYearGrth.cm, x=data$Ht.cm, y=data$shrubarea, pch=18, cex=2, theta = 45, phi = 20, ticktype = "detailed",
            xlab = "Ht", ylab = "shrubarea", zlab = "growth",  
            surf = list(z=predmatrix, x=Ht.cm,y=shrubarea,
                        facets = NA),
            main="fakedata")
}

plot3D(data, model, Ht_range, shrub_range, Fire)

###EXAMPLE:
with (mtcars, {
  # linear regression
  attach(mtcars)
  fit <- lm(mpg ~ wt + disp)
  # predict values on regular xy grid
  wt.pred <- seq(1.5, 5.5, length.out = 30)
  disp.pred <- seq(71, 472, length.out = 30)
  xy <- expand.grid(wt = wt.pred, disp = disp.pred)
  mpg.pred <- matrix (nrow = 30, ncol = 30,  data = predict(fit, newdata = data.frame(xy),interval = "prediction"))
  # fitted points for droplines to surface
  fitpoints <- predict(fit) 
  scatter3D(z = mpg, x = wt, y = disp, pch = 18, cex = 2, 
            theta = 20, phi = 20, ticktype = "detailed",
            xlab = "wt", ylab = "disp", zlab = "mpg",  
            surf = list(x = wt.pred, y = disp.pred, z = mpg.pred,  
                        facets = NA, fit = fitpoints),
            main = "mtcars")
})
x


scatter3D(z=pred$predicted, x=pred$Ht.cm, y=pred$shrubarea, pch=18, cex=2, theta = 20, phi = 20, ticktype = "detailed",
          xlab = "Ht", ylab = "shrubarea", zlab = "growth",  
          surf = list(z=pred, x=Ht.cm,y=shrubarea,
                      facets = NA,fit=predict(ABCO.1)))


