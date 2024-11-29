#### Preamble ####
# Purpose: Cleans the raw Bike Theft data to what we need to analyze.
# Author: Jin Zhang
# Date: 26 Novemeber 2024
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
clean_data <- raw_data |>
  select(STATUS, OCC_HOUR, OCC_MONTH, PREMISES_TYPE, BIKE_COST, NEIGHBOURHOOD_158)


# Step 3: Rename columns for better readability
clean_data <- clean_data |>
  rename(
    Theft_Status = STATUS,
    Occurrence_Hour = OCC_HOUR,
    Occurrence_Month = OCC_MONTH,
    Premises_Type = PREMISES_TYPE,
    Bike_Cost = BIKE_COST,
    Neighbourhood = NEIGHBOURHOOD_158
  )

# Step 4: Convert Theft_Status to binary variable
clean_data <- clean_data |>
  mutate(Theft_Status = ifelse(Theft_Status == "STOLEN", 1, 0),)

print(clean_data)

# Step 5: Convert Occurrence_Month from string to integer
month_mapping <- c(
  "January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5, "June" = 6,
  "July" = 7, "August" = 8, "September" = 9, "October" = 10, "November" = 11, "December" = 12
)
clean_data <- clean_data |>
  mutate(Occurrence_Month = as.integer(month_mapping[Occurrence_Month]))

# Step 5: Convert Neighbourhood to Region and replace Neighbourhood column
neighbourhood_mapping <- list(
  'North York' = c('Willowdale', 'York Mills', 'Bayview Village', 'Don Valley Village', 'Lansing-Westgate', 'Downsview', 'Pleasant View', 'Parkwoods-O\'Connor Hills', 'Newtonbrook', 'Bathurst Manor', 'Victoria Village'),
  'Toronto' = c('Rosedale', 'High Park North', 'Corso Italia-Davenport', 'Playter Estates-Danforth', 'Wychwood', 'Leaside-Bennington', 'Mount Dennis'),
  'Downtown' = c('Financial District', 'Entertainment District', 'Kensington-Chinatown', 'Church-Yonge Corridor', 'Moss Park', 'Regent Park', 'St Lawrence', 'Cabbagetown-South St.James Town', 'University', 'Bay Cloverhill'),
  'Scarborough' = c('Guildwood', 'Woburn', 'West Hill', 'Birchcliffe-Cliffside', 'Malvern', 'Bendale', 'Agincourt', 'Morningside', 'Highland Creek', 'Clairlea-Birchmount', 'Kennedy Park'),
  'Midtown' = c('Forest Hill', 'Yonge-Eglinton', 'Mount Pleasant West', 'Mount Pleasant East', 'Davisville Village', 'Chaplin Estates', 'Lawrence Park North', 'Deer Park', 'Moore Park')
)

# Flatten the mapping into a dataframe for easier joining
neighbourhood_df <- stack(neighbourhood_mapping) |>
  rename(Neighbourhood = values, Region = ind)

# Clean up Neighbourhood column to remove numbers or extra text that may not match exactly
clean_data <- clean_data |>
  mutate(Neighbourhood = gsub("\\s*\\(\\d+\\)", "", Neighbourhood))

# Merge the neighbourhood mapping with the clean_data
clean_data <- clean_data |>
  left_join(neighbourhood_df, by = "Neighbourhood") |>
  mutate(Region = as.character(Region), Region = ifelse(is.na(Region), 'Other', Region)) |>
  select(-Neighbourhood)  # Replace Neighbourhood with Region

# Step 6: Remove rows with missing data and Region == 'Other'
clean_data <- clean_data |>
  filter(Region != 'Other') |>
  na.omit()

# Step 8: Remove outliers from Bike_Cost
q1 <- quantile(clean_data$Bike_Cost, 0.25)
q3 <- quantile(clean_data$Bike_Cost, 0.75)
iqr <- q3 - q1

# Defining the lower and upper bounds for outliers
lower_bound <- q1 - 1.5 * iqr
upper_bound <- q3 + 1.5 * iqr

# Filter out the outliers in Bike_Cost
clean_data <- clean_data |>
  filter(Bike_Cost >= lower_bound & Bike_Cost <= upper_bound)

#### Save data ####
write_parquet(x = clean_data,
              sink = "data/02-analysis_data/analysis_data.parquet")
