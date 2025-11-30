#' Handedness by Sex
#'
#' Handedness counts by sex, used to illustrate chi-squared tests
#' for independence.
#'
#' @format A tibble with 6 rows and 3 variables:
#' \describe{
#'   \item{sex}{Sex (character): male or female}
#'   \item{hnd}{Handedness (character): right, left, or ambi}
#'   \item{count}{Number of individuals (integer)}
#' }
#'
#' @source Freedman, D., Pisani, R., & Purves, R. (2007).
#'   \emph{Statistics} (4th ed.), Chapter 28, Section 4.
#'   W.W. Norton & Company.
#'
#' @examples
#' data(handedness)
#' summary(handedness)
#'
"handedness"
