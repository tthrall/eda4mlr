#' Create a Student Project for EDA for Machine Learning
#'
#' Scaffolds a complete student workspace with chapter folders,
#' workbook templates, companion logs, and (optionally) Positron IDE
#' configuration for the EDA Companion agent.
#'
#' @param path Character. Path where the project should be created.
#' @param student_name Character. Student's name for the portfolio index.
#'   Defaults to "Student Name".
#' @param chapters Integer vector. Which chapters to include. Defaults to 1:5.
#' @param positron Logical. Whether to include Positron IDE configuration
#'   for the EDA Companion agent. Defaults to TRUE.
#' @param open Logical. Whether to open the new project in RStudio/Positron.
#'   Defaults to TRUE.
#'
#' @return Invisibly returns the path to the created project.
#'
#' @details
#' The created project includes:
#' \itemize{
#'   \item An `.Rproj` file and `_quarto.yml` for a Quarto book project
#'   \item Chapter folders with work and companion log templates
#'   \item A portfolio `index.qmd` with progress tracking
#'   \item A `.gitignore` configured for R/Quarto projects
#'   \item A `README.md` describing the portfolio (suitable for GitHub)
#' }
#'
#' When \code{positron = TRUE}, the project additionally includes:
#' \itemize{
#'   \item `.vscode/positron/agents/eda-companion.agent.md`: the EDA
#'     Companion agent configuration
#'   \item `.vscode/positron/instructions/chNN.instructions.md`: per-chapter
#'     content knowledge files (all 15 chapters, regardless of \code{chapters})
#'   \item `.vscode/positron/instructions/learner-profile.instructions.md`:
#'     a template for the student to describe their background and goals
#' }
#'
#' Chapter metadata (numbers, slugs, titles) is read from the registry file
#' \code{inst/templates/book-chapters.txt}, which is the single source of
#' truth for chapter organization across the eda4ml ecosystem.
#'
#' @examples
#' \dontrun{
#' # Create project with default chapters (1-5) and Positron support
#' eda4mlr::create_project("~/eda4ml-portfolio", student_name = "Jane Doe")
#'
#' # Create project with all chapters, no Positron
#' eda4mlr::create_project("~/eda4ml-portfolio",
#'                         student_name = "Jane Doe",
#'                         chapters = 1:15,
#'                         positron = FALSE)
#'
#' # Add Positron support to an existing project later
#' eda4mlr::setup_positron("~/eda4ml-portfolio", student_name = "Jane Doe")
#' }
#'
#' @seealso [setup_positron()] to add Positron configuration to an existing
#'   project.
#'
#' @export
create_project <- function(path,
                           student_name = "Student Name",
                           chapters = 1:5,
                           positron = TRUE,
                           open = TRUE) {


  # --- Chapter metadata (from registry) ------------------------------------

  chapter_registry <- get_chapter_registry()


  # --- Validate inputs -----------------------------------------------------

  valid_chapters <- chapter_registry$chapter

  if (!all(chapters %in% valid_chapters)) {
    stop("chapters must be integers between 1 and ", max(valid_chapters))
  }

  if (dir.exists(path)) {
    stop("Directory already exists: ", path)
  }

  # Subset to requested chapters
  selected <- chapter_registry[chapter_registry$chapter %in% chapters, ]


  # --- Create base directory -----------------------------------------------

  dir.create(path, recursive = TRUE)
  project_name <- basename(path)


  # --- .gitignore ----------------------------------------------------------

  gitignore_lines <- c(
    "# R",
    ".Rproj.user",
    ".Rhistory",
    ".RData",
    ".Ruserdata",
    "",
    "# Quarto",
    "/.quarto/",
    "_book/",
    "*_cache/",
    "*_files/"
  )
  writeLines(gitignore_lines, file.path(path, ".gitignore"))


  # --- .Rproj file ---------------------------------------------------------

  rproj_content <- c(
    "Version: 1.0",
    "",
    "RestoreWorkspace: Default",
    "SaveWorkspace: Default",
    "AlwaysSaveHistory: Default",
    "",
    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: Yes",
    "NumSpacesForTab: 2",
    "Encoding: UTF-8",
    "",
    "RnwWeave: Sweave",
    "LaTeX: pdfLaTeX",
    "",
    "AutoAppendNewline: Yes",
    "StripTrailingWhitespace: Yes"
  )
  writeLines(rproj_content, file.path(path, paste0(project_name, ".Rproj")))


  # --- _quarto.yml ---------------------------------------------------------

  quarto_yml <- c(
    "project:",
    "  type: book",
    "  output-dir: _book",
    "",
    "book:",
    paste0("  title: \"EDA for ML Portfolio: ", student_name, "\""),
    paste0("  author: \"", student_name, "\""),
    "  date: today",
    "  chapters:",
    "    - index.qmd"
  )

  for (i in seq_len(nrow(selected))) {
    ch_num <- sprintf("%02d", selected$chapter[i])
    slug <- selected$slug[i]
    quarto_yml <- c(
      quarto_yml,
      paste0("    - ch", ch_num, "-", slug, "/ch", ch_num, "-work.qmd")
    )
  }

  quarto_yml <- c(
    quarto_yml,
    "",
    "format:",
    "  html:",
    "    theme: cosmo",
    "    code-fold: true",
    "    toc: true"
  )
  writeLines(quarto_yml, file.path(path, "_quarto.yml"))


  # --- README.md -----------------------------------------------------------

  readme_lines <- c(
    paste0("# ", project_name),
    "",
    paste0("**", student_name, "** | ",
           "[Exploratory Data Analysis for Machine Learning]",
           "(https://tthrall.github.io/eda4ml/)"),
    "",
    "## About This Portfolio",
    "",
    "This portfolio documents my work through *Exploratory Data Analysis",
    "for Machine Learning* by Tony Thrall. Each chapter folder contains my",
    "analysis code, written responses, and a log of my conversations with",
    "the EDA Companion, an AI-enhanced Socratic tutor designed to support",
    "independent reasoning rather than provide direct answers.",
    "",
    "The portfolio is structured as a Quarto book that can be rendered to",
    "HTML for sharing with instructors, collaborators, or prospective",
    "employers.",
    "",
    "## Structure",
    "",
    "Each chapter folder contains two files:",
    "",
    "- `chNN-work.qmd`: R code, analysis, and written responses to",
    "  exercises and discussion questions",
    "- `chNN-companion.qmd`: A log of interactions with the EDA Companion,",
    "  documenting the reasoning process and key insights",
    "",
    "## Chapters",
    "",
    "| Chapter | Topic | Status |",
    "|---------|-------|--------|"
  )

  for (i in seq_len(nrow(selected))) {
    readme_lines <- c(
      readme_lines,
      paste0("| ", selected$chapter[i], " | ", selected$title[i],
             " | Not started |")
    )
  }

  readme_lines <- c(
    readme_lines,
    "",
    "## Getting Started",
    "",
    "This project requires the",
    "[eda4mlr](https://github.com/tthrall/eda4mlr) R package:",
    "",
    "```r",
    "# install.packages(\"pak\")",
    "pak::pak(\"tthrall/eda4mlr\")",
    "```",
    "",
    "Open the `.Rproj` file in RStudio or Positron to begin."
  )

  if (positron) {
    readme_lines <- c(
      readme_lines,
      "",
      "## EDA Companion (Positron)",
      "",
      "This project includes configuration for the EDA Companion agent in",
      "[Positron IDE](https://positron.posit.co/). The Companion provides",
      "Socratic tutoring: it asks questions and challenges your reasoning",
      "rather than giving direct answers. To use it, open this project in",
      "Positron and start a conversation with the EDA Companion agent in",
      "the assistant panel.",
      "",
      "Before your first session, edit",
      "`.vscode/positron/instructions/learner-profile.instructions.md`",
      "to describe your background and goals. This helps the Companion",
      "calibrate its questions to your experience level."
    )
  }

  writeLines(readme_lines, file.path(path, "README.md"))


  # --- index.qmd -----------------------------------------------------------

  index_qmd <- c(
    "---",
    "title: \"EDA for ML Portfolio\"",
    paste0("author: \"", student_name, "\""),
    "date: today",
    "---",
    "",
    "## About This Portfolio",
    "",
    "This portfolio documents my work through *Exploratory Data Analysis",
    "for Machine Learning*.",
    "",
    "**Textbook:** <https://tthrall.github.io/eda4ml/>",
    "",
    "## Structure",
    "",
    "Each chapter folder contains:",
    "",
    "- `chXX-work.qmd`: My R code, analysis, and written responses",
    "- `chXX-companion.qmd`: Log of my interactions with the EDA Companion",
    "",
    "## Progress",
    "",
    "| Chapter | Topic | Status |",
    "|---------|-------|--------|"
  )

  for (i in seq_len(nrow(selected))) {
    index_qmd <- c(
      index_qmd,
      paste0("| ", selected$chapter[i], " | ", selected$title[i],
             " | Not started |")
    )
  }

  writeLines(index_qmd, file.path(path, "index.qmd"))


  # --- Chapter folders and files -------------------------------------------

  for (i in seq_len(nrow(selected))) {
    ch_num <- sprintf("%02d", selected$chapter[i])
    slug <- selected$slug[i]
    title <- selected$title[i]
    ch_dir <- file.path(path, paste0("ch", ch_num, "-", slug))
    dir.create(ch_dir)

    # Work file
    work_qmd <- c(
      "---",
      paste0("title: \"Chapter ", selected$chapter[i], ": ", title, "\""),
      paste0("author: \"", student_name, "\""),
      "date: today",
      "format:",
      "  html:",
      "    code-fold: true",
      "    toc: true",
      "---",
      "",
      "## Learning Objectives",
      "",
      "<!-- Review the chapter's learning objectives and note them here -->",
      "",
      "## Reading Notes",
      "",
      "<!-- Key concepts, questions, and observations from reading the chapter -->",
      "",
      "## Exercises",
      "",
      "### Exercise X.X",
      "",
      "```{r}",
      "# Your code here",
      "```",
      "",
      "<!-- Your interpretation and discussion -->",
      "",
      "## Reflection",
      "",
      "<!-- What did you learn? What remains unclear? -->"
    )
    writeLines(work_qmd, file.path(ch_dir, paste0("ch", ch_num, "-work.qmd")))

    # Companion log file
    companion_qmd <- c(
      "---",
      paste0("title: \"Chapter ", selected$chapter[i], " Companion Log\""),
      paste0("author: \"", student_name, "\""),
      "date: today",
      "format:",
      "  html:",
      "    toc: true",
      "---",
      "",
      "## About This Log",
      "",
      paste0(
        "This document records my interactions with the EDA Companion while ",
        "working through Chapter ", selected$chapter[i], ". Each session ",
        "captures the context, conversation, and what I learned."
      ),
      "",
      "---",
      "",
      "## Session: YYYY-MM-DD",
      "",
      "### Context",
      "",
      "<!-- What were you working on? What prompted you to consult the Companion? -->",
      "",
      "### Conversation",
      "",
      "<!-- Paste the relevant portion of your conversation with the Companion -->",
      "",
      "### What I Learned",
      "",
      "<!-- Summarize the key insight or resolution -->",
      "",
      "### Open Questions",
      "",
      "<!-- What remains unclear or needs further exploration? -->",
      "",
      "---",
      "",
      "<!-- Copy the session template above for additional sessions -->"
    )
    writeLines(companion_qmd,
               file.path(ch_dir, paste0("ch", ch_num, "-companion.qmd")))
  }


  # --- Positron scaffolding ------------------------------------------------

  if (positron) {
    setup_positron(path, student_name = student_name, quiet = TRUE)
  }


  # --- Done ----------------------------------------------------------------

  message("Created EDA for ML portfolio at: ", path)
  message("Chapters included: ", paste(chapters, collapse = ", "))

  if (positron) {
    message("Positron EDA Companion: configured")
    message(
      "  -> Edit .vscode/positron/instructions/learner-profile.instructions.md",
      "\n     to describe your background before your first Companion session."
    )
  }

  # Open in RStudio/Positron if requested
  if (open && requireNamespace("rstudioapi", quietly = TRUE)) {
    if (rstudioapi::isAvailable()) {
      rstudioapi::openProject(
        file.path(path, paste0(project_name, ".Rproj"))
      )
    }
  }

  invisible(path)
}


#' Read the chapter registry
#'
#' Returns the chapter metadata table from the package's authoritative
#' registry file. This is the single source of truth for chapter numbers,
#' slugs, and titles across the eda4ml ecosystem.
#'
#' @return A data frame with columns: \code{chapter} (integer),
#'   \code{slug} (character), \code{title} (character).
#'
#' @keywords internal
#'
#' @export
get_chapter_registry <- function() {

  registry_path <- system.file(
    "templates", "book-chapters.txt",
    package = "eda4mlr",
    mustWork = FALSE
  )

  if (registry_path == "") {
    stop(
      "Chapter registry file not found. ",
      "Ensure inst/templates/book-chapters.txt exists in the package.",
      call. = FALSE
    )
  }

  registry <- utils::read.delim(registry_path, stringsAsFactors = FALSE)

  # Validate expected columns
  expected <- c("chapter", "slug", "title")
  if (!all(expected %in% names(registry))) {
    stop(
      "Chapter registry must contain columns: ",
      paste(expected, collapse = ", "),
      call. = FALSE
    )
  }

  registry$chapter <- as.integer(registry$chapter)
  registry <- registry[order(registry$chapter), ]

  registry
}
