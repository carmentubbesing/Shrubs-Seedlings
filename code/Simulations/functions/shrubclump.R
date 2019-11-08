shrubclump <- function(){
  load(file="~/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings_vert.Rdata")
  dffull <<- df
  df <- df %>%
    dplyr::select(Sdlg, Species, Cov1.3, Ht1.3, ShrubSpp03, shrubarea3, BasDia2016.cm, Ht2016.cm_spring, heatload, incidrad, Slope.Deg, Elevation, Fire, Years, Year) %>%
    filter(Year==year) %>%
    filter(Fire == fire) %>%
    filter(!is.na(Ht2016.cm_spring)) %>%
    mutate(Cov_prop = Cov1.3/1200) %>%
    distinct() %>%
    droplevels()
  
  raster_df <<- df %>%
    dplyr::select(Sdlg, Cov1.3, Ht1.3, ShrubSpp03, heatload, incidrad, Slope.Deg, Elevation, Fire) %>%
    mutate(sqrt_shrubarea3 = sqrt(Cov1.3*Ht1.3)) %>%
    mutate(ID = Sdlg) %>%
    mutate(ID = as.numeric(paste(ID))) %>%
    dplyr::select(ID, everything()) %>%
    mutate(ShrubSppID = case_when(
      ShrubSpp03 == "ARPA" ~ 1,
      ShrubSpp03 == "CECO" ~ 2,
      ShrubSpp03 == "CHSE" ~ 3,
      ShrubSpp03 == "LIDE" ~ 4,
      ShrubSpp03 == "Other" ~ 5
    ))
  
    shrub_ID <- (sample(df$ShrubSpp03, length_m*height_m, replace = T))
    summary(as.factor(shrub_ID))
    shrub_ID <- as.numeric(shrub_ID)
    summary(as.factor(shrub_ID))
    
    xy <- matrix(shrub_ID, length_m, height_m)
    
    r <- raster(xy, xmn = 0, xmx = length_m, ymn = 0, ymx = height_m)
    crs_epsg <- CRS("+init=epsg:26910")
    crs(r) <- crs_epsg
    plot(r)
    
    focalr <- focal(r, w = matrix(1/shrub_clumpiness, nrow = shrub_clumpiness, ncol = shrub_clumpiness), pad = T, padValue = mean(r@data@values))
    plot(focalr)
    summary(getValues(focalr))
    
    # Add random small numbers to values to  make them unique
    seq <- seq(0, 0.01, length.out = length(values(focalr)))
    smallnums <- sample(seq, length(values(focalr)))
    values(focalr) <- values(focalr)+smallnums
    
    xg <- split(sort(getValues(focalr)), sort(shrub_ID))
    xg
    summary(xg)
    
    values(focalr) <- ifelse(values(focalr) %in% xg$`1`, 1, values(focalr))
    values(focalr) <- ifelse(values(focalr) %in% xg$`2`, 2, values(focalr))
    values(focalr) <- ifelse(values(focalr) %in% xg$`3`, 3, values(focalr))
    values(focalr) <- ifelse(values(focalr) %in% xg$`4`, 4, values(focalr))
    values(focalr) <- ifelse(values(focalr) %in% xg$`5`, 5, values(focalr))
    summary(as.factor(getValues(focalr)))
    
    r <<- focalr
    df_new <<- df
 }
    
    
    
    
