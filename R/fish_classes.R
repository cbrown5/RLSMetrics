#' Class names for fish and sharks for filtering data frames
#'
#' @usage fish_classes()
#'
#' @return xout a \code{character} vector
#' \code{c("Actinopterygii", "Elasmobranchii")}
#'
#' @details
#'
#' @author Christopher J. Brown
#' @examples
#' data(fdat)
#' filter(fdat, Class %in% fish_classes())

#' @rdname nspp
#' @export
fish_classes <- function(){
    c("Actinopterygii", "Elasmobranchii", "Chondrichthyes")
}
