require(raster)
require(tidyverse)
require(sf)
require(sp)
require(knitr)


initialize <- function(df, r, n_seedlings, lambda, length_m, height_m){

   pts.sf.lm <- df %>%
    rename("Ht_cm1" = Ht2016.cm_spring) %>%
    mutate(Years = as.factor(Years)) %>%
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3)) %>%
    mutate("Year"="2016") %>%
    mutate(Year = as.factor(Year)) %>%
    rename(dia.cm = BasDia2016.cm) %>%
    mutate(ShrubSpp03 = case_when(ShrubSpp03 == "CHSE" ~ "Other",
                                  TRUE ~ as.character(ShrubSpp03)))
  
  
  ## Add unique identifier since there are some repeats of Sdlg numbers 
  pts.sf.lm <- pts.sf.lm %>% 
    mutate(ID_withinrep = seq(1, nrow(pts.sf.lm)))
  
  ## Split up species
  pts.sf.abco <- pts.sf.lm %>% filter(Species == "ABCO")
  pts.sf.pipo <- pts.sf.lm %>% filter(Species == "PIPO")

  pts.sf.abco <- pts.sf.abco %>%
    mutate(Years = as.numeric(paste(Years))) %>%
    mutate(ShrubSpp03 = as.factor(paste(ShrubSpp03)))

  pts.sf.pipo <- pts.sf.pipo %>%
    mutate(Years = as.numeric(paste(Years))) %>%
    mutate(ShrubSpp03 = as.factor(paste(ShrubSpp03)))
  
  pts <- list(pts.sf.abco, pts.sf.pipo)
  return(pts)
}
