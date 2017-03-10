### GOAL: FIND RELATIONSHIP BETWEEN ABCO GROWTH, ABCO HT, SHRUB COVER TOTAL, SHRUB HEIGHTS

############################################################################################
### DATA AGGREGATION AND PREP
############################################################################################

## INITIAL SETUP: SAME AS "Look_at_data_so_far.R"
#setwd("~/Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Completed_Data") # Mac
setwd("C:/Users/Carmen/Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Shrubs2016_Completed_Data_and_Photos/") # PC
seedlings.light <- read.csv("Master_Compiled_Jul30_1204_seedlings.csv")
shrubs <- read.csv("Master_Compiled_Jul30_1204_shrubs.csv")
# Check for typos 
unique(seedlings.light$Species)
# Fix doubly named fires
seedlings.light$Fire[seedlings.light$Fire=="FRED"]<- "FRDS"; seedlings.light$Fire[seedlings.light$Fire=="AMRC"]<- "AMCR"
# Create variable for fire x patch
seedlings.light$Fire.Patch <- paste(seedlings.light$Fire, seedlings.light$Patch, sep = "-")
# Separate out by seedling species
abco <- subset(seedlings.light, seedlings.light$Species == "ABCO" & seedlings.light$Ht.cm > 0)

# COMBINE SHRUB AND SEEDLING DATA
shrubs.abco <- subset(shrubs, shrubs$Seedling. %in% abco$Seedling)
# Check that they're the same seedlings in both data files
sort(unique(abco$Seedling))
sort(unique(shrubs.abco$Seedling.))
setdiff(sort(unique(abco$Seedling)), sort(unique(shrubs.abco$Seedling.)))
setdiff(sort(unique(shrubs.abco$Seedling.)),sort(unique(abco$Seedling)))

### Aggregate shrub data to find total cover at each segment
# Separate shrub data by segment
segment.names <- names(summary(shrubs.abco$Segment))
shrubs.abco.01 <- subset(shrubs.abco, shrubs.abco$Segment %in% segment.names[1:3])
shrubs.abco.12 <- subset(shrubs.abco, shrubs.abco$Segment == "1-2 m ")
shrubs.abco.23 <- subset(shrubs.abco, shrubs.abco$Segment %in% segment.names[5:6])
# Why are the lengths of the above different? Because there's a record for each shrub, not seedling
setdiff(shrubs.abco.12$Seedling., shrubs.abco.01$Seedling.)
setdiff(shrubs.abco.01$Seedling., shrubs.abco.12$Seedling.)
# Add up species cover segment
shrubs.abco.01.sum <- aggregate(shrubs.abco.01$Cover.cm, by = list(Seedling = shrubs.abco.01$Seedling.), FUN = sum)
shrubs.abco.12.sum <- aggregate(shrubs.abco.12$Cover.cm, by = list(Seedling = shrubs.abco.12$Seedling.), FUN = sum)
shrubs.abco.23.sum <- aggregate(shrubs.abco.23$Cover.cm, by = list(Seedling = shrubs.abco.23$Seedling.), FUN = sum)
# Combine shrub cover by segment with seedling data frame
names(abco)[names(abco)=="Seedling."] <- "Seedling"
# for 0-1 m segment
abco <- merge(abco,shrubs.abco.01.sum, by = "Seedling")
names(abco)[names(abco)=="x"] <- "cov01"
# for 1-2 m segment
abco <- merge(abco,shrubs.abco.12.sum, by = "Seedling")
names(abco)[names(abco)=="x"] <- "cov12"
# for 2-3 m segment
abco <- merge(abco,shrubs.abco.23.sum, by = "Seedling")
names(abco)[names(abco)=="x"] <- "cov23"

# Test by spot checking
subset(abco, abco$Seedling == "107")$cov01
sum(subset(shrubs.abco, shrubs.abco$Seedling == "107" & shrubs.abco$Segment %in% segment.names[1:3])$Cover.cm)
subset(abco, abco$Seedling == "95")$cov12
sum(subset(shrubs.abco, shrubs.abco$Seedling == "95" & shrubs.abco$Segment %in% segment.names[4])$Cover.cm)
subset(abco, abco$Seedling == "94")$cov23
sum(subset(shrubs.abco, shrubs.abco$Seedling == "94" & shrubs.abco$Segment %in% segment.names[5:6])$Cover.cm)

# Make variables for cover from 0-2 and 0-3
abco$cov02 <- abco$cov01+abco$cov12
abco$cov03 <- abco$cov01+abco$cov12+abco$cov23

# Replace NAs with 0
abco$cov01[is.na(abco$cov01)] <- 0
abco$cov12[is.na(abco$cov12)] <- 0
abco$cov23[is.na(abco$cov23)] <- 0
abco$cov02[is.na(abco$cov02)] <- 0
abco$cov03[is.na(abco$cov03)] <- 0

###########################################
### Add shrub ht data


##############################################################################################################
### ANALYSIS
##############################################################################################################

library(nlme)
M1 <- lme(LastYearGrth.cm ~ Ht.cm + cov01, random = ~1|Fire, data = abco)
summary(M1)


