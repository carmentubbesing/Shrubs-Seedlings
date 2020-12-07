prep_df <- function(fire, conifer_species_method, shrub_method, shrub_initial_index, n_seedlings){
  load(file="../../../compiled_data/fire_footprints/master_seedlings_vert.Rdata")
  load(file = "../../../data/welch_CEIN_hts.Rdata")
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
  
  # lump CHSE in with Other
  df <- df %>% 
    mutate(ShrubSpp03 = ifelse(ShrubSpp03 == "CHSE", "Other", paste(ShrubSpp03)))
  summary(as.factor(df$ShrubSpp03))
  
  # Check how many have emerged
  df %>% 
    rename("Ht_cm1" = Ht2016.cm_spring) %>%
    mutate(emerged = ifelse(
      Ht_cm1*0.75 < Ht1.3, 0, 1
    )) %>% 
    filter(emerged == 1)
  
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
  if(shrub_method %in% c("welch", "min", "median", "max")){
    load("../../../results/coefficients/welch_ratios.Rdata")
  
    df_new <- data.frame()
    
    for(i in 1:nrow(welch_ratios)){
      welch_i <- welch_ratios[i,]
      welch_prop_i <- welch_ratios[i,"prop"] %>% unlist()
      df_i <- df %>% filter(Species == welch_i$Species & ShrubSpp03 == welch_i$Shrub_species) # There are no places in my data where CHSE co-occurs with PIPO
      
      if(welch_i$Shrub_species == "CEIN"){
        df_i <- df %>% 
          filter(Species == welch_i$Species & ShrubSpp03 == "CECO") %>% 
          mutate(ShrubSpp03 = "CEIN") 
        
        sample_hts <- sample_n(welch_CEIN_hts, size = nrow(df_i), replace = T)
        
        df_i <- df_i %>% 
          mutate(Ht1.3 = sample_hts$modal_ht_cm) %>% 
          mutate(shrubarea3 = Cov1.3*Ht1.3)
      }
      
      sample_i <- sample_n(df_i, size = round(n_seedlings*welch_prop_i), replace = T)
      
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
      mutate(prop = n/sum(n)) %>% 
      arrange(ShrubSpp03) %>% 
      dplyr::select(ShrubSpp03, everything())
    
    welch_ratios
    
  }
  
  # If shrub method = min, then set shrub cover, height and area to minimum values for that tree species
  if(shrub_method == "min"){
    df_new <- df_new %>% 
      mutate(shrubarea3 = case_when(
        Species == "ABCO" ~ min(dffull[dffull$Species == "ABCO", "shrubarea3"]) %>% unlist,
        Species == "PIPO" ~ min(dffull[dffull$Species == "PIPO", "shrubarea3"]) %>% unlist,
        TRUE ~ 999
      )) %>% 
      mutate(Ht1.3 = case_when(
        Species == "ABCO" ~ min(dffull[dffull$Species == "ABCO", "Ht1.3"]) %>% unlist,
        Species == "PIPO" ~ min(dffull[dffull$Species == "PIPO", "Ht1.3"]) %>% unlist,
        TRUE ~ 999
      )) %>% 
      mutate(Cov1.3 = case_when(
        Species == "ABCO" ~ min(dffull[dffull$Species == "ABCO", "Cov1.3"]) %>% unlist,
        Species == "PIPO" ~ min(dffull[dffull$Species == "PIPO", "Cov1.3"]) %>% unlist,
        TRUE ~ 999
    ))
    
  }
  
  if(shrub_method == "median"){
    df_new <- df_new %>% 
      mutate(shrubarea3 = case_when(
        Species == "ABCO" ~ median(dffull[dffull$Species == "ABCO", "shrubarea3"] %>% unlist),
        Species == "PIPO" ~ median(dffull[dffull$Species == "PIPO", "shrubarea3"] %>% unlist),
        TRUE ~ 999
      )) %>% 
      mutate(Ht1.3 = case_when(
        Species == "ABCO" ~ median(dffull[dffull$Species == "ABCO", "Ht1.3"] %>% unlist),
        Species == "PIPO" ~ median(dffull[dffull$Species == "PIPO", "Ht1.3"] %>% unlist),
        TRUE ~ 999
      )) %>% 
      mutate(Cov1.3 = case_when(
        Species == "ABCO" ~ median(dffull[dffull$Species == "ABCO", "Cov1.3"] %>% unlist),
        Species == "PIPO" ~ median(dffull[dffull$Species == "PIPO", "Cov1.3"] %>% unlist),
        TRUE ~ 999
      ))
    
  }
  
  if(shrub_method == "max"){
    df_new <- df_new %>% 
      mutate(shrubarea3 = case_when(
        Species == "ABCO" ~ max(dffull[dffull$Species == "ABCO", "shrubarea3"]) %>% unlist,
        Species == "PIPO" ~ max(dffull[dffull$Species == "PIPO", "shrubarea3"]) %>% unlist,
        TRUE ~ 999
      )) %>% 
      mutate(Ht1.3 = case_when(
        Species == "ABCO" ~ max(dffull[dffull$Species == "ABCO", "Ht1.3"]) %>% unlist,
        Species == "PIPO" ~ max(dffull[dffull$Species == "PIPO", "Ht1.3"]) %>% unlist,
        TRUE ~ 999
      )) %>% 
      mutate(Cov1.3 = case_when(
        Species == "ABCO" ~ max(dffull[dffull$Species == "ABCO", "Cov1.3"]) %>% unlist,
        Species == "PIPO" ~ max(dffull[dffull$Species == "PIPO", "Cov1.3"]) %>% unlist,
        TRUE ~ 999
      ))
    
  }
  
  # If shrub_method is for a single shrub species, select only seedlings under one of those shrub species
  if(shrub_method == "ARPA") {
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

  # If shrub_initial_index is for a single shrub species, reassign shrub initial cover, ht, and index
  if(shrub_initial_index == "ARPA") {
    new_shrub_data <- df %>% 
      filter(ShrubSpp03 == "ARPA") %>% 
      dplyr::select(Ht1.3, Cov1.3, shrubarea3) %>% 
      sample_n(size = nrow(df_new), replace = T)
    
  } else if(shrub_initial_index == "CECO"){
    new_shrub_data <- df %>% 
      filter(ShrubSpp03 == "CECO") %>% 
      dplyr::select(Ht1.3, Cov1.3, shrubarea3) %>% 
      sample_n(size = nrow(df_new), replace = T)
    
  } else if(shrub_initial_index == "CEIN"){
    sample_hts <- sample_n(welch_CEIN_hts, size = nrow(df_new), replace = T)
    new_shrub_data <- df %>% 
      filter(ShrubSpp03 == "CECO") %>% 
      sample_n(size = nrow(df_new), replace = T) %>% 
      mutate(ShrubSpp03 = "CEIN") %>% 
      mutate(Ht1.3 = sample_hts$modal_ht_cm) %>% 
      mutate(shrubarea3 = Cov1.3*Ht1.3)
  } 
  
  if(shrub_initial_index %in% c("ARPA", "CECO", "CEIN")){
    df_new <- df_new %>% 
      mutate(Cov1.3 = new_shrub_data$Cov1.3) %>% 
      mutate(Ht1.3 = new_shrub_data$Ht1.3) %>% 
      mutate(shrubarea3 = new_shrub_data$shrubarea3)  
  }

  #check
  df_new %>%
    group_by(Species, ShrubSpp03) %>%
    count() %>%
    ungroup() %>%
    mutate(prop = n/sum(n))

  df_new %>% 
    group_by(Species) %>% 
    summarize(mean(Ht1.3), max(Ht1.3))
  
  df <- df_new
  
  return(df)
}

