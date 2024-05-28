library(ggplot2)
library(dplyr)
library(tidyverse)
library(tidyr)
library(lubridate)
library(reshape2)


data = read.csv("data/games.csv")
data_separated_genres = data %>%
  separate_rows(Categories, sep = ",")


data_separated_genres$date = as.Date(data_separated_genres$Release.date, format = "%b %d, %Y")

data_separated_genres$year_month <- year(data_separated_genres$date)
data_separated_genres = data_separated_genres %>% filter(year_month <= 2024 & year_month >= 2005)
#data_separated_genres$year_month <- floor_date(data_separated_genres$date, "month")

data_separated_genres = data_separated_genres %>% filter(Categories != "") %>% filter(Release.date != "")
data_separated_genres = data_separated_genres[c("Name", "Categories", "year_month")]

genre_freq <- table(data_separated_genres$Categories)

# Identify the top 5 most popular genres
n=5
top_genres <- names(sort(genre_freq, decreasing = TRUE))[1:n]

# Create a new column to categorize genres
data_separated_genres$category <- ifelse(data_separated_genres$Categories %in% top_genres, data_separated_genres$Categories, "Other")

agg_data <- data_separated_genres %>%
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
colnames(agg_data_wide)[-1]
agg_data_wide$year_month
as.matrix(agg_data_wide[,-1])

# Create a heatmap
fig <- plot_ly(
  #y = colnames(agg_data_wide)[-1],
  #x = agg_data_wide$year_month,
  z = as.matrix(agg_data_wide[,-1]),
  type = 'heatmap',
  colorscale = "Greys"
)

# Customize layout
fig <- fig %>%
  layout(
    title = "Heatmap of Proportions Over Time",
    xaxis = list(title = "Category"),
    yaxis = list(title = "Date")
  )

# Show the figure
fig





