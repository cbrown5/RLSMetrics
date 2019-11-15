#' Class names for inverts for filtering data frames
#'
#' @usage invert_classes()
#'
#' @return xout a \code{character} vector
#' \code{ c("Asteroidea", "Bivalvia","Cephalopoda",
#' "Crinoidea", "Echinoidea","Gastropoda",
#' "Holothuroidea", "Malacostraca")}
#'
#' @details
#'
#' @author Christopher J. Brown
#' @examples
#' data(fdat)
#' filter(fdat, Class %in% invert_classes())

#' @rdname invert_classes
#' @export
invert_classes <- function(){
  c("Asteroidea", "Bivalvia","Cephalopoda",
     "Crinoidea", "Echinoidea","Gastropoda",
    "Holothuroidea", "Malacostraca")

}
