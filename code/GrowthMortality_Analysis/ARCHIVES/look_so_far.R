library(readxl)
library(ggplot2)
library(dplyr)
df <- read_excel("~/../Dropbox (Stephens Lab)/SORTIE/Growth_mortality/data/details/compiled/Mort_details_compiled_Sep08_2017.xlsx", sheet = 2)
df$HEIGHT <- as.numeric(df$HEIGHT)
df <- df %>%
  mutate(SPECIES = ifelse(SPECIES == "pipo","PIPO",SPECIES)) %>% 
  mutate(SPECIES = ifelse(SPECIES == "abco","ABCO",SPECIES)) %>% 
  mutate(DEAD_ALIVE = toupper(DEAD_ALIVE)) %>% 
  filter(SEEDLING != "2")
  
summary(as.factor(df$SPECIES))

df <- df %>% 
  filter(PATH_DAMAGE != 1) %>% 
  filter(DEAD_ALIVE == "DEAD")

ggplot(df)+
  geom_histogram(aes(x = HEIGHT, col = SPECIES, fill = SPECIES), stat = "bin", position = position_dodge(width=20), alpha = .5, binwidth = 25)+
  scale_x_continuous(breaks = seq(0,175,25))

nrow(df)
