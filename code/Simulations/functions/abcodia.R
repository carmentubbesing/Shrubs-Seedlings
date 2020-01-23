abcodia <- function(){
  
  load("../../results/coefficients/LM_dia_abco_dendro.Rdata")
  coefabco <<- lmeabco$coefficients$fixed
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(dia.growth.rel.log = coefabco["(Intercept)"] +
             coefabco["pre_growth_height"]*Ht_cm1+
             coefabco["pre_growth_diameter"]*dia.cm+
             coefabco["ht_growth"]*pred) %>% 
    mutate(dia.growth.rel = exp(dia.growth.rel.log)) %>% 
    mutate(dia.cm = dia.cm + dia.growth.rel*dia.cm)   # calculate new ht after growth
   ggplot(pts.sf.abco, aes(x = dia.cm, y = dia.cm))+
     geom_point()+
     geom_abline(aes(slope = 1, intercept = 0))
}