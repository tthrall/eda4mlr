#' Set up the EDA Companion on Posit Assistant
#'
#' Installs the EDA Companion's Posit Assistant configuration into a
#' workspace: an `AGENTS.md` assembled from the packaged spec template
#' with the learner's profile inlined, the permission and model
#' settings at `.posit/assistant/settings.json`, and every chapter
#' skill under `.posit/assistant/skills/`.
#'
#' Successor to [setup_positron()], which configured the deprecated
#' Positron Assistant stack and is retained only for the transition.
#'
#' The spec text deploys byte-identical across learners; only the
#' Student Profile section differs. That property is what keeps
#' cross-learner behavioral comparisons attributable, and this
#' function's template mechanism enforces it.
#'
#' @param path Path to the workspace root (the project folder
#'   containing the chapter directories).
#' @param profile The learner's profile: either a path to a profile
#'   `.md` file (for example one kept under
#'   `eda4ml-positron/ec-resources/profiles/`) or a character vector
#'   of profile text. A leading HTML comment block (provenance notes
#'   in the canonical profile files) is stripped before inlining. If
#'   omitted, the packaged blank profile form is used, personalized
#'   with `student_name` when supplied; the student is then expected
#'   to complete the Student Profile section of `AGENTS.md`.
#' @param student_name Optional convenience when `profile` is not
#'   supplied: replaces the form's name placeholder so the generated
#'   profile opens "My name is <student_name>."
#' @param overwrite Logical; overwrite an existing `AGENTS.md` or
#'   `settings.json`? Defaults to `FALSE`, refusing to clobber files a
#'   student may have edited (the Student Profile section of
#'   `AGENTS.md` is theirs to adjust). Skills are always refreshed:
#'   they are canonical content, not student-edited.
#' @param quiet Logical; suppress progress messages?
#'
#' @return Invisibly, a character vector of the paths written.
#'
#' @examples
#' \dontrun{
#' # A named learner with a canonical profile file:
#' setup_posit_assistant(
#'   path = "~/eda4ml-aaron",
#'   profile = "~/GitHub/eda4ml-positron/ec-resources/profiles/aaron.md"
#' )
#'
#' # A fresh student, profile to be completed in AGENTS.md:
#' setup_posit_assistant(path = "~/eda4ml-sam", student_name = "Sam")
#' }
#'
#' @export
setup_posit_assistant <- function(path,
                                  profile = NULL,
                                  student_name = NULL,
                                  overwrite = FALSE,
                                  quiet = FALSE) {

  say <- function(...) if (!quiet) cat(..., "\n", sep = "")

  if (!dir.exists(path)) {
    stop("Workspace path does not exist: ", path)
  }

  # --- Locate packaged resources -------------------------------------------

  res_root <- system.file("posit-assistant", package = "eda4mlr")
  if (identical(res_root, "")) {
    stop(
      "Packaged Posit Assistant resources not found.\n",
      "Run data-raw/sync_assistant_files.R and rebuild the package."
    )
  }
  template_path <- file.path(res_root, "AGENTS-template.md")
  settings_path <- file.path(res_root, "settings.json")
  form_path     <- file.path(res_root, "profile-template.md")
  skills_root   <- file.path(res_root, "skills")

  for (p in c(template_path, settings_path, form_path)) {
    if (!file.exists(p)) stop("Packaged resource missing: ", p)
  }

  # --- Resolve the profile text --------------------------------------------

  profile_source <- NULL
  if (is.null(profile)) {
    profile_lines <- readLines(form_path, warn = FALSE)
    profile_source <- "packaged blank form"
    if (!is.null(student_name)) {
      profile_lines <- sub("<your name>", student_name, profile_lines,
                           fixed = TRUE)
      profile_source <- paste0("packaged blank form (name: ",
                               student_name, ")")
    }
  } else if (length(profile) == 1 && file.exists(profile)) {
    profile_lines <- readLines(profile, warn = FALSE)
    profile_source <- basename(profile)
  } else {
    profile_lines <- unlist(strsplit(as.character(profile), "\n",
                                     fixed = TRUE))
    profile_source <- "supplied text"
  }

  # Strip a single leading HTML comment block (canonical profiles carry
  # provenance comments that should not deploy).
  txt <- paste(profile_lines, collapse = "\n")
  txt <- sub("^\\s*<!--.*?-->\\s*", "", txt)
  profile_body <- trimws(txt)

  if (!nzchar(profile_body)) {
    stop("Resolved profile text is empty; check the profile argument.")
  }

  # --- Assemble AGENTS.md ---------------------------------------------------

  template <- paste(readLines(template_path, warn = FALSE), collapse = "\n")

  # The placeholder is replaced only where it stands alone on its own
  # line (the Student Profile section); prose that merely mentions the
  # token is left untouched. It must appear exactly once.
  placeholder_line <- "(?m)^\\{\\{LEARNER_PROFILE\\}\\}$"
  n_found <- length(gregexpr(placeholder_line, template,
                             perl = TRUE)[[1]])
  if (!grepl(placeholder_line, template, perl = TRUE) || n_found != 1) {
    stop("Packaged AGENTS-template.md must contain the learner-profile ",
         "placeholder exactly once, alone on its own line; found ",
         if (grepl(placeholder_line, template, perl = TRUE)) n_found else 0,
         ". Re-run the sync script.")
  }

  provenance <- paste0(
    "<!-- Generated ", format(Sys.Date()),
    " by eda4mlr::setup_posit_assistant(); profile source: ",
    profile_source, ". -->\n"
  )
  agents_text <- paste0(
    provenance,
    sub(placeholder_line, profile_body, template, perl = TRUE)
  )

  if (grepl("\\{\\{LEARNER_PROFILE\\}\\}", agents_text)) {
    stop("Internal error: a learner-profile placeholder survived ",
         "assembly; the generated AGENTS.md would be malformed.")
  }
  if (!endsWith(agents_text, "\n")) {
    agents_text <- paste0(agents_text, "\n")
  }

  written <- character(0)

  agents_dest <- file.path(path, "AGENTS.md")
  if (file.exists(agents_dest) && !overwrite) {
    stop(
      "AGENTS.md already exists at ", agents_dest, ".\n",
      "It may carry student edits (the Student Profile section is ",
      "theirs to adjust). Use overwrite = TRUE to replace it."
    )
  }
  writeLines(agents_text, agents_dest, sep = "")
  written <- c(written, agents_dest)
  say("Wrote: AGENTS.md (profile source: ", profile_source, ")")

  # --- settings.json --------------------------------------------------------

  assistant_dir <- file.path(path, ".posit", "assistant")
  dir.create(assistant_dir, recursive = TRUE, showWarnings = FALSE)

  settings_dest <- file.path(assistant_dir, "settings.json")
  if (file.exists(settings_dest) && !overwrite) {
    say("Kept existing settings.json (use overwrite = TRUE to replace).")
  } else {
    file.copy(settings_path, settings_dest, overwrite = TRUE)
    written <- c(written, settings_dest)
    say("Wrote: .posit/assistant/settings.json")
  }

  # --- Skills ---------------------------------------------------------------

  skill_dirs <- list.dirs(skills_root, recursive = FALSE)
  skill_dirs <- skill_dirs[grepl("^ch\\d{2}-", basename(skill_dirs))]
  if (length(skill_dirs) == 0) {
    stop("No packaged skills found under: ", skills_root)
  }

  dest_skills <- file.path(assistant_dir, "skills")
  for (d in skill_dirs) {
    dd <- file.path(dest_skills, basename(d))
    dir.create(dd, recursive = TRUE, showWarnings = FALSE)
    file.copy(file.path(d, "SKILL.md"), file.path(dd, "SKILL.md"),
              overwrite = TRUE)
    written <- c(written, file.path(dd, "SKILL.md"))
  }
  say("Wrote: ", length(skill_dirs),
      " chapter skills under .posit/assistant/skills/")

  # --- Closing guidance -----------------------------------------------------

  say("")
  say("Posit Assistant configuration installed.")
  say("Open the folder fresh in Positron and trust the workspace when")
  say("prompted; then ask the assistant 'With whom am I speaking?' to")
  say("confirm the EDA Companion loaded.")
  if (grepl("blank form", profile_source, fixed = TRUE)) {
    say("The Student Profile section of AGENTS.md is a form to complete:")
    say("edit it directly so the Companion can calibrate to you.")
  }

  invisible(written)
}
