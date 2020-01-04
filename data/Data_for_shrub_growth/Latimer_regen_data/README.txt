From Derek Young email on January 2, 2020:

Shrub data attached! The shrub table joins to the plot table (which has coordinates and fire names) by "PlotID".

Shrub data was recorded for all species that had cover > 10%, up to 4 species. If there were more than 4 species > 10%, the 4 with the greatest cover were measured.

You should probably only use unmanaged plots (half the database), which you can identify by Type == "control". Managed plots ("treatment") may have had shrub release. Or you could identify that directly by (facts.released == "no" | is.na(facts.released)) which could allow you to use some of the treatment plots if you don't mind that they had seedlings planted into them.

I forgot one nuance: on the Cottonwood fire (the oldest one), there was a block of plots where FACTS said they were not treated but the crew thought they might have been planted based on the density and spacing of the tree seedlings. These plots are actually already filtered out by my rule above. If you want to include them, you can identify them as: Type == "internal" & is.na(facts.planting.years.post). Without these plots, there are not a ton of relevant plots from the Cottonwood fire. The Cottonwood plots where Type == "control" are from a higher-elevation part of the fire where the conditions are not so climatically marginal. The rest of the fire is right on the edge of the forest-sagebrush transition, as I mentioned.

Fire year is a column in the plots table. All were surveyed in 2018.

We just ask that you stick to analyzing this dataset for the specific purpose you described and don't share the data. If you publish data with the paper you can trim the table to just the plots and columns you used.

Derek
