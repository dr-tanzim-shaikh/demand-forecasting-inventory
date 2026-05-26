# Results Summary

## Forecast Accuracy

Four simple forecasting models were compared using the final 90 days of demand data as the test period.

| Model | MAE | RMSE | MAPE |
|---|---:|---:|---:|
| Naive forecast | 8.778 | 10.148 | 40.633 |
| 7-day moving average | 5.060 | 6.299 | 34.053 |
| Simple exponential smoothing | 5.295 | 6.544 | 35.960 |
| ARIMA(1,0,1) | 4.911 | 6.126 | 32.778 |

## Best Forecasting Model

The best-performing model was:

`ARIMA(1,0,1)`

This model had the lowest MAE, RMSE, and MAPE among the models tested.

## Inventory Decision Results

Using the selected forecasting model, the inventory decision calculations gave:

| Decision Component | Value |
|---|---:|
| Expected demand during lead time | 161.00 |
| Safety stock | 30.26 |
| Deterministic reorder point | 161.00 |
| Uncertainty-aware reorder point | 191.26 |

## Interpretation

The deterministic reorder point only uses expected demand during lead time.

The uncertainty-aware reorder point adds safety stock to protect against demand variability.

Therefore, the uncertainty-aware policy recommends holding an additional 30.26 units compared with the deterministic policy.

## Limitation

The forecasting accuracy is moderate rather than excellent. The best model still has a MAPE of 32.778%, indicating that demand is variable and difficult to predict precisely.

This supports the need for uncertainty-aware inventory planning.
