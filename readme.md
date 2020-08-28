# Analysis of the Reef Life Survey dataset

 CJ Brown  2019

This package contains handy functions designed for analysing data of fish/invert counts on a  transect, and specifically for the Reef Life Survey methodology. You can access RLS [data here](https://reeflifesurvey.imas.utas.edu.au/static/landing.html).

You can  install this package directly from github with `devtools` and `remotes`:
`devtools::install_github("cbrown5/RLSMetrics")`

This package is not yet up to date with the latest release of `dplyr` (a dependency) so be warned, this may induce bugs or errors.

This package currently has no working vignettes. They are planned in the future.

## Tips and advice

- When calculating average abundances of species across sites, watch out for missing records. The UVC surveys only record species that were there, not the ones that were missing. So if you average across multiple surveys within a site, you may overestimate abundance/biomass (because the zeros are missing).

- Check for and sum over duplicate species records within surveys. This happens when divers observed the same the same species at different locations on a transect. The CTI in particular is sensitive to the number of records, there should only be one row (but can have multiple individuals) per species per survey.

- Check your biomass calculations, e.g. with `summary` or `quantile` before you use biomass in indicators. In particular, I've often noticed the length-weight conversions for sharks can come up with very high weights.

- Check your filters on taxa, e.g. M1 fish abundance, folk will normally filter for non-cryptic fish and the fish classes. (typos in class names will result in mismatches). 



Contact chris.brown@griffith.edu.au with any queries.  
