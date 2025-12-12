#' Daily Temperatures for Honolulu and New York City (1995-2020)
#'
#' Daily average temperatures (°F) recorded at Honolulu, Hawaii and 
#' New York City, New York from January 1, 1995 through May 13, 2020.
#'
#' @format `hnl_nyc_temps` is a tibble with 18,530 rows and 5 columns:
#' \describe{
#'   \item{city}{City name: "Honolulu" or "New York City"}
#'   \item{date}{Date of observation}
#'   \item{temp}{Average daily temperature (°F), with some missing values}
#'   \item{temp_imputed}{Temperature with missing values imputed via moving average}
#'   \item{year}{Year of observation}
#' }
#' 
#' @details
#' The dataset contains 9,265 daily observations for each city. Missing values
#' (18 for Honolulu, 20 for New York City) were imputed using a moving average
#' method via \code{imputeTS::na_ma()}. The \code{temp} column preserves the
#' original missing values; the \code{temp_imputed} column provides the
#' imputed series suitable for spectrum estimation and other analyses
#' requiring complete data.
#' 
#' Honolulu temperatures have mean 77°F with standard deviation 3.4°F.
#' New York City temperatures have mean 56°F with standard deviation 17.1°F.
#' The contrast illustrates how climate differs between tropical and 
#' mid-latitude locations: Honolulu is warmer and far less variable.
#'
#' @source Weather station data obtained from NOAA.
#'
#' @examples
#' library(ggplot2)
#' 
#' # Compare temperature distributions
#' ggplot(hnl_nyc_temps, aes(x = temp_imputed, fill = city)) +
#'   geom_density(alpha = 0.5) +
#'   labs(x = "Temperature (°F)", y = "Density")
#'
#' # Time series for one city
#' hnl <- subset(hnl_nyc_temps, city == "Honolulu")
#' plot(hnl$date, hnl$temp_imputed, type = "l", 
#'      xlab = "Date", ylab = "Temperature (°F)")
#'
#' @seealso \code{\link{hnl_nyc_temps_wide}} for wide format suitable for
#'   multivariate time series analysis.
#'
"hnl_nyc_temps"


#' Daily Temperatures for Honolulu and New York City (Wide Format)
#'
#' Daily average temperatures (°F) for Honolulu and New York City in wide
#' format, suitable for multivariate time series analysis including
#' cross-spectrum and coherence estimation.
#'
#' @format `hnl_nyc_temps_wide` is a tibble with 9,265 rows and 5 columns:
#' \describe{
#'   \item{date}{Date of observation}
#'   \item{HNL}{Honolulu temperature (°F), imputed}
#'   \item{NYC}{New York City temperature (°F), imputed}
#'   \item{HNL_raw}{Honolulu temperature with original missing values}
#'   \item{NYC_raw}{New York City temperature with original missing values}
#' }
#' 
#' @details
#' This is a wide-format version of \code{\link{hnl_nyc_temps}}, with one
#' row per date and separate columns for each city. The \code{HNL} and 
#' \code{NYC} columns contain imputed values suitable for spectrum estimation;
#' the \code{HNL_raw} and \code{NYC_raw} columns preserve original missing
#' values.
#' 
#' To convert to a multivariate time series for use with \code{stats::spec.pgram()}:
#' \preformatted{
#' ts_data <- ts(hnl_nyc_temps_wide[, c("HNL", "NYC")], 
#'               frequency = 365, start = c(1995, 1))
#' }
#'
#' @source Weather station data obtained from NOAA.
#'
#' @examples
#' # Create multivariate time series
#' ts_data <- ts(hnl_nyc_temps_wide[, c("HNL", "NYC")], 
#'               frequency = 365, start = c(1995, 1))
#'
#' # Estimate cross-spectrum and coherence
#' spec_result <- spec.pgram(ts_data, spans = c(7, 7), taper = 0.1)
#' 
#' # Plot coherence
#' plot(spec_result, plot.type = "coherency")
#'
#' @seealso \code{\link{hnl_nyc_temps}} for long (tidy) format.
#'
"hnl_nyc_temps_wide"
