#' Calculate metrics by trophic groups
#'
#' @usage tgroup_metrics(datin, ..., tgroups = NA, traits, na.rm = T,
#' metrics = "biomass", classes = fish_classes())
#' @param datin \code{tbl_df} the main data-frame to use
#' @param ... optional grouping variables.
#' @param tgroups optional \code{character} giving trophic group names
#' @param traits \code{data.frame} or  \code{tbl_df} giving trait data
#' @param na.rm \code{logical} remove NAs?
#' @param metrics \code{character} which metrics to calculate.
#' see \code{\link{calcmetrics}}
#' @param classes \code{character} Filter for Class.
#'
#' @return xout a \code{tbl_df} with the (optional) grouping
#' variables and the metric value(s) for a trophic group or
#' set of functional groups
#'
#' @details see \code{\link{calcmetrics}} for how metrics are calculated
#' If \code{tgroup = NA} the TrophicGroups field will be ignored and all
#' trophic groups will be included.
#'
#' @author Christopher J. Brown
#' @examples
#'
#' data(rls)
#' data (fdat)
#'flim <- fdat %>% select(SpeciesID, Class, TrophicGroup)
#'herbs <- c("browsing herbivore", "scraping herbivore", "excavator", "algal farmer")
#'r2 <- rls %>% filter(Method ==1) %>%
#'    inner_join(survdat) %>%
#'    inner_join(sdat)
#'fout <- tgroup_metrics(r2, Location, Ecoregion, tgroups = herbs, traits = flim, na.rm = T, metrics = "alpha")
#' @rdname tgroup_metrics
#' @export
tgroup_metrics <- function(datin, ..., tgroups = NA, traits, na.rm = T, metrics = "biomass", classes = fish_classes()){

    if ("Method" %in% names(datin)){
        if(length(unique(datin$Method))>1){
            warning("You are pooling metrics across >1 method. Consider filtering input data for a single method first. ")
        }
    }
    filter_by_tgroup <- (!is.na(tgroups[1]))

    dout <- datin %>%
        inner_join(traits, by = "SpeciesID") %>%
        filter(Class %in% classes) %>%
        {if(filter_by_tgroup) filter(., TrophicGroup %in% tgroups) else . } %>%
        calcmetrics(metrics = metrics, ..., na.rm = na.rm)
    return(dout)
}
