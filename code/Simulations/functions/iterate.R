

iterate <- function(iterations, fire, years_max, climate_method){

  no_cores <- detectCores() - 2 # Use all but one or two cores on your computer
  c1 <- makeCluster(no_cores)
  registerDoParallel(c1)
  set.seed(123)
  dfsimallreps <- foreach(i= 1:iterations, .combine = rbind, .packages = c('tidyverse', 'sf', 'mgcv'),  .errorhandling = "remove") %dopar% {
    time.start <- Sys.time()
    
    source("functions/prep_df.R")
    df <- prep_df(fire)
    
    source("functions/initialize_nonspatial.R")
    source("functions/sim.R")
    source("functions/abco_shrubgrowth.R") # no uncertainty for shrub cover, it messes everything up!
    source("functions/pipo_shrubgrowth.R") # no uncertainty for shrub cover, it messes everything up!
    source("functions/abcomort.R") #uncertainty done
    source("functions/pipomort.R") #uncertainty done
    source("functions/abcodia_footprints.R") #uncertainty done
    source("functions/pipodia_footprints.R") #uncertainty done
    source("functions/abcogrowth.R") #uncertainty done
    source("functions/pipogrowth.R") #uncertainty done
    source("functions/pipo_emerge.R")
    source("functions/abco_emerge.R")
    
    n_seedlings <- 200
    length_m <- 40
    height_m <- 40
    lambda <- 4
    shrub_clumpiness <- 7
    cumsum_2015 <- 0.441
    cumsum_2016 <- 0.912
    cumsum_2017 <- 1

    # Remove old objects
    remove(pts.sf.abco, pts.sf.pipo)

    # Execute

    pts <- initialize(df, r, n_seedlings, lambda, length_m, height_m)
    pts.sf.abco <- pts[[1]]
    pts.sf.pipo <- pts[[2]]
    
    dfsimall <- sim(years_max, pts.sf.abco, pts.sf.pipo, cumsum_2015, cumsum_2016, cumsum_2017, iterations, climate_method)
    dfsimall <-  dfsimall %>%
      mutate(rep = i)
    return(dfsimall)
  }
  return(dfsimallreps)
}

