#####################################################################################
### TESTING OUT SORTIE BEHAVIORS
#####################################################################################

### BEHAVIOR: "Power growth - height only"

### My equation for seedling growth for pines: 

# AMRC
### growth in cm = -.59 + 0.19 * Ht.cm - .006 * shrub ht - .00054 * Ht.cm * Shrub ht
### Test that's right

Ht.cm <- c(rep(seq(0,300,5),4))
fakedata <- as.data.frame(Ht.cm)
fakedata$Ht1.3 <- c(rep(c(5,50,100,150),61))

predicted <- -.598 + 0.187 * fakedata$Ht.cm - .00683 * fakedata$Ht1.3 - .00054 * fakedata$Ht.cm * fakedata$Ht1.3

pred <- as.data.frame(predicted)
pred$Shrub_height <- fakedata$Ht1.3
pred$Ht.cm <- fakedata$Ht.cm

plot_AMCR <- ggplot(pred[pred$Shrub_height<51,])+
  geom_line(aes(y= predicted ,x=Ht.cm,group=Shrub_height,col=Shrub_height))+
  scale_color_gradient(low="blue",high="red")+
  labs(title = "Predicted seedling growth,\nAmerican Complex Fire")+
  ylim(0,55)+
  xlim(0,300)+
  xlab("Seedling height")+
  ylab("Seedling growth")
plot_AMCR
hist(predicted)
# WORKS!

# STAR
### growth in cm = -.598 + (0.187-.00407)*Ht.cm - .00683*shrub ht - .00054 * Ht.cm * Shrub ht - 1.1096
### Test that's right

Ht.cm <- c(rep(seq(0,300,5),4))
fakedata <- as.data.frame(Ht.cm)
fakedata$Ht1.3 <- c(rep(c(5,50,100,150),61))

predicted <- 1.1096-.598 +(0.187-.00407)* fakedata$Ht.cm - .00683 * fakedata$Ht1.3 - .00054 * fakedata$Ht.cm * fakedata$Ht1.3

pred <- as.data.frame(predicted)
pred$Shrub_height <- fakedata$Ht1.3
pred$Ht.cm <- fakedata$Ht.cm

plot_STAR <- ggplot(pred[pred$Shrub_height>51 & pred$Ht.cm <= 230,])+
  geom_line(aes(y= predicted ,x=Ht.cm,group=Shrub_height,col=Shrub_height))+
  scale_color_gradient(low="blue",high="red")+
  labs(title = "Predicted seedling growth,\nStar Fire")+
  ylim(0,55)+
  xlim(0,300)+
  xlab("Seedling height")+
  ylab("Seedling growth")
plot_STAR
hist(predicted)

# FRDS

Ht.cm <- c(rep(seq(0,300,5),4))
fakedata <- as.data.frame(Ht.cm)
fakedata$Ht1.3 <- c(rep(c(5,50,100,150),61))

predicted <- .3021076-.5984835 +(.1870188+.0012349)* fakedata$Ht.cm - .0068351 * fakedata$Ht1.3 - .0005397 * fakedata$Ht.cm * fakedata$Ht1.3

# Which is approximately the same as (without as many sig figs):
coefs <- summary(SORTIE_pinus)$coefficients
predicted <- coefs[5] +coefs[1] +(coefs[2] + coefs[8])* fakedata$Ht.cm + coefs[3] * fakedata$Ht1.3 + coefs[10] * fakedata$Ht.cm * fakedata$Ht1.3




pred <- as.data.frame(predicted)
pred$Shrub_height <- fakedata$Ht1.3
pred$Ht.cm <- fakedata$Ht.cm

plot_FRDS <- ggplot(pred[pred$Ht.cm<=max(dfFRDS$Ht.cm),])+
  geom_line(aes(y= predicted ,x=Ht.cm,group=Shrub_height,col=Shrub_height))+
  scale_color_gradient(low="blue",high="red")+
  labs(title = "Predicted seedling growth,\nFreds Fire")+
  ylim(0,55)+
  xlim(0,300)+
  xlab("Seedling height")+
  ylab("Seedling growth")
plot_FRDS
hist(predicted)

### IMPORTANT LESSON: MANY SIG FIGS ARE IMPORTANT SO NEVER TYPE THEM OUT, JUST CALL THE COEFFICIENTS FROM THE SUMMARY

# CLVD


predicted <- -.05-.5984835 +(.1870188+.0012349)* fakedata$Ht.cm - .0068351 * fakedata$Ht1.3 - .0005397 * fakedata$Ht.cm * fakedata$Ht1.3

pred <- as.data.frame(predicted)
pred$Shrub_height <- fakedata$Ht1.3
pred$Ht.cm <- fakedata$Ht.cm

plot_FRDS <- ggplot(pred[pred$Ht.cm<=max(dfFRDS$Ht.cm),])+
  geom_line(aes(y= predicted ,x=Ht.cm,group=Shrub_height,col=Shrub_height))+
  scale_color_gradient(low="blue",high="red")+
  labs(title = "Predicted seedling growth,\nFreds Fire")+
  ylim(0,55)+
  xlim(0,300)+
  xlab("Seedling height")+
  ylab("Seedling growth")
plot_FRDS
hist(predicted)
