#' Portacaval Shunt Studies by Design Type
#'
#' Counts of studies evaluating the portacaval shunt surgery, classified
#' by study design and reported degree of patient improvement.
#'
#' @format A tibble with 3 rows and 4 variables:
#' \describe{
#'   \item{design}{Study design (character): no_controls, controls_not_randomized,
#'     or randomized_controlled}
#'   \item{marked}{Number of studies reporting marked improvement (integer)}
#'   \item{moderate}{Number of studies reporting moderate improvement (integer)}
#'   \item{none}{Number of studies reporting no improvement (integer)}
#' }
#'
#' @details
#' The portacaval shunt is a surgical procedure for treating portal
#' hypertension in patients with liver cirrhosis. This dataset summarizes
#' the results of 51 studies, showing how conclusions about treatment
#' efficacy varied dramatically with study design. Studies without controls
#' overwhelmingly reported marked improvement, while randomized controlled
#' trials found no benefit.
#'
#' @seealso \code{\link{portacaval_survival}}
#'
#' @source Freedman, D., Pisani, R., & Purves, R. (2007).
#'   \emph{Statistics} (4th ed.), Chapter 1, Section 2, p. 7.
#'   W.W. Norton & Company.
#'
#' @examples
#' data(portacaval_studies)
#' portacaval_studies
#'
"portacaval_studies"
