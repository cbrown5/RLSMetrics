## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, results ='markup', warnings = FALSE, comment = '', strip.white = FALSE)

## ------------------------------------------------------------------------
    library(RLSPrivate)
    data(rls)
    data(sdat)
    data(survdat)
    data(fdat)

## ------------------------------------------------------------------------
rls$BioMass <- rls$BioMass/1000 #convert to kg

## ------------------------------------------------------------------------
data(cryptdat)
data(invertclasses)

dout <- allmetrics(rls, SurveyID, sdat = sdat, survdat = survdat, fdat = fdat, cryptdat = cryptdat, invertclasses = invertclasses)
dout

## ------------------------------------------------------------------------
   calcmetrics(rls, metrics = c("alpha"))

## ------------------------------------------------------------------------
 head(calcmetrics(rls, SurveyID, metrics = c("bioatsize"), sizecat = 40))

## ------------------------------------------------------------------------
    #alpha diversity
    rls %>%
        inner_join(survdat) %>%
        calcmetrics(SiteCode, metrics = "alpha")

## ------------------------------------------------------------------------
    #gamma diversity by sites 
    rls %>%
        inner_join(survdat) %>%
        nspp(SiteCode)

    #gamma diversity by ecoregions
   rls %>%
        inner_join(survdat) %>%
        inner_join(sdat) %>%
        nspp(Ecoregion)


## ------------------------------------------------------------------------
flim <- fdat %>% select(SpeciesID, Class, TrophicGroup)

herbs <- c("browsing herbivore", "scraping herbivore", "excavator", "algal farmer")

r2 <- rls %>% filter(Method ==1) %>%
    inner_join(survdat) %>%
    inner_join(sdat)
fout <- tgroup_metrics(r2, Location, Ecoregion, tgroups = herbs, traits = flim, na.rm = T, metrics = "biomass")

hist(fout$biomass)

## ------------------------------------------------------------------------
flim <- fdat %>% select(SpeciesID, Class, Family, ThermalMP_5_95)

r2 <- rls %>% filter(Method ==1) %>%
    inner_join(survdat) %>%
   inner_join(sdat) %>%
    inner_join(flim) %>%
    filter(Class %in% fish_classes())
 xout <- r2 %>% commtempindex(Location, Ecoregion, tempvar = "ThermalMP_5_95", abundvar = "BioMass", dolog = TRUE)
hist(xout$CTI)


