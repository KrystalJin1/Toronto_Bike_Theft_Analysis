library(plumber)
library(rstanarm)
library(tidyverse)

# Load the model
model <- readRDS("Bike_Theft_model.rds")

# Define the model version
version_number <- "0.0.1"

# Define the variables
variables <- list(
  Occurrence_Hour = "Represents the hour of the day when the bike theft incident occurred. Ranging from 0 to 23, this variable captures temporal patterns in theft likelihood, potentially influenced by changes in human activity and environmental factors throughout the day.",
  Occurrence_Month = "Indicates the month of the year when the bike theft took place. Ranging from 1 (January) to 12 (December), this variable is used to observe seasonal trends in bike theft, which might vary due to weather conditions, holiday periods, or other seasonal activities.",
  Premises_TypeOutdoors = "Categorizes the theft location as 'Outdoors', which includes public, semi-public, and transit areas. This classification helps to identify the risk associated with bike thefts in open and possibly less secure environments compared to private or controlled zones.",
  Premises_TypeHouse = "Describes theft locations classified as 'Residential', which typically includes private homes, apartment complexes, and residential buildings. This variable assesses the risk of bike thefts occurring in areas where bikes are likely stored in more secure, private settings.",
  Premises_TypeOther = "The place in house", 
  Bike_Cost = "Represents the reported monetary value of the bike. This continuous variable is used to analyze whether the cost of the bike influences its likelihood of being stolen, under the assumption that more expensive bikes are more attractive targets for theft."
)

#* @param Occurrence_Hour
#* @param Occurrence_Month 
#* @param Premises_TypeHouse
#* @param Premises_TypeOutdoors
#* @param Premises_TypeOther
#* @param Bike_Cost
#* @get /Prediction_Bike_Theft_Status
Prediction_Bike_Theft_Status <- function(Occurrence_Hour = 5, Occurrence_Month = 5, Premises_Type = "Outdoors", Bike_Cost = 500) {
  # Convert inputs to appropriate types
  Occurrence_Hour <- as.numeric(Occurrence_Hour)
  Occurrence_Month <- as.numeric(Occurrence_Month)
  Premises_Type <- as.character(Premises_Type)
  Bike_Cost <- as.integer(Bike_Cost)
  
  # Prepare the payload as a data frame
  payload <- data.frame(
    Occurrence_Hour = Occurrence_Hour,
    Occurrence_Month = Occurrence_Month,
    Premises_Type = Premises_Type,
    Bike_Cost = Bike_Cost
  )
  
  # Extract posterior samples
  posterior_samples <- as.matrix(model)  # Convert to matrix for easier manipulation
  
  # Define the generative process for prediction
  beta_Occurrence_Hour <- posterior_samples[, "Occurrence_Hour"]
  beta_Occurrence_Month <- posterior_samples[, "Occurrence_Month"]
  beta_Premises_Type <- posterior_samples[, "Premises_TypeOutdoors"]
  beta_Premises_Type <- posterior_samples[, "Premises_TypeOther"]
  beta_Premises_Type <- posterior_samples[, "Premises_TypeHouse"]
  beta_Bike_Cost <- posterior_samples[, "Bike_Cost"]
  alpha <- posterior_samples[, "(Intercept)"]
  
  # Compute the predicted value for the observation
  predicted_values <- alpha +
    beta_Occurrence_Hour * payload$Occurrence_Hour + beta_Occurrence_Month * payload$Occurrence_Month +
    beta_Premises_Type * ifelse(payload$Premises_Type == "Outdoors", 1, 0) + beta_Premises_Type * ifelse(payload$Premises_Type  == "Apartment", 1, 0) + beta_Premises_Type * ifelse(payload$Premises_Type  == "House", 1, 0)
  beta_Bike_Cost * payload$Bike_Cost
  
  # Predict
  mean_logodds <- mean(predicted_values)
  mean_prob <- exp(mean_logodds) / (1 + exp(mean_logodds))
  mean_prediction <- ifelse(mean_prob > 0.5, "yes, stolen", "no, not stolen")
  
  # Store results
  result <- list(
    "estimated Bike Theft Status" = mean_prediction
  )
  
  return(result)
}



