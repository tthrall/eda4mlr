#' 1948 Truman-Dewey Election Predictions
#'
#' Polling predictions for the 1948 U.S. presidential election from
#' three major pollsters, compared with the actual election result.
#'
#' @format A tibble with 4 rows and 5 variables:
#' \describe{
#'   \item{source}{Source of prediction (character): crossley, gallup, roper,
#'     or election_result}
#'   \item{truman}{Predicted or actual percentage for Harry Truman (integer)}
#'   \item{dewey}{Predicted or actual percentage for Thomas Dewey (integer)}
#'   \item{thurmond}{Predicted or actual percentage for Strom Thurmond (integer)}
#'   \item{wallace}{Predicted or actual percentage for Henry Wallace (integer)}
#' }
#'
#' @details
#' All three major pollsters predicted Thomas Dewey would defeat Harry
#' Truman, leading to the famous "Dewey Defeats Truman" headline. The
#' failure stemmed from multiple causes: quota sampling methods that
#' introduced bias, stopping polling too early (missing late shifts to
#' Truman), and allocation of undecided voters.
#'
#' @source Freedman, D., Pisani, R., & Purves, R. (2007).
#'   \emph{Statistics} (4th ed.), Chapter 19, Section 3, p. 337.
#'   W.W. Norton & Company.
#'
#' @examples
#' data(truman_dewey)
#' truman_dewey
#'
"truman_dewey"
