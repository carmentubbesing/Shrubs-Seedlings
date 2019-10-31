dfsimallreps <- data.frame()

iterate <- function(n){
  for(i in 1:n){
    suppressMessages(initialize())
    suppressMessages(sim(20))
    
    dfsimall <<-  dfsimall %>% 
       mutate(rep = i)

    if(nrow(dfsimallreps) == 0){
      dfsimallreps <- dfsimall
    } else{
      dfsimallreps <- bind_rows(dfsimallreps, dfsimall)
       dfsimallreps <<- dfsimallreps 
     }
     remove(dfsimall)
     
   }
   dfsimallreps <<- dfsimallreps
}

