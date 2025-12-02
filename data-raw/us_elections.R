##
# us_elections.R
#   Prepare US presidential election polling data for eda4mldata package
##

library(tibble)

# US presidential election Gallup poll accuracy (1952-2004)
# From Freedman, Pisani, & Purves (2007), Chapter 19, Section 5
us_elections <- tribble(
  ~year, ~n,      ~winner,       ~gallup, ~actual, ~error,
  1952L, 5385L,   "Eisenhower",     51.0,    55.1,   -4.1,
  1956L, 8144L,   "Eisenhower",     59.5,    57.4,    2.1,
  1960L, 8015L,   "Kennedy",        51.0,    49.7,    1.3,
  1964L, 6625L,   "Johnson",        64.0,    61.1,    2.9,
  1968L, 4414L,   "Nixon",          43.0,    43.4,   -0.4,
  1972L, 3689L,   "Nixon",          62.0,    60.7,    1.3,
  1976L, 3439L,   "Carter",         48.0,    50.1,   -2.1,
  1980L, 3500L,   "Reagan",         47.0,    50.7,   -3.7,
  1984L, 3456L,   "Reagan",         59.0,    58.8,    0.2,
  1988L, 4089L,   "Bush",           56.0,    53.4,    2.6,
  1992L, 2019L,   "Clinton",        49.0,    43.0,    6.0,
  1996L, 2895L,   "Clinton",        52.0,    49.2,    2.8,
  2000L, 3571L,   "Bush",           48.0,    47.9,    0.1,
  2004L, 2014L,   "Bush",           49.0,    50.6,   -1.6
)

# Save to package data directory
usethis::use_data(us_elections, overwrite = TRUE)

##
#  EOF
##
