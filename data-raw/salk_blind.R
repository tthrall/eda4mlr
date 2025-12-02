##
# salk_blind.R
#   Prepare Salk vaccine randomized controlled trial data for eda4mldata package
##

library(tibble)

# Salk vaccine double-blind randomized controlled trial (1954)
# From Freedman, Pisani, & Purves (2007), Chapter 1, Section 1
salk_blind <- tribble(
  ~assignment,   ~size,   ~rate,
  "treatment",   200000L,    28L,
  "control",     200000L,    71L,
  "no_consent",  350000L,    46L
)

# Save to package data directory
usethis::use_data(salk_blind, overwrite = TRUE)

##
#  EOF
##
