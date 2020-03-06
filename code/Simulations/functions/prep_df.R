prep_df <- function(fire, conifer_species_method, shrub_method){
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
  
  if(shrub_method == "CECO"){
    df <- df %>% 
      mutate(ShrubSpp03 = "CECO") %>% 
      mutate(ShrubSpp03 = as.factor(ShrubSpp03))
  } else if(shrub_method == "ARPA"){
    df <- df %>% 
      mutate(ShrubSpp03 = "ARPA") %>% 
      mutate(ShrubSpp03 = as.factor(ShrubSpp03))
  }
  
  if(shrub_method == "CHSE"){
    df <- df %>% 
      mutate(ShrubSpp03 = "CHSE") %>% 
      mutate(ShrubSpp03 = as.factor(ShrubSpp03))
  }
  
  return(df)
}

