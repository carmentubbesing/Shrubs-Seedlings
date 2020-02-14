sim <- function(years_max){
  dfsim <- data.frame()
  dfsimall <- data.frame()
  i <- 1
  
  # Set initial emerged values
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(emerged = ifelse(
      Ht_cm1*0.75 < Ht1.3, 0, 1
    )) 
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(emerged = ifelse(
      Ht_cm1*0.75 < Ht1.3, 0, 1
    )) 
  
  for(i in 1:years_max){
    
    # If everything is already emerged, just add a year but don't do anything else
    if(max(pts.sf.abco$Years)>10 & all(pts.sf.abco$emerged==1) & all(pts.sf.pipo$emerged==1)){
      pts.sf.abco <<- pts.sf.abco %>% 
        mutate(Years = Years + 1)
      pts.sf.pipo <<- pts.sf.pipo %>% 
        mutate(Years = Years + 1)
      dfsim <- full_join(st_drop_geometry(pts.sf.pipo), st_drop_geometry(pts.sf.abco))
      
      if(nrow(dfsimall) == 0){
        dfsimall <- dfsim
      } else{
        dfsimall <- full_join(dfsim, dfsimall)
      }
    dfsimall <<- dfsimall
      next()
    }
    
    # Assign a climate year 
    random <<- runif(1,0,1)
    climate_year <<- case_when(
      random < cumsum_2015 ~ 2015,
      random > cumsum_2015 & random < cumsum_2016 ~ 2016,
      random > cumsum_2016 ~ 2017
    ) 
    
    # Apply all functions to abco if any of the abco haven't emerged yet, else just add a year 
    if(any(pts.sf.abco$emerged==0) ){
      pts.sf.abco <<- pts.sf.abco %>% 
        mutate(Year = climate_year) 
      abcogrowth()
      abcomort()
      abcodia()
      abco_shrubgrowth()
      abco_emerge()
      pts.sf.abco <<- pts.sf.abco %>% 
        mutate(Years = Years + 1)
    } else{
      pts.sf.abco <<- pts.sf.abco %>% 
        mutate(Years = Years + 1)
    }
    
    # Apply all functions to PIPO if any of the abco haven't emerged yet, else just add a year 
    if(any(pts.sf.pipo$emerged==0) ){
      pts.sf.pipo <<- pts.sf.pipo %>% 
        mutate(Year = climate_year) 
      pipogrowth()
      pipomort()
      pipodia()
      pipo_shrubgrowth()
      pipo_emerge()
      pts.sf.pipo <<- pts.sf.pipo %>% 
        mutate(Years = Years + 1)
    }else{
      pts.sf.pipo <<- pts.sf.pipo %>% 
        mutate(Years = Years + 1)
    }
    
    dfsim <- full_join(st_drop_geometry(pts.sf.pipo), st_drop_geometry(pts.sf.abco))
    
    if(nrow(dfsimall) == 0){
      dfsimall <- dfsim
    } else{
      dfsimall <- full_join(dfsim, dfsimall)
    }
  }
  
  dfsimall <<- dfsimall
  
}

