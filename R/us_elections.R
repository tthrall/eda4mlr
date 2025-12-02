#' US Presidential Election Gallup Poll Accuracy
#'
#' Gallup poll predictions and actual results for U.S. presidential
#' elections from 1952 to 2004.
#'
#' @format A tibble with 14 rows and 6 variables:
#' \describe{
#'   \item{year}{Election year (integer)}
#'   \item{n}{Gallup poll sample size (integer)}
#'   \item{winner}{Name of election winner (character)}
#'   \item{gallup}{Gallup prediction for winner's vote share (numeric, percent)}
#'   \item{actual}{Actual vote share for winner (numeric, percent)}
#'   \item{error}{Prediction error: gallup minus actual (numeric, percentage points)}
#' }
#'
#' @details
#' This dataset tracks Gallup's final pre-election poll predictions against
#' actual outcomes for 14 presidential elections. The error column shows
#' prediction accuracy, with positive values indicating overestimation of
#' the winner's support and negative values indicating underestimation.
#'
#' Note that in years with significant third-party candidates (1968, 1992),
#' the winner's vote share may be well below 50\%.
#'
#' @source Freedman, D., Pisani, R., & Purves, R. (2007).
#'   \emph{Statistics} (4th ed.), Chapter 19, Section 5, p. 342.
#'   W.W. Norton & Company.
#'
#' @examples
#' data(us_elections)
#' us_elections
#'
#' # Mean absolute error
#' mean(abs(us_elections$error))
#'
"us_elections"
