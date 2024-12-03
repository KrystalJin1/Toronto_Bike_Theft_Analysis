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
library(arrow)

#### Read data ####
analysis_data <- read_parquet(file = here::here("data/02-analysis_data/analysis_data.parquet"))

#### Model data ####
# Fit a Bayesian logistic regression model to predict Theft Status
Bike_Theft_model <-
  stan_glm(
    formula = Theft_Status ~ Occurrence_Hour + Occurrence_Month + Premises_Type + Bike_Cost,
    data = analysis_data,
    family = binomial(link = "logit"), # Logistic regression for binary outcome
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 1008184288
  )

Bike_Theft_model2 <- glm(Theft_Status ~ Occurrence_Hour + Occurrence_Month + Premises_Type + Bike_Cost,
  data = analysis_data,
  family = binomial(link = "logit")
)

#### Save model ####
saveRDS(
  Bike_Theft_model,
  file = "models/Bike_Theft_model.rds"
)

saveRDS(
  Bike_Theft_model2,
  file = "models/Bike_Theft_model_Frequentist.rds"
)

### Model comparison ###
# Train-Test Split
set.seed(1008184288) # For reproducibility
train_indices <- sample(1:nrow(analysis_data), size = 0.8 * nrow(analysis_data))
train_data <- analysis_data[train_indices, ]
test_data <- analysis_data[-train_indices, ]

# Fit the stan_glm model
library(rstanarm)
Bike_Theft_model <- stan_glm(
  formula = Theft_Status ~ Occurrence_Hour + Occurrence_Month + Premises_Type + Bike_Cost,
  data = train_data,
  family = binomial(link = "logit"),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  seed = 1008184288
)

# Fit the glm model
Bike_Theft_model2 <- glm(
  formula = Theft_Status ~ Occurrence_Hour + Occurrence_Month + Premises_Type + Bike_Cost,
  data = train_data,
  family = binomial(link = "logit")
)

# Predictions on the test set
# For stan_glm
stan_preds <- posterior_predict(Bike_Theft_model, newdata = test_data)
stan_preds_mean <- apply(stan_preds, 2, mean) # Predicted probabilities
stan_class <- ifelse(stan_preds_mean > 0.5, 1, 0) # Predicted class

# For glm
glm_preds <- predict(Bike_Theft_model2, newdata = test_data, type = "response") # Predicted probabilities
glm_class <- ifelse(glm_preds > 0.5, 1, 0) # Predicted class

# Evaluate Performance
# Accuracy
stan_accuracy <- mean(stan_class == test_data$Theft_Status)
glm_accuracy <- mean(glm_class == test_data$Theft_Status)

# Print Results
cat("Stan GLM Model Accuracy:", stan_accuracy, "\n")
cat("GLM Model Accuracy:", glm_accuracy, "\n")
