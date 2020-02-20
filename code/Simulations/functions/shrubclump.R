shrubclump <- function(df, length_m, height_m, shrub_clumpiness){

    shrub_ID <- (sample(df$ShrubSpp03, length_m*height_m, replace = T))
    summary(as.factor(shrub_ID))
    shrub_ID <- as.numeric(shrub_ID)
    summary(as.factor(shrub_ID))
    
    xy <- matrix(shrub_ID, length_m, height_m)
    
    r <- raster(xy, xmn = 0, xmx = length_m, ymn = 0, ymx = height_m)
    crs_epsg <- CRS("+init=epsg:26910")
    crs(r) <- crs_epsg

    focalr <- focal(r, w = matrix(1/shrub_clumpiness, nrow = shrub_clumpiness, ncol = shrub_clumpiness), pad = T, padValue = mean(r@data@values))

    summary(getValues(focalr))
    
    # Add random small numbers to values to  make them unique
    seq <- seq(0, 0.01, length.out = length(values(focalr)))
    smallnums <- sample(seq, length(values(focalr)))
    values(focalr) <- values(focalr)+smallnums
    
    xg <- split(sort(getValues(focalr)), sort(shrub_ID))
    
    values(focalr) <- ifelse(values(focalr) %in% xg$`1`, 1, values(focalr))
    values(focalr) <- ifelse(values(focalr) %in% xg$`2`, 2, values(focalr))
    values(focalr) <- ifelse(values(focalr) %in% xg$`3`, 3, values(focalr))
    values(focalr) <- ifelse(values(focalr) %in% xg$`4`, 4, values(focalr))
    values(focalr) <- ifelse(values(focalr) %in% xg$`5`, 5, values(focalr))
    summary(as.factor(getValues(focalr)))
    
    r <- focalr
    return(r)
 }
    
    
    
    
