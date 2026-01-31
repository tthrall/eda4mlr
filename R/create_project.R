#' Create a Student Project for EDA for Machine Learning
#'
#' Scaffolds a complete student workspace with chapter folders,
#' workbook templates, and companion logs for documenting interactions
#' with the EDA Companion.
#'
#' @param path Character. Path where the project should be created.
#' @param student_name Character. Student's name for the portfolio index.
#'   Defaults to "Student Name".
#' @param chapters Integer vector. Which chapters to include. Defaults to 1:5.
#' @param open Logical. Whether to open the new project in RStudio. Defaults to TRUE.
#'
#' @return Invisibly returns the path to the created project.
#'
#' @examples
#' \dontrun{
#' # Create project with default chapters (1:5)
#' eda4mlr::create_project("~/eda4ml-portfolio", student_name = "Jane Doe")
#'
#' # Create project with all chapters
#' eda4mlr::create_project("~/eda4ml-portfolio", chapters = 1:15)
#' }
#'
#' @export
create_project <- function(path,
                           student_name = "Student Name",
                           chapters = 1:5,
                           open = TRUE) {


  # Chapter metadata

  chapter_info <- list(
    list(num = 1,  slug = "eda",              title = "Exploratory Data Analysis"),
    list(num = 2,  slug = "conditioning",     title = "Conditional Distributions"),
    list(num = 3,  slug = "clustering",       title = "Clustering"),
    list(num = 4,  slug = "simulation",       title = "Statistical Simulation"),
    list(num = 5,  slug = "study-design",     title = "Sampling and Study Design"),
    list(num = 6,  slug = "information",      title = "Information Theory"),
    list(num = 7,  slug = "regression",       title = "Linear Regression"),
    list(num = 8,  slug = "pca",              title = "Principal Component Analysis"),
    list(num = 9,  slug = "lda",              title = "Linear Discriminant Analysis"),
    list(num = 10, slug = "text",             title = "Text as Data"),
    list(num = 11, slug = "topics",           title = "Topic Models"),
    list(num = 12, slug = "timeseries-intro", title = "Time Series Data"),
    list(num = 13, slug = "timeseries-time",  title = "Time Domain Methods"),
    list(num = 14, slug = "timeseries-freq",  title = "Frequency Domain Methods"),
    list(num = 15, slug = "graphs",           title = "Graph Theory for Machine Learning")
  )


  # Validate chapters

  valid_chapters <- 1:15

  if (!all(chapters %in% valid_chapters)) {
    stop("chapters must be integers between 1 and 15")
  }


  # Create base directory

  if (dir.exists(path)) {
    stop("Directory already exists: ", path)
  }
  dir.create(path, recursive = TRUE)


  # Get project name from path

  project_name <- basename(path)


  # Create .Rproj file
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

  # Create _quarto.yml
  quarto_yml <- c(
    "project:",
    "  type: book",
    "  output-dir: _book",
    "",
    "book:",
    paste0("  title: \"EDA for ML Portfolio: ", student_name, "\""),
    "  author: \"", student_name, "\"",
    "  date: today",
    "  chapters:",
    "    - index.qmd"
  )


  # Add chapter files to quarto.yml

  for (ch in chapter_info[chapters]) {
    ch_num <- sprintf("%02d", ch$num)
    quarto_yml <- c(
      quarto_yml,
      paste0("    - ch", ch_num, "-", ch$slug, "/ch", ch_num, "-work.qmd")
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

  # Create index.qmd
  index_qmd <- c(
    "---",
    paste0("title: \"EDA for ML Portfolio\""),
    paste0("author: \"", student_name, "\""),
    "date: today",
    "---",
    "",
    "## About This Portfolio",
    "",
    "This portfolio documents my work through *Exploratory Data Analysis for Machine Learning*.",
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

  for (ch in chapter_info[chapters]) {
    index_qmd <- c(
      index_qmd,
      paste0("| ", ch$num, " | ", ch$title, " | Not started |")
    )
  }

  writeLines(index_qmd, file.path(path, "index.qmd"))

  # Create chapter folders and files
  for (ch in chapter_info[chapters]) {
    ch_num <- sprintf("%02d", ch$num)
    ch_dir <- file.path(path, paste0("ch", ch_num, "-", ch$slug))
    dir.create(ch_dir)

    # Work file
    work_qmd <- c(
      "---",
      paste0("title: \"Chapter ", ch$num, ": ", ch$title, "\""),
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
      paste0("title: \"Chapter ", ch$num, " Companion Log\""),
      paste0("author: \"", student_name, "\""),
      "date: today",
      "format:",
      "  html:",
      "    toc: true",
      "---",
      "",
      "## About This Log",
      "",
      "This document records my interactions with the EDA Companion while working",
      "through Chapter ", ch$num, ". Each session captures the context, conversation,",
      "and what I learned.",
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
    writeLines(companion_qmd, file.path(ch_dir, paste0("ch", ch_num, "-companion.qmd")))
  }

  message("Created EDA for ML portfolio at: ", path)
  message("Chapters included: ", paste(chapters, collapse = ", "))

  # Open in RStudio if requested
  if (open && rstudioapi::isAvailable()) {
    rstudioapi::openProject(file.path(path, paste0(project_name, ".Rproj")))
  }

  invisible(path)
}
