abcogrowth <- function(){
  hts <- pts.sf.abco %>% dplyr::select(Ht_cm1) %>% st_drop_geometry() %>% unlist()

  load("../../results/coefficients/LM_abco_nonnorm.Rdata")
  load("../../results/coefficients/RMSE_fir_growth.Rdata")
  
  LMabco <- LM_abco_nonnorm
  remove(LM_abco_nonnorm)
  coefabco <<- LMabco$coefficients$fixed
  
  error_iteration <- rnorm(1, 0, unlist(RMSE_fir_growth))
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(pred = coefabco["(Intercept)"] +
             coefabco["Years"]*Years+
             coefabco["heatload"]*heatload+
             coefabco["incidrad"]*incidrad+
             coefabco["Ht_cm1"]*Ht_cm1+
             coefabco["sqrt_shrubarea3"]*sqrt_shrubarea3+
             coefabco["Slope.Deg"]*Slope.Deg+
             coefabco["Elevation"]*Elevation+
             coefabco["Ht_cm1:sqrt_shrubarea3"]*sqrt_shrubarea3*Ht_cm1
             + error_iteration
             ) %>%
    mutate(pred_exp = exp(pred)) %>% 
    mutate(Ht_cm1 = Ht_cm1 + pred_exp*Ht_cm1)   # calculate new ht after growth
  
}