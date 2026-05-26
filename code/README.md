# Code Folder

This folder contains R scripts for the demand forecasting and inventory decision-making project.

## Files

- `01_data_cleaning.R` — reads raw demand data, cleans it, selects one store-item series, and saves cleaned data.
- `02_descriptive_analysis.R` — creates descriptive statistics, monthly summaries, and demand plots.
- `03_forecasting_models.R` — fits forecasting models and compares forecast accuracy.
- `04_inventory_decision_rules.R` — converts forecast results into safety stock and reorder point calculations.

## How to Run

From the main project folder, run:

```r
source("code/01_data_cleaning.R")
source("code/02_descriptive_analysis.R")
source("code/03_forecasting_models.R")
source("code/04_inventory_decision_rules.R")
```

## Outputs Generated

The scripts generate:

- cleaned demand data in `data/`
- summary tables in `outputs/tables/`
- plots in `outputs/plots/`
