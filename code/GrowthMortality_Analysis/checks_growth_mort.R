## ------------------------------------------------------------------------
require(tidyverse)
require(dplR)


## ------------------------------------------------------------------------
setwd("~/Shrubs-Seedlings/code/GrowthMortality_Analysis/")
load("../../compiled_data/growth_mortality/df_vert.Rdata")


## ------------------------------------------------------------------------
df %>% group_by(SPECIES, DEAD) %>% summarize(n())


## ------------------------------------------------------------------------
check_mates <- df %>% group_by(PAIR) %>% filter(n() != 2)
nrow(check_mates) ==0


## ------------------------------------------------------------------------
df_duplicates <- df
df_duplicates %>% 
  filter(duplicated(SEEDLING)) %>% nrow() ==0


## ------------------------------------------------------------------------
df_missing <- df
df_missing %>% 
  filter(is.na(LAST_YR_GR_cm) | is.na(MINUS_1_GR_cm) | is.na(MINUS_2_GR_cm)) %>% 
  dplyr::select(SEEDLING, LAST_YR_GR_cm, MINUS_1_GR_cm, MINUS_2_GR_cm, NOTES, Notes) %>% 
  nrow()==0


## ------------------------------------------------------------------------
df %>% 
  filter(BAS_DIA_AVE != (BAS_DIA_1_mm + BAS_DIA_2_mm)/2) %>% nrow() ==0


## ------------------------------------------------------------------------
files <- list.files("../../../../Dropbox (Stephens Lab)/SORTIE/Growth_mortality/data/Growth Mortality Dendro Data/", full.names = T, pattern = ".raw")
sample <- sample(length(files), 1)
file <- files[sample]
rwl <- read.rwl(file)


## ------------------------------------------------------------------------
series_sample <- sample(names(rwl), 1)
series_sample_data <- as.data.frame(rwl)[series_sample]
series_sample_data


## ------------------------------------------------------------------------
remove(df)
load(file = "../../compiled_data/dendro_joined.Rdata")
compiled_dendro <- df
remove(rwl)
load(file = "../../compiled_data/rwl_joined.Rdata")
compiled_rwl <- rwl


## ------------------------------------------------------------------------
compiled_dendro %>% filter(series==series_sample)
series_sample_data
as.data.frame(compiled_rwl)[series_sample]

