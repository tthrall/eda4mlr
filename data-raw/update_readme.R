##
# update_readme.R
#   Auto-generate README.md sections from metadata TSV files
##

# Read metadata files
tibbles <- readr::read_tsv(
  here::here("data-raw", "eda4ml_tibbles.txt"),
  show_col_types = FALSE
)

citations <- readr::read_tsv(
  here::here("data-raw", "eda4ml_tbl_citations.txt"),
  show_col_types = FALSE
)

# --- Generate table of data sets ---
datasets_table <- tibbles |>
  dplyr::arrange(tbl) |>
  dplyr::transmute(
    Dataset      = paste0("`", tbl, "`"),
    Observations = format(n_obs, big.mark = ","),
    Variables    = n_vars,
    Description  = dscr )

datasets_md <- datasets_table |>
  knitr::kable(
    format = "html",
    align  = "lrrl"
  )

# --- Generate data sources table ---
sources_table <- citations |>
  dplyr::transmute(
    Topic  = topic,
    Source = paste0("[", nm_src, "](", url_src, ")")
  )

sources_md <- sources_table |>
  knitr::kable(
    format = "markdown",
    align  = "ll" )

# --- Generate citations section ---
format_citation <- function(
    row # <chr>
) {
  parts <- c(row$citn_1, row$citn_2, row$citn_3, row$citn_4)
  parts <- parts[!is.na(parts) & parts != ""]

  # Join parts intelligently
  citation_text <- paste(parts, collapse = " ")

  glue::glue("**{row$topic}**
> {citation_text}

")
}

citations_md <- citations |>
  dplyr::rowwise() |>
  dplyr::group_split() |>
  lapply(format_citation) |>
  paste(collapse = "\n")

# --- Assemble README ---
readme_template <- glue::glue('
# eda4mldata

Companion R package for the textbook *Exploratory Data Analysis for Machine Learning* by Tony Thrall.
## Installation

You can install the development version of eda4mldata from GitHub:
```r
# install.packages("remotes")
remotes::install_github("tthrall/eda4mldata")
```

## Datasets

The package provides the following datasets:

{paste(datasets_md, collapse = "
")}

### Handedness Data

Handedness counts by sex from Freedman, Pisani & Purves (2007), used to illustrate chi-squared tests for independence.
```r
library(eda4mldata)
data(handedness)
handedness
#> # A tibble: 6 × 3
#>   sex    hnd   count
#>   <chr>  <chr> <int>
#> 1 male   right   934
#> 2 male   left    113
#> 3 male   ambi     20
#> 4 female right  1070
#> 5 female left     92
#> 6 female ambi      8
```

### MNIST Handwritten Digits

Sample images from the MNIST database of handwritten digits, useful for demonstrating image data and dimension reduction.
```r
data(mnist_example)
data(mnist_train)
data(mnist_test)

# mnist_example contains one image per digit (0-9)
# mnist_train and mnist_test contain 1000 images each
dim(mnist_train)
#> [1] 1000    5
```

### OECD Better Life Index

Well-being indicators for 36 countries across 11 dimensions (housing, income, jobs, education, environment, health, etc.).
```r
data(oecd_bli)
data(oecd_bli_indicators)

# See available indicators
oecd_bli_indicators$indicator
#>  [1] "Stakeholder Engagement"    "Voter Turnout"
#>  [3] "Air Pollution"             "Water Quality"
#> ...
```

### Olympic Running Data

Fastest running times for Olympic track events from 1896 to 2016, for men and women across seven distances.
```r
data(olympic_running)
head(olympic_running)
#> # A tibble: 6 × 4
#>    year length sex   time
#>   <int>  <int> <chr> <dbl>
#> 1  1896    100 male   12
#> ...
```

### Wine Quality Data

Physicochemical measurements for Portuguese Vinho Verde wines, with quality ratings from expert tasters.
```r
data(wine_quality)
dim(wine_quality)
#> [1] 6497   13
```

## Data Sources

{paste(sources_md, collapse = "
")}

## Related

- [EDA for Machine Learning](https://github.com/tthrall/eda4ml) — the companion textbook

## Citations

If you use these datasets, please cite the original sources:

{citations_md}

## License

MIT License
')
# Write README
writeLines(readme_template, here::here("README.md"))

cat("README.md updated successfully.\
")

##
#  EOF
##
