abcomort <- function(){
  load("../../results/coefficients/gr_mort_all_coefficients_abco.Rdata")
  random_row <- sample(1:nrow(all_coefficients),1)
  coef <- all_coefficients[random_row,]
  coef_int <- unlist(coef[2])
  coef_gr <- unlist(coef[1])
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(emerged = ifelse(
      (Ht_cm1*0.75)>Ht1.3, 1, 0
    )) %>% 
    mutate(prob_mort = exp(coef_int + coef_gr*pred)/(1+exp(coef_int + coef_gr*pred))) %>% 
    mutate(rand = runif(nrow(pts.sf.abco), 0,1)) %>% 
    mutate(dead = ifelse(rand<prob_mort & emerged ==0, 1, 0)) %>% 
    filter(dead ==0)

}