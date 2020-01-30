pipodia <- function(){
  
  
  load("../../results/coefficients/LM_dia_pipo_dendro.Rdata")
  coefpipo <<- LMPIPO_final$coefficients
  
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(dia.growth.rel = coefpipo["(Intercept)"] +
             coefpipo["pre_growth_height"]*Ht_cm1+
             coefpipo["pre_growth_diameter"]*dia.cm+
             coefpipo["relgrvert"]*pred_exp+
             coefpipo["pre_growth_diameter:relgrvert"]*pred_exp*dia.cm) %>% 
    mutate(dia.cm = dia.cm + dia.growth.rel*dia.cm)   # calculate new ht after growth
}



# TEST
# newdatatest <- pts.sf.pipo %>% 
#   mutate(pre_growth_diameter = dia.cm, pre_growth_height = Ht_cm1, relgrvert = pred_exp)
# predict_dia_test <- predict(LMPIPO_final, newdata = newdatatest)
# hist(predict_dia_test)
# hist(pts.sf.pipo$dia.growth.rel)
