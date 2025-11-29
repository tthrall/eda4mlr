#' Wine Quality Dataset
#'
#' Red and white wine samples from the UCI Machine Learning Repository,
#' with physicochemical properties and quality ratings.
#'
#' @format A tibble with 6497 rows and 13 variables:
#' \describe{
#'   \item{color}{Wine color (factor): red or white}
#'   \item{fix_acidity}{Fixed acidity in g/dm3}
#'   \item{vol_acidity}{Volatile acidity in g/dm3}
#'   \item{citric_acid}{Citric acid in g/dm3}
#'   \item{res_sugar}{Residual sugar in g/dm3}
#'   \item{chlorides}{Chlorides in g/dm3}
#'   \item{free_so2}{Free sulfur dioxide in mg/dm3}
#'   \item{total_so2}{Total sulfur dioxide in mg/dm3}
#'   \item{density}{Density in g/cm3}
#'   \item{pH}{pH value}
#'   \item{sulphates}{Sulphates in g/dm3}
#'   \item{alcohol}{Alcohol percentage by volume}
#'   \item{quality}{Quality score from 0 to 10}
#' }
#'
#' @source \url{https://archive.ics.uci.edu/ml/datasets/wine+quality}
#'
#' @examples
#' data(wine_quality)
#' summary(wine_quality)
#'
"wine_quality"
