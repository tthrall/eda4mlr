##
# us_arrests.R
# Prepare US arrests dataset for eda4mldata package
##

# Load USArrests from base R datasets
# Original data has state names as row names
us_arrests <- datasets::USArrests |>
  tibble::as_tibble(rownames = "state_name") |>
  dplyr::mutate(
    state =
      datasets::state.abb[
        match(state_name, datasets::state.name)
      ]
  ) |>
  rename(
    urban_pop = UrbanPop,
    murder    = Murder,
    assault   = Assault,
    rape      = Rape
  ) |>
  dplyr::select(state, state_name, urban_pop, assault, rape, murder)

# Verify: should be 50 states
stopifnot(nrow(us_arrests) == 50L)

# Save to package data directory
usethis::use_data(us_arrests, overwrite = TRUE)

##
#  EOF
##
