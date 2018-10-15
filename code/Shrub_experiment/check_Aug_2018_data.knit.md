---
title: "Check August 2018 Data"
author: "Carmen"
date: "October 11, 2018"
output: html_document
---




# Read in all data

```r
df <- read_excel("~/../Dropbox (Stephens Lab)/Shrub_experiment/Data/Original - do not edit/seedlings_Aug_2018/Seedling_vert_Aug30_2018_1100(4).xlsx")
```

# Do some basic cleaning

```r
df <- df %>% 
  rename(SEEDLING = `seedling tag #`)
```


# See if all compartments and islands and plots are represented

```r
print(df %>% group_by(compartment, island, plot) %>% 
  summarise(count = n()), n = 50)
```

```
## # A tibble: 49 x 4
## # Groups:   compartment, island [?]
##    compartment island  plot count
##          <dbl> <chr>  <dbl> <int>
##  1         180 A          1     4
##  2         180 A          2     6
##  3         180 B          1    16
##  4         180 B          2    14
##  5         180 C          1    14
##  6         180 C          2     6
##  7         180 D          1    16
##  8         180 D          2     8
##  9         180 E          1    10
## 10         180 E          2     3
## 11         180 F          1     6
## 12         180 F          2    13
## 13         180 G          1    13
## 14         180 G          2    11
## 15         180 H          1    12
## 16         180 H          2     9
## 17         180 J          1    11
## 18         180 J          2    19
## 19         180 P          1    13
## 20         180 P          2     8
## 21         180 Q          1     7
## 22         180 Q          2    11
## 23         180 R          1    17
## 24         180 R          2     7
## 25         180 S          1     3
## 26         180 S          2     5
## 27         180 U          1     7
## 28         180 U          2     4
## 29         380 C          1     5
## 30         380 C          2     6
## 31         380 K          1     9
## 32         380 K          2     9
## 33         380 L          1     9
## 34         380 L          2    11
## 35         380 N          1    18
## 36         380 N          2    20
## 37         380 Q          1    13
## 38         380 Q          2    12
## 39         570 E          1     4
## 40         570 E          2     3
## 41         570 G          1     7
## 42         570 G          2     6
## 43         570 J          1     8
## 44         570 J          2    15
## 45         570 O          1     8
## 46         570 O          2     6
## 47         570 P          1     7
## 48         570 P          2     7
## 49          NA <NA>      NA     1
```

# Compare to previous seedling list from 2017

Note: there are two sets of 2017 df's, because some seedlings had vert data but not diameter data and vice versa

```r
df18 <- df
remove(df)
load("~/../Dropbox (Stephens Lab)/Shrub_experiment/Data/JOINED_DATA/df_vert_final.Rdata")
df17v <- df
remove(df)
load("~/../Dropbox (Stephens Lab)/Shrub_experiment/Data/JOINED_DATA/df_dia_final.Rdata")
df17d <- df
remove(Df)
```

```
## Warning in remove(Df): object 'Df' not found
```

# There are more seedlings in the 2018 data than the 2018 data. Investigate why that is. 

## Rename column name in 2017 data












