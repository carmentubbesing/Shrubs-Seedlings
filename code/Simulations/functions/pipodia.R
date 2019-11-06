pipodia <- function(){
  
  load("../../results/coefficients/LM_dia_pipo.Rdata")
  coefpipo <<- lmpipo$coefficients
  
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(dia.cm = coefpipo["(Intercept)"] +
             coefpipo["height_2018"]*Ht_cm1+
             coefpipo["sqrt(shrubarea)"]*sqrt_shrubarea3+
             coefpipo["dia17_cm_Aug"]*dia.cm+
             coefpipo["height_2018:dia17_cm_Aug"]*Ht_cm1*dia.cm) 
  # ggplot(pts.sf.pipo, aes(x = BasDia2016.cm, y = dia.cm))+
  #   geom_point()+
  #   geom_abline(aes(slope = 1, intercept = 0))
}