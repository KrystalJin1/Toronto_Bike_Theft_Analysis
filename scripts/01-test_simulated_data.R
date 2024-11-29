#### Preamble ####
# Purpose: Tests the simulated Bike Theft data.
# Author: Jin Zhang
# Date: 26 Novemeber 2024
# Contact: kry.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? No.


#### Workspace setup ####
library(tidyverse)
library(testthat)

# Read simulated data
simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv", show_col_types = FALSE)

## Test about simulated data

test_that("Theft_Status contains only 0 or 1", {
  unique_statuses <- unique(simulated_data$Theft_Status)
  expect_true(all(unique_statuses %in% c(0, 1)),
              paste("Unexpected values in Theft_Status:", paste(setdiff(unique_statuses, c(0, 1)), collapse = ", ")))
})

test_that("Occurrence_Hour is within valid range (0-23)", {
  expect_true(all(simulated_data$Occurrence_Hour >= 0 & simulated_data$Occurrence_Hour <= 23),
              "Occurrence_Hour contains values outside the range 0-23.")
})

test_that("Bike_Cost is non-negative", {
  expect_true(all(simulated_data$Bike_Cost >= 0),
              "Bike_Cost contains negative values.")
})

test_that("Region contains all expected regions", {
  expected_regions <- c('North York', 'Toronto', 'Downtown', 'Scarborough', 'Midtown')
  unique_regions <- unique(simulated_data$Region)
  missing_regions <- setdiff(expected_regions, unique_regions)
  expect_true(length(missing_regions) == 0,
              paste("Missing regions:", paste(missing_regions, collapse = ", ")))
})

test_that("Premises_Type is not empty", {
  expect_false(any(is.na(simulated_data$Premises_Type)), "Premises_Type contains missing values.")
})

test_that("Number of rows is correct", {
  expect_true(nrow(simulated_data) == 2000, "The number of rows in simulated_data is not 2000.")
})
