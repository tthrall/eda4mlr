##
# galton_families.R
#   Prepare Galton family heights dataset for eda4mldata package
##

# Load Galton's family data from HistData package
# Original: 934 children from 205 families
# We extract one adult child per family (the first/oldest)
galton_raw <- HistData::GaltonFamilies

galton_families <- galton_raw |>
  tibble::as_tibble() |>
  dplyr::group_by(family) |>
  dplyr::slice_head(n = 1) |>
  dplyr::ungroup() |>
  dplyr::transmute(
    family   = as.integer(family),
    father   = father,
    mother   = mother,
    child    = childHeight,
    gender   = tolower(gender)
  )

# Verify: should be 205 families
stopifnot(nrow(galton_families) == 205L)

# Save to package data directory
usethis::use_data(galton_families, overwrite = TRUE)

##
#  EOF
##
