abcodia <- function(){
  
  load("../../results/coefficients/LM_dia_abco_dendro.Rdata")
  coefabco <<- LMPIPO_final_abco$coefficients
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(dia.growth.rel = coefabco["(Intercept)"] +
             coefabco["pre_growth_height"]*Ht_cm1+
             coefabco["pre_growth_diameter"]*dia.cm+
             coefabco["relgrvert"]*pred_exp+
             coefabco["pre_growth_diameter:relgrvert"]*pred_exp*dia.cm) %>% 
    mutate(dia.cm = dia.cm + dia.growth.rel*dia.cm)   # calculate new ht after growth
}