### LOOKING AT SEEDLING GROWTH ~ LIGHT 

#setwd("~/Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Completed_Data") # Mac
setwd("C:/Users/Carmen/Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Shrubs2016_Completed_Data_and_Photos/") # PC
seedlings.light <- read.csv("Master_Compiled_Jul30_1204_seedlings.csv")
shrubs <- read.csv("Master_Compiled_Jul30_1204_shrubs.csv")
# Check for typos 
unique(seedlings.light$Species)
# Create variable for fire x patch
seedlings.light$Fire.Patch <- paste(seedlings.light$Fire, seedlings.light$Patch, sep = "-")
head(seedlings.light$Fire.Patch, n=20)
summary(seedlings.light$Fire)
seedlings.light$Fire[seedlings.light$Fire=="FRED"]<- "FRDS"
seedlings.light$Fire[seedlings.light$Fire=="AMRC"]<- "AMCR"
# Separate out by seedling species
abco <- subset(seedlings.light, seedlings.light$Species == "ABCO" & seedlings.light$Ht.cm > 0)
pila <- subset(seedlings.light, seedlings.light$Species == "PILA")
cade <- subset(seedlings.light, seedlings.light$Species == "CADE"& seedlings.light$Ht.cm > 0 & seedlings.light$FINAL_Gr_CADE_. > 0)
pipo <- subset(seedlings.light, seedlings.light$Species == "PIPO" & seedlings.light$Ht.cm > 0)
psme <- subset(seedlings.light, seedlings.light$Species == "PSME")

### LOOK AT ALL SEEDLINGS
summary(seedlings.light$Species)

### Check for impossible ht values
attach(seedlings.light)
seedlings.light$ht.growth2016 <- Ht.cm - Ht2015 - LastYearGrth.cm
sort(seedlings.light$ht.growth2016)
subset(seedlings.light, ht.growth2016 < 0)

### ABCO

# Check for relationship between growth and height, to create relative growth index
dev.off()
plot(abco$LastYearGrth.cm, abco$Ht.cm)
# Delete the two massive outliers
abco <- subset(abco, abco$Ht.cm < 220 & abco$LastYearGrth.cm < 25)
plot(abco$LastYearGrth.cm, abco$Ht.cm)
# Create relative growth index
#abco$Gr.relative <- abco$LastYearGrth.cm/abco$Ht.cm
#plot(abco$DIFN, abco$Gr.relative)
# Make model
library(nlme)
abco.DIFN <- subset(abco, !is.na(abco$DIFN))
abco.fit <- lme(LastYearGrth.cm ~ DIFN+Ht.cm, random = ~1|Fire, data = abco.DIFN)
summary(abco.fit)

# Uh oh! Major pattern in the residuals
plot(abco.DIFN$LastYearGrth.cm, resid(abco.fit))

# Look at resids for the relationship between growth and height
abco.fit.ht <- lm(LastYearGrth.cm ~ Ht.cm, data = abco)
summary(abco.fit.ht)
plot(abco$LastYearGrth.cm, resid(abco.fit.ht))
plot(abco$Ht.cm, resid(abco.fit.ht))

# Look at ht-grth relationship
plot(abco$Ht.cm, abco$LastYearGrth.cm)
abline(abco.fit.ht)
library(mgcv)
grth.ht.sm <- gam(abco$LastYearGrth.cm ~ s(abco$Ht.cm))
plot(grth.ht.sm, se = TRUE)

# Try a model that includes shrub data to see if that changes the relationships between ht and growth
abco.fit <- lme(LastYearGrth.cm ~ DIFN+Ht.cm, random = ~1|Fire, data = abco.DIFN)

# With Basal Diameter
plot(abco$DIFN, abco$Gr.relative)
abco.fit.1 <- lm(abco$Gr.relative ~ abco$DIFN*abco$BasDia.cm)
summary(abco.fit.1)
abline(abco.fit.1)

# With GrBArat (described below)
attach(abco)
abco$BA <- pi*((BasDia.cm/2)^2)
attach(abco)
abco$htBArat <- Ht.cm/BA
abco$GrBArat <- Gr.relative/BA
attach(abco)
hist(htBArat, breaks = 15)
hist(Gr.relative, breaks = 15)
hist(GrBArat, breaks = 15)
hist(log(GrBArat), breaks = 15)
# abco.no.outliers <- subset(abco, Gr.relative < .35)
# attach(abco.no.outliers)

abco.fit.6 <- lm(Gr.relative ~ DIFN+htBArat)
summary(abco.fit.6)

abco.fit.7 <- lm(Gr.relative ~ DIFN+log(GrBArat))
summary(abco.fit.7)

plot(Gr.relative, GrBArat)
plot(Gr.relative, DIFN)
abline(abco.fit.7)

### Compare to RGR using volume
# Narrow it down to ABCO in AMRC Fire, since 74/79 of ABCO with detailed volume data are at that fire 
abco.vol <- subset(abco, !is.na(abco$Dia2015) & abco$Fire %in% c("AMCR", "AMRC"))
nrow(subset(abco, !is.na(abco$Dia2015)))
attach(abco.vol)
# It looks like on July 20th there's an error with the way they took heights for the seedlings Varya and I had already visitedabco.vol$ht.growth2016 <- Ht.cm - Ht2015 - LastYearGrth.cm
abco.vol$tot16 <- ((BasDia.cm/2)^2*pi*Ht.cm)/2
abco.vol$ch.vol <- ((abco.vol$Dia2015/2)^2*pi*(abco.vol$Ht.cm - abco.vol$Ht2015))/2 - ((abco.vol$Dia2016/2)^2*pi*(abco.vol$Ht.cm - abco.vol$Ht2015-abco.vol$LastYearGrth.cm))/2
abco.vol$rel.ch.vol <- (((Dia2015/2)^2*pi*(Ht.cm - Ht2015))/2 - ((Dia2016/2)^2*pi*(Ht.cm - Ht2015 - LastYearGrth.cm))/2)/((BasDia.cm/2)^2)*pi*Ht.cm/2
abco.vol$rel.ch.test <- (((Dia2015/2)^2)*(Ht.cm - Ht2015) - ((Dia2016/2)^2)*(Ht.cm - Ht2015 - LastYearGrth.cm))/((BasDia.cm/2)^2)*Ht.cm
abco.vol$rel.ch.test.2 <- ch.vol/tot16

# Check for measurement errors that caused negative values for growth of 2016
abco.vol$ht.growth2016 <- Ht.cm - Ht2015 - LastYearGrth.cm
## MANY ERRORS WITH HT2015 MEASUREMENTS -> TRY CALCULATING CHANGE IN VOLUME AS A PORTION OF A CONE
attach(abco.vol)
abco.vol$ch.vol.fr <- (1/3)*pi*((Dia2016/2)^2 + (Dia2015/2)^2 + (Dia2015/2)*(Dia2016/2))*LastYearGrth.cm
abco.vol$rel.ch.v.fr <- ch.vol.fr/tot16

plot(ch.vol, ch.vol.fr)
plot(rel.ch.v.fr, rel.ch.test.2)
no.outlier <- subset(abco.vol, rel.ch.v.fr < .5)
attach(no.outlier)
plot(rel.ch.v.fr, rel.ch.test.2)

hist(log(rel.ch.v.fr), breaks = 10)
hist(rel.ch.v.fr, breaks = 10)

plot(DIFN, rel.ch.v.fr)
plot(DIFN, Gr.relative)
plot(sort(rel.ch.v.fr))

wtf.fit <- lm(rel.ch.v.fr ~ DIFN+BasDia.cm)
summary(wtf.fit)

# Try relationship between growth and DIFN
abco.vol.fit <- lm(log(abco.vol$ch.vol) ~ abco.vol$DIFN)
summary(abco.vol.fit)
abline(abco.vol.fit)
plot(sort(abco.vol$ch.vol))
plot(sort(log(abco.vol$ch.vol)))
hist(abco.vol$ch.vol, breaks = 15)
hist(log(abco.vol$ch.vol), breaks = 20)

# Using just relative growth rate
hist(abco.vol$Gr.relative, breaks = 15)

# Try relating growth to DIFN with ht/basal area as a variable
attach(abco.vol)
abco.vol$BA <- pi*((BasDia.cm/2)^2)
attach(abco.vol)
abco.vol$htBArat <- Ht.cm/BA
abco.vol$GrBArat <- Gr.relative/BA
attach(abco.vol)
hist(htBArat, breaks = 15)
hist(Gr.relative, breaks = 15)
hist(GrBArat, breaks = 15)
hist(log(GrBArat), breaks = 15)
abco.no.outliers <- subset(abco.vol, Gr.relative < .35)
attach(abco.no.outliers)

abco.fit.4 <- lm(Gr.relative ~ DIFN+htBArat)
summary(abco.fit.4)

abco.fit.5 <- lm(Gr.relative ~ DIFN+log(GrBArat))
summary(abco.fit.5)

plot(Gr.relative, GrBArat)
plot(Gr.relative, DIFN)

### ABCO by shrub species for the common shrubs

# Make sure seedling numbers match in Seedlings data frame and in Shrubs data frame
shrubs.abco <- subset(shrubs, shrubs$Seedling. %in% abco$Seedling.)
sort(unique(abco$Seedling.))
sort(unique(shrubs.abco$Seedling.))
setdiff(sort(unique(abco$Seedling.)), sort(unique(shrubs.abco$Seedling.)))

# Aggregate shrub data to find highest cover shrub spp for each seedling
shrubs.abco.01 <- subset(shrubs.abco, shrubs.abco$Segment == "0-1 m ")
shrubs.abco.01.sum <- aggregate(shrubs.abco.01$Cover.cm, by = list(ShrubSpp = shrubs.abco.01$ShrubSpp, Seedling = shrubs.abco.01$Seedling.), FUN = sum)
shrubs.abco.01.highest <- aggregate(shrubs.abco.01.sum$x, by = list(Seedling = shrubs.abco.01.sum$Seedling), FUN = max)
shrubs.abco <- merge(shrubs.abco.01.highest, shrubs.abco.01.sum)
# Combine max shrub with seedling data frame
abco <- merge(abco,shrubs.abco, by.x = "Seedling.", by.y = "Seedling")
names(abco)[names(abco)=="Seedling."] <- "Seedling"
# Test by spot checking
subset(abco, abco$Seedling == "107")$ShrubSpp
subset(shrubs.abco, shrubs.abco$Seedling == "107")
subset(abco, abco$Seedling == "95")$ShrubSpp
subset(shrubs.abco, shrubs.abco$Seedling == "95")
subset(abco, abco$Seedling == "94")$ShrubSpp
subset(shrubs.abco, shrubs.abco$Seedling == "94")
# Pick top shrub species - winners are CECO, ARPA, CHSE
summary(abco$ShrubSpp)

# Rerun model with max shrub species in it

# CECO
abco.ceco <- subset(abco, abco$ShrubSpp == "CECO")
plot(abco.ceco$DIFN, abco.ceco$Gr.relative)
abco.ceco.fit <- lm(abco.ceco$Gr.relative ~ abco.ceco$DIFN+abco.ceco$BasDia.cm)
summary(abco.ceco.fit)
abline(abco.ceco.fit)

# ARPA
abco.arpa <- subset(abco, abco$ShrubSpp == "ARPA")
plot(abco.arpa$DIFN, abco.arpa$Gr.relative)
abco.arpa.fit <- lm(abco.arpa$Gr.relative ~ abco.arpa$DIFN)
summary(abco.arpa.fit)
abline(abco.arpa.fit)

### ABCO by shrub patch
abco.AMRC2 <- subset(abco, abco$Fire.Patch == "AMRC-2")
attach(abco.AMRC2)
plot(DIFN, Gr.relative)
abco.WRTS1 <- subset(abco, abco$Fire.Patch == "WRTS-1")
attach(abco.WRTS1)
plot(DIFN, Gr.relative)

### ABCO by fire (to see if AMRC has wide enough range of light)
abco.AMRC <- subset(abco, abco$Fire == "AMRC")
attach(abco.AMRC)
plot(DIFN, Gr.relative)

### PIPO

# Check for relationship between growth and height, to create relative growth index
plot(pipo$LastYearGrth.cm, pipo$Ht.cm)
pipo <- subset(pipo, pipo$Ht.cm < 250)
# Create relative growth index
pipo$Gr.relative <- pipo$LastYearGrth.cm/pipo$Ht.cm
plot(pipo$DIFN, pipo$Gr.relative)
pipo.fit <- lm(pipo$Gr.relative ~ pipo$DIFN+pipo$BasDia.cm)
summary(pipo.fit)
abline(pipo.fit)

# With GrBArat (described above)
attach(pipo)
pipo$BA <- pi*((BasDia.cm/2)^2)
attach(pipo)
pipo$htBArat <- Ht.cm/BA
pipo$GrBArat <- pipo$Gr.relative/pipo$BA
attach(pipo)
hist(htBArat, breaks = 15)
hist(Gr.relative, breaks = 15)
hist(GrBArat, breaks = 15)
hist(log(GrBArat), breaks = 15)
# pipo.no.outliers <- subset(pipo, Gr.relative < .35)
# attach(pipo.no.outliers)

pipo.fit.6 <- lm(Gr.relative ~ DIFN+htBArat)
summary(pipo.fit.6)

pipo.fit.7 <- lm(Gr.relative ~ DIFN+log(GrBArat)+Ht.cm)
summary(pipo.fit.7)

plot(Gr.relative, GrBArat)
plot(Gr.relative, DIFN)
abline(pipo.fit.7)

# Compare to RGR using volume

pipo.vol <- subset(pipo, !is.na(pipo$Dia2015))
nrow(subset(pipo, !is.na(pipo$Dia2015)))
attach(pipo.vol)
# It looks like on July 20th there's an error with the way they took heights for the seedlings Varya and I had already visited
pipo.vol$ht.growth2016 <- Ht.cm - Ht2015 - LastYearGrth.cm
pipo.vol$tot16 <- ((BasDia.cm/2)^2*pi*Ht.cm)/2
pipo.vol$ch.vol <- ((pipo.vol$Dia2015/2)^2*pi*(pipo.vol$Ht.cm - pipo.vol$Ht2015))/2 - ((pipo.vol$Dia2016/2)^2*pi*(pipo.vol$Ht.cm - pipo.vol$Ht2015-pipo.vol$LastYearGrth.cm))/2
pipo.vol$rel.ch.vol <- (((Dia2015/2)^2*pi*(Ht.cm - Ht2015))/2 - ((Dia2016/2)^2*pi*(Ht.cm - Ht2015 - LastYearGrth.cm))/2)/((BasDia.cm/2)^2)*pi*Ht.cm/2
pipo.vol$rel.ch.test <- (((Dia2015/2)^2)*(Ht.cm - Ht2015) - ((Dia2016/2)^2)*(Ht.cm - Ht2015 - LastYearGrth.cm))/((BasDia.cm/2)^2)*Ht.cm
pipo.vol$rel.ch.test.2 <- ch.vol/tot16

# Check for measurement errors that caused negative values for growth of 2016
pipo.vol$ht.growth2016 <- Ht.cm - Ht2015 - LastYearGrth.cm
## MANY ERRORS WITH HT2015 MEASUREMENTS -> TRY CALCULATING CHANGE IN VOLUME AS A PORTION OF A CONE
attach(pipo.vol)
pipo.vol$ch.vol.fr <- (1/3)*pi*((Dia2016/2)^2 + (Dia2015/2)^2 + (Dia2015/2)*(Dia2016/2))*LastYearGrth.cm
pipo.vol$rel.ch.v.fr <- ch.vol.fr/tot16

plot(ch.vol, ch.vol.fr)
plot(pipo.vol$rel.ch.v.fr, pipo.vol$rel.ch.test.2)
no.outlier <- subset(pipo.vol, rel.ch.v.fr < .4)
attach(no.outlier)
plot(rel.ch.v.fr, rel.ch.test.2)

hist(log(rel.ch.v.fr), breaks = 10)
hist(rel.ch.v.fr, breaks = 10)

plot(DIFN, rel.ch.v.fr)
plot(DIFN, pipo.vol$Gr.relative)
plot(sort(rel.ch.v.fr))

wtf.fit <- lm(rel.ch.v.fr ~ DIFN)
summary(wtf.fit)

### TAKEAWAY AS OF 7/26/16: THERE'S NO RELATIONSHIP BETWEEN DIFN AND RELATIVE GROWTH RATE
### HOW CAN I ADDRESS THIS? FIRST STEPS: 1) CHECK ALGEBRA (in excel?), 2) INCLUDE SITE INTO MODEL, 3) GET MORE DATA
### 1) the algebra checks out
### ***** Maybe volumetric change doesn't make sense for my data, since I don't know the previous year's diameter
### ***** - including 

### PIPO by shrub species for the common shrubs

# Make sure seedling numbers match in Seedlings data frame and in Shrubs data frame
shrubs.pipo <- subset(shrubs, shrubs$Seedling. %in% pipo$Seedling.)
sort(unique(pipo$Seedling.))
sort(unique(shrubs.pipo$Seedling.))
setdiff(sort(unique(pipo$Seedling.)), sort(unique(shrubs.pipo$Seedling.)))

# Aggregate shrub data to find highest cover shrub spp for each seedling
shrubs.pipo.01 <- subset(shrubs.pipo, shrubs.pipo$Segment == "0-1 m ")
shrubs.pipo.01.sum <- aggregate(shrubs.pipo.01$Cover.cm, by = list(ShrubSpp = shrubs.pipo.01$ShrubSpp, Seedling = shrubs.pipo.01$Seedling.), FUN = sum)
shrubs.pipo.01.highest <- aggregate(shrubs.pipo.01.sum$x, by = list(Seedling = shrubs.pipo.01.sum$Seedling), FUN = max)
shrubs.pipo <- merge(shrubs.pipo.01.highest, shrubs.pipo.01.sum)
# Combine max shrub with seedling data frame
pipo <- merge(pipo,shrubs.pipo, by.x = "Seedling.", by.y = "Seedling")
names(pipo)[names(pipo)=="Seedling."] <- "Seedling"
# Test by spot checking
subset(pipo, pipo$Seedling == "10")$ShrubSpp
subset(shrubs.pipo, shrubs.pipo$Seedling == "10")
subset(pipo, pipo$Seedling == "109")$ShrubSpp
subset(shrubs.pipo, shrubs.pipo$Seedling == "109")
subset(pipo, pipo$Seedling == "71")$ShrubSpp
subset(shrubs.pipo, shrubs.pipo$Seedling == "71")
# Pick top shrub species - winners are CEIN, ARPA, CHFO
summary(pipo$ShrubSpp)

# ARPA

pipo.arpa <- subset(pipo, pipo$ShrubSpp == "ARPA")
plot(pipo.arpa$DIFN, pipo.arpa$Gr.relative)
pipo.arpa.fit <- lm(pipo.arpa$Gr.relative ~ pipo.arpa$DIFN)
summary(pipo.arpa.fit)
abline(pipo.arpa.fit)

# CEIN

pipo.cein <- subset(pipo, pipo$ShrubSpp == "CEIN")
plot(pipo.cein$DIFN, pipo.cein$Gr.relative)
pipo.cein.fit <- lm(pipo.cein$Gr.relative ~ pipo.cein$DIFN)
summary(pipo.cein.fit)
abline(pipo.cein.fit)

# CHFO

pipo.chfo <- subset(pipo, pipo$ShrubSpp == "CHFO")
plot(pipo.chfo$DIFN, pipo.chfo$Gr.relative)
pipo.chfo.fit <- lm(pipo.chfo$Gr.relative ~ pipo.chfo$DIFN)
summary(pipo.chfo.fit)
abline(pipo.chfo.fit)

### CADE

# Check for relationship between growth and height, to create relative growth index
nrow(cade)
plot(cade$FINAL_Gr_CADE_., cade$BasDia.cm)
# Create relative growth index
plot(cade$DIFN, cade$FINAL_Gr_CADE_.)
cade.fit <- lm(cade$FINAL_Gr_CADE_. ~ cade$DIFN)
summary(cade.fit)
abline(cade.fit)

### PILA

plot(pila$LastYearGrth.cm, pila$Ht.cm)
# Create relative growth index
pila$Gr.relative <- pila$LastYearGrth.cm/pila$Ht.cm
plot(pila$DIFN, pila$Gr.relative)
pila.fit <- lm(pila$Gr.relative ~ pila$DIFN)
summary(pila.fit)
abline(pila.fit)

### FINDING MOST COMMON SHRUB SPECIES

shrubs <- read.csv("Master_Compiled_Jul05_2038_shrubs.csv")
sort(summary(shrubs$ShrubSpp))
shrubs.01 <- subset(shrubs, shrubs$Segment == "0-1 m ")
sort(summary(shrubs.01$ShrubSpp))

# Most common species:
  # 1. CECO
  # 2. ARPA/ARVI
  # 3. CHSE
  # 4. CEIN
  # 5. CHFO
  # 6. PREM
  # 7. LIDE

### Find how many seedlings have homogenous enough shrub cover to use in shrub-ht parameterization

# Add up shrub cover per seedling for each shrub species - threshold is 75% cover of one shrub species, except for CHFO
shrubs.live <- subset(shrubs, shrubs$Dead. != 1 | is.na(shrubs$Dead.)) # exclude dead shrubs
shrub.ag <- aggregate(shrubs.live$Cover.cm, by = list(Seedling = shrubs.live$Seedling., ShrubSpp = shrubs.live$ShrubSpp), FUN = sum)
names(shrub.ag)[names(shrub.ag)=="x"] <- "Cover.cm"
shrub.ag <- na.omit(shrub.ag)
shrub.max <- aggregate(shrub.ag$Cover.cm, by = list(Seedling = shrub.ag$Seedling), FUN = max)
shrub.max <- merge(shrub.max, shrub.ag)
shrub.max <- subset(shrub.max, shrub.max$x == shrub.max$Cover.cm)
shrub.max <- shrub.max[,c(1,3,4)]
shrub.max$PerCover <- shrub.max$Cover.cm/(4*300)
shrub.max[shrub.max$Seedling == "CEIN-1",4] = shrub.max[shrub.max$Seedling == "CEIN-1",3]/900 # fix anomoly of CEIN-1 only having 3 transects
shrub.homog <- subset(shrub.max, shrub.max$PerCover > .75)
# add rows for CHFO
chfo.1 <- shrub.max[shrub.max$Seedling == "chfo-1",]
shrub.homog <- rbind(shrub.homog, chfo.1)
as.table(sort(summary(shrub.homog$ShrubSpp)))
# Check that all of the seedlings in shrub.homog have at least 75% of one species within 1 m in addition to within 3 m
shrub.homog.full <- subset(shrubs, shrubs$Seedling. %in% shrub.homog$Seedling)
shrub.homog.01 <- subset(shrub.homog.full, shrub.homog.full$Segment == "0-1 m " | shrub.homog.full$Segment == "0-1 m")
shrub.homog.01 <- merge(shrub.homog.01, shrub.homog, by.x = "Seedling.", by.y = "Seedling")
diff <- subset(shrub.homog.01, shrub.homog.01$ShrubSpp.x != shrub.homog.01$ShrubSpp.y)
diff <- aggregate(diff$Cover.cm.x, by = list(Seedling = diff$Seedling., ShrubSpp = diff$ShrubSpp.x), FUN = sum)
diff$Perc <- diff$x/400
diff.too.high <- subset(diff, diff$Perc > .25)
diff.too.high
shrub.homog <- subset(shrub.homog, !shrub.homog$Seedling %in% diff.too.high$Seedling)
shrub.homog.full <- subset(shrub.homog.full, !shrub.homog.full %in% diff.too.high$Seedling)
