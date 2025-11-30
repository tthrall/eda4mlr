##
# olympic_running.R
#   Prepare Olympic running data set for `eda4mldata` package
##

library(tibble)
library(dplyr)

# Load from tsibbledata package and convert to plain tibble
olympic_running <- tsibbledata::olympic_running |>

  as_tibble() |>
  rename(
    year   = Year,
    length = Length,
    sex    = Sex,
    time   = Time
  ) |>
  mutate(sex = tolower(sex)) |>
  select(year, length, sex, time)

# Save to package data directory
usethis::use_data(olympic_running, overwrite = TRUE)

##
#  EOF
##
