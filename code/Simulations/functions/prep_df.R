prep_df <- function(fire, conifer_species_method){
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
    df <- df %>% 
      mutate(Species = sample(df$Species, nrow(df)))
  }
  
  return(df)
}


ggplot(df)+
  geom_histogram(aes(x = shrubarea3, fill = Species))

anova(lm(shrubarea3 ~ Species, data = df))
