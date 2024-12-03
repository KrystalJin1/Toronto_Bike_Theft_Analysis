#### Preamble ####
# Purpose: Cleans the raw Bike Theft data to what we need to analyze.
# Author: Jin Zhang
# Date: today
# Contact: kry.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: No.
# Any other information needed? No.

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(arrow)

# Step 1: Load raw data
raw_data <- read_csv("data/01-raw_data/raw_data.csv", show_col_types = FALSE)

# Step 2: Select variables for analysis
clean_data <- raw_data %>%
  select(STATUS, OCC_HOUR, OCC_MONTH, PREMISES_TYPE, BIKE_COST)

# Step 3: Rename columns for better readability
clean_data <- clean_data %>%
  rename(
    Theft_Status = STATUS,
    Occurrence_Hour = OCC_HOUR,
    Occurrence_Month = OCC_MONTH,
    Premises_Type = PREMISES_TYPE,
    Bike_Cost = BIKE_COST
  )

# Step 4: Convert Theft Status to a binary variable
clean_data <- clean_data %>%
  mutate(Theft_Status = ifelse(Theft_Status == "STOLEN", 1, 0))

# Step 5: Convert Occurrence Month from string to integer
month_mapping <- c(
  "January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5, "June" = 6,
  "July" = 7, "August" = 8, "September" = 9, "October" = 10, "November" = 11, "December" = 12
)
clean_data <- clean_data %>%
  mutate(Occurrence_Month = as.integer(month_mapping[Occurrence_Month]))

# Step 6: Remove rows where Bike Cost is NA
clean_data <- clean_data %>% drop_na(Bike_Cost)

# Step 7: Remove outliers from Bike Cost
q1 <- quantile(clean_data$Bike_Cost, 0.25)
q3 <- quantile(clean_data$Bike_Cost, 0.75)
iqr <- q3 - q1

# Defining the lower and upper bounds for outliers
lower_bound <- q1 - 1.5 * iqr
upper_bound <- q3 + 1.5 * iqr

# Filter out the outliers in Bike Cost
clean_data <- clean_data %>%
  filter(Bike_Cost >= lower_bound & Bike_Cost <= upper_bound)

# Step 8: Group Premises Type into categories
clean_data <- clean_data %>%
  mutate(
    Premises_Type = case_when(
      Premises_Type %in% c("Educational", "Commercial", "Transit", "Other") ~ "Other",
      Premises_Type == "Apartment" ~ "Apartment",
      Premises_Type == "Outside" ~ "Outdoors",
      Premises_Type == "House" ~ "House",
      TRUE ~ "NA_character"  
    )
  ) %>%
  drop_na(Premises_Type) # Drop rows where Premises Type becomes NA


#### Save data ####
write_parquet(x = clean_data,
              sink = "data/02-analysis_data/analysis_data.parquet")

