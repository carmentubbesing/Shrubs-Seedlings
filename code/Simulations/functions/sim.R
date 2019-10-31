sim <- function(years){
  dfsim <- data.frame()
  dfsimall <- data.frame()
  
  for(i in 1:years){
    abcogrowth()
    pipogrowth()
    pts.sf.abco <<- pts.sf.abco %>% 
      mutate(Years_nonnorm = Years_nonnorm + 1) %>% 
      mutate(Years = normalize(Years_nonnorm))
    pts.sf.pipo <<- pts.sf.pipo %>% 
      mutate(Years_nonnorm = Years_nonnorm + 1)%>% 
      mutate(Years = normalize(Years_nonnorm))
    
    dfsim <- full_join(st_drop_geometry(pts.sf.pipo), st_drop_geometry(pts.sf.abco))
    if(nrow(dfsimall) == 0){
      dfsimall <- dfsim
    } else{
      dfsimall <- full_join(dfsim, dfsimall)
    }
  }
  
  dfsimall <<- dfsimall
  
}