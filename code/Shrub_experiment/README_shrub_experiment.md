# Shrub Experiment

Data wrangling, cleaning, and analysis for the Blodgett Shrub Removal Experiment.

Files are dependent in the following order:

## 1.  Cleaning code
#### **compile_all_seedling_data_2017.Rmd**
* uses:
    * `Spring_seedling_data_compiled_20171107.xlsx`
    * `Aug_seedling_data_compiled_110717.xlsx`
* creates:
    * `df_vert.Rdata`
    * `df_vert.csv`
    * `df_dia.Rdata`
    * `df_dia.csv`
* changes to sample sizes
    * `df`
        * started with 456
        * removing those that said "thrown out" in notes: -13 = 443
        * removing dead ones, except the one with a note that it died after completing that year's growth: -10 = 433
    * `df_dia`
        * removing those without spring 2017 diameter data: -3 = 430
        * removing those with obvious errors in diameter measurements: -3 = 427
    * `df_vert`
        * 40 trees removed because of broken leaders = 393
        * 1 tree removed because 2016 growth was not distinguishable = 392 

#### **clean_shrub_data.Rmd**
* uses:
    * `ShrubCov_compiled_20171108.xlsx`
* creates:
    * `dfshrub.csv`
    
#### **check_Aug_2018_data**
* uses:
    * `Seedling_vert_Aug30_2018_1100(4).xlsx`
    * 
* creates:
    * `t`

## 2. Intermediary Analysis
#### **1**
* uses: 
    * `1`
    * 
* creates: 
    * `1`
        
## 3. Main analyses
#### **analyze_diameter_growth.Rmd**
* uses:
    * `df_dia.csv`
    * `dfshrub.csv`
* creates:
    * `df_dia_final.Rdata`
* figures:
    * `dia_growth.png`
    
#### **analyze_vertical_growth.Rmd**
* uses:
    * `df_vert.csv`
    * `dfshrub.csv`
* creates:
    * `df_vert_final.Rdata`
* figures:
    * `vert_growth.png`

#### **analyse_volume_growth.Rmd**
* uses: 
    * `df_dia_final.Rdata`
    * `df_vert_final.Rdata`
* creates:
    * none
* figures:
    * `meansSE.pdf`
    
#### **pine_analysis_volume.Rmd**
* uses:
    * `df_dia_final.Rdata`
    * `df_vert_final.Rdata`
* creates:
    * none
* figures:
    * `RGR.png`
    

## 5. Results summaries
#### **1**
* uses:
    * 1`
            
        
