From Derek Young email on December 19, 2019:

Hi Carmen,

Sure, I'm happy to share the data that I have. Below are some (many!) nuances/caveats. TL;DR: the most recent database I have from Kevin (1/13/2016) is attached (as an Access database), and the expanded set of plot data that I have (which includes much more than what I analyzed) is also attached (as a CSV).

1) The database I worked from for the 2019 Ecology paper is one that Kevin sent me in 2016 (dated 1/13/2016). The 438 additional plots that I surveyed (in 2016 and 2017) are not in database, for a few reasons (the surveys I did were not part of Hugh's program but instead through the Latimer Lab; I dropped some measurements to streamline the protocol; and I added other measurements that did not have corresponding fields in the database). Instead, I combined my new data with Kevin's existing data outside of the database. I am attaching the merged database tables. They are produced by an R script that reads Kevin's DB and my plot data and unifies them into a single set of tables. The script also merges in some Power Fire revisit plots that Clark Richter did in 2016 (see below). Here's the age breakdown that I have (with no filtering for severity etc.):
Age     3    4    5    6    7    8    9   11   12 
Plots  74  269 1724   90  195  239   24  120  252 

2) Kevin and I had different ways of recording shrub cover and height. Kevin recorded cover and height by species as well as overall cover. I recorded overall cover, plus the height of the one dominant shrub species (along with its species ID). The merged CSV file that I attached pre-summarizes Kevin's data to only the height and ID of the one dominant shrub species, to be consistent with my data. (The columns are "dominant_shrub_ht_cm" and "dominant_shrub_1"). Kevin's species-specific shrub cover data is not in the tables I exported but it is in the Access database. The Latimer Lab does have a different dataset of shrub cover and height by species for about 100 plots that we could share if that would be helpful (see point #7).

3) I'm not sure if additional plots have been entered into Kevin's (/Safford Lab's) database since 2016. The database copy I have does not have Kristen's Rim or King Fire plots, for example. I also don't know if Clark's plots eventually were added to the database.

4) Kevin's database (the version I have) contains many plots that I did not analyze for the 2019 paper. I specifically only analyzed plots that were surveyed 4 or 5 years post-fire, were in the Sierra Nevada and Southern Cascades, burned at severity 0, 1, 4, or 5, and were within 75 m of a seed source, and were not managed according to FACTS (which should have been excluded prior to survey but Kristen and I found many exceptions). So the database contains a much wider variety of plots that may be relevant to you (relative to what I analyzed). I vaguely remember being told not to analyze plots from the Northern Province fires because Ramona Butz added those but requested others not use them.

5) Re: the Power Fire revisits done by Clark Richter, I'm not sure how Clark feels about them being used in other publications. He's probably open. I did not end up using them in my Ecology paper. They are the plots named "richter.xxx". They don't have shrub cover or height by species, but Clark probably does have that data somewhere because I think he did CSEs along with the regen plots.

6) The revisit plot data I added included revisits of 4 fires at least 3 years after the initial surveys (which were ~5 years post). So that should give you some additional variation in years post-fire and 438 additional plots.

7) Additional Latimer lab data: we have shrub cover data by species from about 100 larger (11.3 m radius) plots we surveyed on 5 Sierra Nevada fires 10, 10, 11, 14, and 24 years post-fire. We're happy to share it for this purpose. Note that some of these fires are in more arid locations where shrub cover is sparser, especially the 24-year-old fire, which is the 1994 Cottonwood Fire. Also doesn't the USFS have tons of post-fire CSE data throughout the state? Apparently it's really hard to interact with the database that contains them though.

Whew, I think that covers it. I'm sure you'll have questions when you look at the data. I'm happy to answer questions and/or re-compile or re-summarize the data, etc, so that it's more useful to you.

Thanks so much for the opportunity to join as a collaborator! I'm definitely interested in hearing your vision and discussing ways I may be able to help. (And helping make it most relevant to my hopeful application of it.) I'm on a "workation" in Costa Rica now with spotty internet and schedule, but I'd love to talk when I'm back (Dec 26 onward). If your timeline is shorter, we could try tomorrow late afternoon, but I can't guarantee it will work. I'm fine leaving it to you to determine down the line whether I ultimately contribute enough to be a co-author.

Also, yes, using the seed tree distance to make sure you're away from surviving trees should work great.

seed_tree_distance_general should just be the minimum of the conifer and hardwood distances. The remote sensing component I described was not involved in those numbers. The multiple columns are just a product of multiple survey protocols over the years.

999 means seed tree not visible or beyond the range of the laser.