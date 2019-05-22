library(ggplot2)
setwd("~/Shrubs-Seedlings/Rdata")
load(file="master_data.Rdata")
df1 <- df[c("Sdlg","LastYearGrth.cm","Fire","FirePatch","Species","Ht.cm","BasDia.cm","ImmedAboveSpp","Cov3","Cov2","Cov1","Cov1.2","Cov1.3","Ht1.2","Ht1.3","Ht3","Ht2","Ht1","Spp3","Spp2","Spp1")] 

################################################################################################
#PART 1. DATA EXPLORATION AND TWEAKING 
################################################################################################

### START WITH ONLY SEEDLINGS WITH VERTICAL GROWTH DATA
df1 <- subset(df1, df1$Species != "CADE")

### LUMP FirePatchES THAT HAVE SAME FIRE AND SIMILAR LOCATION, ELEVATION, AND SLOPE
# Results of exploration of each patch is that no two patches have similar enough characteristics to do that

### Look at individual variables
dotchart(df1$Ht.cm, group = df1$FirePatch, main = "Height of Seedling")
dotchart(df1$LastYearGrth.cm, group = df1$FirePatch, main = "Seedling Growth")
dotchart(log(df1$Ht1), group = df1$FirePatch, main = "Shrub Heights 1")
dotchart(df1$Ht2, group = df1$FirePatch, main = "Shrub Heights 2")
dotchart(df1$Ht3, group = df1$FirePatch, main = "Shrub Heights 3")
dotchart(df1$Cov1, group = df1$FirePatch, main = "Shrub Heights 1")
dotchart(df1$Cov2, group = df1$FirePatch, main = "Shrub Heights 2")
dotchart(df1$Cov3, group = df1$FirePatch, main = "Shrub Heights 3")
dotchart(df1$BasDia.cm, group = df1$FirePatch, main = "Shrub Heights 3")
dotchart(df1$LastYearGrth.cm, group = df1$Species, main = "Seedling Growth by Species")

### TRANSFORMATIONS: TRY TO MAKE THEM BIOLOGICALLY JUSTIFIED! LOOK UP HOW GROWTH AND SIZE CHANGE
# Growth changes logarithmically with height for seedlings. I can get behind that. 
ggplot(data=df1, aes(y=LastYearGrth.cm, x=BasDia.cm))+
  geom_point(aes(colour = Fire))
ggplot(data=df1[df1$Fire=="STAR",], aes(y=LastYearGrth.cm, x=BasDia.cm))+
  geom_point(size=2, color=2)
library(mgcv)
HtAMCR <- df1$Ht.cm
GrAMCR <- df1$LastYearGrth.cm
plot(HtAMCR, GrAMCR, type="p")
M1 <- gam(GrAMCR ~ s(HtAMCR, fx=F, k=-1, bs="cr"))
M2 <- gam(log(GrAMCR) ~ s(HtAMCR, fx=F, k=-1, bs="cr"))
plot(M1, se=TRUE)
plot(M1$fitted.values,resid(M1)); abline(0,0) # Huge heteroskedasticity issues
plot(M2, se=TRUE)
plot(M2$fitted.values,resid(M2)); abline(0,0)
M2pred <- predict(M2, se=T, type="response")
plot(HtAMCR, GrAMCR, type="p")
gam.check(M1);abline(0,1)
gam.check(M2);abline(0,1) # P-values are low if there's a pattern to the residuals
# Model 1, no transformation, is better!
hist(df1$LastYearGrth.cm) # Even though the data look like this!

# It looks like transformations are not needed because relationships are linear even if there are
# more observations of smaller seedlings

### CHECKING COLLINEARITY
pairs(df1[c(2,3,6,5,7,8,9,10)], lower.panel=panel.smooth)

### RANDOM PATCH EFFECT
library(nlme)

# What happens when you compare just 0-1 m vs. 0-2 m?
M3 <- lme(LastYearGrth.cm ~ Ht.cm + Cov1, random = ~1|FirePatch, data= df1) 
summary(M3)
anova(M3)

M4 <- lme(LastYearGrth.cm ~ Ht.cm + Cov1.2, random = ~1|FirePatch, data= df1) 
summary(M4)
anova(M4)
### 0-2 m is better!
M5 <- lme(LastYearGrth.cm ~ Ht.cm + Cov1.3, random = ~1|FirePatch, data= df1) 
summary(M5)
anova(M5)
### 0-2 m wins! Yaaaaay! BUT I'M GETTING AHEAD OF MYSELF!

### STILL NEED TO DEAL WITH HETEROSKEDASTICITY BEFORE I CAN REALLY SAY THAT! LOOK AT ZUUR CH. 4 ON 
### USING GLS AND LOOK IN EXAMPLE CHAPTERS FOR SITUATIONS WHERE IT'S BEEN USED WITH MIXED EFFECTS MODELS


### THE RMARKDOWN FILE "GLS" DEALs WITH HETEROSKEDASTICITY!
