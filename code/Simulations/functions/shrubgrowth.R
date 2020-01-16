shrubgrowth <- function(){
  years_shrub_growth <- max_shrub_ht_years - min(pts.sf.abco$Years)
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(Ht1.3 = ifelse(Years < max_shrub_ht_years, Ht1.3 + (max_shrub_ht_cm-Ht1.3)/years_shrub_growth, Ht1.3)) %>% 
    mutate(shrubarea3 = Cov1.3*Ht1.3) %>% 
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3))
  
  
  
  
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(Ht1.3 = ifelse(Years < max_shrub_ht_years, Ht1.3 + (max_shrub_ht_cm-Ht1.3)/years_shrub_growth, Ht1.3)) %>% 
    mutate(shrubarea3 = Cov1.3*Ht1.3) %>% 
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3))

    
}
