abcodia <- function(){
  
  load("../../results/coefficients/LM_dia_abco.Rdata")
  coefabco <<- lmabco$coefficients
  
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(dia.cm = coefabco["(Intercept)"] +
             coefabco["height_2018"]*Ht_cm1+
             coefabco["sqrt(shrubarea)"]*sqrt_shrubarea3+
             coefabco["dia17_cm_Aug"]*dia.cm+
             coefabco["height_2018:dia17_cm_Aug"]*Ht_cm1*dia.cm) 
  # ggplot(pts.sf.abco, aes(x = BasDia2016.cm, y = dia.cm))+
  #   geom_point()+
  #   geom_abline(aes(slope = 1, intercept = 0))
}