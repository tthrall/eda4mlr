##
# handedness.R
#   Prepare handedness data set for `eda4mldata` package
##

library(tibble)

# Handedness data from Freedman, Pisani, & Purves (2007)
# Statistics (4th ed.), Chapter 28, Section 4: Testing Independence
handedness <- tibble::tribble(
  ~sex,     ~hnd,    ~count,
  "male",   "right",  934L,
  "male",   "left",   113L,
  "male",   "ambi",    20L,
  "female", "right", 1070L,
  "female", "left",    92L,
  "female", "ambi",     8L
)

# Save to package data directory
usethis::use_data(handedness, overwrite = TRUE)

##
#  EOF
##
