###
# mnist.R
#   Prepare MNIST subsets for eda4mldata package
###

library(tidyverse)
library(here)

# --- mnist_example: 10 images, one per digit ---
mnist_example <-
  here::here("data-raw", "xmpl_train_image_tbl.txt") |>
  readr::read_tsv(
    show_col_types = FALSE ) |>
  dplyr::rename(
    img_idx = img_dx,
    row_idx = row_dx,
    col_idx = col_dx ) |>
  dplyr::mutate(label = factor(label)) |>
  dplyr::select(img_idx, row_idx, col_idx, pixel, label) |>
  dplyr::arrange(label)

# --- mnist_train: 1K training images ---
train_images <-
  here::here("data-raw", "mnist_1K_train_image_tbl.txt") |>
  read_tsv(
    show_col_types = FALSE )

train_labels <-
  here::here("data-raw", "mnist_1K_train_labels.txt") |>
  readr::read_tsv(
    show_col_types = FALSE ) |>
  dplyr::mutate(img_idx = row_number())

mnist_train <- train_images |>
  dplyr::rename(
    img_idx = img_dx,
    row_idx = row_dx,
    col_idx = col_dx ) |>
  dplyr::left_join(
    y  = train_labels,
    by = "img_idx" ) |>
  dplyr::mutate(label = factor(label)) |>
  dplyr::select(img_idx, row_idx, col_idx, pixel, label)

# --- mnist_test: 1K test images ---
test_images <-
  here::here("data-raw", "mnist_1K_test_image_tbl.txt") |>
  read_tsv(
    show_col_types = FALSE )

test_labels <-
  here::here("data-raw", "mnist_1K_test_labels.txt") |>
  readr::read_tsv(
    show_col_types = FALSE ) |>
  dplyr::mutate(img_idx = row_number())

mnist_test <- test_images |>
  dplyr::rename(
    img_idx = img_dx,
    row_idx = row_dx,
    col_idx = col_dx ) |>
  dplyr::left_join(
    y  = test_labels,
    by = "img_idx" ) |>
  dplyr::mutate(label = factor(label)) |>
  dplyr::select(img_idx, row_idx, col_idx, pixel, label)

# --- Save datasets ---
usethis::use_data(mnist_example, overwrite = TRUE)
usethis::use_data(mnist_train, overwrite = TRUE)
usethis::use_data(mnist_test, overwrite = TRUE)

##
#   EOF
##
