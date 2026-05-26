# 02_descriptive_analysis.R
# Project: Demand Forecasting and Inventory Decision-Making under Uncertainty
# Purpose: Descriptive analysis and time-series visualization of cleaned demand data

# ------------------------------------------------------------
# 1. Create output folders
# ------------------------------------------------------------

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/plots", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 2. Read cleaned demand data
# ------------------------------------------------------------

clean_file <- "data/demand_data_cleaned.csv"

if (!file.exists(clean_file)) {
  stop("File not found: data/demand_data_cleaned.csv. Run 01_data_cleaning.R first.")
}

demand_data <- read.csv(clean_file, stringsAsFactors = FALSE)

demand_data$date <- as.Date(demand_data$date)
demand_data$demand <- as.numeric(demand_data$demand)

# ------------------------------------------------------------
# 3. Descriptive statistics
# ------------------------------------------------------------

descriptive_summary <- data.frame(
  measure = c(
    "Number of observations",
    "Start date",
    "End date",
    "Minimum demand",
    "Maximum demand",
    "Mean demand",
    "Median demand",
    "Standard deviation",
    "Coefficient of variation"
  ),
  value = c(
    nrow(demand_data),
    as.character(min(demand_data$date)),
    as.character(max(demand_data$date)),
    min(demand_data$demand),
    max(demand_data$demand),
    round(mean(demand_data$demand), 2),
    median(demand_data$demand),
    round(sd(demand_data$demand), 2),
    round(sd(demand_data$demand) / mean(demand_data$demand), 4)
  )
)

write.csv(
  descriptive_summary,
  "outputs/tables/descriptive_summary.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 4. Monthly demand aggregation
# ------------------------------------------------------------

demand_data$year_month <- format(demand_data$date, "%Y-%m")

monthly_demand <- aggregate(
  demand ~ year_month,
  data = demand_data,
  FUN = sum
)

write.csv(
  monthly_demand,
  "outputs/tables/monthly_demand_summary.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 5. Daily demand time-series plot
# ------------------------------------------------------------

png(
  filename = "outputs/plots/daily_demand_time_series.png",
  width = 1000,
  height = 600
)

plot(
  demand_data$date,
  demand_data$demand,
  type = "l",
  xlab = "Date",
  ylab = "Daily Demand",
  main = "Daily Demand Time Series: Store 1, Item 1"
)

dev.off()

# ------------------------------------------------------------
# 6. Monthly demand plot
# ------------------------------------------------------------

png(
  filename = "outputs/plots/monthly_demand_time_series.png",
  width = 1000,
  height = 600
)

plot(
  as.Date(paste0(monthly_demand$year_month, "-01")),
  monthly_demand$demand,
  type = "l",
  xlab = "Month",
  ylab = "Monthly Demand",
  main = "Monthly Demand Time Series: Store 1, Item 1"
)

dev.off()

# ------------------------------------------------------------
# 7. Demand distribution plot
# ------------------------------------------------------------

png(
  filename = "outputs/plots/demand_distribution.png",
  width = 800,
  height = 600
)

hist(
  demand_data$demand,
  breaks = 30,
  xlab = "Daily Demand",
  main = "Distribution of Daily Demand"
)

dev.off()

# ------------------------------------------------------------
# 8. Confirmation message
# ------------------------------------------------------------

cat("Descriptive analysis completed successfully.\n")
cat("Summary saved as: outputs/tables/descriptive_summary.csv\n")
cat("Monthly demand saved as: outputs/tables/monthly_demand_summary.csv\n")
cat("Plots saved in: outputs/plots/\n")
