#' A dataframe of a set of metrics, given grouping variables
#' @usage allmetrics(datin, ...,  na.rm = TRUE, sdat, survdat, fdat, cryptdat, invertclasses)
#' @param datin \code{tbl_df} the main data-frame to use
#' @param ... optional grouping variables.
#' @param sdat \code{tbl_df} giving site level data
#' @param survdat \code{tbl_df} giving survey level data
#' @param fdat \code{tbl_df} giving species trait data
#' @param cryptdat \code{tbl_df} giving cryptic fish families to exclude in Method 1 calculations
#' @param invertclasses \code{character} invert classes to include in calculations
#'
#' @return xout a \code{tbl_df} with the (optional) grouping
#' variables and a set of metric values.
#'
#' @details Common metrics are calculated that include:
#' Method 1 fish richness (\code{m1_alpha})
#' Method 1 fish biomass (\code{m1_biomass})
#' Biomass of fish >= 20cm (method 1) (\code{B20})
#' The above three metrics exclude fish from families \code{cryptdat}
#' Method 2 fish richness (\code{m2_fish_alpha})
#' Method 2 invert richness, for select Classes (\code{m2_invert_alpha})
#' See \code{data(invertclasses)} for Class names
#' Functional group richness  (\code{FG_richness})
#' See \code{data(fdat)} and field \code{FuncGroup} for groups
#' Community temperature indext \code{CTI}
#' Method 2 urchin abundance, excluding genus Echinostrephus \code{urchin_abundance}
#'
#'All values are calculated at survey level then
#' averages are taken at higher levels, if requested.
#'
#' @author Christopher J. Brown
#' @examples
#'

#' @rdname allmetrics
#' @export
allmetrics <- function(datin, ..., sdat, survdat, fdat, cryptdat, invertclasses,  na.rm = TRUE){

    oldw <- getOption("warn")
    options(warn = -1)
    flim <- fdat %>% select(SpeciesID, Class, Family, TrophicGroup)

    # Fish species richness
    #M1
    m1_metrics <- datin %>% filter(Method ==1) %>%
        inner_join(survdat, by = "SurveyID") %>%
        inner_join(sdat, by = "SiteCode") %>%
        inner_join(flim, by = "SpeciesID") %>%
        filter(Class %in% fish_classes()) %>%
        calcmetrics(..., metrics = c("alpha", "biomass", "bioatsize"), na.rm = na.rm)
    x <- names(m1_metrics)
    names(m1_metrics)[x == "alpha"] <- "m1_alpha"
    names(m1_metrics)[x == "biomass"] <- "m1_biomass"
    names(m1_metrics)[x == "bioatsize"] <- "B20"

    # M2 (cryptics)
    m2_richness <- datin %>% filter(Method ==2) %>%
        inner_join(survdat, by = "SurveyID") %>%
        inner_join(sdat, by = "SiteCode") %>%
        inner_join(flim, by = "SpeciesID") %>%
        filter(Class %in% fish_classes()) %>%
        calcmetrics(..., metrics = "alpha", na.rm = na.rm)
    x <- names(m2_richness)
    names(m2_richness)[x == "alpha"] <- "m2_fish_alpha"

    # M2 (inverts)
    m2_richness_inverts <- datin %>%
        filter(Method ==2) %>%
        inner_join(survdat, by = "SurveyID") %>%
        inner_join(sdat, by = "SiteCode") %>%
        inner_join(flim, by = "SpeciesID") %>%
        filter(Class %in% invertclasses) %>%
        calcmetrics(...,metrics = "alpha", na.rm = na.rm)
    x <- names(m2_richness_inverts)
    names(m2_richness_inverts)[x == "alpha"] <- "m2_invert_alpha"

    # Functional richness
    flim2 <- fdat %>% select(SpeciesID, Class, Family, FuncGroup)
    fg_richness <- datin %>%
        inner_join(survdat, by = "SurveyID") %>%
        inner_join(sdat, by = "SiteCode") %>%
        inner_join(flim2, by = "SpeciesID") %>%
        func_rich(..., group = "FuncGroup", na.rm = na.rm)
    x <- names(fg_richness)
    names(fg_richness)[x == "dplyr::n_distinct(FuncGroup)"] <- "FG_richness"

    # Biomass metrics
    # Herbivorous fish biomass
    flim <- fdat %>% select(SpeciesID, Class, TrophicGroup)
    herbs <- c("browsing herbivore", "scraping herbivore", "excavator", "algal farmer")

    herb_biomass <- datin %>% filter(Method ==1) %>%
        inner_join(survdat, by = "SurveyID") %>%
        inner_join(sdat, by = "SiteCode") %>%
        tgroup_metrics(..., tgroups = herbs, traits = flim, na.rm = na.rm, metrics = "biomass")
    x <- names(herb_biomass)
    names(herb_biomass)[x == "alpha"] <- "herbivore_biomass"

    # CTI - M1
    flim <- fdat %>% select(SpeciesID, Class, Family, ThermalMP_5_95)

    M1_CTI <- datin %>% filter(Method ==1) %>%
        inner_join(survdat, by = "SurveyID") %>%
        inner_join(sdat, by = "SiteCode") %>%
        inner_join(flim, by = "SpeciesID") %>%
        filter(Class %in% fish_classes()) %>%
        commtempindex(..., tempvar = "ThermalMP_5_95", abundvar = "Abundance", na.rm = na.rm, dolog = TRUE)

    # Urchin density (excluding Echinostrephus)
    flim <- fdat %>% select(SpeciesID, Class, CURRENT_SPECIES_NAME)
    urchin_density <- datin %>% filter(Method ==2) %>%
        inner_join(survdat, by = "SurveyID") %>%
        inner_join(sdat, by = "SiteCode") %>%
        inner_join(fdat, by = "SpeciesID") %>%
        filter(Class == "Echinoidea") %>%
        mutate(genus = .getgenus(CURRENT_SPECIES_NAME)) %>%
        filter(genus != "Echinostrephus") %>%
        calcmetrics(..., metrics = c("abundance"), na.rm = na.rm)
    x <- names(urchin_density)
    names(urchin_density)[x == "abundance"] <- "urchin_abundance"

    # Join all the data.frames
    alldat <- list(m1_metrics, m2_richness, m2_richness_inverts, 
                   fg_richness, herb_biomass, M1_CTI, urchin_density)
    ngpvars <- length(quos(...))
    gp <- names(alldat[[1]])[1:ngpvars]
    alldat <- purrr::reduce(alldat, full_join, by = gp)
    options(warn = oldw)
    return(alldat)
}
