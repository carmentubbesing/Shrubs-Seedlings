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

This repository holds the code for analyzing Carmen's summer 2016 shrub and seedling measurements. The data being analyzed is located in Stephens lab dropbox -&gt; SORTIE -&gt; Shrubs\_Summer16 -&gt; Shrubs2016\_Completed\_Data\_and\_Photos

Variables
=========

The explanatory variables eligible for inclusion in the model for 2015 seedling growth (cm) include:

1.  light attenuation from LAI-2000 measurements
2.  Most abundant shrub species near the seedling in 3 m radius
3.  Most common shrub species in 2 m radius
4.  Most common shrub species in 1 m radius
5.  Shrub species immediately overtopping the seedling
6.  Total cover of shrubs within 3 m
7.  Total cover of shrubs within 2 m
8.  Total cover of shrubs within 1 m
9.  Elevation
10. Fire
11. Time since fire
12. Seedling species
13. Average shrub height within 3 m
14. Average shrub height within 2 m
15. Average shrub height within 1 m
16. Slope/aspect
17. Seedling diameter
18. Seedling total height

Data processing
===============

-   cleaning and consolidating into one table is done in the file `sdling_grth_model.R`

Analysis
========

Analysis 1
----------

-   The first analysis uses patch as a random effect. This makes the following variables unecessary to include:

1.  Elevation
2.  Fire
3.  Slope/aspect

Problem solving
===============

The main issues to resolve include: 1. incorrect measurements making some ht.cm and ht.2015 values 4 cm too large, with no way to tell which ones are
