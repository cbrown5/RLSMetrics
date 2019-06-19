#TODO
Discussed with Rick on 15/4/2019. Need to update and check against his plots again.
- Eventually we will do biomass calculations in the R package
- We should also add blocks and average over them (so richness per block, then average at a survey)
- But wait to see new db structure from Jost.

Look over: "C:\Users\s2973410\Dropbox\rls-project\RLSPrivate\data-raw\checks against Ricks calculations 07-08-2018" with Rick
Most differences seem to be rounding errors (though they can be quite large, like 10kg!).
Also some species are missing from the traits data I have, e.g. 7620
SurveyID R912345017 is still an outlier. It seems I am just missing data?

15/4/2019 - Rick said to join on Current Taxonomic Name, not speciesID. But the rls datafile I have only has speciesID. So need one with tax names in it.

- Questions for Rick (discussed with Rick 15/4/2019):
There are duplicates in sdat, scovar and scovar2, because some have slightly different lon lats.
How to deal with this? (at moment I have just removed dups)
- Rick says he will clean up those files.
there are duplicates in fdat because of current vs old taxonmoic name. Can I just use current?
(or will this miss some that are given old names)


Add tests/warnings for when species/sites/surveys get duplicated during joins.

- Implement tests with testthat
- do not run on examles (may be slow)
- Create traits data (e.g. range size, thermal affinity etc) from rls database (and then add in extra stuff like trophic group)
- CTI currently uses mutate_ and summarize_, try to get quo to work (couldn't get it to build an equation that would work)
- same as above for func_rich, I should be able to generalise claclmetrics.
- rfishbase integration
- add section to vignette explaining why we have invertclasses and cryptdat (to filter thme in/out)
- check sdat, MPA data are duplicated.
- To tgroup_metrics, return results for groups individually.


Error checks from Rick:

(see B20 and CTI.xxls)

I’ve attached some values of B20 and CTI I used for the SoE. Note that the surveyIDs will be missing the ‘R’ or ‘M’ at the start that distinguish between RLS and LTMPA surveys, but there is a column that specifies dataset, so you can see which prefix they should have.
I was cross-checking a few against these. The CTI is weighted by log abundance, and B20 is the sum of biomass of all fishes in size classes equal to or larger than 20 cm. Both only use M1 data for the fish classes.

you can also compare to the GBR ones, like you say – this one has the functional group richness in it, and alpha diversity.

on M1 and fish classes only, then for each surveyID I sum all biomass, sum B in size classes 20cm and over.

For CTI I need to do a couple of steps, but your formula looks right as far as I can see – just that I use log(X+1) abundance instead of biomass. Either can be used of course, but I have found log abund slightly more sensitive (it does better at picking up changes from recruits of warm water species, for e.g., but without being seriously thrown out by a super abundant species or two).

Func rich may need talking through. the basics are doing a lookup of species and which functional group they belong to, and then counting unique groups within a surveyID (M1 only, or across methods).

I did find one other thing that complicates things with this combined MPA-RLS extract – the surveyIDs for M1 and M2 have been split for RLS (as part of the mechanism to allow them to all be directly compatible within methods). So this means calculating Func rich across methods (or any metric using both M1 and M2) will be more problematic. So for now I think best to not worry about any metrics that cover both methods, just sticking to metrics that only use data from one of the methods at a time.

I cross-checked some of the metrics in the output from the r package vs those I have calculated previously, and there seem to be some minor inconsistencies for most metrics. The M1_alpha seems to be right for many (but I did find some out), CTI looks constantly slightly underestimated (but is fairly close), while total B and B20 and FG_rich appear overestimated, at least for those I checked.

For CTI, I guess it may be just that the biomass values were not logged, but if you can make the default for CTI to use abundance rather than biomass, and log(X+1) the abundance values, this should come out the same as what I have previously used (hopefully).

For the other metrics, is there a way I can check how they were calculated? I couldn’t see the details in the documentation, but may be blind! At first I wondered if it was because there was not an initial filter for M1 only for these (I noticed you have to select these), but German tried that and the numbers were still out a bit.

for the biomass metrics, I did just cross-check the raw biomass values from the “rls” data extract used in the package to an extract I used a year ago, and can see the raw values are slightly different – so there is obviously something at our end contributing to the differences, which I’ll investigate with Just when he is back (I think the combined MPA-RLS extract is using a different set of a and b values for length-weight conversion). But this is not solely responsible, as when I paste the biomass values from a survey in the “rls” extract in the R package folder into excel and sum them, I get a different value of total biomass. e.g. for surveyID = R912345907, the sum of total biomass in M1 when I do it in excel is ca. 416kg, while the output from the package for “m1_biomass” when German filtered only M1 data was 458kg.

for FG_rich, the numbers differ from those we had for the bleaching paper, for e.g., but there are a couple of steps where this could be going wrong. Sometimes it is very close, but other times almost 2x.

So there looks to be something in the calcs going funny, but it is hard for me to check where. Any thoughts one ways I can check would be appreciated, otherwise we can perhaps find a time down the track to go through the calc for each one to see where the issues might be.
It is obviously not critical to fix this asap, but is something we can get to the bottom of eventually, as time permits for all!
