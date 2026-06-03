# data-raw/regenerate-packages.R
#
# Regenerates the package tables in inst/templates/ from the local eda4ml
# book repo:
#   - packages_per_chapter_tbl.txt  (part, chpt, file, pkg)
#   - eda4ml_pkg_tbl.txt            (the deduplicated union)
#
# Run interactively after devtools::load_all(). Re-run when the book changes:
# a chapter loads a new package, or chapters are added, renamed, or reordered.
#
# Future scope: this script should eventually also regenerate chpt-details.txt
# by scanning eda4ml/, so the chapter metadata joined below comes from a
# freshly scanned source rather than the committed file. That is not yet
# built; for now the script reads the committed chpt-details.txt for the
# part and file columns.

# Per-chapter CRAN packages parsed from the book: columns chapter, pkg,
# each chapter's packages already sorted case-insensitively.
chpt_pkgs <- sync_packages()

# Chapter metadata from chpt-details.txt: part (idx_0), chpt (idx_1), and the
# QMD file name (fn_stub + ".qmd"). Non-chapter rows (index, preface, summary,
# references) have a blank idx_1 and are dropped.
details_path <- here::here("inst", "templates", "chpt-details.txt")
meta <- readr::read_tsv(details_path, show_col_types = FALSE) |>
  dplyr::filter(!is.na(idx_1)) |>
  dplyr::transmute(
    part = as.integer(idx_0),
    chpt = as.integer(idx_1),
    file = paste0(fn_stub, ".qmd")
  )

# Four-column per-chapter table: part, chpt, file, pkg. The left join keeps
# chpt_pkgs row order (registry order, case-insensitive within chapter).
per_chapter <- chpt_pkgs |>
  dplyr::rename(chpt = chapter) |>
  dplyr::left_join(meta, by = "chpt") |>
  dplyr::select(part, chpt, file, pkg)

readr::write_tsv(
  per_chapter,
  here::here("inst", "templates", "packages_per_chapter_tbl.txt")
)

# Deduplicated union, case-insensitively sorted to match the per-chapter order.
union_pkgs <- unique(per_chapter$pkg)
union_tbl <- tibble::tibble(
  pkg = union_pkgs[order(tolower(union_pkgs), method = "radix")]
)
readr::write_tsv(
  union_tbl,
  here::here("inst", "templates", "eda4ml_pkg_tbl.txt")
)

message(
  "Wrote ", nrow(per_chapter), " rows to packages_per_chapter_tbl.txt and ",
  nrow(union_tbl), " packages to eda4ml_pkg_tbl.txt"
)
