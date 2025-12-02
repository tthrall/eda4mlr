##
# lit_digest.R
#   Prepare 1936 Literary Digest poll data for eda4mldata package
##

library(tibble)

# 1936 Literary Digest poll predictions
# From Freedman, Pisani, & Purves (2007), Chapter 19, Section 2
lit_digest <- tribble(
  ~source,              ~fdr_pct,
  "digest",                   43L,
  "gallup_re_digest",         44L,
  "gallup_re_election",       56L,
  "election_result",          62L
)

# Save to package data directory
usethis::use_data(lit_digest, overwrite = TRUE)

##
#  EOF
##
