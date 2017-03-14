## Must load dataframe from the script Seedlings_15PlotVariables before doing this:

setwd("C:/Users/Carmen/Dropbox (Stephens Lab)/Last_Chance/Data/2015_Compiled_Data")
seedlings <- read.csv(file="Seedlings_ages_20170310.csv")
seedlings0 <- subset(seedlings, seedlings$Age==1)
seedlings0_shrubs <- subset(seedlings0, seedlings0$Plot %in% 
                              Plots.97[Plots.97$Perc.Shrub>.2,]$Plot)
nrow(seedlings0_shrubs)
