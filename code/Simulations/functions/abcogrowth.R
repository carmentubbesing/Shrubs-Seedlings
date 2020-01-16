abcogrowth <- function(){
  hts <- pts.sf.abco %>% dplyr::select(Ht_cm1) %>% st_drop_geometry() %>% unlist()

  load("../../results/coefficients/LM_abco_nonnorm.Rdata")
  LMabco <- LM_abco_nonnorm
  remove(LM_abco_nonnorm)
  coefabco <<- LMabco$coefficients$fixed
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(pred = coefabco["(Intercept)"] +
             coefabco["Ht_cm1"]*Ht_cm1+
             coefabco["Years"]*Years+
             coefabco["sqrt_shrubarea3"]*sqrt_shrubarea3+
             coefabco["heatload"]*heatload+
             coefabco["incidrad"]*incidrad+
             coefabco["Slope.Deg"]*Slope.Deg+
             coefabco["Elevation"]*Elevation) %>%
    mutate(pred_exp = exp(pred)) %>% 
    mutate(Ht_cm1 = Ht_cm1 + pred_exp*Ht_cm1)   # calculate new ht after growth
  
}