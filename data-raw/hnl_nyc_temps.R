## code to prepare `hnl_nyc_temps` and `hnl_nyc_temps_wide` datasets

library(dplyr)
library(here)
library(readr)
library(tidyr)

# Read source data (previously imputed via imputeTS::na_ma())
hnl_nyc_raw <- readr::read_tsv(here::here(
  "data-raw", "HNL_NYC_t_imp.txt"
)) |>
  dplyr::mutate(across(
    .cols = c(Month, Day, Year),
    .fns  = as.integer
  ))

# Create long (tidy) format
hnl_nyc_temps <- hnl_nyc_raw |>
  dplyr::select(
    city = City,
    date = dt,
    temp = temp,
    temp_imputed = t_imp,
    year = Year
  ) |>
  dplyr::arrange(city, date)

# Create wide format
hnl_nyc_temps_wide <- hnl_nyc_temps |>
  dplyr::select(date, city, temp, temp_imputed) |>
  tidyr::pivot_wider(
    id_cols = date,
    names_from = city,
    values_from = c(temp_imputed, temp),
    names_glue = "{city}_{.value}"
  ) |>
  dplyr::rename(
    HNL = Honolulu_temp_imputed,
    NYC = `New York City_temp_imputed`,
    HNL_raw = Honolulu_temp,
    NYC_raw = `New York City_temp`
  ) |>
  dplyr::select(date, HNL, NYC, HNL_raw, NYC_raw)

# Save to package data
usethis::use_data(hnl_nyc_temps, overwrite = TRUE)
usethis::use_data(hnl_nyc_temps_wide, overwrite = TRUE)
