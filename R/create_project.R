#' Create a Student Project for EDA for Machine Learning
#'
#' Scaffolds a complete student workspace with chapter folders,
#' minimal workbook files, and (optionally) Positron IDE
#' configuration for the EDA Companion agent.
#'
#' @param path Character. Path where the project should be created.
#' @param student_name Character. Student's name for the portfolio index.
#'   Defaults to "Student Name".
#' @param chapters Integer vector. Which chapters to include. Defaults to 1:17.
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
#'   \item Chapter folders, each containing a minimal `chNN-work.qmd`
#'     for the student's notes and code, and an empty
#'     `chNN-agent-transcript.md` for recording Companion conversations
#'   \item A portfolio `index.qmd` with progress tracking
#'   \item A `.gitignore` configured for R/Quarto projects
#'   \item An `.Rprofile` that sets a CRAN mirror for Quarto rendering
#'   \item A `README.md` describing the portfolio (suitable for GitHub)
#' }
#'
#' When \code{positron = TRUE}, the project additionally includes:
#' \itemize{
#'   \item `.vscode/positron/agents/eda-companion.agent.md`: the EDA
#'     Companion agent configuration
#'   \item `.vscode/positron/instructions/chNN.instructions.md`: per-chapter
#'     content knowledge files (all 17 chapters, regardless of \code{chapters})
#'   \item `.vscode/positron/instructions/learner-profile.instructions.md`:
#'     a template for the student to describe their background and goals
#' }
#'
#' Chapter metadata (number, slug, title, has_slides) is read from
#' \code{inst/templates/book-chapters.txt}, the single source of truth
#' for chapter organization across the eda4ml ecosystem. Per-chapter
#' package lists (chapter-specific extras beyond the four core packages
#' \code{eda4mlr}, \code{here}, \code{knitr}, \code{tidyverse}) are read
#' from \code{inst/templates/chpt-packages.txt}, which is regenerated
#' from the source eda4ml book repo by
#' \code{data-raw/regenerate-packages.R}.
#'
#' @examples
#' \dontrun{
#' # Create project with default chapters (1:17) and Positron support
#' eda4mlr::create_project("~/eda4ml-portfolio", student_name = "Jane Doe")
#'
#' # Create project with just chapters 1:5, no Positron
#' eda4mlr::create_project("~/eda4ml-portfolio",
#'                         student_name = "Jane Doe",
#'                         chapters = 1:5,
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
                           chapters = 1:17,
                           positron = TRUE,
                           open = TRUE) {


  # --- Chapter metadata (from registry) ------------------------------------

  chapter_registry <- get_chapter_registry()


  # --- Per-chapter additional packages (from registry) ---------------------

  chpt_packages_path <- system.file(
    "templates", "chpt-packages.txt",
    package = "eda4mlr"
  )
  if (chpt_packages_path == "") {
    stop(
      "Chapter packages file not found. ",
      "Ensure inst/templates/chpt-packages.txt exists in the package.",
      call. = FALSE
    )
  }
  chpt_packages <- utils::read.delim(
    chpt_packages_path, stringsAsFactors = FALSE
  )
  chpt_packages$chapter <- as.integer(chpt_packages$chapter)


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


  # --- .Rprofile -----------------------------------------------------------

  rprofile_lines <- c(
    "# Set CRAN mirror for Quarto rendering",
    "# (Quarto starts a fresh R session that does not inherit the",
    "# mirror setting from the interactive console.)",
    'options(repos = c(CRAN = "https://cran.rstudio.com/"))'
  )
  writeLines(rprofile_lines, file.path(path, ".Rprofile"))


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
    "for Machine Learning* by Tony Thrall. Each chapter folder contains",
    "my notes, code, and developing understanding of the material. The",
    "guiding question for each chapter is: *How would you teach this?*",
    "",
    "The portfolio is structured as a Quarto book that can be rendered to",
    "HTML for sharing with instructors, collaborators, or prospective",
    "employers.",
    "",
    "## Structure",
    "",
    "Each chapter folder contains:",
    "",
    "- `chNN-work.qmd`: Your notes, code, and analysis. This is your",
    "  primary artifact. Use it however serves your learning best.",
    "- `chNN-agent-transcript.md`: A place to record your conversations",
    "  with the EDA Companion.",
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
    "- `chXX-work.qmd`: My notes, code, and analysis",
    "- `chXX-agent-transcript.md`: Record of my EDA Companion conversations",
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

    # Work file: minimal YAML + library loads + framing
    slide_link <- if (isTRUE(selected$has_slides[i])) {
      paste0("[Slides](https://tthrall.quarto.pub/",
             "eda-for-machine-learning-slides/", slug, "-slides.html)")
    } else {
      "Slides: not available"
    }

    # Additional Packages section: chapter-specific packages,
    # or fallback note if the chapter uses only core packages
    chapter_extras <- chpt_packages$pkg[
      chpt_packages$chapter == selected$chapter[i]
    ]
    if (length(chapter_extras) == 0) {
      additional_pkgs_lines <- c(
        "## Additional Packages",
        "",
        "*This chapter uses only the core packages.*",
        ""
      )
    } else {
      additional_pkgs_lines <- c("## Additional Packages", "")
      for (pkg in chapter_extras) {
        additional_pkgs_lines <- c(
          additional_pkgs_lines,
          "```{r}",
          paste0("#| label: ", pkg, "-package"),
          paste0('if (!requireNamespace("', pkg, '", quietly = TRUE)) {'),
          paste0('  install.packages("', pkg, '")'),
          "}",
          paste0("library(", pkg, ")"),
          "```",
          ""
        )
      }
    }

    work_qmd <- c(
      "---",
      paste0('title: "Chapter ', selected$chapter[i], ": ", title, '"'),
      paste0('author: "', student_name, '"'),
      "date: today",
      "format:",
      "  html:",
      "    toc: true",
      "    toc-depth: 4",
      "    code-fold: true",
      "---",
      "",
      "```{r}",
      "#| label: setup",
      "#| message: false",
      paste0("library(", get_core_packages(), ")"),
      "```",
      "",
      additional_pkgs_lines,
      paste0("## Links to Chapter ", selected$chapter[i], ", ", title),
      "",
      paste0("- ", slide_link),
      paste0("- [Chapter](https://tthrall.github.io/eda4ml/",
             slug, ".html)"),
      "",
      "<!-- This file is yours. Use it to record your notes, code, and",
      "     developing understanding of this chapter. A guiding question:",
      "     How would you teach what you've learned here? -->"
    )
    writeLines(work_qmd,
               file.path(ch_dir, paste0("ch", ch_num, "-work.qmd")))

    # Agent transcript: empty file for recording Companion conversations
    transcript_lines <- c(
      paste0("# Chapter ", selected$chapter[i], ": ", title),
      paste0("## EDA Companion Transcript"),
      "",
      "<!-- Use this file to record conversations with the",
      "     EDA Companion. -->"
    )
    writeLines(transcript_lines,
               file.path(ch_dir, paste0("ch", ch_num,
                                        "-agent-transcript.md")))
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
#' @return A data frame with columns:
#'   \code{chapter} (integer),
#'   \code{slug} (character),
#'   \code{title} (character),
#'   \code{has_slides} (logical).
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
  expected <- c("chapter", "slug", "title", "has_slides")
  if (!all(expected %in% names(registry))) {
    stop(
      "Chapter registry must contain columns: ",
      paste(expected, collapse = ", "),
      call. = FALSE
    )
  }

  registry$chapter <- as.integer(registry$chapter)
  registry$has_slides <- as.logical(registry$has_slides)
  registry <- registry[order(registry$chapter), ]

  registry
}
