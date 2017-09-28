Shrubs-Seedlings README
================
Carmen
February 22, 2017

-   [Summary](#summary)
-   [Variables](#variables)
-   [Data processing](#data-processing)
-   [Analysis](#analysis)
    -   [Analysis 1](#analysis-1)
-   [Problem solving](#problem-solving)

Summary
=======

This repository holds the code for analyzing Carmen's summer 2016-2017 shrub and seedling measurements. The data being analyzed is located in Stephens lab dropbox -&gt; SORTIE -&gt; Shrubs\_Summer16 -&gt; Shrubs2016\_Completed\_Data\_and\_Photos

Variables
=========

The explanatory variables eligible for inclusion in the model for 2015 seedling growth (cm) include:

1.  light attenuation from LAI-2000 measurements
2.  Most abundant shrub species 2-3 m from seedling
3.  Most abundant shrub species in 1-2 m from seedling
4.  Most abundant shrub species in 0-1 m from seedling
5.  Shrub species immediately overtopping the seedling
6.  Total cover of shrubs 2-3 m from seedling
7.  Total cover of shrubs 1-2 m from seedling
8.  Total cover of shrubs 0-1 m from seedling
9.  Elevation
10. Fire
11. Time since fire
12. Seedling species
13. Average shrub height 2-3 m from seedling
14. Average shrub height 1-2 m from seedling
15. Average shrub height 0-1 m from seedling
16. Slope/aspect
17. Seedling diameter
18. Seedling total height

Data processing
===============

-   cleaning and consolidating into one table is done in the file `clean_combine.R`

Analysis
========

Analysis 1
----------

-   The first analysis uses patch as a random effect. This makes the following variables unecessary to include:
    1.  Elevation
    2.  Fire
    3.  Slope/aspect
    4.  Time since fire
-   Analysis 1 uses all seedlings and does not use light attenuation, since it is not available for all seedlings
-   Analysis 1 INCLUDES the variables
    1.  Seedling species (factor)
    2.  Patch unique
    3.  Seedling total height (continuous)
    4.  Seedling diameter (continuous)
    5.  Shrub species immediately overtopping the seedling (factor)
    6.  Total cover of shrubs 2-3 m from seedling (continuous)
    7.  Total cover of shrubs 1-2 m from seedling (continuous)
    8.  Total cover of shrubs 0-1 m from seedling (continuous)
    9.  Average shrub height 2-3 m from seedling (continuous)
    10. Average shrub height 1-2 m from seedling (continuous)
    11. Average shrub height 0-1 m from seedling (continuous)
    12. Most abundant shrub species 2-3 m from seedling (factor)
    13. Most abundant shrub species in 1-2 m from seedling (factor)
    14. Most abundant shrub species in 0-1 m from seedling (factor)
-   Clumping of similar patches
    1.  CLVD-SE and CLVD-SW: can't clump, slopes too similar
    2.  

Problem solving
===============

The main issues to resolve include: 1. incorrect measurements making some ht.cm and ht.2015 values 4 cm too large, with no way to tell which ones are
