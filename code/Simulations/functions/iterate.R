

iterate <- function(n){
  
  no_cores <- detectCores() - 1 # Use all but one core on your computer
  c1 <- makeCluster(no_cores)
  registerDoParallel(c1)
  
  dfsimallreps <<- foreach(i=1:n, .combine = rbind, .packages = c('tidyverse', 'sf', 'mgcv'), .errorhandling="remove") %dopar% {
    time.start <<- Sys.time()
    
    source("functions/shrubclump.R")
    source("functions/initialize.R")
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
    
    years_max <<- 50
    max_shrub_ht_years <<- 15
    n_seedlings <<- 300
    length_m <<- 40
    height_m <<- 40
    lambda <<- 4
    shrub_clumpiness <<- 7
    cumsum_2015 <<- 0.441
    cumsum_2016 <<- 0.912
    cumsum_2017 <<- 1
    fire <<- "AMRC"
    
    # Set error terms for the entire simulation
    
    ## Diameter
    load("~/Shrubs-Seedlings/results/coefficients/LM_dia_ABCO_footprints.Rdata")
    load("~/Shrubs-Seedlings/results/coefficients/LM_dia_PIPO_footprints.Rdata")
    sigma_dia_abco <- sigma(ABCO_final)
    error_dia_abco <<- rnorm(1, 0, sigma_dia_abco)
    sigma_dia_pipo <- sigma(PIPO_final)
    error_dia_pipo <<- rnorm(1, 0, sigma_dia_pipo)
    
    ## Vertical tree growth
    load("../../results/coefficients/RMSE_fir_growth.Rdata")
    error_abco_gr <<- rnorm(1, 0, unlist(RMSE_fir_growth))
    load("../../results/coefficients/RMSE_pine_growth.Rdata")
    error_pipo_gr <<- rnorm(1, 0, unlist(RMSE_pine_growth))
    
    ## Mortality
    load("../../results/coefficients/gr_mort_all_coefficients_abco.Rdata")
    random_row <- sample(1:nrow(all_coefficients),1)
    coef_mort_abco <- all_coefficients[random_row,]
    coef_int_mort_abco <<- unlist(coef_mort_abco[2])
    coef_gr_mort_abco <<- unlist(coef_mort_abco[1])
    
    load("../../results/coefficients/gr_mort_all_coefficients_pipo.Rdata") # these coefficients use log(growth) in the model
    random_row <- sample(1:nrow(all_coefficients),1)
    coef_mort_pipo <- all_coefficients[random_row,]
    coef_int_mort_pipo <<- unlist(coef_mort_pipo[2])
    coef_gr_mort_pipo <<- unlist(coef_mort_pipo[1])
    
    
    # Print progress
    i_tenth <- i/10
    if(i_tenth %in% seq(1,100)){
      print(paste("Done with", i, "iterations in", round(Sys.time()-time.start, 1), "minutes"))
    }
    
    # Execute
    suppressMessages(shrubclump())
    suppressMessages(initialize())
    suppressMessages(sim(years_max))
    dfsimall <<-  dfsimall %>% 
      mutate(error_abco_gr = error_abco_gr) %>% 
      mutate(error_pipo_gr = error_pipo_gr) %>% 
      mutate(error_dia_abco = error_dia_abco) %>% 
      mutate(error_dia_pipo = error_dia_pipo) %>% 
      mutate(coef_gr_mort_abco = coef_gr_mort_abco) %>% 
      mutate(coef_gr_mort_pipo = coef_gr_mort_pipo) %>% 
      mutate(rep = i)
  }
}

