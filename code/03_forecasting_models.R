# 03_forecasting_models.R
# Project: Demand Forecasting and Inventory Decision-Making under Uncertainty
# Purpose: Fit simple forecasting models and compare forecast accuracy

# ------------------------------------------------------------
# 1. Create output folders
# ------------------------------------------------------------

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/plots", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 2. Read cleaned data
# ------------------------------------------------------------

clean_file <- "data/demand_data_cleaned.csv"

if (!file.exists(clean_file)) {
  stop("File not found: data/demand_data_cleaned.csv. Run 01_data_cleaning.R first.")
}

demand_data <- read.csv(clean_file, stringsAsFactors = FALSE)

demand_data$date <- as.Date(demand_data$date)
demand_data$demand <- as.numeric(demand_data$demand)

demand_data <- demand_data[order(demand_data$date), ]

# ------------------------------------------------------------
# 3. Train-test split
# ------------------------------------------------------------

test_days <- 90

n <- nrow(demand_data)

train_data <- demand_data[1:(n - test_days), ]
test_data <- demand_data[(n - test_days + 1):n, ]

train_demand <- train_data$demand
test_demand <- test_data$demand

# ------------------------------------------------------------
# 4. Accuracy function
# ------------------------------------------------------------

accuracy_metrics <- function(actual, forecast) {
  mae <- mean(abs(actual - forecast))
  rmse <- sqrt(mean((actual - forecast)^2))
  mape <- mean(abs((actual - forecast) / actual)) * 100
  
  return(c(
    MAE = round(mae, 3),
    RMSE = round(rmse, 3),
    MAPE = round(mape, 3)
  ))
}

# ------------------------------------------------------------
# 5. Forecasting models
# ------------------------------------------------------------

# Model 1: Naive forecast
naive_forecast <- rep(tail(train_demand, 1), test_days)

# Model 2: 7-day moving average forecast
moving_average_value <- mean(tail(train_demand, 7))
moving_average_forecast <- rep(moving_average_value, test_days)

# Model 3: Simple exponential smoothing
ses_model <- HoltWinters(
  ts(train_demand),
  beta = FALSE,
  gamma = FALSE
)

ses_forecast <- as.numeric(predict(ses_model, n.ahead = test_days))

# Model 4: Simple ARIMA(1,0,1)
arima_model <- arima(train_demand, order = c(1, 0, 1))

arima_prediction <- predict(arima_model, n.ahead = test_days)

arima_forecast <- as.numeric(arima_prediction$pred)
arima_se <- as.numeric(arima_prediction$se)

# ------------------------------------------------------------
# 6. Accuracy comparison
# ------------------------------------------------------------

forecast_accuracy <- rbind(
  data.frame(
    model = "Naive forecast",
    t(accuracy_metrics(test_demand, naive_forecast))
  ),
  data.frame(
    model = "7-day moving average",
    t(accuracy_metrics(test_demand, moving_average_forecast))
  ),
  data.frame(
    model = "Simple exponential smoothing",
    t(accuracy_metrics(test_demand, ses_forecast))
  ),
  data.frame(
    model = "ARIMA(1,0,1)",
    t(accuracy_metrics(test_demand, arima_forecast))
  )
)

write.csv(
  forecast_accuracy,
  "outputs/tables/forecast_accuracy.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 7. Forecast output table
# ------------------------------------------------------------

forecast_results <- data.frame(
  date = test_data$date,
  actual_demand = test_demand,
  naive_forecast = round(naive_forecast, 2),
  moving_average_forecast = round(moving_average_forecast, 2),
  ses_forecast = round(ses_forecast, 2),
  arima_forecast = round(arima_forecast, 2),
  arima_lower_95 = round(arima_forecast - 1.96 * arima_se, 2),
  arima_upper_95 = round(arima_forecast + 1.96 * arima_se, 2)
)

write.csv(
  forecast_results,
  "outputs/tables/forecast_results.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 8. Forecast plot
# ------------------------------------------------------------

png(
  filename = "outputs/plots/forecast_comparison_plot.png",
  width = 1000,
  height = 600
)

plot(
  test_data$date,
  test_demand,
  type = "l",
  xlab = "Date",
  ylab = "Demand",
  main = "Actual vs Forecasted Demand"
)

lines(test_data$date, naive_forecast, lty = 2)
lines(test_data$date, moving_average_forecast, lty = 3)
lines(test_data$date, ses_forecast, lty = 4)
lines(test_data$date, arima_forecast, lty = 5)

legend(
  "topright",
  legend = c(
    "Actual",
    "Naive",
    "7-day Moving Average",
    "SES",
    "ARIMA(1,0,1)"
  ),
  lty = c(1, 2, 3, 4, 5),
  bty = "n"
)

dev.off()

# ------------------------------------------------------------
# 9. ARIMA forecast interval plot
# ------------------------------------------------------------

png(
  filename = "outputs/plots/arima_forecast_interval_plot.png",
  width = 1000,
  height = 600
)

plot(
  test_data$date,
  test_demand,
  type = "l",
  xlab = "Date",
  ylab = "Demand",
  main = "ARIMA Forecast with 95% Forecast Interval"
)

lines(test_data$date, arima_forecast, lty = 2)
lines(test_data$date, arima_forecast - 1.96 * arima_se, lty = 3)
lines(test_data$date, arima_forecast + 1.96 * arima_se, lty = 3)

legend(
  "topright",
  legend = c("Actual", "ARIMA Forecast", "95% Lower/Upper"),
  lty = c(1, 2, 3),
  bty = "n"
)

dev.off()

# ------------------------------------------------------------
# 10. Confirmation message
# ------------------------------------------------------------

cat("Forecasting models completed successfully.\n")
cat("Forecast accuracy saved as: outputs/tables/forecast_accuracy.csv\n")
cat("Forecast results saved as: outputs/tables/forecast_results.csv\n")
cat("Forecast plots saved in: outputs/plots/\n")