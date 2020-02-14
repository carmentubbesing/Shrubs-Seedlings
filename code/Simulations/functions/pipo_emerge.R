pipo_emerge <- function(){
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(emerged = ifelse(
      emerged == 0 & Ht_cm1*0.75 < Ht1.3, 0, 1
    )) 
  
}