#  globals.R
#  Declare the bare column names used in non-standard evaluation (the
#  unquoted variables inside dplyr and tidyr data-masking verbs) so that
#  R CMD check does not report them as undefined global variables. These
#  are column references, not package objects.

utils::globalVariables(c(
  "Assault", "Item", "Murder", "Rape", "Title", "UrbanPop",
  "ct", "ds", "gp_tmp", "grp_level", "i_grp", "i_pc", "i_var", "idx",
  "ig_1", "ig_2", "ig_3", "ig_4", "is_1", "is_2", "n", "outer_sum",
  "para", "pc", "pdx", "pkg", "prop", "propn", "sd", "sdx",
  "seg_1", "seg_2", "sntc", "st_abb", "st_nm", "term", "title", "topic",
  "var", "wdx", "word", "x", "x_1", "x_mean", "x_sd", "xend",
  "y", "y_group", "yend"
))
