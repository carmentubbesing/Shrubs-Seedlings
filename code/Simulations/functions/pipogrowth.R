pipogrowth <- function(pts.sf.pipo, sample_gr, shrub_coefficient){
  load("../../results/coefficients/LM_pine_bootstrap_coef.Rdata")
  coefpipo <- coef_all %>% filter(i == sample_gr)
  
  pts.sf.pipo <- pts.sf.pipo %>% 
    mutate(pred = coefpipo[coefpipo$coef =="(Intercept)", "value"] +
             coefpipo[coefpipo$coef =="Years", "value"]*Years+
             coefpipo[coefpipo$coef =="Ht_cm1", "value"]*Ht_cm1+
             coefpipo[coefpipo$coef =="sqrt_shrubarea3", "value"]*sqrt_shrubarea3+
             coefpipo[coefpipo$coef =="heatload", "value"]*heatload+
             #coefpipo[coefpipo$coef =="Elevation", "value"]*Elevation+
             coefpipo[coefpipo$coef =="BasDia2016.cm", "value"]*dia.cm+
             coefpipo[coefpipo$coef =="Ht_cm1:sqrt_shrubarea3", "value"]*sqrt_shrubarea3*Ht_cm1) %>%
    mutate(pred = case_when(
      shrub_coefficient == "CECO" ~ pred + coefpipo[coefpipo$coef =="ShrubSpp03CECO", "value"],
      shrub_coefficient == "CEIN" ~ pred + coefpipo[coefpipo$coef =="ShrubSpp03CEIN", "value"],
      shrub_coefficient == "CHFO" ~ pred + coefpipo[coefpipo$coef =="ShrubSpp03CHFO", "value"],
      shrub_coefficient == "LIDE" ~ pred + coefpipo[coefpipo$coef =="ShrubSpp03LIDE", "value"],
      shrub_coefficient == "Other" ~ pred + coefpipo[coefpipo$coef =="ShrubSpp03Other", "value"],
      TRUE ~ as.numeric(pred)) ) %>% 
    mutate(pred = case_when(
      Year == "2016" ~ pred + coefpipo[coefpipo$coef =="Year2016", "value"],
      Year == "2017" ~ pred + coefpipo[coefpipo$coef =="Year2017", "value"],
      TRUE ~ as.numeric(pred)) ) %>% 
    mutate(pred_exp = exp(pred)) %>% 
    mutate(Ht_cm1 = ifelse(emerged == 1, Ht_cm1, Ht_cm1 + pred_exp*Ht_cm1))  %>% 
    mutate(coef_gr_shrubarea = coefpipo[coefpipo$coef =="sqrt_shrubarea3", "value"]) %>% 
    mutate(coef_gr_shrubarea = coefpipo[coefpipo$coef =="", "value"])
  return(pts.sf.pipo)
  
}