#' 1936 Literary Digest Poll
#'
#' Predictions for the 1936 U.S. presidential election from the Literary
#' Digest poll and Gallup, compared with the actual election result.
#'
#' @format A tibble with 4 rows and 2 variables:
#' \describe{
#'   \item{source}{Source of prediction (character)}
#'   \item{fdr_pct}{Predicted or actual percentage for FDR (integer)}
#' }
#'
#' @details
#' The Literary Digest had correctly predicted every presidential election
#' since 1916, but famously failed in 1936 by predicting Alf Landon would
#' defeat Franklin D. Roosevelt. The Digest mailed questionnaires to 10
#' million people drawn from telephone directories and automobile
#' registration lists—sources that over-represented wealthier voters who
#' favored Landon. George Gallup, using a smaller but more representative
#' sample, correctly predicted both the election outcome and what the
#' biased Digest poll would find.
#'
#' Source values:
#' \itemize{
#'   \item \code{digest}: Literary Digest poll prediction
#'   \item \code{gallup_re_digest}: Gallup's prediction of the Digest result
#'   \item \code{gallup_re_election}: Gallup's prediction of the election
#'   \item \code{election_result}: Actual election result
#' }
#'
#' @source Freedman, D., Pisani, R., & Purves, R. (2007).
#'   \emph{Statistics} (4th ed.), Chapter 19, Section 2, p. 334.
#'   W.W. Norton & Company.
#'
#' @examples
#' data(lit_digest)
#' lit_digest
#'
"lit_digest"
