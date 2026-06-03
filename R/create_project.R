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
#'     for the student's notes and code, an empty
#'     `chNN-agent-transcript.md` for recording Companion conversations,
#'     and a `chNN-summary.qmd` for summarizing the student's learning
#'   \item A portfolio `index.qmd` with progress tracking
#'   \item A `course-summary.qmd` for cross-chapter synthesis
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
#' for chapter organization across the eda4ml ecosystem. Each chapter's
#' full package list is read from
#' \code{inst/templates/packages_per_chapter_tbl.txt} and emitted as bare
#' \code{library()} calls in the work file's \code{CRAN-libraries} chunk
#' (the book pattern: no universal-versus-chapter-specific split). The
#' table is regenerated from the source eda4ml repo by
#' \code{data-raw/regenerate-packages.R}. The chapter and course summary
#' stubs are produced by filling the bundled templates
#' \code{ch-NN-summary-template.qmd} and \code{course-summary-template.qmd}.
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

  pkg_tbl_path <- system.file(
    "templates", "packages_per_chapter_tbl.txt",
    package = "eda4mlr"
  )
  if (pkg_tbl_path == "") {
    stop(
      "Package table not found. ",
      "Ensure inst/templates/packages_per_chapter_tbl.txt exists in the package.",
      call. = FALSE
    )
  }
  pkg_tbl <- utils::read.delim(
    pkg_tbl_path, stringsAsFactors = FALSE
  )
  pkg_tbl$chpt <- as.integer(pkg_tbl$chpt)


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
      paste0("    - ch", ch_num, "-", slug, "/ch", ch_num, "-work.qmd"),
      paste0("    - ch", ch_num, "-", slug, "/ch", ch_num, "-summary.qmd")
    )
  }

  quarto_yml <- c(
    quarto_yml,
    "    - course-summary.qmd"
  )

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
    "This student workspace is a Quarto project (Quarto categorizes it as",
    "a Quarto book) that renders to HTML for sharing with instructors,",
    "collaborators, or prospective employers.",
    "",
    "## Structure",
    "",
    "Each chapter folder contains:",
    "",
    "- `chNN-work.qmd`: Your notes, code, and analysis. This is your",
    "  primary artifact. Use it however serves your learning best.",
    "- `chNN-agent-transcript.md`: A place to record your conversations",
    "  with the EDA Companion.",
    "- `chNN-summary.qmd`: A place to summarize your learning for the",
    "  chapter.",
    "",
    "At the project root, `course-summary.qmd` is a place for",
    "cross-chapter synthesis as your understanding develops.",
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

  # Scope the setup install to this workspace's chapters (the bare union if
  # the workspace covers every chapter).
  if (setequal(selected$chapter, valid_chapters)) {
    install_call <- "eda4mlr::install_eda4ml_packages()"
  } else {
    install_call <- paste0(
      "eda4mlr::install_eda4ml_packages(chapters = c(",
      paste(sort(selected$chapter), collapse = ", "),
      "))"
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
    "Then install the CRAN packages the chapters in this workspace use.",
    "Doing this once at setup prevents the missing-package errors that bare",
    "library() calls raise when you render:",
    "",
    "```r",
    install_call,
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
    "- `chXX-summary.qmd`: My summary of the chapter",
    "",
    "At the project root, `course-summary.qmd` is for my cross-chapter",
    "synthesis.",
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


  # --- course-summary.qmd --------------------------------------------------

  course_template_path <- system.file(
    "templates", "course-summary-template.qmd",
    package = "eda4mlr"
  )
  if (course_template_path == "") {
    stop(
      "Course summary template not found. ",
      "Ensure inst/templates/course-summary-template.qmd exists in the package.",
      call. = FALSE
    )
  }
  course_summary_lines <- readLines(course_template_path, warn = FALSE)
  course_summary_lines <- sub(
    "Course Summary: <course title>",
    "Course Summary: Exploratory Data Analysis for Machine Learning",
    course_summary_lines, fixed = TRUE
  )
  course_summary_lines <- gsub(
    "<your name>", student_name, course_summary_lines, fixed = TRUE
  )
  writeLines(course_summary_lines, file.path(path, "course-summary.qmd"))


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

    # Book-pattern preamble. The chapter's CRAN packages become bare
    # library() calls in a CRAN-libraries chunk, emitted verbatim from the
    # package table (already case-insensitively sorted there). A
    # conflicts-prefer chunk is scaffolded only where the chapter loads
    # conflicted; eda4mlr loads on its own in local-libraries.
    chapter_pkgs <- pkg_tbl$pkg[pkg_tbl$chpt == selected$chapter[i]]

    cran_chunk <- c(
      "```{r}",
      "#| label: CRAN-libraries",
      "#| message: false",
      "# If a library() call below fails with \"there is no package called ...\",",
      "# that package is not installed: run eda4mlr::install_eda4ml_packages()",
      "# (or install.packages(\"<pkg>\")) and then re-run this code chunk.",
      paste0("library(", chapter_pkgs, ")"),
      "```",
      ""
    )

    if ("conflicted" %in% chapter_pkgs) {
      conflicts_chunk <- c(
        "```{r}",
        "#| label: conflicts-prefer",
        "# Resolve package conflicts here, matching the book chapter, e.g.",
        "# conflicted::conflicts_prefer() or tidymodels::tidymodels_prefer().",
        "```",
        ""
      )
    } else {
      conflicts_chunk <- character(0)
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
      "    theme:",
      "      dark: darkly",
      "      light: cosmo",
      "    respect-user-color-scheme: true",
      "---",
      "",
      "```{r}",
      "#| label: setup",
      "#| include: false",
      "knitr::opts_chunk$set(echo = TRUE, error = TRUE, message = FALSE, warning = FALSE)",
      "```",
      "",
      cran_chunk,
      conflicts_chunk,
      "```{r}",
      "#| label: local-libraries",
      "#| message: false",
      "library(eda4mlr)",
      "```",
      "",
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

    # Summary file: read-and-fill the bundled chapter-summary template
    summary_template_path <- system.file(
      "templates", "ch-NN-summary-template.qmd",
      package = "eda4mlr"
    )
    if (summary_template_path == "") {
      stop(
        "Chapter summary template not found. ",
        "Ensure inst/templates/ch-NN-summary-template.qmd exists in the package.",
        call. = FALSE
      )
    }
    summary_lines <- readLines(summary_template_path, warn = FALSE)
    summary_lines <- sub(
      "Chapter NN Summary: <title>",
      paste0("Chapter ", selected$chapter[i], " Summary: ", title),
      summary_lines, fixed = TRUE
    )
    summary_lines <- gsub(
      "<your name>", student_name, summary_lines, fixed = TRUE
    )
    writeLines(summary_lines,
               file.path(ch_dir, paste0("ch", ch_num, "-summary.qmd")))
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
