##
# ucb_admissions.R
#   Prepare UC Berkeley admissions data for eda4mldata package
##

library(tibble)
library(dplyr)

# UC Berkeley graduate admissions data (1973)
# Convert from datasets::UCBAdmissions 3D array to tidy tibble
# Original data from Bickel et al. (1975), Science 187:398-404
# FPP reference: Freedman, Pisani, & Purves (2007), Chapter 1, Section 4
ucb_admissions <- as.data.frame(UCBAdmissions) |>
  as_tibble() |>
  rename(
    admit = Admit,
    sex = Gender,
    dept = Dept,
    count = Freq
  ) |>
  mutate(
    admit = tolower(admit),
    sex = tolower(sex)
  ) |>
  select(dept, sex, admit, count)

# Save to package data directory
usethis::use_data(ucb_admissions, overwrite = TRUE)

##
#  EOF
##
