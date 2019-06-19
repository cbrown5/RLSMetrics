#' @rdname .sum_sizeclass
.sum_sizeclass <- function(x, y, sizecat = 20, na.rm){
    sum(x[y>=sizecat], na.rm = na.rm)
}

#' @rdname .getgenus
.getgenus <- function(x){
    unlist(lapply(strsplit(x, split = "[ ]"), function(y) y[1]))
}
