# data-raw/sync_assistant_files.R
#
# Copies EDA Companion Posit Assistant resources from the
# eda4ml-positron repo into inst/posit-assistant/ for package
# distribution: the AGENTS spec template, settings.json, the blank
# learner-profile form, and all chapter skills.
#
# Successor to sync_positron_files.R (old stack); keep both until the
# old assistant stack is removed from Positron (~August 2026), then
# retire the old script and inst/positron/.
#
# Personal learner profiles (ec-resources/profiles/<name>.md) are
# deliberately NOT distributed; they are supplied at generation time
# via setup_posit_assistant(profile = ...). Only the blank form
# (template.md) ships, supporting the student_name convenience path.
#
# Run this script after updating files in eda4ml-positron, then
# rebuild the package.
#
# Prerequisites:
#   - eda4ml-positron repo cloned as a sibling of eda4mlr
#     (i.e., both under the same parent directory)
#
# Usage:
#   source("data-raw/sync_assistant_files.R")

# --- Locate source repo ----------------------------------------------------

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

ec_resources <- file.path(positron_repo, "ec-resources")

src_template <- file.path(ec_resources, "spec", "AGENTS-template.md")
src_settings <- file.path(ec_resources, "settings.json")
src_profile_form <- file.path(ec_resources, "profiles", "template.md")
src_skills <- file.path(ec_resources, "skills")

dest_root <- file.path(pkg_root, "inst", "posit-assistant")
dest_skills <- file.path(dest_root, "skills")


# --- Validate sources exist and are well-formed ----------------------------

for (p in c(src_template, src_settings, src_profile_form)) {
  if (!file.exists(p)) stop("Source file not found: ", p)
}
if (!dir.exists(src_skills)) {
  stop("Skills directory not found: ", src_skills)
}

# The template must carry the learner-profile placeholder; its absence
# means a learner-specific AGENTS.md was placed in spec/ by mistake.
template_text <- readLines(src_template, warn = FALSE)
if (!any(grepl("{{LEARNER_PROFILE}}", template_text, fixed = TRUE))) {
  stop(
    "AGENTS-template.md lacks the {{LEARNER_PROFILE}} placeholder.\n",
    "Refusing to sync: spec/ may contain a learner-specific file."
  )
}

# Each skill directory must contain SKILL.md whose frontmatter name
# matches the directory (the loader requires this correspondence).
skill_dirs <- list.dirs(src_skills, recursive = FALSE)
skill_dirs <- skill_dirs[grepl("^ch\\d{2}-", basename(skill_dirs))]

if (length(skill_dirs) == 0) {
  stop("No chNN-<slug> skill directories found in: ", src_skills)
}

for (d in skill_dirs) {
  sf <- file.path(d, "SKILL.md")
  if (!file.exists(sf)) stop("Missing SKILL.md in: ", d)
  head_lines <- readLines(sf, n = 5, warn = FALSE)
  name_line <- grep("^name:", head_lines, value = TRUE)
  declared <- trimws(sub("^name:", "", name_line[1]))
  if (!identical(declared, basename(d))) {
    stop(
      "Skill name/directory mismatch in ", basename(d), ":\n",
      "  directory: ", basename(d), "\n",
      "  name:      ", declared
    )
  }
}


# --- Clean-sync the destination --------------------------------------------

# Remove the previous distribution copy entirely so renamed or retired
# skills leave no orphans (renames have happened; see the 2026-07-11
# slug alignment).
if (dir.exists(dest_root)) {
  unlink(dest_root, recursive = TRUE)
  cat("Removed previous inst/posit-assistant/ for a clean sync.\n")
}
dir.create(dest_skills, recursive = TRUE, showWarnings = FALSE)


# --- Copy files -------------------------------------------------------------

file.copy(src_template, file.path(dest_root, "AGENTS-template.md"),
          overwrite = TRUE)
cat("Copied: AGENTS-template.md\n")

file.copy(src_settings, file.path(dest_root, "settings.json"),
          overwrite = TRUE)
cat("Copied: settings.json\n")

file.copy(src_profile_form, file.path(dest_root, "profile-template.md"),
          overwrite = TRUE)
cat("Copied: profile-template.md (blank form only; personal profiles",
    "are never distributed)\n")

for (d in skill_dirs) {
  dd <- file.path(dest_skills, basename(d))
  dir.create(dd, recursive = TRUE, showWarnings = FALSE)
  file.copy(file.path(d, "SKILL.md"), file.path(dd, "SKILL.md"),
            overwrite = TRUE)
  cat("Copied skill:", basename(d), "\n")
}


# --- Summary ---------------------------------------------------------------

cat("\n")
cat("Synced", length(skill_dirs),
    "skills, the AGENTS template, settings.json, and the profile form.\n")
cat("Destination: inst/posit-assistant/\n")
cat("\n")
cat("Next steps:\n")
cat("  1. Review changes with: git diff inst/posit-assistant/\n")
cat("  2. Rebuild package: devtools::document(); devtools::install()\n")
