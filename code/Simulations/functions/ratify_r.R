ratify_r <- function(r, raster_df){
  
  for(j in 1:length(unique(r@data@values))){
    for(i in 1:length(r@data@values)){
      if(r@data@values[i] == j){
        vals <- raster_df %>% filter(ShrubSppID==j) %>% dplyr::select(ID) %>% unlist()
        val_sample <- sample(vals, 1)
        r@data@values[i] <- as.numeric(val_sample)
      }
    }
  }
  
  # Add a raster attribute table (RAT) using data from raster_df
  r <- ratify(r)
  
  rat <- levels(r)[[1]]
  rat <- left_join(rat, raster_df)
  levels(r) <- rat
  return(r)
}