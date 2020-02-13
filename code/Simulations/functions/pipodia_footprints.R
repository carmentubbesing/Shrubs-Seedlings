pipodia <- function(){
  
  load("../../results/coefficients/LM_dia_PIPO_footprints.Rdata")
  
  error_sigma <- sigma(PIPO_final)
  error_iteration <- rnorm(1, 0, error_sigma)
  
  
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(dia.cm = predict(PIPO_final, newdata = pts.sf.pipo) + error_iteration)
  
}



