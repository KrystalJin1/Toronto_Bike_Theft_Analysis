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
n <- 1000 # Number of observations

# Define probabilities of theft based on Premises_Type
premises_types <- c("Outdoors", "House", "Apartment", "Other")
theft_probs <- c(0.8, 0.3, 0.4, 0.5) # Higher probability of theft outdoors

# Simulate Premises_Type
simulated_data <- data.frame(
  Premises_Type = sample(premises_types, n, replace = TRUE, prob = c(0.4, 0.3, 0.2, 0.1)) # Uneven distribution of premises
)

# Assign Theft_Status based on Premises_Type
simulated_data$Theft_Status <- sapply(simulated_data$Premises_Type, function(premise) {
  rbinom(1, size = 1, prob = theft_probs[which(premises_types == premise)])
})

# Add additional independent variables for context
simulated_data$Occurrence_Month <- sample(1:12, n, replace = TRUE) # Random months
simulated_data$Occurrence_Hour <- sample(0:23, n, replace = TRUE) # Random hours
simulated_data$Bike_Cost <- sample(50:2000, n, replace = TRUE) # Random bike cost


#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
