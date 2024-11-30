#### Preamble ####
# Purpose: Simulates a dataset of Bike Theft according to cleaned data. 
# Author: Jin Zhang
# Date: 26 Novemeber 2024
# Contact: kry.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? No.


#### Workspace setup ####
library(tidyverse)
set.seed(1008184288)

# Simulate 1000 rows of data

n <- 10000

# Simulate data
simulated_data <- data.frame(
  Theft_Status = sample(c(0, 1), n, replace = TRUE, prob = c(0.5, 0.5)),  # Assuming equal probability for simplicity
  Occurrence_Month = sample(1:12, n, replace = TRUE),  # Months from January (1) to December (12)
  Occurrence_Hour = sample(0:23, n, replace = TRUE),  # Hours from 0 to 23
  Bike_Cost = sample(50:2000, n, replace = TRUE),  # Cost range from 50 to 2000
  Premises_Type = sample(c("Outdoors", "Residential", "Other"), n, replace = TRUE)  # Premises types
)

#### Save data ####
write_parquet(x = simulated_data,
              sink = "data/00-simulated_data/simulated_data.parquet")


