#' Calculate functional group richness
#' @usage func_rich(datin, ..., group = "SpeciesID",
    #'na.rm = T)
#' @param datin \code{tbl_df} the main data-frame to use
#' @param ... optional grouping variables.
#' @param group \code{character} giving category to calculate
#' richness over
#'
#' @return xout a \code{tbl_df} with the (optional) grouping
#' variables and the richness value(s)
#'
#' @details Richness is calculated per SurveyID, then the mean is
#' taken across grouping variables.
#'
#' @author Christopher J. Brown
#' @examples
#'

#' @rdname func_rich
#' @export
func_rich <- function(datin, ..., group = "SpeciesID",  na.rm = T){

    if (!("SurveyID" %in% names(datin))){
        stop("Data must be at survey level and contain the variable SurveyID")}

    if ("Method" %in% names(datin)){
        if(length(unique(datin$Method))>1){
            warning("You are pooling metrics across >1 method. Consider filtering input data for a single method first. ")
        }
    }

    expr <- paste0("dplyr::n_distinct(",group,")")

    groupby <- dplyr::quos(...)
    groupbysurv <- c(quo(SurveyID), groupby)
    xout <- datin %>%
        dplyr::group_by(!!!groupbysurv) %>%
        dplyr::summarize_(expr) %>%
        ungroup() %>%
        group_by(!!!groupby) %>%
        summarize_if(is.numeric, mean)

    return(xout)
}
