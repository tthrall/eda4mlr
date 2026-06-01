#' Set the eda4ml random seed
#'
#' Stabilize simulated data across the textbook by fixing the seed for
#' random number generation. Call this in place of sourcing the book's
#' \code{eda4ml_set_seed.R} script.
#'
#' @param seed Integer seed passed to \code{\link[base]{set.seed}}. Defaults to 37.
#'
#' @return The seed, invisibly.
#'
#' @examples
#' set_eda4ml_seed()
#' runif(3)
#'
#' @export
set_eda4ml_seed <- function(seed = 37L) {
  set.seed(seed)
  invisible(seed)
}
