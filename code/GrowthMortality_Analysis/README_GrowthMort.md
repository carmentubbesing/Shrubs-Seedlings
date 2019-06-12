# Growth~Mortality Study

Data wrangling, cleaning, and analysis for the growth ~ mortality study.

Files are dependent in the following order:

## 1.  Compiling and cleaning code
#### **Clean_all.Rmd**
* uses:
    * `~/../Dropbox (Stephens Lab)/SORTIE/Growth_mortality/data/details/compiled/archives/Mort_details_compiled_June25_2018.xlsx`
* creates:
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

#### **live_chronology.Rmd**
* uses:
    * `../../data/GrowthMortality/live_pipo_rwl.Rdata`
    * `../../data/GrowthMortality/live_abco_rwl.Rdata`
    * `../../data/GrowthMortality/dead_pipo_rwl.Rdata`
    * `../../data/GrowthMortality/dead_abco_rwl.Rdata`
* creates:
    * `../../compiled_data/live_chron_abco.Rdata`
    * `../../compiled_data/live_chron_pipo.Rdata`
* figures:
    * `../../results/figures/GrowthMortality/live_chron_pipo_nogreendead.jpg`
    * `../../results/figures/GrowthMortality/live_chron_pipo_nogreendead.jpg`
    
#### **date_dead_dendro_abco.Rmd** and **date_dead_dendro_pipo.Rmd**
* uses:
    * `../../data/GrowthMortality/dead_pipo_rwl.Rdata`
    * `../../data/GrowthMortality/dead_abco_rwl.Rdata`
* creates:
    * `../../compiled_data/fir_rings_detrended.Rdata`
    * `../../results/data/GrowthMortality/died2017_abco.Rdata`
    * `../../results/data/GrowthMortality/died2016_abco.Rdata`
    * `../../results/data/GrowthMortality/died2015_abco.Rdata`
    * `../../results/data/GrowthMortality/died2017_pipo.Rdata`
    * `../../results/data/GrowthMortality/died2016_pipo.Rdata`
    * `../../results/data/GrowthMortality/died2015_pipo.Rdata`

#### **Clean_vert.Rmd**
* uses:
    * `~/Shrubs-Seedlings/compiled_data/growth_mortality/df_detailed_clean.Rdata`
    * `../../results/data/GrowthMortality/died2017_abco.Rdata`
    * `../../results/data/GrowthMortality/died2016_abco.Rdata`
    * `../../results/data/GrowthMortality/died2015_abco.Rdata`
    * `../../results/data/GrowthMortality/died2017_pipo.Rdata`
    * `../../results/data/GrowthMortality/died2016_pipo.Rdata`
    * `../../results/data/GrowthMortality/died2015_pipo.Rdata`
* creates:
    * `~/Shrubs-Seedlings/compiled_data/growth_mortality/df_vert.Rdata`

#### **mortality_counts.Rmd**
* uses:
    * `~/../Dropbox (Stephens Lab)/SORTIE/Growth_mortality/data/counts/compiled/Mort_180_counts_compiled_Aug16_2017.xlsx`
    * `~/../Dropbox (Stephens Lab)/SORTIE/Growth_mortality/data/counts/compiled/Mort_380_counts_compiled_Oct1_2017.xlsx`

## 2. Main analyses
#### **Growth_analysis_vert.Rmd**
* uses: 
    * `~/Shrubs-Seedlings/compiled_data/growth_mortality/df_vert.Rdata`
* figures:
    * `fir_RGR.pdf`
    * `../../results/figures/GrowthMortality/Pine_vert_boxplot.png`
    
#### **Dendro_analysis.Rmd**
* uses:
    * `../../data/GrowthMortality/rwl.Rdata`
    * `../../data/GrowthMortality/dendro_all_vars.Rdata`
    * `../../results/data/GrowthMortality/died2017.Rdata`
    * `../../results/data/GrowthMortality/died2016.Rdata`
    * `../../results/data/GrowthMortality/died2015.Rdata`
    
#### **simulations.Rmd**
* uses:
    * `~/Shrubs-Seedlings/compiled_data/growth_mortality/df_vert.Rdata`


            
        
