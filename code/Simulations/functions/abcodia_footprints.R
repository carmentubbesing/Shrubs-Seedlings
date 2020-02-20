abcodia <- function(pts.sf.abco, error_dia_abco){
  load("~/Shrubs-Seedlings/results/coefficients/LM_dia_ABCO_footprints.Rdata")
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(dia.cm = predict(ABCO_final, newdata = pts.sf.abco) + error_dia_abco)
  return(pts.sf.abco)

}