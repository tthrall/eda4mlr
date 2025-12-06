##
# truman_dewey.R
#   Prepare 1948 election polling data for eda4mldata package
##

library(tibble)

# 1948 presidential election polling predictions
# From Freedman, Pisani, & Purves (2007), Chapter 19, Section 3
truman_dewey <- tribble(
  ~source,            ~Truman, ~Dewey, ~Thurmond, ~Wallace,
  "Crossley",              45L,    50L,        2L,       3L,
  "Gallup",                44L,    50L,        2L,       4L,
  "Roper",                 38L,    53L,        5L,       4L,
  "election result",       50L,    45L,        3L,       2L
)

# Save to package data directory
usethis::use_data(truman_dewey, overwrite = TRUE)

##
#  EOF
##
