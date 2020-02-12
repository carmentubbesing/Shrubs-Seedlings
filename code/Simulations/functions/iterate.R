

iterate <- function(n){
  time.start <<- Sys.time()
  
  no_cores <- detectCores() - 1 # Use all but one core on your computer
  c1 <- makeCluster(no_cores)
  registerDoParallel(c1)
  
  dfsimallreps <<- foreach(i=1:n, .combine = rbind, .packages = c('tidyverse', 'sf', 'mgcv')) %dopar% {
    source("functions/shrubclump.R")
    source("functions/initialize.R")
    source("functions/sim.R")
    source("functions/abco_shrubgrowth.R")
    source("functions/pipo_shrubgrowth.R")
    source("functions/abcomort.R")
    source("functions/pipomort.R")
    source("functions/abcodia_footprints.R")
    source("functions/pipodia_footprints.R")
    source("functions/abcogrowth.R")
    source("functions/pipogrowth.R")
    
    years <<- 20
    max_shrub_ht_cm <<- 250
    max_shrub_ht_years <<- 15
    n_seedlings <<- 100
    length_m <<- 40
    height_m <<- 40
    lambda <<- 4
    shrub_clumpiness <<- 7
    cumsum_2015 <<- 0.441
    cumsum_2016 <<- 0.912
    cumsum_2017 <<- 1
    i_tenth <- i/10
    if(i_tenth %in% seq(1,100)){
      print(paste("Done with", i, "iterations in", round(Sys.time()-time.start, 1), "minutes"))
    }
    fire <<- "AMRC"
    suppressMessages(shrubclump())
    suppressMessages(initialize())
    suppressMessages(sim(years))
    dfsimall <<-  dfsimall %>% 
      mutate(rep = i)
  }
}

