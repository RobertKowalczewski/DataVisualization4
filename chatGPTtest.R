# Load necessary libraries
library(plotly)
library(dplyr)
library(tidyr)

data = read.csv("data/games.csv")
data_separated_categories = data %>%
  separate_rows(Categories, sep = ",")


data_separated_categories$date = as.Date(data_separated_categories$Release.date, format = "%b %d, %Y")

data_separated_categories$year_month <- year(data_separated_categories$date)
data_separated_categories = data_separated_categories %>% filter(year_month <= 2024 & year_month >= 2005)
#data_separated_genres$year_month <- floor_date(data_separated_genres$date, "month")

data_separated_categories = data_separated_categories %>% filter(Categories != "") %>% filter(Release.date != "")
data_separated_categories = data_separated_categories[c("Name", "Categories", "year_month")]

categories_freq <- table(data_separated_categories$Categories)

# Identify the top 5 most popular genres
n=20
top_categories <- names(sort(categories_freq, decreasing = TRUE))[1:n]

# Create a new column to categorize genres
data_separated_categories$category <- ifelse(data_separated_categories$Categories %in% top_categories, data_separated_categories$Categories, "Other")

agg_data <- data_separated_categories %>%
  group_by(year_month, category) %>%
  summarise(count = n()) %>%
  ungroup()
agg_data <- agg_data %>%
  group_by(year_month) %>%
  mutate(proportion = count/sum(count)) %>%
  ungroup()

#agg_data <- agg_data %>%
#  group_by(year_month) %>%
#  mutate(cumulative_proportion = cumsum(proportion)) %>% ungroup()

# Reshape the data for heatmap
agg_data_wide <- dcast(agg_data, year_month ~ category, value.var = "proportion")
agg_data_wide[is.na(agg_data_wide)] <- 0

softmax <- function(x) {
  exp_x <- exp(x - max(x))  # Subtract max for numerical stability
  return(exp_x / sum(exp_x))
}

for (i in 1:nrow(agg_data_wide)) {
  row <- agg_data_wide[i, ]
  print(row)
  # Skip the first row
  # Apply softmax to the row (excluding the first element)
  softmax_row <- softmax(minmax(row[-1]))
  # Add the softmax probabilities back to the dataframe
  agg_data_wide[i, -1] <- softmax_row
  print(agg_data_wide[i, -1])
}

# Reshape the data into long format
data_long_categories <- agg_data_wide %>%
  gather(key = "Category", value = "Value", -year_month)

