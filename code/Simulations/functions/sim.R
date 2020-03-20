sim <- function(years_max, pts.sf.abco, pts.sf.pipo, cumsum_2015, cumsum_2016, cumsum_2017, iterations, climate_method, shrub_coefficient, shrub_heightgrowth){
  load("../../data/PRISM/clean_1970-present.Rdata")
  prism <- df
  remove(df)
  prism <- prism[7:nrow(prism),] # ADJUST THIS BASED ON HOW LONG THE SIMULATIONS TAKE
  dfsim <- data.frame()
  dfsimall <- data.frame()
  
  # Set initial emerged values
  pts.sf.pipo <- pts.sf.pipo %>% 
    mutate(emerged = ifelse(
      Ht_cm1*0.75 < Ht1.3, 0, 1
    )) 
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(emerged = ifelse(
      Ht_cm1*0.75 < Ht1.3, 0, 1
    )) 
  
  # Set error terms
  ## Mortality
  load("../../results/coefficients/gr_mort_all_coefficients_abco.Rdata")
  random_row <- sample(1:nrow(all_coefficients),1)
  coef_mort_abco <- all_coefficients[random_row,]
  coef_int_mort_abco <- unlist(coef_mort_abco[2])
  coef_gr_mort_abco <- unlist(coef_mort_abco[1])
  
  load("../../results/coefficients/gr_mort_all_coefficients_pipo.Rdata") # these coefficients use log(growth) in the model
  random_row <- sample(1:nrow(all_coefficients),1)
  coef_mort_pipo <- all_coefficients[random_row,]
  coef_int_mort_pipo <- unlist(coef_mort_pipo[2])
  coef_gr_mort_pipo <- unlist(coef_mort_pipo[1])
  
  ## Vertical growth
  ## Vert Growth
  sample_gr <- sample(1000, 1)
  
  for(i in 1:years_max){
    
    if(climate_method == "random"){
      random <- runif(1,0,1)
      climate_year <- case_when(
        random < cumsum_2015 ~ 2015,
        random > cumsum_2015 & random < cumsum_2016 ~ 2016,
        random > cumsum_2016 ~ 2017
      ) 
    } else if(climate_method == "historic"){
      years <- unlist(max(pts.sf.abco$Years))
      climate_year <- prism[years,2] %>% unlist()
      historic_year_i <- prism[years,1] %>% unlist()
      pts.sf.abco <- pts.sf.abco %>% 
        mutate(historic_year = historic_year_i)
      pts.sf.pipo <- pts.sf.pipo %>% 
        mutate(historic_year = historic_year_i)
      
    } else if(climate_method == "uniform_2015"){
      climate_year <- 2015
    } else if(climate_method == "uniform_2016"){
      climate_year <- 2016
    } else if(climate_method == "uniform_2017"){
      climate_year <- 2017
    }
    
    # If everything is already emerged, just add a year but don't do anything else
    if(max(pts.sf.abco$Years)>10 & all(pts.sf.abco$emerged==1) & all(pts.sf.pipo$emerged==1)){
      pts.sf.abco <- pts.sf.abco %>% 
        mutate(Years = Years + 1)
      pts.sf.pipo <- pts.sf.pipo %>% 
        mutate(Years = Years + 1)
      dfsim <- full_join(pts.sf.pipo, pts.sf.abco)
      
      if(nrow(dfsimall) == 0){
        dfsimall <- dfsim
      } else{
        dfsimall <- full_join(dfsim, dfsimall)
      }
      next()
    }
    
    # Apply all functions to abco if any of the abco haven't emerged yet, else just add a year 
    if(any(pts.sf.abco$emerged==0) ){
      pts.sf.abco <- pts.sf.abco %>% 
        mutate(Year = climate_year) 
      pts.sf.abco <- abcogrowth(pts.sf.abco, sample_gr)
      pts.sf.abco <- abcomort(pts.sf.abco, coef_int_mort_abco, coef_gr_mort_abco)
      pts.sf.abco <- abcodia(pts.sf.abco, sample_gr)
      pts.sf.abco <- abco_shrubgrowth(pts.sf.abco, shrub_heightgrowth)
      pts.sf.abco <- abco_emerge(pts.sf.abco)
      pts.sf.abco <- pts.sf.abco %>% 
        mutate(Years = Years + 1)
    } else{
      pts.sf.abco <- pts.sf.abco %>% 
        mutate(Years = Years + 1)
    }
    
    # Apply all functions to PIPO if any of the abco haven't emerged yet, else just add a year 
    if(any(pts.sf.pipo$emerged==0) ){
      pts.sf.pipo <- pts.sf.pipo %>% 
        mutate(Year = climate_year) 
      pts.sf.pipo <- pipogrowth(pts.sf.pipo, sample_gr, shrub_coefficient)
      pts.sf.pipo <- pipomort(pts.sf.pipo, coef_int_mort_pipo, coef_gr_mort_pipo)
      pts.sf.pipo <- pipodia(pts.sf.pipo, sample_gr)
      pts.sf.pipo <- pipo_shrubgrowth(pts.sf.pipo, shrub_heightgrowth)
      pts.sf.pipo <- pipo_emerge(pts.sf.pipo)
      pts.sf.pipo <- pts.sf.pipo %>% 
        mutate(Years = Years + 1)
    }else{
      pts.sf.pipo <- pts.sf.pipo %>% 
        mutate(Years = Years + 1)
    }
    
    #dfsim <- full_join(st_drop_geometry(pts.sf.pipo), st_drop_geometry(pts.sf.abco))
    dfsim <- full_join(pts.sf.pipo, pts.sf.abco)
      
    if(nrow(dfsimall) == 0){
      dfsimall <- dfsim
    } else{
      dfsimall <- full_join(dfsim, dfsimall)
    }
  }
  dfsimall <-  dfsimall %>%
    mutate(coef_gr_mort_abco = coef_gr_mort_abco) %>%
    mutate(coef_gr_mort_pipo = coef_gr_mort_pipo)
  return(dfsimall)
  
}

