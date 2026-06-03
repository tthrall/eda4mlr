#' Install the R packages used by the eda4ml book
#'
#' Checks which packages used by the eda4ml book are not yet installed and
#' installs the missing ones. By default it considers the full set of
#' packages used anywhere in the book; pass \code{chapters} to scope the
#' check to a subset, so a student working through only the early chapters
#' is not asked to install packages those chapters never load.
#'
#' The package lists are read from the bundled tables in
#' \code{inst/templates/}: the union \code{eda4ml_pkg_tbl.txt} for the full
#' set, and \code{packages_per_chapter_tbl.txt} when \code{chapters} is
#' supplied. The lists are CRAN-only and do not include \code{eda4mlr}
#' itself, which supplies this function and is therefore already installed.
#'
#' Installation uses the CRAN repository configured in the session; the
#' student workspace created by \code{create_project()} sets one in its
#' \code{.Rprofile}.
#'
#' @param chapters Optional integer vector of chapter numbers. When supplied,
#'   only the packages those chapters use are considered; when \code{NULL}
#'   (the default), the full book union is used.
#' @param ... Additional arguments passed to \code{utils::install.packages()}.
#'
#' @return Invisibly, a character vector of the packages that were missing
#'   and for which installation was attempted (empty if none were missing).
#'
#' @examples
#' \dontrun{
#' # Install everything the book uses:
#' install_eda4ml_packages()
#'
#' # Install only what chapters 1 through 5 need:
#' install_eda4ml_packages(chapters = 1:5)
#' }
#'
#' @export
install_eda4ml_packages <- function(chapters = NULL, ...) {
  if (is.null(chapters)) {
    tbl_path <- system.file(
      "templates", "eda4ml_pkg_tbl.txt",
      package = "eda4mlr"
    )
    if (tbl_path == "") {
      stop(
        "Package union table not found. ",
        "Ensure inst/templates/eda4ml_pkg_tbl.txt exists in the package.",
        call. = FALSE
      )
    }
    pkgs <- utils::read.delim(tbl_path, stringsAsFactors = FALSE)$pkg
  } else {
    tbl_path <- system.file(
      "templates", "packages_per_chapter_tbl.txt",
      package = "eda4mlr"
    )
    if (tbl_path == "") {
      stop(
        "Per-chapter package table not found. ",
        "Ensure inst/templates/packages_per_chapter_tbl.txt exists in the package.",
        call. = FALSE
      )
    }
    pkg_tbl <- utils::read.delim(tbl_path, stringsAsFactors = FALSE)
    pkg_tbl$chpt <- as.integer(pkg_tbl$chpt)
    pkgs <- pkg_tbl$pkg[pkg_tbl$chpt %in% chapters]
  }

  pkgs <- unique(pkgs[!is.na(pkgs) & nzchar(pkgs)])

  if (length(pkgs) == 0L) {
    message("No packages found in scope.")
    return(invisible(character(0)))
  }

  missing <- setdiff(pkgs, rownames(utils::installed.packages()))

  if (length(missing) == 0L) {
    message("All eda4ml packages in scope are already installed.")
    return(invisible(character(0)))
  }

  message(
    "Installing ", length(missing), " missing package(s): ",
    paste(missing, collapse = ", ")
  )
  utils::install.packages(missing, ...)
  invisible(missing)
}
