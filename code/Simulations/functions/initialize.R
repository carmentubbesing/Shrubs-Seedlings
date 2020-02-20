require(raster)
require(tidyverse)
require(sf)
require(sp)
require(knitr)


initialize <- function(df, r, n_seedlings, lambda, length_m, height_m){
 
  # Create a square polygon surrounding the raster 
  p <- as(extent(r), "SpatialPolygons")
  crs(p) <- crs(r)

  # Disperse seedlings inside that polygon using a poisson dispersal kernel
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
  
  # Figure out which raster cell those points fall onto and assign the points the corresponding Sdlg #
  pts.sf <- pts.sf %>%
    mutate(Sdlg = raster::extract(r, as(pts.sf, "Spatial")))

  pts.sf <- pts.sf %>%
    mutate(Sdlg = as.factor(Sdlg))
  
  # Join points with seedling data
  pts.sf <- left_join(pts.sf, df) 
  pts.sf.lm <- pts.sf %>%
    rename("Ht_cm1" = Ht2016.cm_spring) %>%
    mutate(Years = as.factor(Years)) %>%
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3)) %>%
    mutate("Year"="2016") %>%
    mutate(Year = as.factor(Year)) %>%
    rename(dia.cm = BasDia2016.cm) %>%
    mutate(ShrubSpp03 = case_when(ShrubSpp03 == "CHSE" ~ "Other",
                                  TRUE ~ as.character(ShrubSpp03)))
  
  
  ## Add unique identifier since there are some repeats of Sdlg numbers 
  pts.sf.lm <- pts.sf.lm %>% 
    mutate(ID_withinrep = seq(1, nrow(pts.sf.lm)))
  
  ## Split up species
  pts.sf.abco <- pts.sf.lm %>% filter(Species == "ABCO")
  pts.sf.pipo <- pts.sf.lm %>% filter(Species == "PIPO")

  pts.sf.abco <- pts.sf.abco %>%
    mutate(Years = as.numeric(paste(Years))) %>%
    mutate(ShrubSpp03 = as.factor(paste(ShrubSpp03)))

  pts.sf.pipo <- pts.sf.pipo %>%
    mutate(Years = as.numeric(paste(Years))) %>%
    mutate(ShrubSpp03 = as.factor(paste(ShrubSpp03)))
  
  pts <- list(pts.sf.abco, pts.sf.pipo)
  return(pts)
}
