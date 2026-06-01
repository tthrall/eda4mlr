##
# wine_quality.R
#   Provenance for data/wine_quality.rda (eda4mlr::wine_quality).
#
#   ORIGIN: red + white wine samples from the UCI Machine Learning
#   Repository (https://archive.ics.uci.edu/ml/datasets/wine+quality).
#   That source is no longer reachable, so the dataset is pinned to a
#   frozen local copy, data-raw/wine_quality.csv, which is the source of
#   record going forward. The CSV was written once from the shipped object:
#       readr::write_csv(eda4mlr::wine_quality, "data-raw/wine_quality.csv")
#
#   This script rebuilds data/wine_quality.rda from that CSV, offline and
#   deterministically. It is non-destructive by default (regenerate <-
#   FALSE). Before any deliberate overwrite, confirm the rebuild matches
#   what you currently ship:
#       waldo::compare(eda4mlr::wine_quality, wine_quality)
##

regenerate <- FALSE  # leave FALSE to preserve the shipped .rda

if (regenerate) {

  # Source of record: the frozen CSV (UCI is no longer reachable).
  # Types are fixed explicitly so the rebuild is deterministic.
  wine_quality <- readr::read_csv(
    "data-raw/wine_quality.csv",
    col_types = readr::cols(
      color       = readr::col_character(),
      fix_acidity = readr::col_double(),
      vol_acidity = readr::col_double(),
      citric_acid = readr::col_double(),
      res_sugar   = readr::col_double(),
      chlorides   = readr::col_double(),
      free_so2    = readr::col_double(),
      total_so2   = readr::col_double(),
      density     = readr::col_double(),
      pH          = readr::col_double(),
      sulphates   = readr::col_double(),
      alcohol     = readr::col_double(),
      quality     = readr::col_double()  # if waldo flags int vs dbl, use col_integer()
    )
  ) |>
    dplyr::mutate(color = factor(color, levels = c("red", "white")))

  # Schema guard: a rebuild must match the documented configuration
  # (R/wine_quality.R) before it overwrites the shipped data.
  expected_names <- c(
    "color", "fix_acidity", "vol_acidity", "citric_acid", "res_sugar",
    "chlorides", "free_so2", "total_so2", "density", "pH",
    "sulphates", "alcohol", "quality"
  )
  stopifnot(
    nrow(wine_quality) == 6497L,
    ncol(wine_quality) == 13L,
    identical(names(wine_quality), expected_names),
    is.factor(wine_quality$color),
    identical(levels(wine_quality$color), c("red", "white"))
  )

  usethis::use_data(wine_quality, overwrite = TRUE)

} else {
  message(
    "wine_quality is pinned to data-raw/wine_quality.csv; ",
    "data/wine_quality.rda left untouched. ",
    "Set regenerate <- TRUE to rebuild from the CSV after review."
  )
}

##
#  EOF
##
