abco_shrubgrowth <- function(pts.sf.abco, shrub_heightgrowth){
  
  # Load gam models from `Shrub_growth_analysis.Rmd`
  load("../../../results/coefficients/gamCECO.Rdata")
  load("../../../results/coefficients/gamARPA.Rdata")
  load("../../../results/coefficients/gamCEIN.Rdata")
  load("../../../results/coefficients/gamCHSE.Rdata")
  load("../../../results/coefficients/gamOTHER.Rdata")
  
  # Add a column for mean predicted shrub height for the present year, predicted by the GAM for each species
  x1 <- data.frame(years_since_fire = unique(pts.sf.abco$Years))

  if(shrub_heightgrowth == "CECO"){
    pts.sf.abco <- pts.sf.abco %>% 
    mutate(mean_shrub_ht_by_spp = predict.gam(gamCECO, x1, se= T)$fit)
  } else if(shrub_heightgrowth == "CEIN"){
    pts.sf.abco <- pts.sf.abco %>% 
      mutate(mean_shrub_ht_by_spp = predict.gam(gamCEIN, x1, se= T)$fit)
  } else if(shrub_heightgrowth == "ARPA"){
    pts.sf.abco <- pts.sf.abco %>% 
      mutate(mean_shrub_ht_by_spp = predict.gam(gamARPA, x1, se= T)$fit)
  } else if(shrub_heightgrowth == "empirical") {
    pts.sf.abco <- pts.sf.abco %>% 
      mutate(mean_shrub_ht_by_spp = case_when(
        ShrubSpp03 == "CECO" ~ predict.gam(gamCECO, x1, se= T)$fit,
        ShrubSpp03 == "ARPA" ~ predict.gam(gamARPA, x1, se= T)$fit,
        ShrubSpp03 == "CEIN" ~ predict.gam(gamCEIN, x1, se= T)$fit,
        TRUE  ~ predict.gam(gamOTHER, x1, se= T)$fit
      ))     
  }
  
  
  # Check
 # pts.sf.abco %>% group_by(ShrubSpp03, mean_shrub_ht_by_spp) %>% count()
  
  # Add a column for difference between current height and expected height
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(diff_shr_ht = Ht1.3 - mean_shrub_ht_by_spp)
  
  # Repeat the mean height calculations for the next year
  x2 <- data.frame(years_since_fire = unique(pts.sf.abco$Years+1))
  
  if(shrub_heightgrowth == "CECO"){
    pts.sf.abco <- pts.sf.abco %>% 
      mutate(mean_shrub_ht_by_spp_T2 = predict.gam(gamCECO, x2, se= T)$fit)
  } else if(shrub_heightgrowth == "CEIN"){
    pts.sf.abco <- pts.sf.abco %>% 
      mutate(mean_shrub_ht_by_spp_T2 = predict.gam(gamCEIN, x2, se= T)$fit)
  } else if(shrub_heightgrowth == "ARPA"){
    pts.sf.abco <- pts.sf.abco %>% 
      mutate(mean_shrub_ht_by_spp_T2 = predict.gam(gamARPA, x2, se= T)$fit)

  } else if(shrub_heightgrowth == "empirical") {
    pts.sf.abco <- pts.sf.abco %>% 
      mutate(mean_shrub_ht_by_spp_T2 = case_when(
        ShrubSpp03 == "CECO" ~ predict.gam(gamCECO, x2, se= T)$fit,
        ShrubSpp03 == "ARPA" ~ predict.gam(gamARPA, x2, se= T)$fit,
        ShrubSpp03 == "CEIN" ~ predict.gam(gamCEIN, x2, se= T)$fit,
        TRUE  ~ predict.gam(gamOTHER, x2, se= T)$fit
      ))     
  }
  
  
  # Check
  #pts.sf.abco %>% group_by(ShrubSpp03, mean_shrub_ht_by_spp, mean_shrub_ht_by_spp_T2) %>% count()
  
  # Now make height this new height plus the difference between predicted height and actual height for the present year
  # If the newly assigned height is less than 0, don't change the height
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(Ht1.3 = ifelse(mean_shrub_ht_by_spp_T2 + diff_shr_ht>0,mean_shrub_ht_by_spp_T2 + diff_shr_ht, Ht1.3 ))
  
  # Change shrub COVER based on linear model from my data
  #*******************************************************
  load("../../../results/coefficients/LM_shrubcover.Rdata")
  
  # Add a column for predicted shrub cover for the present year, predicted by the LM
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(predicted_shrub_cov = predict(lmALL.ME, newdata = pts.sf.abco)) 
  
  # Add a column for difference between current cover and expected cover
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(diff_shr_cov = Cov1.3 - predicted_shrub_cov)
  
  x2 <- pts.sf.abco %>% 
    mutate(Years = Years + 1)
  
  # Repeat the mean cover calculations for the next year
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(predicted_shrub_cov_T2 = predict(lmALL.ME, newdata = x2)) 
  
  # Check
  # ggplot(pts.sf.abco)+
  #   geom_point(aes(x = predicted_shrub_cov, y = predicted_shrub_cov_T2))+
  #   geom_abline(aes(intercept = 0, slope = 1))
  
  # Now make cover this new cover plus the difference between predicted cover and actual cover for the present year
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(Cov1.3 = predicted_shrub_cov_T2 + diff_shr_cov)
  
  #summary(pts.sf.abco$Cov1.3)
  
  # Re-calculate shrub indices
  pts.sf.abco <- pts.sf.abco %>% 
    mutate(shrubarea3 = Cov1.3*Ht1.3) %>% 
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3))
  
  return(pts.sf.abco)
}
