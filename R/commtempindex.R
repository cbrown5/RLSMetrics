#' Calculate the community temperature index
#'
#' @usage commtempindex(datin, ...,
#', tempvar = "ThermalMP_5_95", abundvar = "BioMass",
#' na.rm = T, dolog = TRUE)
#' @param datin \code{tbl_df} A dataframe of species observations with a
#' temperature index for each observation.
#' @param ... optional grouping variables.
#' @param tempvar \code{character} temperature index variable
#' @param abundvar \code{character} abundance/biomass variable to use
#' @param na.rm \code{logical} remove NAs?
#' @param log \code{logical} log response?
#'
#' @return xout a \code{tbl_df} with the (optional) grouping
#' variables and the CTI values.
#'
#' @details The CTI is calculated per SurveyID, then the mean is
#' taken across grouping variables.
#' The CTI is calculated: \eqn{\frac{\sum{T_j B_{i,j}}}{\sum{B_{i,j}}}}
#'Where there are n surveys i, \eqn{T_j} are the species thermal indexes
#' (e.g. thermal midpoint from a species range) and \eqn{B_{i,j}} are the
#' biomasses or abundances of each species at each site.
#' The default is the log(base 10) of the abundance.
#' If you chose the log option, the function will calculate log10(x+1). 

#'
#' @author Christopher J. Brown
#' @examples
#' data(rls)
#' data(fdat)
#'flim <- fdat %>% select(SpeciesID, Class, Family, ThermalMP_5_95)
#'
#'r2 <- rls %>% filter(Method ==1) %>%
#'    inner_join(survdat) %>%
#'    inner_join(sdat) %>%
#'    inner_join(flim) %>%
#'    filter(Class %in% fish_classes())
#' xout <- r2 %>% commtempindex(Location, Ecoregion, tempvar = "ThermalMP_5_95", abundvar = "BioMass", dolog = TRUE)
#'hist(xout$CTI)

#' @rdname commtempindex
#' @export
commtempindex <- function(datin, ...,
                          tempvar = "ThermalMP_5min_95max", abundvar = "Abundance", na.rm = T, dolog = TRUE){

    if (!("SurveyID" %in% names(datin))){
        stop("Data must be at survey level and contain the variable SurveyID")}

    if ("Method" %in% names(datin)){
        if(length(unique(datin$Method))>1){
            warning("You are pooling metrics across >1 method. Consider filtering input data for a single method first. ")
        }
    }
    if (dolog){
        datin[,abundvar] <- log10(datin[,abundvar]+1)
    }
    expr <- paste0(tempvar, "*", abundvar)
    expr2 <- paste0("sum(STI, na.rm = ",na.rm,")/sum(",abundvar,",na.rm = ",na.rm,")")
    groupby <- dplyr::quos(...)
    groupbysurv <- c(quo(SurveyID), groupby)
    xout <- datin %>%
        mutate_(STI = expr) %>%
        dplyr::group_by(!!!groupbysurv) %>%
        dplyr::summarize_(CTI = expr2) %>%
        ungroup() %>%
        group_by(!!!groupby) %>%
        summarize_if(is.numeric, mean)

    return(xout)
}
