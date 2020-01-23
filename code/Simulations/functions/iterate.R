dfsimallreps <- data.frame()
time.start <- Sys.time()
iterate <- function(n){
  for(i in 1:n){
    i_tenth <- i/10
    if(i_tenth %in% seq(1,100)){
      print(paste("Done with", i, "iterations in", round(Sys.time()-time.start, 1), "minutes"))
    }
    suppressMessages(initialize())
    suppressMessages(sim(years))
    
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

