#' Calculate metrics for a sampling unit from survey level data
#' @usage calcmetrics(datin, ..., sizecat = 20,
    #'na.rm = T,
    #'metrics = c( "alpha", "biomass", "bioatsize"))
#' @param datin \code{tbl_df} the main data-frame to use
#' @param ... optional grouping variables.
#' @param sizecat \code{numeric} giving size minimum size category to include in
#' calculation of \code{bioatsize}
#' @param metrics \code{character} vector of metrics to calculate. Default is
#' all of them.
#'
#' @return xout a \code{tbl_df} with the (optional) grouping
#' variables and the metric value(s)
#'
#' @details Metrics are calculated per SurveyID, then the mean is
#' taken across grouping variables.
#'Metric alpha is number of species on a survey, metric biomass is biomass of
#' metric bioatsize is biomass of fish >= \code{sizecat}
#'
#' @author Christopher J. Brown
#' @examples
#'
#' data(rls)
#' calcmetrics(rls, SurveyID, metrics = "alpha") # Alpha richness by survey
#' calcmetrics(rls, SurveyID, Method ) #All metrics averaged by survey and method.

#' @rdname calcmetrics
#' @export
calcmetrics <- function(datin, ..., sizecat = 20, na.rm = T, metrics = c("alpha", "biomass", "bioatsize", "abundance")){

    if (!("SurveyID" %in% names(datin))){
        stop("Data must be at survey level and contain the variable SurveyID")}

    if ("Method" %in% names(datin)){
        if(length(unique(datin$Method))>1){
            warning("You are pooling metrics across >1 method. Consider filtering input data for a single method first. ")
        }
    }

        args <- list(
            alpha = dplyr::quo(dplyr::n_distinct(SpeciesID)),
            biomass = dplyr::quo(sum(BioMass, na.rm = na.rm)),
            bioatsize = dplyr::quo(.sum_sizeclass(BioMass, SizeClass, sizecat = sizecat, na.rm = na.rm)),
            abundance = dplyr::quo(sum(Abundance, na.rm = na.rm))
            )

        imatch <- match(metrics, names(args))
        if(is.na(imatch)[1]) stop("No valid metric name found")

        args <- args[imatch]
        groupby <- dplyr::quos(...)
        groupbysurv <- c(quo(SurveyID), groupby)
        xout <- datin %>%
            dplyr::group_by(!!!groupbysurv) %>%
            dplyr::summarize(!!!args) %>%
            ungroup() %>%
            group_by(!!!groupby) %>%
            summarize_if(is.numeric, mean)

    return(xout)
}
