#' Olympic Running Event Winning Times
#'
#' Fastest running times for Olympic track events from 1896 to 2016,
#' for men and women across seven distances (100m, 200m, 400m, 800m,
#' 1500m, 5000m, 10000m).
#'
#' @format A tibble with 312 rows and 4 variables:
#' \describe{
#'   \item{year}{Olympic year (integer)}
#'   \item{length}{Race distance in meters (integer)}
#'   \item{sex}{Sex of event (character): male or female}
#'   \item{time}{Winning time in seconds (numeric)}
#' }
#'
#' @details
#' Missing values occur in 1916, 1940, and 1944 due to the World Wars.
#' Women's events were introduced at different times: 100m and 800m in
#' 1928, 200m in 1948, 400m in 1964, 1500m in 1972, and 5000m/10000m
#' in 1996.
#'
#' @source International Olympic Committee,
#'   \url{https://olympics.com/en/sports/athletics/}.
#'   Data obtained via the \code{tsibbledata} package.
#'
#' @examples
#' data(olympic_running)
#' summary(olympic_running)
#'
"olympic_running"
