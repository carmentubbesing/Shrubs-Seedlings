# Fire Footprint Study

Data wrangling, cleaning, and analysis for the fire footprint shrubs + seedlings study.

Files are dependent in the following order:

## 1.  Cleaning code

#### **clean_seedlings_2016.Rmd**
* uses:
    * `~/../Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Completed_Data_and_Photos/Master_Compiled_seedlings.csv`
* creates:
    * `../../compiled_data/fire_footprints/seedlings_cleaned_2016.Rdata`

#### **clean_shrubs.Rmd**
* uses:
    * `~/../Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Completed_Data_and_Photos/Master_Compiled_shrubs.csv`
    * `../../compiled_data/fire_footprints/seedlings_cleaned_2016.Rdata`
* creates:
    * `~/Shrubs-Seedlings/compiled_data/shrub_master_data_2016.Rdata`
* does:
    * merges data from both 2016 visits for trees that were revisited

#### **clean_combine_2016-only.Rmd**
* uses:
    * `~/Shrubs-Seedlings/compiled_data/shrub_master_data_2016.Rdata`
    * `~/../Dropbox (Stephens Lab)/SORTIE/Shrubs_Summer16/Completed_Data_and_Photos/LAI-2000_data/AllDIFNGaps1-4`
* creates:
    * `~/Shrubs-Seedlings/compiled_data/master_data_2016.Rdata`
    * `~/Shrubs-Seedlings/compiled_data/master_data_2016.csv`

#### **clean_combine_2016-2017.Rmd**
* uses:
    * `~/../Dropbox (Stephens Lab)/SORTIE/FireFootprints_2017/data/compiled/`
    * `Shrubs_Summer17_Compiled_Sep14.xlsx`
    * `~/Shrubs-Seedlings/compiled_data/`
    * `master_data_2016.csv`
* creates:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings.Rdata`
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings.csv`

#### **add_site_class.Rmd**
* uses:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings.Rdata`
* creates: 
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings1.Rdata`

## 2. Intermediary Data Wrangling and Analysis

#### **Heat_load**
* does:
    * fills in missing values of slope, aspect, and latitude
    * calculates heat load from slope, aspect, and latitude
* uses:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings1.Rdata`
* creates:
    *  `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings2.Rdata`
    
#### **Clean_vert_growth**
* uses:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings2.Rdata`
* creates:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings_vert.Rdata`

## 3. Main analyses

#### **fir_vert_growth_all_years**
* uses: 
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings_vert.Rdata`
* creates: 
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/fir_vert.Rdata`
    
#### **Pine_vertical_growth**
* uses:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings_vert.Rdata`
* creates:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/pinus_vert.Rdata`

#   _____________________________________________________________________________________________



# ARCHIVES

    
#### **clean_dia_both_species.Rmd**
* uses:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_seedlings2.Rdata`
* creates:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_dia.Rdata`

#### **fir_dia_growth_all_years**
* uses: 
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_dia.Rdata`
* creates: 
    * `~/Shrubs-Seedlings/compiled_data/fire_footprints/fir_dia.Rdata`
* figures:
    * `fir_dia.pdf`

#### **Pine_dia_growth**
* uses:
    * `~/../Documents/Shrubs-Seedlings/compiled_data/fire_footprints/master_dia.Rdata`
* creates:
    * `~/Shrubs-Seedlings/compiled_data/fire_footprints/pinus_dia.Rdata`

#### **Fir_vol_growth_clean**
* does: 
    * gets volume data ready for analysis
* uses: 
    * `~/Shrubs-Seedlings/compiled_data/fire_footprints/fir_dia.Rdata`
    * `~/Shrubs-Seedlings/compiled_data/fire_footprints/fir_vert.Rdata`
* creates:
    * `~/Shrubs-Seedlings/compiled_data/fire_footprints/fir_vol.Rdata`

#### **Fir_vol_growth_analysis**
* does:
    * filter to seedlings that have data for both vertical growth and diameter growth
    * removes outliers (>2 SD from mean)
    * adjust diameter growth so that all values are > 0 
    * calculate relative growth rate
* uses: 
    * `~/Shrubs-Seedlings/compiled_data/fire_footprints/fir_dia.Rdata`
    * `~/Shrubs-Seedlings/compiled_data/fire_footprints/fir_vert.Rdata`
* creates:
    * `~/Shrubs-Seedlings/compiled_data/fire_footprints/fir_vol.Rdata`
* figures:
    * `fir_RGR.pdf`


        
