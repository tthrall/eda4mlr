#' Salk Vaccine Trial: Randomized Controlled Double-Blind Design
#'
#' Results from the 1954 Salk polio vaccine field trial using a
#' randomized controlled double-blind design.
#'
#' @format A tibble with 3 rows and 3 variables:
#' \describe{
#'   \item{assignment}{Group assignment (character): treatment, control, or no_consent}
#'   \item{size}{Number of children in group (integer)}
#'   \item{rate}{Polio rate per 100,000 (integer)}
#' }
#'
#' @details
#' In this design, children whose parents consented were randomly assigned
#' to receive either the vaccine (treatment) or a placebo (control), with
#' neither the children nor the evaluating physicians knowing which was
#' which (double-blind). Children whose parents did not consent were
#' tracked separately.
#'
#' Compare with \code{\link{salk_nfip}} for the alternative observed-control
#' design used in some areas.
#'
#' @seealso \code{\link{salk_nfip}}
#'
#' @source Freedman, D., Pisani, R., & Purves, R. (2007).
#'   \emph{Statistics} (4th ed.), Chapter 1, Section 1, p. 3.
#'   W.W. Norton & Company.
#'
#' @examples
#' data(salk_blind)
#' salk_blind
#'
"salk_blind"
