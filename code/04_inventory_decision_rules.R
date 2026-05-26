# 04_inventory_decision_rules.R
# Project: Demand Forecasting and Inventory Decision-Making under Uncertainty
# Purpose: Convert forecasted demand into inventory decision rules

# ------------------------------------------------------------
# 1. Create output folders
# ------------------------------------------------------------

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/plots", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 2. Read required files
# ------------------------------------------------------------

forecast_accuracy_file <- "outputs/tables/forecast_accuracy.csv"
forecast_results_file <- "outputs/tables/forecast_results.csv"
clean_data_file <- "data/demand_data_cleaned.csv"

if (!file.exists(forecast_accuracy_file)) {
  stop("File not found: outputs/tables/forecast_accuracy.csv. Run 03_forecasting_models.R first.")
}

if (!file.exists(forecast_results_file)) {
  stop("File not found: outputs/tables/forecast_results.csv. Run 03_forecasting_models.R first.")
}

if (!file.exists(clean_data_file)) {
  stop("File not found: data/demand_data_cleaned.csv. Run 01_data_cleaning.R first.")
}

forecast_accuracy <- read.csv(forecast_accuracy_file, stringsAsFactors = FALSE)
forecast_results <- read.csv(forecast_results_file, stringsAsFactors = FALSE)
demand_data <- read.csv(clean_data_file, stringsAsFactors = FALSE)

forecast_results$date <- as.Date(forecast_results$date)
demand_data$date <- as.Date(demand_data$date)
demand_data$demand <- as.numeric(demand_data$demand)

# ------------------------------------------------------------
# 3. Select best forecasting model using RMSE
# ------------------------------------------------------------

best_model_row <- forecast_accuracy[
  which.min(forecast_accuracy$RMSE),
]

best_model <- best_model_row$model

forecast_column <- if (best_model == "Naive forecast") {
  "naive_forecast"
} else if (best_model == "7-day moving average") {
  "moving_average_forecast"
} else if (best_model == "Simple exponential smoothing") {
  "ses_forecast"
} else if (best_model == "ARIMA(1,0,1)") {
  "arima_forecast"
} else {
  stop("Best model name not recognized.")
}

# ------------------------------------------------------------
# 4. Inventory assumptions
# ------------------------------------------------------------

lead_time_days <- 7
service_level <- 0.95
z_value <- qnorm(service_level)

# ------------------------------------------------------------
# 5. Demand during lead time
# ------------------------------------------------------------

lead_time_forecast <- forecast_results[1:lead_time_days, ]

expected_demand_during_lead_time <- sum(lead_time_forecast[[forecast_column]])

# ------------------------------------------------------------
# 6. Demand variability
# ------------------------------------------------------------

recent_days <- 365

recent_demand <- tail(demand_data$demand, recent_days)

sigma_demand <- sd(recent_demand)

# ------------------------------------------------------------
# 7. Safety stock and reorder point
# ------------------------------------------------------------

safety_stock <- z_value * sigma_demand * sqrt(lead_time_days)

deterministic_reorder_point <- expected_demand_during_lead_time

uncertainty_aware_reorder_point <- expected_demand_during_lead_time + safety_stock

# ------------------------------------------------------------
# 8. Inventory decision summary
# ------------------------------------------------------------

inventory_decision_summary <- data.frame(
  decision_component = c(
    "Best forecasting model",
    "Forecast column used",
    "Lead time in days",
    "Service level",
    "Z value",
    "Expected demand during lead time",
    "Demand standard deviation",
    "Safety stock",
    "Deterministic reorder point",
    "Uncertainty-aware reorder point",
    "Additional stock due to uncertainty"
  ),
  value = c(
    best_model,
    forecast_column,
    lead_time_days,
    service_level,
    round(z_value, 4),
    round(expected_demand_during_lead_time, 2),
    round(sigma_demand, 2),
    round(safety_stock, 2),
    round(deterministic_reorder_point, 2),
    round(uncertainty_aware_reorder_point, 2),
    round(safety_stock, 2)
  )
)

write.csv(
  inventory_decision_summary,
  "outputs/tables/inventory_decision_summary.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 9. Model selected for inventory decision
# ------------------------------------------------------------

model_selection_for_inventory <- data.frame(
  selected_model = best_model,
  selection_metric = "Lowest RMSE",
  MAE = best_model_row$MAE,
  RMSE = best_model_row$RMSE,
  MAPE = best_model_row$MAPE
)

write.csv(
  model_selection_for_inventory,
  "outputs/tables/model_selection_for_inventory.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 10. Reorder point comparison table
# ------------------------------------------------------------

reorder_point_comparison <- data.frame(
  method = c(
    "Deterministic inventory decision",
    "Uncertainty-aware inventory decision"
  ),
  reorder_point = c(
    round(deterministic_reorder_point, 2),
    round(uncertainty_aware_reorder_point, 2)
  )
)

write.csv(
  reorder_point_comparison,
  "outputs/tables/reorder_point_comparison.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 11. Reorder point comparison plot
# ------------------------------------------------------------

png(
  filename = "outputs/plots/reorder_point_comparison.png",
  width = 800,
  height = 600
)

barplot(
  reorder_point_comparison$reorder_point,
  names.arg = c("Deterministic", "Uncertainty-aware"),
  ylab = "Reorder Point",
  main = "Deterministic vs Uncertainty-Aware Reorder Point"
)

dev.off()

# ------------------------------------------------------------
# 12. Confirmation message
# ------------------------------------------------------------

cat("Inventory decision rules completed successfully.\n")
cat("Best forecasting model:", best_model, "\n")
cat("Expected demand during lead time:", round(expected_demand_during_lead_time, 2), "\n")
cat("Safety stock:", round(safety_stock, 2), "\n")
cat("Deterministic reorder point:", round(deterministic_reorder_point, 2), "\n")
cat("Uncertainty-aware reorder point:", round(uncertainty_aware_reorder_point, 2), "\n")
cat("Inventory decision outputs saved in outputs/tables/ and outputs/plots/\n")

