# Demand Forecasting and Inventory Decision-Making under Uncertainty

This project connects demand forecasting with inventory decision-making under uncertainty using historical store-item demand data and R.

## Project Aim

The aim of this project is to show how demand forecasts can support inventory decisions when future demand is uncertain.

## Research Question

How can demand forecasting models support inventory decision-making when future demand is uncertain?

## Dataset

The project uses the Kaggle Store Item Demand Forecasting dataset.

For the first version, one demand series is analysed:

- Store: 1
- Item: 1
- Frequency: Daily
- Number of observations: 1826

## Methods Used

- Data cleaning
- Descriptive statistics
- Time-series visualisation
- Naive forecast
- 7-day moving average
- Simple exponential smoothing
- ARIMA(1,0,1)
- Forecast accuracy comparison
- Safety stock calculation
- Reorder point calculation
- Deterministic versus uncertainty-aware inventory decision comparison

## Forecasting Results

Four forecasting models were compared using the final 90 days as the test period.

| Model | MAE | RMSE | MAPE |
|---|---:|---:|---:|
| Naive forecast | 8.778 | 10.148 | 40.633 |
| 7-day moving average | 5.060 | 6.299 | 34.053 |
| Simple exponential smoothing | 5.295 | 6.544 | 35.960 |
| ARIMA(1,0,1) | 4.911 | 6.126 | 32.778 |

The best-performing model was ARIMA(1,0,1).

## Inventory Decision Results

| Decision Component | Value |
|---|---:|
| Expected demand during lead time | 161.00 |
| Safety stock | 30.26 |
| Deterministic reorder point | 161.00 |
| Uncertainty-aware reorder point | 191.26 |

## Interpretation

The deterministic reorder point uses only expected demand during lead time.

The uncertainty-aware reorder point adds safety stock to protect against demand variability.

In this case, the uncertainty-aware inventory rule recommends holding an additional 30.26 units.

## Project Structure

```text
demand-forecasting-inventory/
├── README.md
├── data/
│   ├── README.md
│   ├── train.csv
│   └── demand_data_cleaned.csv
├── code/
│   ├── README.md
│   ├── 01_data_cleaning.R
│   ├── 02_descriptive_analysis.R
│   ├── 03_forecasting_models.R
│   └── 04_inventory_decision_rules.R
├── outputs/
│   ├── README.md
│   ├── tables/
│   └── plots/
└── report/
    ├── README.md
    ├── results_summary.md
    └── final_project_report.md
```

## R Scripts

- `code/01_data_cleaning.R`
- `code/02_descriptive_analysis.R`
- `code/03_forecasting_models.R`
- `code/04_inventory_decision_rules.R`

## Outputs

Tables are stored in:

`outputs/tables/`

Plots are stored in:

`outputs/plots/`

Reports are stored in:

`report/`

## Reproducibility

Run the scripts in this order:

```r
source("code/01_data_cleaning.R")
source("code/02_descriptive_analysis.R")
source("code/03_forecasting_models.R")
source("code/04_inventory_decision_rules.R")
```

## Data Source

This project uses the Kaggle Store Item Demand Forecasting dataset.

Dataset page: https://www.kaggle.com/competitions/demand-forecasting-kernels-only

The dataset provides historical store-item sales data suitable for time-series demand forecasting.

## Citation

This project uses the Kaggle Store Item Demand Forecasting dataset.

Dataset page: https://www.kaggle.com/competitions/demand-forecasting-kernels-only

If using this repository, please cite or acknowledge the original dataset source.

## Limitations

This is a first-version portfolio project.

The models are intentionally simple. The project does not use advanced machine learning or deep learning.

The analysis uses one store-item demand series only.

The best model still has a MAPE of 32.778%, so the forecasts should be treated as decision-support estimates rather than precise demand predictions.

## Tools

- R
- Markdown
- Excel for viewing CSV outputs

## Author

Dr. Tanzim Shahabuddin Shaikh  
Assistant Professor of Statistics  
Ph.D. in Statistics, University of Mumbai
