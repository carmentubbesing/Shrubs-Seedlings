r <- raster(ncols=100, nrows=100)
cells <- c(3:10, 210)
r <- rasterFromCells(r, cells)
plot(r)
cbind(1:ncell(r), getValues(r))



shrub_ID <- (sample(df$ShrubSpp03, length_m*height_m, replace = T))
summary(as.factor(shrub_ID))
shrub_ID <- as.numeric(shrub_ID)
summary(as.factor(shrub_ID))

xy <- matrix(shrub_ID, length_m, height_m)

r <- raster(xy, xmn = 0, xmx = length_m, ymn = 0, ymx = height_m)
crs_epsg <- CRS("+init=epsg:26910")
crs(r) <- crs_epsg
plot(r)

focalr <- focal(r, w = matrix(1/shrub_clumpiness, nrow = shrub_clumpiness, ncol = shrub_clumpiness))
focalr[is.na(getValues(focalr))] <- 0
plot(focalr)
summary(getValues(focalr))
summary(as.factor(getValues(focalr)))

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

plot(focalr)
r <- ratify(focalr)
rat <- levels(r)[[1]]
head(rat)
levels(r) <- rat
r@data@values <- as.factor(r@data@values)
plot(r)
r

raster_df <- df %>% 
  dplyr::select(Sdlg, Cov1.3, Ht1.3, ShrubSpp03, heatload, incidrad, Slope.Deg, Elevation, Fire) %>% 
  rename(ID = Sdlg) %>% 
  mutate(ID = as.numeric(paste(ID))) %>% 
  mutate(sqrt_shrubarea3 = sqrt(Cov1.3*Ht1.3))
rat <- left_join(rat, raster_df)


# NEXT STEPS: CREATE A COLUMN IN DF FOR NUMERIC SHRUB SPP ID AND LINK IT TO THESE NUMBERED CELLS, THEN MERGE WITH MAIN SCRIPTS AND APPLY SHRUB COMPETITION VALUES