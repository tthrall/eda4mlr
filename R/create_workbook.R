#' Create a workbook from template
#'
#' Copies a workbook template to the current working directory for the student
#' to complete.
#'
#' @param chapter Character string identifying the chapter. Use
#'   \code{list_workbooks()} to see available options.
#' @param overwrite Logical. If \code{TRUE}, overwrite existing file with same
#'   name. Default is \code{FALSE}.
#'
#' @return Invisibly returns the path to the created file.
#'
#' @examples
#' \dontrun{
#' # Create the EDA chapter workbook
#' create_workbook("eda")
#'
#' # See available workbooks
#' list_workbooks()
#' }
#'
#' @export
create_workbook <- function(chapter, overwrite = FALSE) {


  # Construct template filename

  template_name <- paste0(chapter, "-wkbk.qmd")

  # Find template in installed package
  template_path <- system.file(
    "templates", template_name,
    package = "eda4mlr",
    mustWork = FALSE
  )

  if (template_path == "") {
    available <- list_workbooks()
    stop(
      "Template '", chapter, "' not found.\n",
      "Available workbooks: ", paste(available, collapse = ", "),
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
  file.copy(template_path, dest_path, overwrite = overwrite)

  message("Created: ", dest_path)
  message("Open in RStudio and begin working through the exercises.")

  invisible(dest_path)
}


#' List available workbooks
#'
#' Shows all workbook templates available in the eda4mlr package.
#'
#' @return Character vector of chapter identifiers (without the -wkbk.qmd suffix).
#'
#' @examples
#' list_workbooks()
#'
#' @export
list_workbooks <- function() {

  template_dir <- system.file("templates", package = "eda4mlr")

  if (template_dir == "") {
    return(character(0))
  }

  files <- list.files(template_dir, pattern = "-wkbk\\.qmd$")

  # Strip suffix to get chapter identifiers
  sub("-wkbk\\.qmd$", "", files)
}
