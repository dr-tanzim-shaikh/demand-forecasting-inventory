# Data Folder

This folder contains raw and cleaned demand data for the project.

## Files

- `train.csv` — raw Kaggle Store Item Demand Forecasting dataset
- `demand_data_cleaned.csv` — cleaned daily demand series for Store 1, Item 1

## Dataset Source

The raw data comes from the Kaggle Store Item Demand Forecasting dataset.

## Selected Series

For the first version of this project, the analysis uses:

- Store: 1
- Item: 1
- Frequency: Daily
- Number of observations after cleaning: 1826

## Note

The raw dataset should be kept unchanged.

All cleaning steps are performed in:

`code/01_data_cleaning.R`
