normalize <- function(x) {
  if(sd(x)==0){
    return((x-mean(dffull$Years))/sd(dffull$Years))
  } else{
    return ((x - mean(x)) / sd(x))
  }
}