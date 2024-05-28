library(ggplot2)
library(dplyr)
library(tidyverse)
library(tidyr)
library(lubridate)
Sys.setlocale("LC_TIME", "en_US.UTF-8")

data = read.csv("data/games.csv")
data_separated_genres = data %>%
  separate_rows(Genres, sep = ",")


data_separated_genres$date = as.Date(data_separated_genres$Release.date, format = "%b %d, %Y")

data_separated_genres$year_month <- year(data_separated_genres$date)
data_separated_genres = data_separated_genres %>% filter(year_month <= 2024)
#data_separated_genres$year_month <- floor_date(data_separated_genres$date, "month")

data_separated_genres = data_separated_genres %>% filter(Genres != "") %>% filter(Release.date != "")
data_separated_genres = data_separated_genres[c("Name", "Genres", "year_month")]

genre_freq <- table(data_separated_genres$Genres)

# Identify the top 5 most popular genres
n=5
top_genres <- names(sort(genre_freq, decreasing = TRUE))[1:n]

# Create a new column to categorize genres
data_separated_genres$category <- ifelse(data_separated_genres$Genres %in% top_genres, data_separated_genres$Genres, "Other")

agg_data <- data_separated_genres %>%
  group_by(year_month, category) %>%
  summarise(count = n()) %>%
  ungroup()
agg_data <- agg_data %>%
  group_by(year_month) %>%
  mutate(proportion = count/sum(count)) %>%
  ungroup()


p = ggplot(agg_data, aes(x = year_month, y = proportion, fill=category)) +
  geom_area(position = 'fill') + 
  #scale_x_date(date_labels = "%b %d, %Y", date_breaks = "1 month") + # Customize date labels and breaks
  #scale_y_continuous(labels = scales::percent) +
  labs(x = "Date", y = "Count", title = "Plot with Continuous Date Axis") + 
  theme_minimal()+
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank() 
  )

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
  fill = 'tonexty'
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





