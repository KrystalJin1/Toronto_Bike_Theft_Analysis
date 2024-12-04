# Changing Dynamics of Urban Bike Thefts: Understanding Trends to Inform Future Prevention Efforts

## Overview

This repository houses the analysis of bike theft patterns in Toronto, from 2014 to 2024. Using the data sourced from the Toronto Police Service Public Safety Data Portal, this project applies Bayesian logistic regression models to evaluate how different variables such as time of day, month, and location influence bike theft incidents.

To utilize the resources in this repository, click the green "Code" button, then "Download ZIP". Once downloaded, move the folder to your desired working directory on your computer, and adapt the contents as necessary for your analysis and reporting.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Toronto Police Service Public Safety Data Portal.
-   `data/simulated_data` simulates a dataset of Bike Theft according to cleaned data. 
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models for data and API which allows the user to enter input and get a predicted price.
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate (00-simulate_data.R), test simulate data (01-test_simulated_data.R), clean data (02-clean_data.R), test data (03-test_analysis_data.R), exploratory (04-exploratory_data.R) and the model (05-model_data.R).


## Statement on LLM usage

No auto-complete tools such as GitHub Copilot were used in the course of this project. Statement on LLM Usage: Aspects of the code and paper were written with the help of ChatGPT. The entire chat history is available in others/llms/usage.txt.

