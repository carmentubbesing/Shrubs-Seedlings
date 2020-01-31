pipogrowth <- function(){
  hts <- pts.sf.abco %>% dplyr::select(Ht_cm1) %>% st_drop_geometry() %>% unlist()
  
  load("../../results/coefficients/LM_pine_nonnorm_sim.Rdata")
  LMpipo <- LM_pine_nonnorm_sim
  remove(LM_pine_nonnorm_sim)
  coefpipo <<- LMpipo$coefficients$fixed
   
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(pred = coefpipo["(Intercept)"] +
             coefpipo["Ht_cm1"]*Ht_cm1+
             coefpipo["Years"]*Years+
             coefpipo["sqrt_shrubarea3"]*sqrt_shrubarea3+
             coefpipo["heatload"]*heatload+
             coefpipo["Elevation"]*Elevation) %>%
    mutate(pred = case_when(
      ShrubSpp03 == "CECO" ~ pred + coefpipo["ShrubSpp03CECO"],
      ShrubSpp03 == "CEIN" ~ pred + coefpipo["ShrubSpp03CEIN"],
      ShrubSpp03 == "CHFO" ~ pred + coefpipo["ShrubSpp03CHFO"],
      ShrubSpp03 == "LIDE" ~ pred + coefpipo["ShrubSpp03LIDE"],
      ShrubSpp03 == "Other" ~ pred + coefpipo["ShrubSpp03Other"],
      TRUE ~ as.numeric(pred)) ) %>% 
    mutate(pred = case_when(
      Year == "2016" ~ pred + coefpipo["Year2016"],
      Year == "2017" ~ pred + coefpipo["Year2017"],
      TRUE ~ as.numeric(pred)) ) %>% 
    mutate(pred_exp = exp(pred)) %>% 
    mutate(Ht_cm1 = Ht_cm1 + pred_exp*Ht_cm1)  
  
}