
require(tidyverse)
require(sf)
require(knitr)


initialize <- function(df, r, n_seedlings, lambda, length_m, height_m, shrub_method){

  # randomly select seedlings with replacement
    load("../../results/coefficients/welch_ratios.Rdata")
    welch_shrspp <- welch_shrspp %>% 
      dplyr::select(-sum, -total)
    
    df_new <- data.frame()
    for(i in 1:nrow(welch_shrspp)){
      welch_i <- welch_shrspp[i,]
      welch_prop_i <- welch_shrspp[i,"prop"] %>% unlist()
      df_i <- df %>% filter(Species == welch_i$Species & ShrubSpp03 == welch_i$Shrub_species)
      sample_i <- sample_n(df_i, size = n_seedlings*welch_prop_i, replace = T)
      
      if(nrow(df_new)==0){
        df_new <- sample_i
      } else{
        df_new <- full_join(df_new, sample_i)    
      }
    
    #check
    df_new %>%
      group_by(Species, ShrubSpp03) %>%
      count() %>%
      ungroup() %>%
      mutate(prop = n/sum(n))
    welch_shrspp

  }
  pts.sf.lm <- df_new %>%
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
