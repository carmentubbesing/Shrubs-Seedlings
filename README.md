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
19. Shrubarea = shrub height from 0-2 m times shrub cover from 0-2 m

Data processing
===============

-   cleaning and consolidating into one table is done in the file `clean_combine.R`

Analysis
========

Details to come.

Problem solving
===============

The main issues to resolve include: 1. incorrect measurements making some ht.cm and ht.2015 values 4 cm too large, with no way to tell which ones are
