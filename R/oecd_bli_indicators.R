#' OECD Better Life Index Indicator Metadata
#'
#' Descriptions of the 24 component indicators used in the
#' OECD Better Life Index.
#'
#' @format A tibble with 24 rows and 5 variables:
#' \describe{
#'   \item{code}{Indicator code matching column names in \code{oecd_bli}}
#'   \item{category}{Dimension/topic (one of 11 well-being dimensions)}
#'   \item{indicator}{Indicator name}
#'   \item{unit}{Unit of measurement (PC = percent, YR = years,
#'     USD = US dollars, RATIO = ratio, HOUR = hours,
#'     AVSCORE = average score, MICRO_M3 = micrograms per cubic meter)}
#'   \item{description}{Brief description of what the indicator measures}
#' }
#'
#' @source OECD Better Life Index,
#'   \url{https://www.oecdbetterlifeindex.org/}.
#'
#' @seealso \code{\link{oecd_bli}}
#'
#' @examples
#' data(oecd_bli_indicators)
#' oecd_bli_indicators
#'
"oecd_bli_indicators"
