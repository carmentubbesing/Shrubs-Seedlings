climate_year <- function(climate_method, pts.sf.abco, pts.sf.pipo, prism){
  # Assign a climate year depending on the method for this run
  
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
    
  }
  
}