

iterate <- function(n){
  
  no_cores <- detectCores() - 1 # Use all but one core on your computer
  c1 <- makeCluster(no_cores)
  registerDoParallel(c1)
  
  dfsimallreps <<- foreach(i=1:n, .combine = rbind, .packages = c('tidyverse', 'sf', 'mgcv')) %dopar% {
    time.start <<- Sys.time()
    
    source("functions/shrubclump.R")
    source("functions/initialize.R")
    source("functions/sim.R")
    source("functions/abco_shrubgrowth.R")
    source("functions/pipo_shrubgrowth.R")
    source("functions/abcomort.R") #needs uncertainty!
    source("functions/pipomort.R") #needs uncertainty!
    source("functions/abcodia_footprints.R") #uncertainty done
    source("functions/pipodia_footprints.R") #uncertainty done
    source("functions/abcogrowth.R") #uncertainty done
    source("functions/pipogrowth.R") #uncertainty done
    
    years_max <<- 40
    max_shrub_ht_years <<- 15
    n_seedlings <<- 200
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
    suppressMessages(sim(years_max))
    dfsimall <<-  dfsimall %>% 
      mutate(rep = i)
  }
}

