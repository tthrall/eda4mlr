##
# portacaval_studies.R
#   Prepare portacaval shunt study results data for eda4mldata package
##

library(tibble)

# Portacaval shunt study results by design type
# From Freedman, Pisani, & Purves (2007), Chapter 1, Section 2
portacaval_studies <- tribble(
  ~design,                         ~marked, ~moderate, ~none,
  "no_controls",                       24L,        7L,    1L,
  "controls_not_randomized",           10L,        3L,    2L,
  "randomized_controlled",              0L,        1L,    3L
)

# Save to package data directory
usethis::use_data(portacaval_studies, overwrite = TRUE)

##
#  EOF
##
