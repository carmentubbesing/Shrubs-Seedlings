require(raster)
require(tidyverse)
require(sf)
require(sp)
require(knitr)

initialize <- function(){
  load(file="~/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings_vert.Rdata")
  dffull <<- df
  df <- df %>% 
    dplyr::select(Sdlg, Species, Cov1.3, Ht1.3, ShrubSpp03, shrubarea3, BasDia2016.cm, Ht2016.cm_spring, heatload, incidrad, Slope.Deg, Elevation, Fire, Years, Year) %>% 
    filter(Year=="2016") %>% 
    filter(Fire == "AMRC") %>% 
    filter(!is.na(Ht2016.cm_spring)) %>% 
    mutate(Cov_prop = Cov1.3/1200) %>% 
    distinct()
  
  values <- as.numeric(paste(sample(df$Sdlg, 400, replace = T)))
  xy <- matrix(values, 20,20)
  r <- raster(xy, xmn = 0, xmx = 20, ymn = 0, ymx = 20)
  crs_epsg <- CRS("+init=epsg:26910")
  crs(r) <- crs_epsg
  r <<- r
  
  p <- as(extent(r), "SpatialPolygons")
  crs(p) <- crs(r)
  p <<- p
  
  x.left <- 0.5+rpois(10,2.5)
  x.right <- 19.5-rpois(10,2.5)
  y.bottom <- 0.5+rpois(10,2.5)
  y.top <- 19.5-rpois(10,2.5)
  x <- sample(c(x.left, x.right), 20)
  y <- sample(c(y.top, y.bottom), 20)
  
  left.edge <- cbind(x = x.left, y = (0.5 + sample(c(0:19), 10)))
  right.edge <- cbind(x = x.right, y = (0.5 +sample(c(0:19), 10)))
  
  top.edge <- cbind(x =  c(0.5 + sample(c(1:19), 10)), y = y.top)
  bottom.edge <- cbind(x = c(0.5 + sample(c(1:19), 10)),  y = y.bottom)
  
  edges <- rbind(left.edge, right.edge, top.edge, bottom.edge)
  pts.xy <- edges
  
  pts.sp <- SpatialPoints(coords = pts.xy[,c("x", "y")], proj4string = crs(p))
  pts.sf <- as(pts.sp, "sf")
  
  pts.sf <- pts.sf %>% 
    mutate(Sdlg = raster::extract(r, as(pts.sf, "Spatial")))
  
  pts.sf <- pts.sf %>% 
    mutate(Sdlg = as.factor(Sdlg))
  pts.sf <- left_join(pts.sf, df)
  
  pts.sf.lm <- pts.sf %>% 
    rename("Ht_cm1" = Ht2016.cm_spring) %>% 
    mutate(Years = as.factor(Years)) %>% 
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3)) %>% 
    mutate("Year"="2016") %>% 
    mutate(Year = as.factor(Year)) %>% 
    mutate(ShrubSpp03 = case_when(ShrubSpp03 == "CHSE" ~ "Other",
                                  TRUE ~ as.character(ShrubSpp03))) 
  
  pts.sf.abco <- pts.sf.lm %>% filter(Species == "ABCO")
  pts.sf.pipo <- pts.sf.lm %>% filter(Species == "PIPO")
  
  source("functions/normalize.R")
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(Years = as.numeric(paste(Years))) %>% 
    mutate(Ht_cm_nonnorm = as.factor(paste(Ht_cm1))) %>% 
    mutate(Years_nonnorm = as.factor(paste(Years))) %>% 
    mutate_if(is.numeric, normalize) %>% 
    mutate(ShrubSpp03 = as.factor(paste(ShrubSpp03))) %>% 
    mutate(Ht_cm_nonnorm = as.numeric(paste(Ht_cm_nonnorm)))%>% 
    mutate(Years_nonnorm = as.numeric(paste(Years_nonnorm)))
  
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(Years = as.numeric(paste(Years))) %>% 
    mutate(Ht_cm_nonnorm = as.factor(paste(Ht_cm1))) %>% 
    mutate(Years_nonnorm = as.factor(paste(Years))) %>% 
    mutate_if(is.numeric, normalize) %>% 
    mutate(ShrubSpp03 = as.factor(paste(ShrubSpp03))) %>% 
    mutate(Ht_cm_nonnorm = as.numeric(paste(Ht_cm_nonnorm)))%>% 
    mutate(Years_nonnorm = as.numeric(paste(Years_nonnorm)))
  
}
