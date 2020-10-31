abcodia <- function(pts.sf.abco, sample_gr){
  load("../../../results/coefficients/LM_dia_ABCO_models_all.Rdata")
  model <- models_all[[sample_gr]]
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(dia.cm = predict(model, newdata = pts.sf.abco))
  return(pts.sf.abco)

}