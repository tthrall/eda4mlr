#' Sync per-chapter package lists from the eda4ml book repo
#'
#' Parses each chapter QMD in the local `eda4ml` checkout and returns a
#' tibble of chapter-package pairs faithful to what each chapter loads.
#' Reads only the labeled `CRAN-libraries` chunk per chapter; flags any
#' `local-libraries` chunk that loads something other than `eda4mlr`.
#'
#' @param book_path Character. Path to the local `eda4ml` book repo. If
#'   NULL, defaults to a sibling directory `../eda4ml`.
#' @param book_chapters Character. Path to `book-chapters.txt`. If NULL,
#'   defaults to the file shipped with `eda4mlr`.
#' @return A tibble with columns `chapter` (integer) and `pkg` (character).
#' @keywords internal
sync_packages <- function(
    book_path     = NULL,
    book_chapters = NULL
) {
  # Resolve defaults
  if (is.null(book_path)) {
    book_path <- normalizePath(
      file.path("..", "eda4ml"),
      mustWork = FALSE
    )
  }
  if (!dir.exists(book_path)) {
    stop("book_path not found: ", book_path)
  }

  if (is.null(book_chapters)) {
    book_chapters <- system.file(
      "templates", "book-chapters.txt",
      package = "eda4mlr"
    )
  }
  if (!file.exists(book_chapters)) {
    stop("book_chapters file not found: ", book_chapters)
  }

  registry <- readr::read_tsv(book_chapters, show_col_types = FALSE)

  # Extract package names from a labeled chunk in a QMD file
  extract_pkgs_from_chunk <- function(qmd_lines, label) {
    label_pat <- paste0("^#\\|\\s*label:\\s*", label, "\\s*$")
    label_idx <- stringr::str_which(qmd_lines, label_pat)

    if (length(label_idx) == 0) return(character(0))
    label_idx <- label_idx[1]

    # Walk forward to the closing fence
    end_idx <- label_idx + 1
    while (end_idx <= length(qmd_lines) &&
           !stringr::str_detect(qmd_lines[end_idx], "^```\\s*$")) {
      end_idx <- end_idx + 1
    }
    chunk_body <- qmd_lines[(label_idx + 1):(end_idx - 1)]

    # library(pkg) or library("pkg"), allowing trailing args/comments
    lib_pat <- "^\\s*library\\(\"?([A-Za-z][A-Za-z0-9.]*)\"?"
    matches <- stringr::str_match(chunk_body, lib_pat)
    pkgs <- matches[, 2]
    pkgs <- pkgs[!is.na(pkgs)]
    unique(pkgs)
  }

  # Per-chapter extraction
  extract_for_chapter <- function(chapter, slug) {
    qmd_fp <- file.path(book_path, paste0(slug, ".qmd"))
    if (!file.exists(qmd_fp)) {
      warning("Chapter ", chapter, " QMD not found: ", qmd_fp)
      return(tibble::tibble(chapter = integer(), pkg = character()))
    }
    qmd_lines <- readr::read_lines(qmd_fp)

    cran_pkgs  <- extract_pkgs_from_chunk(qmd_lines, "CRAN-libraries")
    local_pkgs <- extract_pkgs_from_chunk(qmd_lines, "local-libraries")

    # Sanity-check the local chunk
    unexpected <- setdiff(local_pkgs, "eda4mlr")
    if (length(unexpected) > 0) {
      warning(
        "Chapter ", chapter,
        " local-libraries chunk loads unexpected package(s): ",
        paste(unexpected, collapse = ", ")
      )
    }

    if (length(cran_pkgs) == 0) {
      return(tibble::tibble(chapter = integer(), pkg = character()))
    }
    tibble::tibble(
      chapter = as.integer(chapter),
      pkg     = sort(cran_pkgs)
    )
  }

  results <- purrr::map2(
    registry$chapter, registry$slug,
    extract_for_chapter
  )
  dplyr::bind_rows(results)
}
