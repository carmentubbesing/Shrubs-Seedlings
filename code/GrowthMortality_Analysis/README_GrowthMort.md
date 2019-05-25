# Growth~Mortality Study

Data wrangling, cleaning, and analysis for the growth ~ mortality study.

Files are dependent in the following order:

## 1.  Compiling and cleaning code
#### **Clean_vert.Rmd**
* uses:
    * `~/../Dropbox (Stephens Lab)/SORTIE/Growth_mortality/data/details/compiled/archives/Mort_details_compiled_June25_2018.xlsx`
* creates:
    * `~/Shrubs-Seedlings/compiled_data/growth_mortality/df_vert.Rdata`
    * `~/Shrubs-Seedlings/compiled_data/growth_mortality/df_detailed_clean.Rdata`

#### **dendro_join.Rmd**
* uses:
    * all files in `Dropbox (Stephens Lab)/SORTIE/Growth_mortality/data/Growth Mortality Dendro Data/`
* creates:
    * `../../compiled_data/dendro_joined.Rdata`
    * `../../compiled_data/rwl_joined.Rdata`
    
#### **Clean_dendro.Rmd**
* uses:
    * `~/Shrubs-Seedlings/compiled_data/growth_mortality/df_detailed_clean.Rdata`
    * `../../compiled_data/dendro_joined.Rdata`
* creates:
    * `../../compiled_data/growth_mortality/dendro_all_vars.Rdata`
    * `../../data/GrowthMortality/live_pipo_rwl.Rdata`
    * `../../data/GrowthMortality/live_pipo.rwl`
    * `../../data/GrowthMortality/live_abco.rwl`
    * `../../data/GrowthMortality/dead_abco_rwl.Rdata`
    * `../../data/GrowthMortality/dead_pipo_rwl.Rdata`
    * `../../data/GrowthMortality/dead_abco.rwl`
    * `../../data/GrowthMortality/dead_pipo.rwl`


## Intermediary cleaning/analysis

#### **live_chronology.Rmd**

#### **date_dead_dendro.Rmd**
* uses:
    * `../../data/GrowthMortality/dead_pipo_rwl.Rdata`
    * `../../data/GrowthMortality/dead_abco_rwl.Rdata`
* creates:
    * `../../compiled_data/fir_rings_detrended.Rdata`

#### **Clean_detailed_data.Rmd**
* uses:
    * `../../compiled_data/growth_mortality/dendro_all_vars.Rdata`
    * `../../compiled_data/fir_rings_detrended.Rdata`



## 2. Main analyses
#### **Growth_analysis_vert.Rmd**
* uses: 
    * `~/Shrubs-Seedlings/compiled_data/growth_mortality/df_vert.Rdata`
* figures:
    * `fir_RGR.pdf`
    
#### **Dendro_analysis.Rmd**
* uses:
    * `../../data/GrowthMortality/rwl.Rdata`
    * `../../data/GrowthMortality/dendro_all_vars.Rdata`

            
        
