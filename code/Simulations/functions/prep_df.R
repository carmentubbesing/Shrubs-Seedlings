prep_df <- function(fire, conifer_species_method, shrub_method, n_seedlings){
  load(file="../../compiled_data/fire_footprints/master_seedlings_vert.Rdata")
  dffull <- df
  
  df <- df %>%
    dplyr::select(Sdlg, Species, Cov1.3, Ht1.3, ShrubSpp03, shrubarea3, BasDia2016.cm, Ht2016.cm_spring, heatload, incidrad, Slope.Deg, Elevation, Fire, Years, Year) %>%
    filter(Year==2016) %>%
    filter(Fire == fire) %>%
    filter(!is.na(Ht2016.cm_spring)) %>%
    mutate(Cov_prop = Cov1.3/1200) %>%
    distinct() %>%
    droplevels()
  
  if(conifer_species_method == "random"){
    sample <- sample(nrow(df), nrow(df), replace = T)
    df <- df %>% 
      mutate(Species = unlist(df[sample, "Species"])) %>% 
      mutate(BasDia2016.cm = unlist(df[sample, "BasDia2016.cm"])) %>% 
      mutate(Ht2016.cm_spring = unlist(df[sample, "Ht2016.cm_spring"]))
  }
  
  # if(shrub_method == "CECO"){
  #   df <- df %>% 
  #     mutate(ShrubSpp03 = "CECO") %>% 
  #     mutate(ShrubSpp03 = as.factor(ShrubSpp03))
  # } else if(shrub_method == "ARPA"){
  #   df <- df %>% 
  #     mutate(ShrubSpp03 = "ARPA") %>% 
  #     mutate(ShrubSpp03 = as.factor(ShrubSpp03))
  # }
  
  # randomly select seedlings with replacement
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
  
  if(shrub_method %in% c("ARPA", "CECO")){
    load("../../results/coefficients/welch_ratios.Rdata")
    if(shrub_method == "ARPA") {
      welch_shrspp <- welch_shrspp %>% 
      filter(Shrub_species == "ARPA") %>% 
      mutate(prop = sum/sum(sum))
    } else if(shrub_method == "CECO"){
      welch_shrspp <- welch_shrspp %>% 
        filter(Shrub_species == "CECO") %>% 
        mutate(prop = sum/sum(sum))
    }
    df_new <- data.frame()
    for(i in 1:nrow(welch_shrspp)){
      welch_i <- welch_shrspp[i,]
      welch_prop_i <- welch_shrspp[i,"prop"] %>% unlist()
      df_i <- df %>% filter(Species == welch_i$Species & ShrubSpp03 == welch_i$Shrub_species)
      sample_i <- sample_n(df_i, size = n_seedlings*welch_prop_i, replace = T)
      
      if(nrow(sample_i)==0){
        next()
      } else if(nrow(df_new)==0){
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
    df <- df_new
  }
  
  
  return(df)
}

