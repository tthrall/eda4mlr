# wine_quality.R
# Prepare wine quality dataset for eda4mldata package

library(tidyverse)

# UCI Machine Learning Repository URLs
url_red   <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"
url_white <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"

# Read data (semicolon-separated)
red   <- read_delim(url_red,   delim = ";", show_col_types = FALSE)
white <- read_delim(url_white, delim = ";", show_col_types = FALSE)

# Combine with color indicator
wine_quality <- bind_rows(
  red   |> mutate(color = "red"),
  white |> mutate(color = "white")
) |>
  relocate(color) |>
  mutate(color = factor(color))

# Save to package data directory
usethis::use_data(wine_quality, overwrite = TRUE)

##
#  EOF
##
