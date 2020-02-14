abco_emerge <- function(){
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(emerged = ifelse(
      emerged == 0 & Ht_cm1*0.75 < Ht1.3, 0, 1
    )) 
}