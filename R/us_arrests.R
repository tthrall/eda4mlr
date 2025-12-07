#' US Violent Crime Rates by State (1973)
#'
#' Violent crime rates and urban population percentage for US states
#' in 1973. A classic dataset for clustering and principal component
#' analysis demonstrations.
#'
#' @format A tibble with 50 rows and 6 variables:
#' \describe{
#'   \item{state}{State abbreviation (character, two-letter postal code)}
#'   \item{state_name}{State name (character)}
#'   \item{urban_pop}{Percent of population living in urban areas (numeric)}
#'   \item{assault}{Assault arrests per 100,000 population (numeric)}
#'   \item{rape}{Rape arrests per 100,000 population (numeric)}
#'   \item{murder}{Murder arrests per 100,000 population (numeric)}
#' }
#'
#' @details
#' This dataset is commonly used to illustrate clustering methods
#' and dimension reduction techniques. The variables
#' (assault, rape, murder) are rates of \emph{arrest}.
#'
#' @source McNeil, D. R. (1977). \emph{Interactive Data Analysis}.
#'   Wiley.
#'
#'   Data obtained from the base R \code{datasets} package.
#'
#' @examples
#' data(us_arrests)
#' summary(us_arrests)
#'
"us_arrests"
