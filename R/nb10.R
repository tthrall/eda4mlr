#' NB10 Repeated Weighings
#'
#' One hundred repeated weighings of a standard weight on a precision
#' balance, used to illustrate measurement error and the normal distribution.
#'
#' @format A tibble with 100 rows and 2 variables:
#' \describe{
#'   \item{idx}{Measurement index (integer): 1 to 100}
#'   \item{deficit}{Micrograms below 10 grams (integer)}
#' }
#'
#' @details
#' Each measurement records how many micrograms the weight measured below
#' the nominal 10 grams. The measurements cluster around 404 micrograms
#' with variation due to measurement error, providing a concrete example
#' for discussing the normal distribution and repeated measurements.
#'
#' @source Freedman, D., Pisani, R., & Purves, R. (2007).
#'   \emph{Statistics} (4th ed.), Chapter 6, Section 1, p. 98.
#'   W.W. Norton & Company.
#'
#' @examples
#' data(nb10)
#' mean(nb10$deficit)
#' sd(nb10$deficit)
#' hist(nb10$deficit)
#'
"nb10"
