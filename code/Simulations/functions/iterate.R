

iterate <- function(iterations, fire, years_max, climate_method, conifer_species_method, shrub_method, n_seedlings, shrub_coefficient, shrub_heightgrowth, shrub_initial_index){

  no_cores <- detectCores() - 2 # Use all but one or two cores on your computer
  c1 <- makeCluster(no_cores)
  registerDoParallel(c1)
  set.seed(123)
  dfsimallreps <- foreach(i= 1:iterations, .combine = rbind, .packages = c('tidyverse', 'sf', 'mgcv'),  .errorhandling = "remove") %dopar% {
    time.start <- Sys.time()
    
    source("functions/prep_df.R")
    df <- prep_df(fire, conifer_species_method, shrub_method, shrub_initial_index, n_seedlings)
    
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
    source("functions/climate_year.R")
    
   
    # length_m <- 40
    # height_m <- 40
    # lambda <- 4
    # shrub_clumpiness <- 7


    # Remove old objects
    remove(pts.sf.abco, pts.sf.pipo)

    # Execute

    pts <- initialize(df, r, n_seedlings, lambda, length_m, height_m)
    pts.sf.abco <- pts[[1]]
    pts.sf.pipo <- pts[[2]]
    
    dfsimall <- sim(years_max, pts.sf.abco, pts.sf.pipo, cumsum_2015, cumsum_2016, cumsum_2017, iterations, climate_method, shrub_coefficient, shrub_heightgrowth)
    dfsimall <-  dfsimall %>%
      mutate(rep = i)
    return(dfsimall)
  }
  return(dfsimallreps)
}

