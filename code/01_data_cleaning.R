# 01_data_cleaning.R
# Project: Demand Forecasting and Inventory Decision-Making under Uncertainty
# Purpose: Clean Kaggle Store Item Demand data and prepare one product-store demand series

# ------------------------------------------------------------
# 1. Create required folders
# ------------------------------------------------------------

dir.create("data", showWarnings = FALSE)
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/plots", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 2. Read raw data
# ------------------------------------------------------------

raw_file <- "data/train.csv"

if (!file.exists(raw_file)) {
  stop("File not found: data/train.csv. Put train.csv inside the data folder.")
}

demand_raw <- read.csv(raw_file, stringsAsFactors = FALSE)

# ------------------------------------------------------------
# 3. Standardize column names
# ------------------------------------------------------------

names(demand_raw) <- tolower(names(demand_raw))

required_columns <- c("date", "store", "item", "sales")

missing_columns <- setdiff(required_columns, names(demand_raw))

if (length(missing_columns) > 0) {
  stop(
    paste(
      "Missing required columns:",
      paste(missing_columns, collapse = ", ")
    )
  )
}

# ------------------------------------------------------------
# 4. Convert variables
# ------------------------------------------------------------

demand_raw$date <- as.Date(demand_raw$date)
demand_raw$store <- as.integer(demand_raw$store)
demand_raw$item <- as.integer(demand_raw$item)
demand_raw$sales <- as.numeric(demand_raw$sales)

# ------------------------------------------------------------
# 5. Remove invalid records
# ------------------------------------------------------------

demand_clean <- demand_raw[complete.cases(demand_raw), ]

demand_clean <- demand_clean[demand_clean$sales >= 0, ]

# ------------------------------------------------------------
# 6. Select one store-item series for first version
# ------------------------------------------------------------

selected_store <- 1
selected_item <- 1

one_series <- demand_clean[
  demand_clean$store == selected_store &
    demand_clean$item == selected_item,
]

# ------------------------------------------------------------
# 7. Aggregate demand by date
# ------------------------------------------------------------

daily_demand <- aggregate(
  sales ~ date,
  data = one_series,
  FUN = sum
)

names(daily_demand) <- c("date", "demand")

daily_demand <- daily_demand[order(daily_demand$date), ]

daily_demand$store <- selected_store
daily_demand$item <- selected_item
daily_demand$year <- as.integer(format(daily_demand$date, "%Y"))
daily_demand$month <- as.integer(format(daily_demand$date, "%m"))

daily_demand <- daily_demand[
  ,
  c("date", "store", "item", "year", "month", "demand")
]

# ------------------------------------------------------------
# 8. Create cleaning summary
# ------------------------------------------------------------

cleaning_summary <- data.frame(
  description = c(
    "Raw rows",
    "Rows after removing missing/invalid values",
    "Selected store",
    "Selected item",
    "Final daily demand rows",
    "Start date",
    "End date",
    "Minimum demand",
    "Maximum demand",
    "Mean demand"
  ),
  value = c(
    nrow(demand_raw),
    nrow(demand_clean),
    selected_store,
    selected_item,
    nrow(daily_demand),
    as.character(min(daily_demand$date)),
    as.character(max(daily_demand$date)),
    min(daily_demand$demand),
    max(daily_demand$demand),
    round(mean(daily_demand$demand), 2)
  )
)

# ------------------------------------------------------------
# 9. Save cleaned data and summary
# ------------------------------------------------------------

write.csv(
  daily_demand,
  "data/demand_data_cleaned.csv",
  row.names = FALSE
)

write.csv(
  cleaning_summary,
  "outputs/tables/data_cleaning_summary.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 10. Confirmation message
# ------------------------------------------------------------

cat("Data cleaning completed successfully.\n")
cat("Cleaned file saved as: data/demand_data_cleaned.csv\n")
cat("Cleaning summary saved as: outputs/tables/data_cleaning_summary.csv\n")
cat("Selected store:", selected_store, "\n")
cat("Selected item:", selected_item, "\n")
cat("Number of daily observations:", nrow(daily_demand), "\n")