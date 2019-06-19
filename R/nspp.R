#' Calculate gamma diversity for a sampling unit
#'
#' @usage nspp(datin, ...)
#'
#' @param datin \code{tbl_df} the main data-frame to use
#' ... optional grouping variables.
#'
#' @return xout a \code{tbl_df} with the (optional) grouping
#' variables and species richness.
#'
#' @details Calculates total numbers of species across the groups i.e. gamma diversity
#' See \code{\link{calcmetrics}} to get mean survey level richness.  
#'
#' @author Christopher J. Brown
#' @examples
#' nspp(rls, SurveyID) # Richness by survey
#'  nspp(rls, SurveyID, Method ) #Richness by survey and method.


#' @rdname nspp
#' @export
nspp <- function(datin, ...){
        groupby <- quos(...)
        xout <- datin %>%
            dplyr::group_by(!!!groupby) %>%
            dplyr::summarize(richness = dplyr::n_distinct(SpeciesID))
    return(xout)
}
