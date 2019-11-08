require(raster)
require(tidyverse)
require(sf)
require(sp)
require(knitr)


initialize <- function(){

  for(i in 1:length(r@data@values)){
   if(r@data@values[i] == 1){
     r@data@values[i] <- as.numeric(sample(unlist(raster_df %>% filter(ShrubSppID==1) %>% dplyr::select(ID)), 1))
   }
    if(r@data@values[i] == 2){
      r@data@values[i] <- as.numeric(sample(unlist(raster_df %>% filter(ShrubSppID==2) %>% dplyr::select(ID)), 1))
    }
    if(r@data@values[i] == 3){
      r@data@values[i] <- as.numeric(sample(unlist(raster_df %>% filter(ShrubSppID==3) %>% dplyr::select(ID)), 1))
    }
    if(r@data@values[i] == 4){
      r@data@values[i] <- as.numeric(sample(unlist(raster_df %>% filter(ShrubSppID==4) %>% dplyr::select(ID)), 1))
    }
    if(r@data@values[i] == 5){
      r@data@values[i] <- as.numeric(sample(unlist(raster_df %>% filter(ShrubSppID==5) %>% dplyr::select(ID)), 1))
    }

  }

  r <- ratify(r)

  rat <- levels(r)[[1]]
  rat <- left_join(rat, raster_df)
  levels(r) <- rat
  r <<- r

  p <- as(extent(r), "SpatialPolygons")
  crs(p) <- crs(r)
  p <<- p


  x.left <- 0.5 + rpois(n_seedlings/2, lambda)
  x.right <- length_m-.5 - rpois(n_seedlings/2, lambda)
  y.bottom <- 0.5 + rpois(n_seedlings/2, lambda)
  y.top <- height_m -0.5 - rpois(n_seedlings/2, lambda)
  x <- sample(c(x.left, x.right), n_seedlings)
  y <- sample(c(y.top, y.bottom), n_seedlings)


  left.edge.y <- 0.5 + sample(x = c(0:(height_m-.5)), size = length(x.left), replace = T)
  right.edge.y <- 0.5 + sample(x = c(0:(height_m-.5)), size = length(x.right), replace = T)

  top.edge.x <- 0.5 + sample(x = c(0:(length_m-.5)), size = length(y.top), replace = T)
  bottom.edge.x <- 0.5 + sample(x = c(0:(length_m-.5)), size = length(y.bottom), replace = T)

  left.edge <- cbind(x = x.left, y = left.edge.y)
  right.edge <- cbind(x = x.right, y = right.edge.y)

  top.edge <- cbind(x = top.edge.x, y = y.top)
  bottom.edge <- cbind(x = bottom.edge.x,  y = y.bottom)

  edges <- rbind(left.edge, right.edge, top.edge, bottom.edge)
  pts.xy <- edges

  pts.sp <- SpatialPoints(coords = pts.xy[,c("x", "y")], proj4string = crs(p))
  pts.sf <- as(pts.sp, "sf")

  pts.sf <- pts.sf %>%
    mutate(Sdlg = raster::extract(r, as(pts.sf, "Spatial")))

  pts.sf <- pts.sf %>%
    mutate(Sdlg = as.factor(Sdlg))
  pts.sf <- left_join(pts.sf, df_new) # THIS LINE IS CAUSING PROBLEMS

  pts.sf.lm <- pts.sf %>%
    rename("Ht_cm1" = Ht2016.cm_spring) %>%
    mutate(Years = as.factor(Years)) %>%
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3)) %>%
    mutate("Year"="2016") %>%
    mutate(Year = as.factor(Year)) %>%
    mutate(dia.cm = BasDia2016.cm) %>%
    mutate(ShrubSpp03 = case_when(ShrubSpp03 == "CHSE" ~ "Other",
                                  TRUE ~ as.character(ShrubSpp03)))

  pts.sf.abco <- pts.sf.lm %>% filter(Species == "ABCO")
  pts.sf.pipo <- pts.sf.lm %>% filter(Species == "PIPO")

  pts.sf.abco <<- pts.sf.abco %>%
    mutate(Years = as.numeric(paste(Years))) %>%
    mutate(ShrubSpp03 = as.factor(paste(ShrubSpp03)))

  pts.sf.pipo <<- pts.sf.pipo %>%
    mutate(Years = as.numeric(paste(Years))) %>%
    mutate(ShrubSpp03 = as.factor(paste(ShrubSpp03)))

}
