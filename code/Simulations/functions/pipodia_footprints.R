pipodia <- function(pts.sf.pipo, error_dia_pipo){
  load("../../results/coefficients/LM_dia_PIPO_footprints.Rdata")
  
  pts.sf.pipo <- pts.sf.pipo %>% 
    mutate(dia.cm = predict(PIPO_final, newdata = pts.sf.pipo) + error_dia_pipo)
  return(pts.sf.pipo)
}



