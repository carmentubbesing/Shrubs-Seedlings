library(readxl)
library(tidyr)
library(dplyr)
setwd("/Users/Carmen/Dropbox (Stephens Lab)/Shrub_experiment/Data/")
messydata <- read_excel("plots.xlsx",sheet=1,col_names = T)
cleandata <- messydata %>%
  rename(Transect1Cov=`Transect 1 cov (cm)`) %>%
  rename(Transect2Cov=`Transect 2 cov (cm)`) %>%
  select(1:10)

cover <- cleandata %>%
  select(-`Transect 2 ht (cm)`,-`Transect 1 ht (cm)`) %>%
  gather(key=Transect,value=Cover,Transect1Cov, Transect2Cov)

cover$Transect <- as.factor(cover$Transect)
cover$Transect <- ifelse(cover$Transect=="Transect1Cov", "N","S")

heights <- cleandata %>%
  select(-`Transect1Cov`,-`Transect2Cov`)%>%
  gather(key = Transect, value = Height, `Transect 2 ht (cm)`, `Transect 1 ht (cm)`)

heights$Transect <- as.factor(heights$Transect)
heights$Transect <- ifelse(heights$Transect=="Transect 1 ht (cm)", "N","S")

cleandata <- full_join(cover, heights)%>%
  select(Compartment, Island, Plot, Transect, `Shrub species`, Cover, Height, Date)
write.csv(cleandata, "shrubs_initial_plots.csv", row.names = F)
