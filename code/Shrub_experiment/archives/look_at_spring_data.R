library(readxl)
library(tidyr)
library(dplyr)


setwd("/Users/Carmen/Dropbox (Stephens Lab)/Shrub_experiment/Data/")
dia <- read_excel("Compiled/Data_compiled_20170830.xlsx",sheet=2,col_names = T)
dia <- dia[1:12]
summary(as.factor(dia$species))
hist(dia[dia$species=="PIPO",]$`dm at base 1 (mm)`)
hist(dia[dia$species=="ABCO",]$`dm at base 1 (mm)`)
summary <- dia %>%
  group_by(compartment, island, plot,species) %>%
  summarise(n=length(`dm at base 1 (mm)`))
hist(summary[summary$species=="ABCO",]$n, breaks=20)
hist(summary[summary$species=="PIPO",]$n, breaks=20)
nrow(dia[dia$species=="ABCO",])
nrow(dia[dia$species=="PIPO",])

