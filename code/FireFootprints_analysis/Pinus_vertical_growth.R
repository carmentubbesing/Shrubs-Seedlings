## ---- include = F--------------------------------------------------------
require(nlme)
require(randomForest)
require(tree)
require(knitr)
require(tidyverse)
require(ggplot2)
require(VSURF)
require(effects)
require(MuMIn)
require(car)
set.seed(12346)


## ------------------------------------------------------------------------
setwd("~/Shrubs-Seedlings/code/FireFootprints_analysis/")
load(file="../../compiled_data/fire_footprints/master_seedlings_vert.Rdata")


## ------------------------------------------------------------------------
load("../../results/VSURF_pipo_vars.Rdata")


## ------------------------------------------------------------------------
df_summary <- df %>% 
  group_by(Species) %>% 
  summarize(min= min(sqrt_shrubarea3), max = max(sqrt_shrubarea3), median = median(sqrt_shrubarea3))


## ------------------------------------------------------------------------
min_shrub <- df_summary %>% 
  filter(min == max(min)) %>% 
  select(min) %>% 
  unlist()
min_shrub


## ------------------------------------------------------------------------
max_shrub <- df_summary %>% 
  filter(max == min(max)) %>% 
  select(max) %>% 
  unlist()
max_shrub


## ------------------------------------------------------------------------
median_shrub <- df %>% 
  mutate(shrubarea3 = sqrt(shrubarea3)) %>%
  summarize(median = median(shrubarea3)) %>% 
  unlist
median_shrub


## ------------------------------------------------------------------------
summary <- summary(sqrt(df$shrubarea3))
summary
quart1 <- summary[2]
quart3 <- summary[5]
mean <- mean(sqrt(df$shrubarea3))
shrubarea_range_conservative <- cbind(min, max, median)
shrubarea_range_conservative


## ------------------------------------------------------------------------
df %>% 
  filter(Species == "PIPO") %>% 
  group_by(Fire) %>% 
  summarize(n()) %>% 
  arrange(`n()`)
df <- df %>% 
  filter(Species == "PIPO")


## ------------------------------------------------------------------------
length(unique(df$Sdlg))
nrow(df)


## ------------------------------------------------------------------------
df %>% 
  group_by(Sdlg, Fire) %>%
  select(Sdlg, Fire) %>%
  distinct() %>% 
  ungroup() %>% 
  group_by(Fire) %>% 
  summarize(n = n()) %>% 
  mutate(total = sum(n))


## ------------------------------------------------------------------------
mean(df$VertGrowth_Rel)
sd(df$VertGrowth_Rel)
sd(df$VertGrowth_Rel)/sqrt(nrow(df))
ggplot(df)+
  geom_boxplot(aes(y = VertGrowth_Rel))


## ------------------------------------------------------------------------
normalize <- function(x) {
    return ((x - mean(x)) / sd(x))
  }


## ------------------------------------------------------------------------
LMdf <- df %>% 
  mutate(sqrt_shrubarea3 = sqrt(shrubarea3)) %>%
  mutate(log_shrubarea3 = log(shrubarea3+1)) %>%
  dplyr::select(Fire, 
         Sdlg, 
         VertGrowth_Rel, 
         Years, 
         Ht_cm1, 
         sqrt_shrubarea3, 
         log_shrubarea3, 
         BasDia2016.cm, 
         incidrad, 
         Year, 
         Elevation, 
         siteclass,
         heatload, 
         ShrubSpp03) %>% 
 mutate_if(is.numeric, normalize) %>% 
  mutate(VertGrowth_Rel = df$VertGrowth_Rel)
LMdf <- droplevels(LMdf)


## ------------------------------------------------------------------------
vars_one <- paste(vars, collapse = " + ")
vars_one
f <- formula(paste("VertGrowth_Rel ~ ",vars_one))
f


## ------------------------------------------------------------------------
LM <- lme(f, data = LMdf, random = ~ 1| Fire/Sdlg, method = "ML")


## ------------------------------------------------------------------------
source("~/../Documents/HighstatLibV10.R.txt")
z <- cbind(df$VertGrowth_Rel, df$Years, df$heatload, df$Ht_cm1, df$BasDia2016.cm, df$sqrt_shrubarea3, df$Elevation, df$Year)
colnames(z) <- c("Growth", "Years", "heatload", "Ht_cm1", "BasDia", "shrubs", "Elevation", "Year")
pairs(z, lower.panel = panel.smooth2, upper.panel = panel.cor, diag.panel = panel.hist)


## ------------------------------------------------------------------------
source("~/../Documents/HighstatLibV10.R.txt") # from Zuur https://highstat.com/index.php/mixed-effects-models-and-extensions-in-ecology-with-r
corvif(LMdf %>% select(!!vars))
vif(LM)


## ------------------------------------------------------------------------
f_int <- update(as.formula(f), ~ . + BasDia2016.cm:sqrt_shrubarea3)
LM_int <- lme(f_int, data = LMdf, random = ~ 1| Fire/Sdlg, method = "ML")
AICcmodavg::AICc(LM)
AICcmodavg::AICc(LM_int)
if(
  AICcmodavg::AICc(LM) > AICcmodavg::AICc(LM_int)
) print(paste("WITH INTERACTION WINS BY", round(AICcmodavg::AICc(LM)-AICcmodavg::AICc(LM_int), digits = 2), "AIC")) else print(paste("WITHOUT INTERACTION WINS BY", round(AICcmodavg::AICc(LM_int)-AICcmodavg::AICc(LM), digits = 2)))


## ------------------------------------------------------------------------
vars_int <- paste(vars_one, "+ Ht_cm1:sqrt_shrubarea3")
f_int <- formula(paste("VertGrowth_Rel ~ ",vars_int))
LM_int <- lme(f_int, data = LMdf, random = ~ 1| Fire/Sdlg, method = "ML")
AICcmodavg::AICc(LM)
AICcmodavg::AICc(LM_int)
if(
  AICcmodavg::AICc(LM) > AICcmodavg::AICc(LM_int)
) print(paste("WITH INTERACTION WINS BY", round(AICcmodavg::AICc(LM)-AICcmodavg::AICc(LM_int), digits = 2), "AIC")) else print(paste("WITHOUT INTERACTION WINS BY", round(AICcmodavg::AICc(LM_int)-AICcmodavg::AICc(LM), digits = 2)))


## ------------------------------------------------------------------------
plot(LM)


## ------------------------------------------------------------------------
f_no_log <- formula(paste("exp(VertGrowth_Rel) ~", vars_one))
LM_no_log <-  lme(f_no_log, data = LMdf, random = ~ 1| Fire/Sdlg, method = "ML")
plot(LM_no_log)


## ------------------------------------------------------------------------
summary(LM)


## ------------------------------------------------------------------------
drop <- drop1(LM, test = "Chisq")
drop$var <- row.names(drop)
drop <- tbl_df(drop)
drop %>% 
  arrange( `Pr(>Chi)`) %>% 
  mutate( `Pr(>Chi)` = paste( `Pr(>Chi)`))


## ------------------------------------------------------------------------
cor(df$Ht_cm1, df$sqrt_shrubarea3)
ggplot(df, aes(x = Ht_cm1, y = sqrt_shrubarea3))+
  geom_point()+
  geom_smooth(method = "lm")


## ------------------------------------------------------------------------
E <- resid(LM, type = "normalized")
df$E <- E
pred <- predict(LM)
plot(LM)
plot(df$shrubarea3, E)
plot(df$Ht_cm1, E)
plot(df$Years, E)
plot(df$Ht1.3, E)
plot(df$BasDia2016.cm, E)
plot(df$incidrad, E)
plot(df$Year, E)
ggplot(df, aes(x = log(df$shrubarea3), y = E))+
  geom_point()+
  geom_smooth()


## ------------------------------------------------------------------------
plot(predictorEffect("Years", LM))
plot(predictorEffect("sqrt_shrubarea3", LM))
plot(predictorEffect("Ht_cm1", LM))
plot(predictorEffect("ShrubSpp03", LM))


## ------------------------------------------------------------------------
r.squaredGLMM(LM)


## ------------------------------------------------------------------------
eff_shrubarea <- predictorEffect("sqrt_shrubarea3", LM)
effects_df <- as.data.frame(eff_shrubarea)
head(effects_df)


## ------------------------------------------------------------------------
effects_df <- effects_df %>% 
  mutate(sqrt_shrubarea3 = sqrt_shrubarea3*sd(sqrt(df$shrubarea3))+mean(sqrt(df$shrubarea3)) ) 


## ------------------------------------------------------------------------
plot_min <- exp(min(effects_df$lower))
plot_max <- exp(max(effects_df$upper))
save(plot_min, file = "../../results/figures/FireFootprints/plot_min.Rdata")
save(plot_max, file = "../../results/figures/FireFootprints/plot_max.Rdata")


## ------------------------------------------------------------------------
ggplot(effects_df)+
  geom_line(aes(x = sqrt_shrubarea3, y = exp(fit)), col = "#fc8d62")+
  geom_ribbon(aes(x = sqrt_shrubarea3, ymin = exp(lower), ymax = exp(upper)), fill = "#fc8d62",   alpha = .4)+
  theme_bw()+
  xlab(bquote('                           Shrub competition ' ))+
  ylab("Relative growth rate")+
  geom_rug(data = df, aes(x = sqrt(shrubarea3), y = exp(VertGrowth_Rel)), alpha = .7, position = "jitter", sides = "b")+
  ylim(c(plot_min, plot_max))+
  labs(fill = "Juvenile tree height (cm)")+
  labs(col = "Juvenile tree height (cm)")+
  theme(legend.position = c(0.62, 0.8))+
  theme(
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        text = element_text(size = 11))
ggsave(file = "../../results/figures/FireFootprints/PineVertRel_noint.png", width = 3, height = 3, dpi = 400)


## ------------------------------------------------------------------------
ggplot(df)+
  geom_boxplot(aes(x = Fire, y = shrubarea3))
ggplot(df)+
  geom_boxplot(aes(x = as.factor(Years), y = shrubarea3))


## ------------------------------------------------------------------------
summary(df$Cov1.3)
summary(df$Ht1.3)
summary(df$shrubarea3)


## ------------------------------------------------------------------------
summary(df$Cov1.3/(300*4))


## ------------------------------------------------------------------------
save(LM, file = "../../results/data/FireFootprints/LM_pipo.Rdata")


## ------------------------------------------------------------------------
newdata_means <- as.data.frame(LMdf) %>% 
  ungroup() %>% 
  summarise_if(is.numeric, .funs = c("mean")) %>% 
  mutate(sqrt_shrubarea3 = min(LMdf$sqrt_shrubarea3))

newdata_cat <- LMdf %>% 
  select(ShrubSpp03, Year) %>% 
  distinct()
sdlg <- as.data.frame(sort(rep(LMdf$Sdlg, 18))) %>% 
  rename(Sdlg = `sort(rep(LMdf$Sdlg, 18))`)
newdata <-cbind(newdata_means, newdata_cat)
newdata <- cbind(sdlg, newdata)
Fires <- LMdf %>% select(Sdlg, Fire) %>% mutate(Fire = as.factor(Fire))
newdata <- full_join(Fires, newdata)
pred <- predict(LM, newdata = newdata)
gr_minshrub_pipo <- exp(mean(pred))


## ------------------------------------------------------------------------
newdata_means <- as.data.frame(LMdf) %>% 
  ungroup() %>% 
  summarise_if(is.numeric, .funs = c("mean")) %>% 
  mutate(sqrt_shrubarea3 = max(LMdf$sqrt_shrubarea3))

newdata_cat <- LMdf %>% 
  select(ShrubSpp03, Year) %>% 
  distinct()
sdlg <- as.data.frame(sort(rep(LMdf$Sdlg, 18))) %>% 
  rename(Sdlg = `sort(rep(LMdf$Sdlg, 18))`)
newdata <-cbind(newdata_means, newdata_cat)
newdata <- cbind(sdlg, newdata)
Fires <- LMdf %>% select(Sdlg, Fire) %>% mutate(Fire = as.factor(Fire))
newdata <- full_join(Fires, newdata)
pred <- predict(LM, newdata = newdata)
gr_maxshrub_pipo <- exp(mean(pred))


## ------------------------------------------------------------------------
newdata_means <- as.data.frame(LMdf) %>% 
  ungroup() %>% 
  summarise_if(is.numeric, .funs = c("mean")) %>% 
  mutate(sqrt_shrubarea3 = median(LMdf$sqrt_shrubarea3))

newdata_cat <- LMdf %>% 
  select(ShrubSpp03, Year) %>% 
  distinct()
sdlg <- as.data.frame(sort(rep(LMdf$Sdlg, 18))) %>% 
  rename(Sdlg = `sort(rep(LMdf$Sdlg, 18))`)
newdata <-cbind(newdata_means, newdata_cat)
newdata <- cbind(sdlg, newdata)
Fires <- LMdf %>% select(Sdlg, Fire) %>% mutate(Fire = as.factor(Fire))
newdata <- full_join(Fires, newdata)
pred <- predict(LM, newdata = newdata)
gr_medshrub_pipo <- exp(mean(pred))


## ------------------------------------------------------------------------
save(gr_minshrub_pipo, file = "../../results/data/FireFootprints/gr_minshrub_pipo.Rdata")
save(gr_maxshrub_pipo, file = "../../results/data/FireFootprints/gr_maxshrub_pipo.Rdata")
save(gr_medshrub_pipo, file = "../../results/data/FireFootprints/gr_medshrub_pipo.Rdata")


## ------------------------------------------------------------------------
fit_median <- effects_df[which.min(abs(effects_df$sqrt_shrubarea3 - median_shrub)),]$fit
fit_median
fit_min <- effects_df[which.min(abs(effects_df$sqrt_shrubarea3 - min_shrub)),]$fit
fit_min
fit_max <- effects_df[which.min(abs(effects_df$sqrt_shrubarea3 - max_shrub)),]$fit
#fit_mean <- effects_df[which.min(abs(effects_df$sqrt_shrubarea3 - mean_shrub)),]$fit
mean <- mean(df$shrubarea3/10000)
print(paste("fit_median = ", exp(fit_median)))
print(paste("fit_min = ", exp(fit_min)))
print(paste("fit_max = ", exp(fit_max)))
print(paste("fit_median_log = ", fit_median))
print(paste("fit_min_log = ", fit_min))
print(paste("fit_max_log = ", fit_max))
#print(paste("fit_mean_log = ", fit_mean))


## ------------------------------------------------------------------------
gr_minshrub_pipo <- exp(fit_min)
gr_maxshrub_pipo <- exp(fit_max)
gr_medshrub_pipo <- exp(fit_median)


## ------------------------------------------------------------------------
collins_shrubarea <- sqrt((.6*1200)*86)
effects_df[which.min(abs(effects_df$sqrt_shrubarea3 - quart1)),]$fit


## ------------------------------------------------------------------------
sd <- sd(df$shrubarea3/10000)


## ------------------------------------------------------------------------
eff_shrubspp <- predictorEffect("ShrubSpp03", LM)
effects_df <- as.data.frame(eff_shrubspp)
head(effects_df)


## ------------------------------------------------------------------------
ggplot(effects_df %>% filter(ShrubSpp03 != "Other"  ))+
  geom_point(aes(x = ShrubSpp03, y = exp(fit)))+
  ylim(.1, .25)+
  ylab("Juvenile pine relative growth rate")+
  theme_bw()+
  geom_errorbar(aes(x = ShrubSpp03, ymin=exp(lower), ymax=exp(upper)), width=.1) +
  scale_x_discrete(labels=c("ARPA" = "Arctostaphylos\npatula",
                            "CECO" = "Ceanothus\ncordulatus",
                            "CEIN" = "Ceanothus\nintegerrimus",
                            "CHFO" = "Chamaebatia\nfoliolosa",
                            "LIDE" = "Notholithocarpus\ndensiflorus"
                            ))+
  theme(  text = element_text(size = 11),
          panel.grid.major.x = element_blank(),
          panel.grid.minor = element_blank(),
          axis.text.x = element_text(face = "bold.italic",
                                   angle=45, 
                                   vjust=1, 
                                   hjust=1))+
  xlab("Dominant shrub species")
  


ggsave(file = "../../results/figures/FireFootprints/PineVertShrubSpp.png", width = 4, height = 4, dpi = 400)


## ------------------------------------------------------------------------
sort(unique(df$Sdlg))


## ------------------------------------------------------------------------
df %>% 
  filter(Year==2015) %>% 
  filter(is.na(Ht2017.cm.fall) & is.na(Ht2015.meas2016)) %>% 
  nrow()


## ------------------------------------------------------------------------
save(df, file ="../../compiled_data/fire_footprints/pine_vert.Rdata")

