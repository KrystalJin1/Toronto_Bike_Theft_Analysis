#### Preamble ####
# Purpose: Set up a suitable model for the dataset.
# Author: Jin Zhang
# Date: 26 Novemeber 2024
# Contact: kry.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: No.
# Any other information needed? No.


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_parquet(file = here::here("data/02-analysis_data/analysis_data.parquet"))


#### Model data ####
# Fit a Bayesian logistic regression model to predict Theft Status
Bike_Theft_model <- 
  stan_glm(
    formula = Theft_Status ~ Occurrence_Hour + Occurrence_Month + Premises_Type + Bike_Cost,
    data = analysis_data,
    family = binomial(link = "logit"),  # Logistic regression for binary outcome
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 1008184288
  )


#### Save model ####
saveRDS(
  Bike_Theft_model,
  file = "models/Bike_Theft_model.rds"
)
