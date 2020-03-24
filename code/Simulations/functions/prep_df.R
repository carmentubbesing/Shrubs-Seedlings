prep_df <- function(fire, conifer_species_method, shrub_method, n_seedlings){
  load(file="../../compiled_data/fire_footprints/master_seedlings_vert.Rdata")
  load(file = "../../data/welch_CEIN_hts.Rdata")
  dffull <- df
  
  # filter and clean df
  df <- df %>%
    dplyr::select(Sdlg, Species, Cov1.3, Ht1.3, ShrubSpp03, shrubarea3, BasDia2016.cm, Ht2016.cm_spring, heatload, incidrad, Slope.Deg, Elevation, Fire, Years, Year) %>%
    filter(Year==2016) %>%
    filter(Fire == fire) %>%
    filter(!is.na(Ht2016.cm_spring)) %>%
    mutate(Cov_prop = Cov1.3/1200) %>%
    distinct() %>%
    droplevels()
  
  # Randomize where the trees are if conifer_species_method = random
  if(conifer_species_method == "random"){
    sample <- sample(nrow(df), nrow(df), replace = T)
    df <- df %>% 
      mutate(Species = unlist(df[sample, "Species"])) %>% 
      mutate(BasDia2016.cm = unlist(df[sample, "BasDia2016.cm"])) %>% 
      mutate(Ht2016.cm_spring = unlist(df[sample, "Ht2016.cm_spring"]))
  }
  
  # Randomly select seedlings with replacement
  
  # If shrub_method = "welch", then select based on proportions in welch data
  if(shrub_method=="welch"){
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
      
    }
    
    #check
    df_new %>%
      group_by(Species, ShrubSpp03) %>%
      count() %>%
      ungroup() %>%
      mutate(prop = n/sum(n))
    welch_shrspp
    
  }
  
  # If shrub_method is for a single shrub species, select only seedlings under one of those shrub species
  if(shrub_method == "empirical"){
    df_new <- sample_n(df, size = n_seedlings, replace = T)
  } else if(shrub_method == "ARPA") {
    df_new <- df %>% 
      filter(ShrubSpp03 == "ARPA") %>% 
      sample_n(size = n_seedlings, replace = T)
  } else if(shrub_method == "CECO"){
    df_new <- df %>% 
      filter(ShrubSpp03 == "CECO") %>% 
      sample_n(size = n_seedlings, replace = T) 
      
  } else if(shrub_method == "CEIN"){
    sample_hts <- sample_n(welch_CEIN_hts, size = n_seedlings, replace = T)
    df_new <- df %>% 
      filter(ShrubSpp03 == "CECO") %>% 
      sample_n(size = n_seedlings, replace = T) %>% 
      mutate(ShrubSpp03 = "CEIN") %>% 
      mutate(Ht1.3 = sample_hts$modal_ht_cm) %>% 
      mutate(shrubarea3 = Cov1.3*Ht1.3)
      
  } 

  #check
  df_new %>%
    group_by(Species, ShrubSpp03) %>%
    count() %>%
    ungroup() %>%
    mutate(prop = n/sum(n))

  df <- df_new
  
  return(df)
}

