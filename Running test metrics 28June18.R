rm(list=ls()) ## Clear console

library(RLSPrivate)
vignette("ReefLifeSurvey")

data(rls)
data(sdat)
data(survdat)
data(fdat)

rls$BioMass <- rls$BioMass/1000 #convert to kg
data(cryptdat)
data(invertclasses)

dout <- allmetrics(rls, SurveyID, sdat = sdat, survdat = survdat, fdat = fdat, cryptdat = cryptdat, invertclasses = invertclasses)
dout

rlsM1<-rls[rls$Method=="1",] ## Filtering for M1 only

doutM1 <- allmetrics(rlsM1, SurveyID, sdat = sdat, survdat = survdat, fdat = fdat, cryptdat = cryptdat, invertclasses = invertclasses)
doutM1

write.csv(doutM1, "RLS from Christ's only with M1 for Rick 4Jul18.csv")

## Commmunity temperature index

flim <- fdat %>% select(SpeciesID, Class, Family, ThermalMP_5_95)

r2 <- rls %>% filter(Method ==1) %>%
  inner_join(survdat) %>%
  inner_join(sdat) %>%
  inner_join(flim) %>%
  filter(Class %in% fish_classes())

xout <- r2 %>% commtempindex(Location, Ecoregion, tempvar = "ThermalMP_5_95", abundvar = "BioMass", dolog = TRUE)
hist(xout$CTI)
