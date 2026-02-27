#' Create a workbook from template
#'
#' Copies a workbook template to the current working directory for the student
#' to complete.
#'
#' @param chapter Chapter identifier. Either an integer chapter number or a
#'   character slug. Use \code{list_workbooks()} to see available options.
#' @param overwrite Logical. If \code{TRUE}, overwrite existing file with same
#'   name. Default is \code{FALSE}.
#' @param open Logical. If \code{TRUE} and RStudio is available, open the file
#'   automatically. Default is \code{TRUE}.
#'
#' @return Invisibly returns the path to the created file.
#'
#' @examples
#' \dontrun{
#' # Create by chapter number
#' create_workbook(3)
#'
#' # Create by slug
#' create_workbook("eda")
#'
#' # See available workbooks
#' list_workbooks()
#' }
#'
#' @export
create_workbook <- function(chapter, overwrite = FALSE, open = TRUE) {

  # Get available workbooks
  available <- list_workbooks()

  if (nrow(available) == 0) {
    stop("No workbook templates are currently available.", call. = FALSE)
  }

  # Resolve chapter to a row in the registry
  if (is.numeric(chapter)) {
    row <- available[available$chapter == chapter, ]
    if (nrow(row) == 0) {
      stop(
        "Chapter ", chapter, " not found.\n",
        "Use list_workbooks() to see available chapters.",
        call. = FALSE
      )
    }
  } else if (is.character(chapter)) {
    row <- available[available$slug == chapter, ]
    if (nrow(row) == 0) {
      stop(
        "Template '", chapter, "' not found.\n",
        "Use list_workbooks() to see available options.",
        call. = FALSE
      )
    }
  } else {
    stop("'chapter' must be a number or character string.", call. = FALSE)
  }

  slug <- row$slug

  # Construct template filename
  template_name <- paste0(slug, "-wkbk.qmd")

  # Find template in installed package
  template_path <- system.file(
    "templates", template_name,
    package = "eda4mlr",
    mustWork = FALSE
  )

  if (template_path == "") {
    stop(
      "Template file '", template_name, "' not found in package.",
      call. = FALSE
    )
  }

  # Destination in current working directory
  dest_path <- file.path(getwd(), template_name)

  # Check for existing file
  if (file.exists(dest_path) && !overwrite) {
    stop(
      "File '", template_name, "' already exists.\n",
      "Use overwrite = TRUE to replace it.",
      call. = FALSE
    )
  }

  # Copy template
  success <- file.copy(template_path, dest_path, overwrite = overwrite)
  if (!success) {
    stop("Failed to copy template to '", dest_path, "'.", call. = FALSE)
  }

  message(
    "Created: ", template_name, "\n",
    "Chapter ", row$chapter, ": ", row$title, "\n",
    "Open in RStudio and begin working through the exercises."
  )

  # Open in RStudio if available and requested
  if (open && requireNamespace("rstudioapi", quietly = TRUE)) {
    if (rstudioapi::isAvailable()) {
      rstudioapi::navigateToFile(dest_path)
    }
  }

  invisible(dest_path)
}


#' List available workbooks
#'
#' Shows all workbook templates available in the eda4mlr package.
#' Reads chapter metadata from the package's authoritative registry
#' and checks which corresponding template files exist on disk.
#'
#' @return A tibble with columns:
#'   \describe{
#'     \item{chapter}{Integer chapter number}
#'     \item{slug}{Character identifier used in \code{create_workbook()}}
#'     \item{title}{Descriptive chapter title}
#'   }
#'
#' @examples
#' list_workbooks()
#'
#' @export
list_workbooks <- function() {

  registry <- get_chapter_registry()

  # Check which templates actually exist on disk
  template_dir <- system.file("templates", package = "eda4mlr")
  existing_files <- list.files(template_dir, pattern = "-wkbk\\.qmd$")
  existing_slugs <- sub("-wkbk\\.qmd$", "", existing_files)

  # Filter registry to chapters with available templates
  available <- registry[registry$slug %in% existing_slugs, , drop = FALSE]
  available <- available[order(available$chapter), , drop = FALSE]

  tibble::as_tibble(available)
}
