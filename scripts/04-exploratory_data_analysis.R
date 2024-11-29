#### Preamble ####
# Purpose: Give a basic EDA to each variables in cleaned data.
# Author: Jin Zhang
# Date: 26 Novemeber 2024
# Contact: kry.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: No.
# Any other information needed? No.


# Load necessary libraries
library(ggplot2)
library(dplyr)

# Step 1: Load analysis data
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# Step 2: Summary statistics
summary_stats <- summary(analysis_data)
#print(summary_stats)

# Step 3: Plot Theft_Status distribution
barplot(table(analysis_data$Theft_Status),
        main = "Distribution of Theft Status",
        xlab = "Theft Status (0 = Other, 1 = Stolen)",
        ylab = "Count")

# Step 4: Plot Occurrence_Hour distribution
hist(analysis_data$Occurrence_Hour,
     main = "Distribution of Theft Occurrence Hour",
     xlab = "Hour of Day (0-23)",
     ylab = "Count",
     breaks = 24)

# Step 5: Plot Occurrence_Month distribution
hist(analysis_data$Occurrence_Month,
     main = "Distribution of Theft Occurrence Month",
     xlab = "Month(1-12)",
     ylab = "Count",
     breaks = 12)

# Step 6: Plot Bike_Cost distribution
hist(analysis_data$Bike_Cost,
     main = "Distribution of Bike Cost",
     xlab = "Bike Cost",
     ylab = "Count",
     breaks = 20,
     xlim = c(0, 15000))

# Step 7: Count by Premises_Type
barplot(table(analysis_data$Premises_Type),
        main = "Count of Theft by Premises Type",
        xlab = "Premises Type",
        ylab = "Count",
        las = 2)

# Step 8: Count by Region
barplot(table(analysis_data$Region),
        main = "Count of Theft by Region",
        xlab = "Region",
        ylab = "Count",
        las = 2)
