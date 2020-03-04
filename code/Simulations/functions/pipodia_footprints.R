pipodia <- function(pts.sf.pipo, sample_gr){
  load("../../results/coefficients/LM_dia_PIPO_models_all.Rdata")
  model <- models_all[[sample_gr]]
  pts.sf.pipo <- pts.sf.pipo %>% 
    mutate(dia.cm = predict(model, newdata = pts.sf.pipo))
  return(pts.sf.pipo)
}

