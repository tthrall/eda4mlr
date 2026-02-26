#' Add Positron EDA Companion Configuration to a Project
#'
#' Installs the EDA Companion agent file, per-chapter instruction files,
#' and a learner profile template into an existing student project. This
#' is called automatically by \code{create_project()} when
#' \code{positron = TRUE}, but can also be used standalone to add
#' Positron support to a project created earlier.
#'
#' @param path Character. Path to the project root (the directory
#'   containing the `.Rproj` file).
#' @param student_name Character. Student's name, used in the learner
#'   profile template. Defaults to "Student Name".
#' @param overwrite Logical. If \code{TRUE}, overwrite existing Positron
#'   configuration files. Defaults to \code{FALSE}.
#' @param quiet Logical. If \code{TRUE}, suppress informational messages.
#'   Defaults to \code{FALSE}.
#'
#' @return Invisibly returns the path to the `.vscode/positron` directory.
#'
#' @details
#' This function creates the following structure inside \code{path}:
#'
#' \preformatted{
#' .vscode/positron/
#'   agents/
#'     eda-companion.agent.md
#'   instructions/
#'     ch01.instructions.md
#'     ...
#'     ch15.instructions.md
#'     learner-profile.instructions.md
#' }
#'
#' All 15 chapter instruction files are installed regardless of which
#' chapter folders exist in the project, so students can progress beyond
#' their initial chapter selection without reconfiguring.
#'
#' The learner profile is a template with placeholders. Students should
#' edit it to describe their background and goals before their first
#' Companion session.
#'
#' @examples
#' \dontrun{
#' # Add Positron support to an existing project
#' eda4mlr::setup_positron("~/eda4ml-portfolio", student_name = "Jane Doe")
#'
#' # Overwrite existing configuration (e.g., after a package update)
#' eda4mlr::setup_positron("~/eda4ml-portfolio", overwrite = TRUE)
#' }
#'
#' @seealso [create_project()] which calls this function when
#'   \code{positron = TRUE}.
#'
#' @export
setup_positron <- function(path,
                           student_name = "Student Name",
                           overwrite = FALSE,
                           quiet = FALSE) {

  # --- Validate path -------------------------------------------------------

  if (!dir.exists(path)) {
    stop("Directory does not exist: ", path, call. = FALSE)
  }

  positron_dir <- file.path(path, ".vscode", "positron")
  agents_dir   <- file.path(positron_dir, "agents")
  instr_dir    <- file.path(positron_dir, "instructions")


  # --- Check for existing configuration ------------------------------------

  if (dir.exists(positron_dir) && !overwrite) {
    existing <- list.files(positron_dir, recursive = TRUE)
    if (length(existing) > 0) {
      stop(
        "Positron configuration already exists at: ", positron_dir, "\n",
        "Use overwrite = TRUE to replace existing files.",
        call. = FALSE
      )
    }
  }


  # --- Create directories --------------------------------------------------

  dir.create(agents_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(instr_dir,  recursive = TRUE, showWarnings = FALSE)


  # --- Install agent file --------------------------------------------------

  agent_src <- system.file(
    "positron", "agents", "eda-companion.agent.md",
    package = "eda4mlr",
    mustWork = FALSE
  )

  if (agent_src == "") {
    stop(
      "EDA Companion agent file not found in eda4mlr package.\n",
      "You may need to update: pak::pak(\"tthrall/eda4mlr\")",
      call. = FALSE
    )
  }

  file.copy(agent_src, file.path(agents_dir, "eda-companion.agent.md"),
            overwrite = overwrite)


  # --- Install chapter instruction files -----------------------------------

  instr_src_dir <- system.file(
    "positron", "instructions",
    package = "eda4mlr",
    mustWork = FALSE
  )

  if (instr_src_dir == "") {
    stop(
      "Instruction files not found in eda4mlr package.\n",
      "You may need to update: pak::pak(\"tthrall/eda4mlr\")",
      call. = FALSE
    )
  }

  instr_files <- list.files(
    instr_src_dir,
    pattern = "^ch\\d{2}\\.instructions\\.md$",
    full.names = TRUE
  )

  if (length(instr_files) == 0) {
    warning("No chapter instruction files found in package.", call. = FALSE)
  }

  for (f in instr_files) {
    file.copy(f, file.path(instr_dir, basename(f)), overwrite = overwrite)
  }


  # --- Generate learner profile from template ------------------------------

  profile_dest <- file.path(instr_dir, "learner-profile.instructions.md")

  # Only generate if it doesn't exist or overwrite is TRUE.
  # The profile is personal; we don't want to clobber a student's edits
  # unless they explicitly ask.
  if (!file.exists(profile_dest) || overwrite) {
    profile_lines <- c(
      "---",
      "name: \"Learner Profile\"",
      "description: \"Background and learning context for the EDA Companion\"",
      "applyTo: \"**/*\"",
      "---",
      "",
      "# About Me",
      "",
      paste0("My name is ", student_name, "."),
      "",
      "<!-- Edit this file to describe your background and goals.",
      "     The EDA Companion reads this to calibrate its questions",
      "     to your experience level. Be honest about what you know",
      "     and don't know; there are no wrong answers here. -->",
      "",
      "## Academic Background",
      "",
      "<!-- What have you studied? What degrees or courses are relevant? -->",
      "",
      "## Programming Experience",
      "",
      "<!-- How comfortable are you with R? Python? Have you used",
      "     tidyverse, ggplot2, or other data analysis tools? -->",
      "",
      "## Data Experience",
      "",
      "<!-- Have you worked with real data before? In what context?",
      "     What's the biggest dataset you've explored? -->",
      "",
      "## Goals",
      "",
      "<!-- What are you hoping to get out of this textbook?",
      "     Are you preparing for a specific role or course? -->",
      "",
      "## Learning Context",
      "",
      "<!-- Are you working through this book independently or as part",
      "     of a course? What chapter are you starting with? -->"
    )
    writeLines(profile_lines, profile_dest)
  }


  # --- Report --------------------------------------------------------------

  if (!quiet) {
    n_instr <- length(instr_files)
    message("Positron EDA Companion configured at: ", positron_dir)
    message("  Agent file:        agents/eda-companion.agent.md")
    message("  Instruction files: ", n_instr, " chapter files installed")
    message("  Learner profile:   instructions/learner-profile.instructions.md")
    message("")
    message(
      "Next step: edit the learner profile to describe your background\n",
      "and goals before your first Companion session."
    )
  }

  invisible(positron_dir)
}
