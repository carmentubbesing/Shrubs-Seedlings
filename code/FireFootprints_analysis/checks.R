## ---- include = F--------------------------------------------------------
require(readxl)
require(dplyr)
require(tidyverse)


## ------------------------------------------------------------------------
setwd("~/Shrubs-Seedlings/code/FireFootprints_analysis/tests/")


## ------------------------------------------------------------------------
load("../../../compiled_data/fire_footprints/master_seedlings.Rdata")


## ------------------------------------------------------------------------
dups <- df %>% 
  group_by(Sdlg) %>% 
  filter(n()>1)
nrow(dups)==0


## ------------------------------------------------------------------------
boo <- (function(x) x[sapply(x, nrow)>0])(lapply(lapply(dups, function(x) tapply(x, dups$Sdlg, function(x) x[1]!=x[2])), function(x) subset(dups, Sdlg %in% names(which(x)))))
print(boo)


## ------------------------------------------------------------------------
load("../../../compiled_data/fire_footprints/seedlings_cleaned_2016.Rdata")
df_seedlings <- df
remove(df)
load("../../../compiled_data/fire_footprints/shrub_master_data_2016.Rdata")


## ------------------------------------------------------------------------
mismatch <- anti_join(shr_by_sdlg, df_seedlings)
mismatch


## ------------------------------------------------------------------------
original_seedlings <- read.csv("~/../Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Completed_Data_and_Photos/Master_Compiled_seedlings.csv")
mismatch <- mismatch %>% dplyr::select(-Species)
mismatch <- left_join(mismatch, original_seedlings, by = c("Sdlg" = "Seedling."))
mismatch <- mismatch %>% 
  filter(Species %in% c("PIPO", "ABCO")) %>% 
  dplyr::select(Sdlg, Fire, Patch, DataSheet, Note1, Note2)


## ------------------------------------------------------------------------
mismatch <- mismatch %>% filter(Sdlg != "16")
nrow(mismatch %>% filter()) == 0


## ------------------------------------------------------------------------
remove(df_seedlings,original_seedlings, shr_by_sdlg)


## ------------------------------------------------------------------------
load("../../../compiled_data/fire_footprints/master_seedlings_vert.Rdata")


## ------------------------------------------------------------------------
check_years <- df %>% 
  group_by(Fire, Years, Year) %>% 
  summarize(n()) %>% 
  mutate(Year = as.numeric(paste(Year))) %>% 
  mutate(Fire_year = Year-Years) %>% 
  mutate(check = ifelse(Fire == "AMRC" & Fire_year==2008, 0, 1)) %>% 
  mutate(check = ifelse(Fire == "CLVD" & Fire_year==1992, 0, check)) %>% 
  mutate(check = ifelse(Fire == "FRDS" & Fire_year==2004, 0, check)) %>% 
  mutate(check = ifelse(Fire == "STAR" & Fire_year==2001, 0, check)) %>% 
  mutate(check = ifelse(Fire == "WRTS" & Fire_year==1981, 0, check))
sum(check_years$check)==0


## ------------------------------------------------------------------------
siteclass <- df$siteclass
all(siteclass %in% c(2,3,4,6))


## ------------------------------------------------------------------------
load("../../../compiled_data/fire_footprints/pine_vert.Rdata")
sort(names(df))


## ------------------------------------------------------------------------
set.seed(12345)
sample <- sort(sample(1:251, 10))
sample
dfsample <- df[sample,] %>% 
  select(Sdlg, Fire, FirePatch, Datasheet1_2016, Datasheet2_2016, Light_File, DataSheet2017, Notes2017, Note1_2016, Note2_2016, everything()) %>% 
  arrange(Fire, Sdlg)


## ------------------------------------------------------------------------
check1 <- t(dfsample[1,])
check1[1,]
write.csv(check1, file = "check1.csv")


## ------------------------------------------------------------------------
check3 <- t(dfsample[3,])
check3[1,]
write.csv(check3, file = "check3.csv")


## ------------------------------------------------------------------------
check4 <- t(dfsample[4,])
check4[1,]
write.csv(check4, file = "check4.csv")

