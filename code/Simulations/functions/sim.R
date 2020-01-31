sim <- function(years){
  dfsim <- data.frame()
  dfsimall <- data.frame()
  i <- 1
  for(i in 1:years){
    
    random <<- runif(1,0,1)
    climate_year <<- case_when(
      random < cumsum_2015 ~ 2015,
      random > cumsum_2015 & random < cumsum_2016 ~ 2016,
      random > cumsum_2016 ~ 2017
    ) 
    
    pts.sf.abco <<- pts.sf.abco %>% 
      mutate(Year = climate_year) 
    
    pts.sf.pipo <<- pts.sf.pipo %>% 
      mutate(Year = climate_year) 
      
    abcogrowth()
    pipogrowth()
    abcomort()
    pipomort()
    
    # Plot comparision of pipo and abco starting diameters
    ggplot()+
      geom_histogram(aes(pts.sf.abco$dia.cm), fill = "pink", bins = 20)+
      geom_histogram(aes(pts.sf.pipo$dia.cm), fill = "light green", bins = 20)+
      theme_minimal()
    
    ggplot()+
      geom_histogram(aes(pts.sf.abco$Ht_cm1), fill = "pink", bins = 20)+
      geom_histogram(aes(pts.sf.pipo$Ht_cm1), fill = "light green", bins = 20)+
      theme_minimal()
    
    abcodia()
    pipodia()
    abco_shrubgrowth()
    pipo_shrubgrowth()
    
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
  }
  
  dfsimall <<- dfsimall
  
}