pipo_shrubgrowth <- function(){
  
  # Load gam models from `Shrub_growth_analysis.Rmd`
  load("~/Shrubs-Seedlings/results/coefficients/gamCECO.Rdata")
  load("~/Shrubs-Seedlings/results/coefficients/gamARPA.Rdata")
  load("~/Shrubs-Seedlings/results/coefficients/gamCEIN.Rdata")
  load("~/Shrubs-Seedlings/results/coefficients/gamCHSE.Rdata")
  load("~/Shrubs-Seedlings/results/coefficients/gamOTHER.Rdata")
  
  # Add a column for mean predicted shrub height for the present year, predicted by the GAM for each species
  x <- data.frame(years_since_fire = unique(pts.sf.pipo$Years))
  
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(mean_shrub_ht_by_spp = case_when(
      ShrubSpp03 == "CECO" ~ predict.gam(gamCECO, x, se= T)$fit,
      ShrubSpp03 == "ARPA" ~ predict.gam(gamARPA, x, se= T)$fit,
      ShrubSpp03 == "CEIN" ~ predict.gam(gamCEIN, x, se= T)$fit,
      ShrubSpp03 == "CHSE" ~ predict.gam(gamCHSE, x, se= T)$fit,
      TRUE  ~ predict.gam(gamOTHER, x, se= T)$fit
    )) %>% 
    mutate(se_shrub_ht_by_spp = case_when(
      ShrubSpp03 == "CECO" ~ predict.gam(gamCECO, x, se= T)$se.fit,
      ShrubSpp03 == "ARPA" ~ predict.gam(gamARPA, x, se= T)$se.fit,
      ShrubSpp03 == "CEIN" ~ predict.gam(gamCEIN, x, se= T)$se.fit,
      ShrubSpp03 == "CHSE" ~ predict.gam(gamCHSE, x, se= T)$se.fit,
      TRUE  ~ predict.gam(gamOTHER, x, se= T)$se.fit
    ))
  
  # Check
  pts.sf.pipo %>% group_by(ShrubSpp03, mean_shrub_ht_by_spp) %>% count()
  pts.sf.pipo %>% group_by(ShrubSpp03, se_shrub_ht_by_spp) %>% count()
  
  # Add a column for difference between current height and expected height
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(diff_shr_ht = Ht1.3 - mean_shrub_ht_by_spp)
  
  # Repeat the mean height calculations for the next year
  x <- data.frame(years_since_fire = unique(pts.sf.pipo$Years+1))
  
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(mean_shrub_ht_by_spp_T2 = case_when(
      ShrubSpp03 == "CECO" ~ predict.gam(gamCECO, x, se= T)$fit,
      ShrubSpp03 == "ARPA" ~ predict.gam(gamARPA, x, se= T)$fit,
      ShrubSpp03 == "CEIN" ~ predict.gam(gamCEIN, x, se= T)$fit,
      ShrubSpp03 == "CHSE" ~ predict.gam(gamCHSE, x, se= T)$fit,
      TRUE  ~ predict.gam(gamOTHER, x, se= T)$fit
    )) %>% 
    mutate(se_shrub_ht_by_spp_T2 = case_when(
      ShrubSpp03 == "CECO" ~ predict.gam(gamCECO, x, se= T)$se.fit,
      ShrubSpp03 == "ARPA" ~ predict.gam(gamARPA, x, se= T)$se.fit,
      ShrubSpp03 == "CEIN" ~ predict.gam(gamCEIN, x, se= T)$se.fit,
      ShrubSpp03 == "CHSE" ~ predict.gam(gamCHSE, x, se= T)$se.fit,
      TRUE  ~ predict.gam(gamOTHER, x, se= T)$se.fit
    ))
  
  # Check
  pts.sf.pipo %>% group_by(ShrubSpp03, mean_shrub_ht_by_spp, mean_shrub_ht_by_spp_T2) %>% count()
  pts.sf.pipo %>% group_by(ShrubSpp03, se_shrub_ht_by_spp, mean_shrub_ht_by_spp_T2) %>% count()
  
  # Now make height this new height plus the difference between predicted height and actual height for the present year
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(Ht1.3 = mean_shrub_ht_by_spp_T2 + diff_shr_ht)
  
  
  # Change shrub COVER based on linear model from my data
  load("~/Shrubs-Seedlings/results/coefficients/LM_shrubcover.Rdata")
  
  # Add a column for predicted shrub cover for the present year, predicted by the LM
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(predicted_shrub_cov = predict(lmALL.ME, newdata = pts.sf.pipo)) %>% 
    mutate(se_predicted_shrub_cov = predict(lmALL.ME, newdata = pts.sf.pipo, se= T)$se.fit)
  
  # Add a column for difference between current cover and expected cover
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(diff_shr_cov = Cov1.3 - predicted_shrub_cov)
  
  x2 <- pts.sf.pipo %>% 
    mutate(Years = Years + 1)
  
  # Repeat the mean height calculations for the next year
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(predicted_shrub_cov_T2 = predict(lmALL.ME, newdata = x2)) %>% 
    mutate(se_predicted_shrub_cov_T2 = predict(lmALL.ME, newdata = x2, se= T)$se.fit)
  
  # Check
  ggplot(pts.sf.pipo)+
    geom_point(aes(x = predicted_shrub_cov, y = predicted_shrub_cov_T2))+
    geom_abline(aes(intercept = 0, slope = 1))
  
  # Now make height this new height plus the difference between predicted height and actual height for the present year
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(Cov1.3 = predicted_shrub_cov_T2 + diff_shr_cov)
  
  
  # Re-calculate shrub indices
  pts.sf.pipo <<- pts.sf.pipo %>% 
    mutate(shrubarea3 = Cov1.3*Ht1.3) %>% 
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3))
}
