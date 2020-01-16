abco_shrubgrowth <- function(){
  
  # Load gam models from `Shrub_growth_analysis.Rmd`
  load("~/Shrubs-Seedlings/results/coefficients/gamCECO.Rdata")
  load("~/Shrubs-Seedlings/results/coefficients/gamARPA.Rdata")
  load("~/Shrubs-Seedlings/results/coefficients/gamCEIN.Rdata")
  load("~/Shrubs-Seedlings/results/coefficients/gamCHSE.Rdata")
  load("~/Shrubs-Seedlings/results/coefficients/gamOTHER.Rdata")
  
  # Add a column for mean predicted shrub height for the present year, predicted by the GAM for each species
  x <- data.frame(years_since_fire = unique(pts.sf.abco$Years))

  pts.sf.abco <<- pts.sf.abco %>% 
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
  pts.sf.abco %>% group_by(ShrubSpp03, mean_shrub_ht_by_spp) %>% count()
  pts.sf.abco %>% group_by(ShrubSpp03, se_shrub_ht_by_spp) %>% count()
  
  # Add a column for difference between current height and expected height
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(diff_shr_ht = Ht1.3 - mean_shrub_ht_by_spp)
  
  # Repeat the mean height calculations for the next year
  x <- data.frame(years_since_fire = unique(pts.sf.abco$Years+1))
  
  pts.sf.abco <<- pts.sf.abco %>% 
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
  pts.sf.abco %>% group_by(ShrubSpp03, mean_shrub_ht_by_spp, mean_shrub_ht_by_spp_T2) %>% count()
  pts.sf.abco %>% group_by(ShrubSpp03, se_shrub_ht_by_spp, mean_shrub_ht_by_spp_T2) %>% count()
  
  # Now make height this new height plus the difference between predicted height and actual height for the present year
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(Ht1.3 = mean_shrub_ht_by_spp_T2 + diff_shr_ht)
  
  # Re-calculate shrub indices
  pts.sf.abco <<- pts.sf.abco %>% 
    mutate(shrubarea3 = Cov1.3*Ht1.3) %>% 
    mutate(sqrt_shrubarea3 = sqrt(shrubarea3))
}
