prep_raster_df <- function(fire){
  load(file="~/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings_vert.Rdata")
  dffull <- df
  df <- df %>%
    dplyr::select(Sdlg, Species, Cov1.3, Ht1.3, ShrubSpp03, shrubarea3, BasDia2016.cm, Ht2016.cm_spring, heatload, incidrad, Slope.Deg, Elevation, Fire, Years, Year) %>%
    filter(Year==2016) %>%
    filter(Fire == fire) %>%
    filter(!is.na(Ht2016.cm_spring)) %>%
    mutate(Cov_prop = Cov1.3/1200) %>%
    distinct() %>%
    droplevels()
  
  ggplot(df, aes(BasDia2016.cm))+
    geom_histogram(aes(fill = Species), bins = 20, position = "dodge")+
    theme_minimal()
  
  raster_df <- df %>%
    dplyr::select(Sdlg, Cov1.3, Ht1.3, ShrubSpp03, heatload, incidrad, Slope.Deg, Elevation, Fire) %>%
    mutate(sqrt_shrubarea3 = sqrt(Cov1.3*Ht1.3)) %>%
    mutate(ID = Sdlg) %>%
    mutate(ID = as.numeric(paste(ID))) %>%
    dplyr::select(ID, everything())
  
  if(fire=="AMRC"){
    raster_df <- raster_df %>% 
      mutate(ShrubSppID = case_when(
        ShrubSpp03 == "ARPA" ~ 1,
        ShrubSpp03 == "CECO" ~ 2,
        ShrubSpp03 == "CHSE" ~ 3,
        ShrubSpp03 == "LIDE" ~ 4,
        ShrubSpp03 == "Other" ~ 5
      ))
  }
  
  if(fire=="STAR"){
    raster_df <- raster_df %>% 
      mutate(ShrubSppID = case_when(
        ShrubSpp03 == "CEIN" ~ 1,
        ShrubSpp03 == "CECO" ~ 2,
        ShrubSpp03 == "PREM" ~ 3,
        ShrubSpp03 == "Other" ~ 4
      ))
  }
  return(raster_df)
}