README
================
Carmen
November 5, 2019

-   [Summary](#summary)
-   [Prep code](#prep-code)
    -   [**diameter\_ht.Rmd**](#diameter_ht.rmd)
-   [Functions](#functions)
-   [Running simulations](#running-simulations)
    -   [**simulations.Rmd**](#simulations.rmd)

Summary
=======

This folder has all the code to run SORTIE-style simulations of stand-replacing fire patches

Prep code
=========

#### **diameter\_ht.Rmd**

-   uses:
    -   `../../compiled_data/dfshrubs.Rdata`
-   creates:
    -   .Rdata\`
-   does:
    -   creates linear models for diameter in relation to height for ABCO and PIPO

Functions
=========

1.  **shrubclump.R**
    -   uses:
        -   objects:
            -   "~/Shrubs-Seedlings/compiled\_data/fire\_footprints/master\_seedlings\_vert.Rdata"
            -   `year` = factor, either 2015, 2016, or 2017
            -   `fire` = factor, always AMRC for American River Complex for now
            -   `length_m` = numeric, length of simulated shrub patch
            -   `height_m` = numeric, length of simulated shrub patch
            -   `shrub_clumpiness` = numeric, determinds how clump shrub species in patch are
    -   creates:
        -   `r` = raster of shrub patch with species codes 1-5
        -   `df_new` = edited df with shrub and seedling data
        -   `raster_df` = cleaned `df` with seedling data, shrub species codes 1-5, as well as species ID names
    -   does:
        -   simplifies shrub data from fire footprint seedling measurements
        -   randomly selects rows from fire footprint df for shrub data
        -   creates shrub patch raster
        -   smooths shrub patch using `focal()` to make shrubs clump by species
2.  **initialize.R**
    -   uses:
        -   `r@data@values`
        -   `n_seedlings` = number of seedlings to draw from df (note: could be less than final \# due to overlap)
        -   `lambda` = lambda of the poisson distribution used to place seedlings in the raster
    -   creates:
        -   `r` = new version with all the data
        -   `p` = SpatialPolygons border of `r`
        -   `pts.sf.abco` = points where ABCO seedlings are
        -   `pts.sf.pipo` = points where PIPO seedlings are
    -   does:
        -   for each cell in `r`, replaces shrub species code 1-5 with a seedling ID that has dominant shrub species `ShrubSppID` equal to the cell's shrub species code
        -   createst Raster Attribute Table for `r` with all the data from `raster_df`, linked by seedling ID
        -   creates spatial points objects for seedlings and randomly selects their locations using poisson distributions from the edges of the shrub patch
3.  **sim.R**
    -   uses:
        -   objects:
            -   `pts.sf.pipo`
            -   `pts.sf.abco`
            -   `dfsimall`
            -   `years` = integer \# of years in simulation
        -   code:
            -   `abcogrowth.R`
            -   `pipogrowth.R`
            -   `abcomort.R`
            -   `pipomort.R`
            -   `abcodia.R`
            -   `pipodia.R`
            -   `shrubgrowth.R`
    -   creates:
        -   `dfsimall` = results across all year
    -   does for each year :
        -   simulates one time step of vertical growth, mortality, diameter growth, shrub growth
        -   adds one year to prep for the next time step
        -   joins previous data frame to new year's results
4.  **abcogrowth.R**
    -   uses:
    -   creates:
    -   does:
5.  **pipogrowth.R**
    -   uses:
    -   creates:
    -   does:
6.  **abcodia.R**
    -   uses:
    -   creates:
    -   does:
7.  **pipodia.R**
    -   uses:
    -   creates:
    -   does:
8.  **abcomort.R**
    -   uses:
    -   creates:
    -   does:
9.  **pipomort.R**
    -   uses:
    -   creates:
    -   does:
10. **shrubgrowth.R**
    -   uses:
    -   creates:
    -   does:
11. **iterate.R**
    -   uses:
    -   creates:
    -   does:

Running simulations
===================

#### **simulations.Rmd**

-   uses:
    -   

-   creates:
    -   

-   does:
    -
