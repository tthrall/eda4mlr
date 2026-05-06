# data-raw/regenerate-packages.R
#
# Regenerates inst/templates/chpt-packages.txt from the local eda4ml
# book repo.
#
# Run interactively after devtools::load_all(). Re-run when:
#   - the book changes (a chapter loads a new package), or
#   - get_core_packages() changes.

# Parse the book, apply policy
chpt_pkgs_book    <- sync_packages()
chpt_pkgs_student <- chpt_pkgs_book |>
  dplyr::filter(!pkg %in% get_core_packages())

# Persist
out_path <- here::here("inst", "templates", "chpt-packages.txt")
readr::write_tsv(chpt_pkgs_student, out_path)

message(
  "Wrote ", nrow(chpt_pkgs_student),
  " rows to inst/templates/chpt-packages.txt"
)
