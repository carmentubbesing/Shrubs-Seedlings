abcogrowth <- function(pts.sf.abco, sample_gr){
  load("../../results/coefficients/LM_fir_bootstrap_coef.Rdata")
  coefabco <- coef_all %>% filter(i == sample_gr) %>% dplyr::select(-i) %>% t() %>% as.data.frame()
  names(coefabco) <- unlist(coefabco[2,])
  coefabco <- coefabco[1,] %>% mutate_all(paste) %>% mutate_all(as.numeric)
  coefabco
  
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(pred = coefabco[1,"(Intercept)"] +
             coefabco[1,"Years"]*Years+
             coefabco[1, "heatload"]*heatload+
             coefabco[1, "incidrad"]*incidrad+
             coefabco[1, "Ht_cm1"]*Ht_cm1+
             coefabco[1, "sqrt_shrubarea3"]*sqrt_shrubarea3+
             coefabco[1, "Slope.Deg"]*Slope.Deg+
             coefabco[1, "Elevation"]*Elevation+
             coefabco[1, "Ht_cm1:sqrt_shrubarea3"]*sqrt_shrubarea3*Ht_cm1
             ) %>%
    mutate(pred_exp = exp(pred)) %>% 
    mutate(Ht_cm1 = ifelse(emerged == 1, HT_cm1, Ht_cm1 + pred_exp*Ht_cm1))  %>% 
    mutate(coef_gr_shrubarea =coefabco[1, "sqrt_shrubarea3"] )
  return(pts.sf.abco)
  
}
