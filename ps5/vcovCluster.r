# vcovCluster.r 
# By Yiqing Xu

# function: computes var-cov matrix using clustered robust standart errors
# inputs:
# --model = model object from call to lm or glm
# --cluster = vector with cluster ID indicators
# output:
# --cluster robust var-cov matrix

# to call this for a model use:
# coeftest(model,vcov = vcovCluster(model, cluster))


vcovCluster <- function(model, cluster){
  require(sandwich)
  require(lmtest)
  if(nrow(model.matrix(model))!=length(cluster)){
    stop("check your data: cluster variable has different N than model")
  }
  M <- length(unique(cluster))
  N <- length(cluster)           
  K <- model$rank   
  if(M<50){
    warning("Fewer than 50 clusters, variances may be unreliable (could try block bootstrap instead).")
  }
  dfc <- (M/(M - 1)) * ((N - 1)/(N - K))
  uj  <- apply(estfun(model), 2, function(x) tapply(x, cluster, sum));
  rcse.cov <- dfc * sandwich(model, meat = crossprod(uj)/N)
  return(rcse.cov)
}