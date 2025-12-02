##
# nb10.R
#   Prepare NB10 weighing data for eda4mldata package
##

library(tibble)

# NB10 repeated weighing measurements
# 100 measurements of a standard weight, recording micrograms below 10 grams
# From Freedman, Pisani, & Purves (2007), Chapter 6, Section 1
nb10 <- tibble(
  idx = 1:100,
  deficit = c(
    409L, 400L, 406L, 399L, 402L, 406L, 401L, 403L, 401L, 403L,
    398L, 403L, 407L, 402L, 401L, 399L, 400L, 401L, 405L, 402L,
    408L, 399L, 399L, 402L, 399L, 397L, 407L, 401L, 399L, 401L,
    403L, 400L, 410L, 401L, 407L, 423L, 406L, 406L, 402L, 405L,
    405L, 409L, 399L, 402L, 407L, 406L, 413L, 409L, 404L, 402L,
    404L, 406L, 407L, 405L, 411L, 410L, 410L, 410L, 401L, 402L,
    404L, 405L, 392L, 407L, 406L, 404L, 403L, 408L, 404L, 407L,
    412L, 406L, 409L, 400L, 408L, 404L, 401L, 404L, 408L, 406L,
    408L, 406L, 401L, 412L, 393L, 437L, 418L, 415L, 404L, 401L,
    401L, 407L, 412L, 375L, 409L, 406L, 398L, 406L, 403L, 404L
  )
)

# Save to package data directory
usethis::use_data(nb10, overwrite = TRUE)

##
#  EOF
##
