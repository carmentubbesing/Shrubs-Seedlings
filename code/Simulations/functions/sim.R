sim <- function(years_max){
  dfsim <- data.frame()
  dfsimall <- data.frame()
  i <- 1
  for(i in 1:years_max){
    
    pts.sf.abco <<- pts.sf.abco %>% 
      mutate(emerged = ifelse(
        (Ht_cm1*0.75)>Ht1.3, 1, 0
      )) 
    
    pts.sf.pipo <<- pts.sf.pipo %>% 
      mutate(emerged = ifelse(
        (Ht_cm1*0.75)>Ht1.3, 1, 0
      )) 
    
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
    
    random <<- runif(1,0,1)
    
    climate_year <<- case_when(
      random < cumsum_2015 ~ 2015,
      random > cumsum_2015 & random < cumsum_2016 ~ 2016,
      random > cumsum_2016 ~ 2017
    ) 
    
    if(any(pts.sf.abco$emerged==0) ){
      pts.sf.abco <<- pts.sf.abco %>% 
        mutate(Year = climate_year) 
      abcogrowth()
      abcomort()
      abcodia()
      abco_shrubgrowth()
      pts.sf.abco <<- pts.sf.abco %>% 
        mutate(Years = Years + 1)
    } else{
      pts.sf.abco <<- pts.sf.abco %>% 
        mutate(Years = Years + 1)
    }
    
    if(any(pts.sf.pipo$emerged==0) ){
      pts.sf.pipo <<- pts.sf.pipo %>% 
        mutate(Year = climate_year) 
      pipogrowth()
      pipomort()
      pipodia()
      pipo_shrubgrowth()
      
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