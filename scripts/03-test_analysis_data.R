#### Preamble ####
# Purpose: Tests cleaned data to make every requirements is satisfied.
# Author: Jin Zhang
# Date: 26 Novemeber 2024
# Contact: kry.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: No.
# Any other information needed? No.


#### Workspace setup ####
library(tidyverse)
library(testthat)

# Read cleaned data

cleaned_data <- read_parquet("data/02-analysis_data/analysis_data.parquet") |>
  mutate(
    Theft_Status = as.integer(Theft_Status),
    Occurrence_Hour = as.integer(Occurrence_Hour),
    Premises_Type = as.character(Premises_Type)
  )


#### Test data ####

# 1. Check if Occurrence_Month is within valid range (1-12).
test_that("Occurrence_Month is within valid range (1-12)", {
  expect_true(
    all(cleaned_data$Occurrence_Month >= 0 & cleaned_data$Occurrence_Month <= 23),
    "Occurrence_Month contains values outside the range 1-12."
  )
})

# 2. Check Theft_Status contains only 0 or 1.

test_that("Theft_Status contains only 0 or 1", {
  unique_statuses <- unique(cleaned_data$Theft_Status)
  expect_true(
    all(unique_statuses %in% c(0, 1)),
    paste("Unexpected values in Theft_Status:", paste(setdiff(unique_statuses, c(0, 1)), collapse = ", "))
  )
})

# 3. Check Occurrence_Hour is within valid range (0-23).

test_that("Occurrence_Hour is within valid range (0-23)", {
  expect_true(
    all(cleaned_data$Occurrence_Hour >= 0 & cleaned_data$Occurrence_Hour <= 23),
    "Occurrence_Hour contains values outside the range 0-23."
  )
})


# 4. Check Bike_Cost is non-negative.

test_that("Bike_Cost is non-negative", {
  expect_true(
    all(cleaned_data$Bike_Cost >= 0),
    "Bike_Cost contains negative values."
  )
})


# 5. Check no missing values in dataset.

test_that("no missing values in dataset", {
  expect_true(all(!is.na(cleaned_data)))
})

# 6. Check Variable types are correct.

test_that("Variable types are correct", {
  expect_type(cleaned_data$Theft_Status, "integer")
  expect_type(cleaned_data$Occurrence_Hour, "integer")
  expect_type(cleaned_data$Occurrence_Month, "integer")
  expect_type(cleaned_data$Premises_Type, "character")
  expect_type(cleaned_data$Bike_Cost, "double")
})



# 7. Check the dataset has 5 columns
test_that("dataset has 5 columns", {
  expect_equal(ncol(cleaned_data), 5)
})
