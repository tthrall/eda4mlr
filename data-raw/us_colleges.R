##
# us_colleges.R
#   Prepare US colleges dataset for eda4mldata package
##

# Load College data from ISLR2 package
# Original data has college names as row names
us_colleges <- ISLR2::College |>
  tibble::as_tibble(rownames = "college") |>
  dplyr::rename(
    private        = Private,
    apps           = Apps,
    accept         = Accept,
    enroll         = Enroll,
    top10perc      = Top10perc,
    top25perc      = Top25perc,
    f_undergrad    = F.Undergrad,
    p_undergrad    = P.Undergrad,
    outstate       = Outstate,
    room_board     = Room.Board,
    books          = Books,
    personal       = Personal,
    phd            = PhD,
    terminal       = Terminal,
    s_f_ratio      = S.F.Ratio,
    perc_alumni    = perc.alumni,
    expend         = Expend,
    grad_rate      = Grad.Rate
  ) |>
  dplyr::mutate(
    private = ifelse(private == "Yes", "yes", "no")
  )

# Verify: should be 777 colleges
stopifnot(nrow(us_colleges) == 777L)

# Save to package data directory
usethis::use_data(us_colleges, overwrite = TRUE)

##
#  EOF
##
