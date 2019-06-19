#CJ Brown  2018

#To install this package just `setwd()` to this folder then use the devtools package `devtools::install()`. You could also use
# `install.packages("path/to/this/folder/", repos = NULL, type = "source")`
#Once you've loaded the package try `vignette(RLSPrivate)` to get help. 

# Contact chris.brown@griffith.edu.au with any queries.  


rm(list=ls()) ## Clear console

setwd("C:\\Users\\gasoler\\Dropbox\\RLSPrivate")
library(devtools)
devtools::install()
vignette("ReefLifeSurvey")
library(RLSPrivate)
data(rls)
data(sdat)
data(survdat)
data(fdat)

rls$BioMass <- rls$BioMass/1000 #convert to kg
