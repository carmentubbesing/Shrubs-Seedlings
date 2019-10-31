abcogrowth <- function(){
  hts <- pts.sf.abco %>% dplyr::select(Ht_cm_nonnorm) %>% st_drop_geometry() %>% unlist()# Save hts before normalization to convert it back later

  load("../../results/data/FireFootprints/LM_abco.Rdata")
  LMabco <- LM
  remove(LM)
  coefabco <<- LMabco$coefficients$fixed
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(pred = coefabco["(Intercept)"] +
             coefabco["Ht_cm1"]*Ht_cm1+
             coefabco["Years"]*Years+
             coefabco["sqrt_shrubarea3"]*sqrt_shrubarea3+
             coefabco["heatload"]*heatload+
             coefabco["incidrad"]*incidrad+
             coefabco["Slope.Deg"]*Slope.Deg+
             coefabco["Elevation"]*Elevation+
             coefabco["BasDia2016.cm"]*BasDia2016.cm) %>%
    mutate(pred = case_when(
      Year == "2016" ~ pred + coefabco["Year2016"],
      Year == "2017" ~ pred + coefabco["Year2017"],
      TRUE ~ as.numeric(pred)) ) %>% 
    mutate(pred_exp = exp(pred)) %>% 
    mutate(Ht_cm_nonnorm = Ht_cm_nonnorm + pred_exp*Ht_cm_nonnorm)   # calculate new ht after growth
  
}