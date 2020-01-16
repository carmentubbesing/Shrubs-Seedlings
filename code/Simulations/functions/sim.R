sim <- function(years){
  dfsim <- data.frame()
  dfsimall <- data.frame()
  
  for(i in 1:years){
    abcogrowth()
    pipogrowth()
    abcomort()
    pipomort()
    abcodia()
    pipodia()
   # shrubgrowth()
    pts.sf.abco <<- pts.sf.abco %>% 
      mutate(Years = Years + 1)
    pts.sf.pipo <<- pts.sf.pipo %>% 
      mutate(Years = Years + 1)
    
    
    dfsim <- full_join(st_drop_geometry(pts.sf.pipo), st_drop_geometry(pts.sf.abco))
    if(nrow(dfsimall) == 0){
      dfsimall <- dfsim
    } else{
      dfsimall <- full_join(dfsim, dfsimall)
    }
  }
  
  dfsimall <<- dfsimall
  
}