# data-raw/sync_positron_files.R
#
# Copies EDA Companion agent and instruction files from the
# eda4ml-positron repo into inst/positron/ for package distribution.
#
# Run this script after updating files in eda4ml-positron, then
# rebuild the package.
#
# Prerequisites:
#   - eda4ml-positron repo cloned as a sibling of eda4mlr
#     (i.e., both under the same parent directory)
#
# Usage:
#   source("data-raw/sync_positron_files.R")

# --- Locate source repo ----------------------------------------------------

# Try sibling directory first, then fall back to explicit path
pkg_root <- here::here()
parent_dir <- dirname(pkg_root)
positron_repo <- file.path(parent_dir, "eda4ml-positron")

if (!dir.exists(positron_repo)) {
  stop(
    "Cannot find eda4ml-positron repo.\n",
    "Expected at: ", positron_repo, "\n",
    "Clone it as a sibling of eda4mlr, or edit this script."
  )
}

cat("Source repo:", positron_repo, "\n")


# --- Define source and destination paths -----------------------------------

src_agent <- file.path(positron_repo, "ec-resources",
                       "eda-companion.agent.md")
src_instructions <- file.path(positron_repo, "ch-instructions")

dest_agents <- file.path(pkg_root, "inst", "positron", "agents")
dest_instructions <- file.path(pkg_root, "inst", "positron", "instructions")


# --- Validate sources exist ------------------------------------------------

if (!file.exists(src_agent)) {
  stop("Agent file not found: ", src_agent)
}

if (!dir.exists(src_instructions)) {
  stop("Instructions directory not found: ", src_instructions)
}


# --- Create destination directories ----------------------------------------

dir.create(dest_agents, recursive = TRUE, showWarnings = FALSE)
dir.create(dest_instructions, recursive = TRUE, showWarnings = FALSE)


# --- Copy agent file -------------------------------------------------------

file.copy(src_agent, file.path(dest_agents, "eda-companion.agent.md"),
          overwrite = TRUE)
cat("Copied: eda-companion.agent.md\n")


# --- Copy instruction files ------------------------------------------------

instr_files <- list.files(src_instructions,
                          pattern = "^ch\\d{2}\\.instructions\\.md$",
                          full.names = TRUE)

if (length(instr_files) == 0) {
  warning("No chapter instruction files found in: ", src_instructions)
}

for (f in instr_files) {
  file.copy(f, file.path(dest_instructions, basename(f)), overwrite = TRUE)
  cat("Copied:", basename(f), "\n")
}


# --- Summary ---------------------------------------------------------------

cat("\n")
cat("Synced", length(instr_files), "instruction files and 1 agent file.\n")
cat("Destination: inst/positron/\n")
cat("\n")
cat("Next steps:\n")
cat("  1. Review changes with: git diff inst/positron/\n")
cat("  2. Rebuild package: devtools::document(); devtools::install()\n")
