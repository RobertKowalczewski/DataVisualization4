library(ggplot2)
library(dplyr)
library(tidyverse)
library(tidyr)
library(lubridate)


data = read.csv("data/games.csv")
data_separated_genres = data %>%
  separate_rows(Genres, sep = ",")




#agg_data <- agg_data %>%
#  group_by(year_month) %>%
#  mutate(cumulative_proportion = cumsum(proportion)) %>% ungroup()

fig <- plot_ly(
  data = agg_data,
  x = ~year_month,
  y = ~proportion,
  color = ~category,
  type = 'scatter',
  mode = 'none',
  stackgroup = 'one', 
  groupnorm = 'percent', 
  fillcolor = 'tonexty'
)

# Customize layout
fig <- fig %>%
  layout(
    title = "Stacked Area Chart with Cumulative Values",
    xaxis = list(title = "Date"),
    yaxis = list(title = "Count", showticklabels = FALSE),
    showlegend = TRUE
  )


fig





