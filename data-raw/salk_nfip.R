##
# salk_nfip.R
#   Prepare Salk vaccine NFIP observed-control design data for eda4mldata package
##

library(tibble)

# Salk vaccine NFIP observed-control design (1954)
# From Freedman, Pisani, & Purves (2007), Chapter 1, Section 1
salk_nfip <- tribble(
  ~grade,   ~assignment,   ~size,   ~rate,
  "2",      "treatment",   225000L,    25L,
  "1, 3",   "control",     725000L,    54L,
  "2",      "no_consent",  125000L,    44L
)

# Save to package data directory
usethis::use_data(salk_nfip, overwrite = TRUE)

##
#  EOF
##
