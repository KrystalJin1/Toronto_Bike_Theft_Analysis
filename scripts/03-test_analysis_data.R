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

clean_data <- read_parquet("data/02-analysis_data/analysis_data.parquet") |>
  mutate(Theft_Status = as.integer(Theft_Status),
         Occurrence_Hour = as.integer(Occurrence_Hour))


#### Test data ####

# 1. Check if Region contains all 5 expected regions using testthat.
expected_regions <- c('North York', 'Toronto', 'Downtown', 'Scarborough', 'Midtown')
test_that("All expected regions are present in the Region column", {
  unique_regions <- unique(clean_data$Region)
  missing_regions <- setdiff(expected_regions, unique_regions)
  expect_true(length(missing_regions) == 0, paste("Missing regions:", paste(missing_regions, collapse = ", ")))
})

# 2. Check Theft_Status contains only 0 or 1.

test_that("Theft_Status contains only 0 or 1", {
  unique_statuses <- unique(clean_data$Theft_Status)
  expect_true(all(unique_statuses %in% c(0, 1)),
              paste("Unexpected values in Theft_Status:", paste(setdiff(unique_statuses, c(0, 1)), collapse = ", ")))
})

# 3. Check Occurrence_Hour is within valid range (0-23).

test_that("Occurrence_Hour is within valid range (0-23)", {
  expect_true(all(clean_data$Occurrence_Hour >= 0 & clean_data$Occurrence_Hour <= 23),
              "Occurrence_Hour contains values outside the range 0-23.")
})

# 4. Check Bike_Cost is non-negative.

test_that("Bike_Cost is non-negative", {
  expect_true(all(clean_data$Bike_Cost >= 0),
              "Bike_Cost contains negative values.")
})


# 5. Check no missing values in dataset.

test_that("no missing values in dataset", {
  expect_true(all(!is.na(clean_data)))
})

# 6. Check Variable types are correct.

test_that("Variable types are correct", {
  expect_type(clean_data$Theft_Status, "integer")
  expect_type(clean_data$Occurrence_Hour, "integer")
  expect_type(clean_data$Occurrence_Month, "integer")
  expect_type(clean_data$Premises_Type, "character")
  expect_type(clean_data$Bike_Cost, "double")
  expect_type(clean_data$Region, "character")
})



# 7. Check the dataset has 5 columns
test_that("dataset has 5 columns", {
  expect_equal(ncol(clean_data), 6)
})



