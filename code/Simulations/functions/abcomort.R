abcomort <- function(pts.sf.abco, coef_int_mort_abco, coef_gr_mort_abco){

  pts.sf.abco <- pts.sf.abco %>% 
    mutate(prob_mort = exp(coef_int_mort_abco + coef_gr_mort_abco*pred)/(1+exp(coef_int_mort_abco + coef_gr_mort_abco*pred))) %>% 
    mutate(prob_mort_annual = prob_mort/3) %>% 
    mutate(rand = runif(nrow(pts.sf.abco), 0,1)) %>% 
    mutate(dead = ifelse(rand<prob_mort_annual & emerged ==0, 1, 0)) %>% 
    filter(dead ==0)
  
  return(pts.sf.abco)

}