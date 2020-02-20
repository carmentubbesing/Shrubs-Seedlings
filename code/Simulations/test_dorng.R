require(doParallel)

no_cores <- detectCores() - 2 # Use all but one core on your computer
c1 <- makeCluster(no_cores)
registerDoParallel(c1)



n <- 10

dfsimallreps<- 0
dfsimallreps <- foreach(i= 1:n, .combine = c) %dopar% {
  source("~/Shrubs-Seedlings/code/Simulations/test_function.R")
  testfunction()
}

dfsimallreps
