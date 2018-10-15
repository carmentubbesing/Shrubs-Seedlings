---
title: "diameter growth analysis"
author: "Carmen"
date: "November 9, 2017"
output: 
    html_document:
        toc: TRUE
---

This code analyzes how shrub removal affected seedling radial growth.



# Load data

```r
df <- read.csv(file = "~/../Dropbox (Stephens Lab)/Shrub_experiment/Data/JOINED_DATA/df_dia.csv")
dfshrub <- read.csv(file = "~/../Dropbox (Stephens Lab)/Shrub_experiment/Data/JOINED_DATA/dfshrub.csv")
```

# Add shrub data

```r
df <- full_join(df, dfshrub)
```

```
## Joining, by = c("compartment", "island", "plot")
```

```r
summary(df$shrubarea)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   33000   47900   64000   66869   78025  119000
```

# Look at sample sizes

```r
df %>% group_by(species, shrub_species, shrubs) %>% 
  summarise(n())
```

```
## # A tibble: 12 x 4
## # Groups:   species, shrub_species [?]
##    species shrub_species   shrubs `n()`
##     <fctr>        <fctr>   <fctr> <int>
##  1    ABCO          ARPA  removed    32
##  2    ABCO          ARPA retained    25
##  3    ABCO          CECO  removed    44
##  4    ABCO          CECO retained    42
##  5    ABCO          CEIN  removed    49
##  6    ABCO          CEIN retained    63
##  7    PIPO          ARPA  removed    35
##  8    PIPO          ARPA retained    19
##  9    PIPO          CECO  removed    45
## 10    PIPO          CECO retained    21
## 11    PIPO          CEIN  removed    32
## 12    PIPO          CEIN retained    29
```

# Check for missing values

```r
summary(df$dia_growth_rel)
```

```
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## -0.40541  0.00000  0.05042  0.05729  0.11180  0.55556
```

```r
summary(df$species)
```

```
## ABCO PIPO 
##  255  181
```

```r
summary(df$shrub_species)
```

```
## ARPA CECO CEIN 
##  111  152  173
```

```r
summary(df$ht_cm)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    6.00   20.00   42.00   49.42   70.00  203.00
```

# Look at height distributions by shrub species

```r
ggplot(df)+
  geom_boxplot(aes(x = interaction(shrub_species, species), y = ht_cm))
```

<img src="analyze_diameter_growth_files/figure-html/unnamed-chunk-6-1.png" width="672" />

# How many of the measurements are below 0?

```r
df %>% 
  summarise(n_neg = sum(dia_growth_rel<0), n_pos = sum(dia_growth_rel>=0), n_total = n()) 
```

```
##   n_neg n_pos n_total
## 1   109   327     436
```

# Stats

## Distribution of diameter growth

```r
hist(df$dia_growth_rel, breaks = 30)
```

<img src="analyze_diameter_growth_files/figure-html/unnamed-chunk-8-1.png" width="672" />

Looks pretty normal.

## Mixed effects with island effect

```r
MM1 <- lme(dia_growth_rel ~ shrubs + ht_cm +  species + shrub_species + shrubarea + shrubs:species + shrubs:shrub_species + shrubs:ht_cm, random =~1|island, data = df, method = "ML")
MM1_noremoval <- lme(dia_growth_rel ~ ht_cm + species + shrub_species + shrubarea, random =~1|island, method = "ML",data = df)
anova(MM1, MM1_noremoval)
```

```
##               Model df       AIC       BIC   logLik   Test  L.Ratio
## MM1               1 13 -691.3371 -638.3278 358.6686                
## MM1_noremoval     2  8 -673.8508 -641.2297 344.9254 1 vs 2 27.48634
##               p-value
## MM1                  
## MM1_noremoval  <.0001
```

### Residuals

```r
E <- residuals(MM1)
pred <- predict(MM1)
plot(MM1, which=c(1))
```

<img src="analyze_diameter_growth_files/figure-html/unnamed-chunk-10-1.png" width="672" />

```r
plot(df$shrubs, E)
```

<img src="analyze_diameter_growth_files/figure-html/unnamed-chunk-10-2.png" width="672" />

```r
plot(df$species, E)
```

<img src="analyze_diameter_growth_files/figure-html/unnamed-chunk-10-3.png" width="672" />

```r
plot(df$shrub_species, E)
```

<img src="analyze_diameter_growth_files/figure-html/unnamed-chunk-10-4.png" width="672" />

# Plot predictions

### Create MyData

```r
MyData <- expand.grid(shrubs = c("retained", "removed"), ht_cm = c(seq(10,300, length = 20)), species = c("ABCO", "PIPO"), shrub_species = c("CEIN","CECO","ARPA"), shrubarea = seq(33000,120000, length = 20))
```

### Add pred

```r
MyData$predMM <- predict(MM1, level = 0, newdata = MyData)
```

## Overall effect of removal on diameter growth

```r
MyData_summary <- MyData %>% 
  group_by(shrubs, shrub_species, species) %>% 
  summarise(mean_predMM = mean(predMM))
figure <- ggplot(MyData_summary,aes(x = shrubs, y = mean_predMM)) +
  geom_point(aes(col = species, shape = shrub_species), size = 2)+
  geom_line(aes(col = species, linetype = shrub_species, group = interaction(shrub_species, species)))+
  theme_bw()+
  scale_color_manual(values=c("#1a9850", "#d73027"))+
  labs(y = "Predicted relative diameter growth")+
  ggtitle("Shrub removal increased diameter growth,\nespecially for whitethorn")
setwd("~/../Dropbox (Stephens Lab)/Shrub_experiment/results/figures/")
png("dia_growth.png")
figure
dev.off()
```

```
## png 
##   2
```

### Plot effect of height

```r
MyData$ht_cm <- as.numeric(paste(MyData$ht_cm))
MyData_height_summary <-  MyData %>% 
  group_by(species, shrubs, ht_cm) %>% 
  summarise(predMM = mean(predMM))
  
ggplot(MyData_height_summary)+
  geom_line(aes(x = ht_cm, y = predMM, group = interaction(shrubs, species), col = species, linetype = shrubs))+
  scale_color_manual(values = c('#d73027','#66bd63','#f46d43','#a6d96a','#fdae61','#1a9850'))+
  theme_bw()+
  ggtitle("The effect of removal was stronger for larger seedlings")+
  labs(y = "Predicted relative growth rate")+
  labs(x = "Seedling height in 2017 (cm)")
```

<img src="analyze_diameter_growth_files/figure-html/unnamed-chunk-14-1.png" width="672" />

The taller the seedling, the smaller the effect of removal. Makes sense.

### Effect of pre-treatment shrub cover 

```r
MyData_shrubarea_summary <- MyData %>% 
  group_by(species, shrubs, shrubarea) %>% 
  summarise(predMM = mean(predMM))
ggplot(MyData_shrubarea_summary)+
  geom_line(aes(x = shrubarea, y = predMM, group = interaction(shrubs, species), linetype = shrubs, col = species))
```

<img src="analyze_diameter_growth_files/figure-html/unnamed-chunk-15-1.png" width="672" />

The greater the pre-treatment shrub cover, the greater the predicted diameter growth. 


# Save final data frame

```r
save(df, file = "~/../Dropbox (Stephens Lab)/Shrub_experiment/Data/JOINED_DATA/df_dia_final.Rdata")
```
