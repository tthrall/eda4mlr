#' Portacaval Shunt Survival Rates by Study Design
#'
#' Survival rates (percent alive after a fixed period) for portacaval shunt
#' surgery patients and controls, comparing randomized and non-randomized
#' study designs.
#'
#' @format A tibble with 2 rows and 3 variables:
#' \describe{
#'   \item{design}{Study design (character): randomized or non_randomized}
#'   \item{surgery}{Survival rate for surgery group (integer, percent)}
#'   \item{control}{Survival rate for control group (integer, percent)}
#' }
#'
#' @details
#' In non-randomized studies, the surgery group showed higher survival
#' than controls (60\% vs. 45\%), suggesting benefit. However, in
#' randomized studies, both groups had identical survival rates (60\%),
#' indicating no treatment effect. The apparent benefit in non-randomized
#' studies arose from selection bias: surgeons selected healthier patients
#' for the operation.
#'
#' @seealso \code{\link{portacaval_studies}}
#'
#' @source Freedman, D., Pisani, R., & Purves, R. (2007).
#'   \emph{Statistics} (4th ed.), Chapter 1, Section 2, p. 7.
#'   W.W. Norton & Company.
#'
#' @examples
#' data(portacaval_survival)
#' portacaval_survival
#'
"portacaval_survival"
