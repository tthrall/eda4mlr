##
# portacaval_survival.R
#   Prepare portacaval shunt survival data for eda4mldata package
##

library(tibble)

# Portacaval shunt survival rates by study design
# From Freedman, Pisani, & Purves (2007), Chapter 1, Section 2
portacaval_survival <- tribble(
  ~design,          ~surgery, ~control,
  "randomized",          60L,      60L,
  "non_randomized",      60L,      45L
)

# Save to package data directory
usethis::use_data(portacaval_survival, overwrite = TRUE)

##
#  EOF
##
