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

# Step 1: Load raw data
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv", show_col_types = FALSE)

# Step 3: Simulate 2000 rows of data
n <- 2000
simulated_data <- analysis_data %>%
  sample_n(n, replace = TRUE) %>%
  mutate(
    Theft_Status = sample(c(0, 1), n, replace = TRUE, prob = c(0.6, 0.4)),
    Occurrence_Hour = sample(0:23, n, replace = TRUE),
    Premises_Type = sample(unique(analysis_data$Premises_Type), n, replace = TRUE),
    Bike_Cost = round(runif(n, min = 50, max = 5000), 2),
    Region = sample(c('North York', 'Toronto', 'Downtown', 'Scarborough', 'Midtown'), n, replace = TRUE)
  )


#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
