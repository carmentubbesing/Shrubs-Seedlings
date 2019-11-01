abcomort <- function(){
  load("../../results/coefficients/mean_coef_gr_abco.Rdata")
  load("../../results/coefficients/mean_coef_int_abco.Rdata")
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(prob_mort = exp(mean_coef_int + mean_coef_gr*pred)/(1+exp(mean_coef_int + mean_coef_gr*pred))) %>% 
    mutate(rand = runif(nrow(pts.sf.abco), 0,1)) %>% 
    mutate(dead = ifelse(rand<prob_mort, 1, 0)) %>% 
    filter(dead ==0)

}