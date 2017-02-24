library(dplyr)

################################################################################################
#PART 1.SEEDLING DATA EXPLORATION AND CLEANING
################################################################################################
### OPEN DATA

DATAWD <- "C:/Users/Carmen/Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Shrubs2016_Completed_Data_and_Photos/" # PC
setwd(DATAWD) 
sdlt <- read.csv("Master_Compiled_seedlings.csv")

# Check for typos 
unique(sdlt$Species)

# Correct typos and create variable for fire x patch
sdlt$Fire[sdlt$Fire=="FRED"]<- "FRDS"
sdlt$Fire[sdlt$Fire=="AMRC"]<- "AMCR"
sdlt$Species[sdlt$Species=="pipo"]<- "PIPO"
sdlt$Species[sdlt$Species=="PILA "]<- "PILA"
sdlt$FirePatch <- paste(sdlt$Fire, sdlt$Patch, sep = "-")
summary(as.factor(sdlt$FirePatch))

# The variable Ht2015 means height to beginning of 2015 growth season. See image "Seedling Diagram"
# Issue is that some values of Ht.cm are 4 cm too large 
# Check how many seedlings would be greatly affected by that difference 
hist(sdlt$Ht.cm)
short <- subset(sdlt, sdlt$Ht.cm<50)
# A lot of seedlings are affected
# Check how many of those were after I left 
summary(short$Personel)
hist(subset(short$Ht.cm, short$Personel %in% c("VF HH", " vf hh")))
# Check for impossible height values
sdlt$grth16 <- sdlt$Ht.cm - sdlt$Ht2015 - sdlt$LastYearGrth.cm
sort(sdlt$grth16)
ht.errors <- subset(sdlt, sdlt$grth16 < 0)
nrow(sdlt)
plot(sdlt$Ht.cm,sdlt$grth16)
plot(sdlt$Ht.cm,sdlt$LastYearGrth.cm)

### Error handling for now: include Ht.cm as variable in the model and use 2016 growth as the dependent variable

### Create data frame for analysis - start with no CADE
#sdlt <- sdlt[sdlt$Species!="CADE",]
sdlt <- sdlt[sdlt$Return==0,]
df <- sdlt[,c("Seedling.","Fire", "Elevation", "Species", "Slope.Deg","Aspect.deg","Ht.cm","BasDia.cm","LastYearGrth.cm","DIFN", "ImmedAboveSpp", "ImmedAboveHt.cm")]
df <- tbl_df(df)
df <- rename(df,Sdlg = Seedling.)

# Funky seedling: 17 has no growth data, intended to come back to it. Delete it from df.
df <- subset(df, df$Sdlg != "17")

################################################################################################
#PART 2.AGGREGATING SHRUB DATA BY SEEDLING 
################################################################################################
### First, rename segment variable to create simpler variable called Seg that corrects typos
shr <- read.csv("Master_Compiled_shrubs.csv")
shr <- tbl_df(shr)
shr$Dead.[is.na(shr$Dead.)] <- 0
shr$Cover.cm[is.na(shr$Cover.cm)] <- 0
shr$Ht.cm[is.na(shr$Ht.cm)] <- 0
shr <- subset(shr, shr$Dead.!= 1)
shr <- subset(shr, !shr$Seedling. %in% c("ARPA-1",  "ceco-1",  "CEIN-1", "CEIN-2","chfo-1", "DCECO-1", "DCECO-2", "DCECO-3", "LIDE-1",  "LIDE-2", "LIDE-3", "LIDE-4"))
shr$Seg <- 0
for(i in 1:nrow(shr)){
if(shr$Segment[i] %in% c("0-1 m ","0 -1 m","0-1 m")){
  shr$Seg[i] <- 1
} else if (shr$Segment[i]=="1-2 m "){
  shr$Seg[i] <- 2
} else if (shr$Segment[i] %in% c("2-3 m","2-3m")){
  shr$Seg[i] <- 3
}  else
    shr$Seg[i] <- 999
}# Takes 4 seconds

# Summarize by segment and total cover

cov <- shr %>%
  group_by(Seedling., Seg) %>%
  summarise(cov =sum(Cover.cm)) %>%
  spread(Seg, cov) %>% 
  rename(Sdlg = Seedling.) %>%
  rename(Cov1=`1`) %>%
  rename(Cov2=`2`) %>%
  rename(Cov3=`3`)

# Summarize by segment and average height
ht <- shr %>%
  group_by(Seedling., Seg) %>%
  summarise(ht =mean(Ht.cm)) %>%
  spread(Seg, ht) %>% 
  rename(Sdlg = Seedling.) %>%
  rename(Ht1=`1`) %>%
  rename(Ht2=`2`) %>%
  rename(Ht3=`3`)  

### Test - all should be TRUE
sum(shr[shr$Seedling.==10 & shr$Seg==1,]$Cover.cm) == cov[cov$Sdlg==10,2]
sum(shr[shr$Seedling.==1 & shr$Seg==3,]$Cover.cm) == cov[cov$Sdlg==1,4]
mean(shr[shr$Seedling.==10 & shr$Seg==1,]$Ht.cm) == ht[ht$Sdlg==10,2]
mean(shr[shr$Seedling.==1 & shr$Seg==3,]$Ht.cm) == ht[ht$Sdlg==1,4]

## Combine cover and ht values
shr_by_sdlg <- full_join(cov,ht,by="Sdlg")

### Find most common shrub species in 0-1, 1-2, and 2-3
spp <- shr %>%
  group_by(Seedling.,Seg, ShrubSpp) %>%
  mutate(cov=sum(Cover.cm)) %>%
  ungroup %>%
  group_by(Seedling.,Seg)%>%
  filter(cov == max(cov)) %>%
  select(Seedling.,Seg,ShrubSpp,cov) %>%
  distinct(.keep_all=TRUE)

### Restructure spp so it can be binded to df
spp2 <- spp %>%
  select(Seedling.,Seg, ShrubSpp) %>%
  group_by(Seedling.) %>%
  spread(Seg, ShrubSpp) %>%
  rename(Sdlg=Seedling.) %>%
  rename(Spp1=`1`) %>%
  rename(Spp2=`2`) %>%
  rename(Spp3=`3`)  # Check for lost seedlings
shr_by_sdlg <- full_join(shr_by_sdlg,spp2,by="Sdlg")

# Check the calculations - should be TRUE
sum(shr[shr$Seedling.==1 &shr$Seg==1 & shr$ShrubSpp=="ARPA",]$Cover.cm)== 
  spp[spp$ShrubSpp=="ARPA" & spp$Seedling.==1 & spp$Seg==1,]$cov[1]
max(spp[spp$Seedling.==1 &spp$Seg==1,]$cov) == spp[spp$Seedling.==1&spp$Seg==1,]$cov[1]

# Check that shrub seedlings match seedlings seedlings
nrow(df) - nrow(shr_by_sdlg)
setdiff(df$Sdlg, shr_by_sdlg$Sdlg)
setdiff(shr_by_sdlg$Sdlg, df$Sdlg)

################################################################################################
#PART 3. COMBINING SHRUB DATA WITH SEEDLING DATA
################################################################################################
df <- full_join(df, shr_by_sdlg, by="Sdlg")
setwd("~/Shrubs-Seedlings/Rdata")
save(df, file="master_data.Rdata")

### NEXT STEPS: ADD SLOPE VALUES AND ELEVATION VALUES WHERE THEY'RE MISSING, LOOK FOR MORE DIFN VALUES, BUILD
### A REGRESSION TREE