pipomort <- function(pts.sf.pipo, coef_int_mort_pipo, coef_gr_mort_pipo){
  
  pts.sf.pipo <- pts.sf.pipo %>% 
    mutate(prob_mort = exp(coef_int_mort_pipo + coef_gr_mort_pipo*pred)/(1+exp(coef_int_mort_pipo + coef_gr_mort_pipo*pred))) %>% 
    mutate(prob_mort_annual = prob_mort/3) %>% 
    mutate(rand = runif(nrow(pts.sf.pipo), 0,1)) %>% 
    mutate(dead = ifelse(rand<prob_mort_annual & emerged ==0, 1, 0)) %>% 
    filter(dead ==0)
  
  return(pts.sf.pipo)
}