prep_raster_df <- function(fire, df){
 
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