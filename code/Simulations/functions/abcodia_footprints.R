abcodia <- function(){
  
  load("../../results/coefficients/LM_dia_ABCO_footprints.Rdata")
  error_sigma <- sigma(ABCO_final)
  error_iteration <- rnorm(1, 0, error_sigma)
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(dia.cm = predict(ABCO_final, newdata = pts.sf.abco) + error_iteration)

}