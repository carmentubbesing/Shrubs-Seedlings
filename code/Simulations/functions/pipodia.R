pipodia <- function(){
  
  
  load("../../results/coefficients/LM_dia_pipo_dendro.Rdata")
  coefpipo <<- lmepipo$coefficients$fixed
  
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(dia.growth.rel.log = coefpipo["(Intercept)"] +
             coefpipo["pre_growth_height"]*Ht_cm1+
             coefpipo["pre_growth_diameter"]*dia.cm+
             coefpipo["ht_growth"]*pred) %>% 
    mutate(dia.growth.rel = exp(dia.growth.rel.log)) %>% 
    mutate(dia.cm = dia.cm + dia.growth.rel*dia.cm)   # calculate new ht after growth
  ggplot(pts.sf.pipo, aes(x = dia.cm, y = dia.cm))+
    geom_point()+
    geom_abline(aes(slope = 1, intercept = 0))
}