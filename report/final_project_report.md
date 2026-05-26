# Final Project Report

## 1. Background

Inventory decisions depend heavily on future demand. If demand is underestimated, stockouts may occur. If demand is overestimated, excess stock and holding costs increase.

This project connects demand forecasting with inventory decision-making under uncertainty.

## 2. Research Question

How can demand forecasting models support inventory decision-making when future demand is uncertain?

## 3. Dataset

The project uses historical store-item demand data from the Kaggle Store Item Demand Forecasting dataset.

For the first version, one demand series was selected:

- Store: 1
- Item: 1
- Frequency: Daily
- Number of observations: 1826

The cleaned dataset is stored as:

`data/demand_data_cleaned.csv`

## 4. Data Cleaning

The raw dataset was cleaned using:

`code/01_data_cleaning.R`

The cleaning process included:

- reading the raw sales data,
- standardising column names,
- converting the date column,
- selecting one store-item demand series,
- aggregating demand by date,
- saving a cleaned demand dataset.

## 5. Descriptive Analysis

Descriptive analysis was performed using:

`code/02_descriptive_analysis.R`

The analysis generated:

- descriptive summary statistics,
- monthly demand summary,
- daily demand time-series plot,
- monthly demand time-series plot,
- demand distribution plot.

The outputs are stored in:

- `outputs/tables/`
- `outputs/plots/`

## 6. Forecasting Models

Four forecasting models were compared:

1. Naive forecast
2. 7-day moving average
3. Simple exponential smoothing
4. ARIMA(1,0,1)

The final 90 days were used as the test period.

## 7. Forecast Accuracy

The forecast accuracy results were:

| Model | MAE | RMSE | MAPE |
|---|---:|---:|---:|
| Naive forecast | 8.778 | 10.148 | 40.633 |
| 7-day moving average | 5.060 | 6.299 | 34.053 |
| Simple exponential smoothing | 5.295 | 6.544 | 35.960 |
| ARIMA(1,0,1) | 4.911 | 6.126 | 32.778 |

The best-performing model was:

`ARIMA(1,0,1)`

It had the lowest MAE, RMSE, and MAPE among the models tested.

## 8. Forecast Uncertainty

The forecasting results show that demand is variable and not perfectly predictable.

The best model still had a MAPE of 32.778%, which indicates moderate forecasting accuracy.

This supports the need to include uncertainty in inventory decisions.

## 9. Inventory Decision Rules

Inventory decision rules were calculated using:

`code/04_inventory_decision_rules.R`

The following formulas were used:

Safety Stock = z × σ_demand × √Lead Time

Reorder Point = Expected Demand during Lead Time + Safety Stock

The assumptions were:

- Lead time: 7 days
- Service level: 95%
- Forecasting model used: ARIMA(1,0,1)

## 10. Inventory Decision Results

| Decision Component | Value |
|---|---:|
| Expected demand during lead time | 161.00 |
| Safety stock | 30.26 |
| Deterministic reorder point | 161.00 |
| Uncertainty-aware reorder point | 191.26 |

## 11. Interpretation

The deterministic reorder point uses only the expected demand during lead time.

The uncertainty-aware reorder point adds safety stock to protect against demand variability.

The uncertainty-aware policy recommends holding an additional 30.26 units compared with the deterministic policy.

This demonstrates how forecasting uncertainty can be translated into practical inventory decisions.

## 12. Limitations

This is a first-version portfolio project.

The forecasting models are intentionally simple. More advanced models such as seasonal ARIMA, ETS, or machine learning models were not used in this version.

The analysis uses only one store-item demand series. Future extensions can compare multiple items and stores.

The best model still has a MAPE of 32.778%, so the forecasts should be treated as decision-support estimates rather than precise demand predictions.

## 13. Conclusion

This project shows how historical demand data can be used to support inventory decision-making under uncertainty.

The project demonstrates a complete R-based workflow:

- data cleaning,
- descriptive analysis,
- forecasting,
- forecast accuracy comparison,
- forecast uncertainty,
- safety stock,
- reorder point calculation,
- deterministic versus uncertainty-aware inventory planning.

The project is suitable as a reproducible applied statistics and inventory analytics portfolio project.
