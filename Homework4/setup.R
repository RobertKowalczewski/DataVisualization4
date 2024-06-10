library(ggplot2)
library(dplyr)
library(tidyverse)
library(tidyr)
library(plotly)
library(stringr)
library(reshape2)

Sys.setlocale("LC_TIME", "en_US.UTF-8")

minmax <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

log_transform <- function(x) {
  return(log1p(x))  # log1p is log(1 + x) to handle zero values
}
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
} 
filter_and_sort_games <- function(data, desired_genre, n) {
  # Filter the data for the desired genre
  genre_filtered <- data %>%
    filter(Genres == desired_genre)
  
  # Sort the filtered data by score
  sorted_genre <- genre_filtered %>%
    arrange(desc(Metacritic.score))
  
  # Extract the names of the games sorted by score
  sorted_games <- sorted_genre$Name
  
  return(head(sorted_games, n))
}
check_all_genres_matched <- function(genres_list, genres_to_check) {
  all(genres_to_check %in% unlist(strsplit(genres_list, ",")))
}


data <- read.csv("data/games.csv")

#data_separated_genres <- data %>%
#  separate_rows(Genres, sep = ",") %>% 
#  select(Genres)
data_separated_genres <- data %>%
  separate_rows(Genres, sep = ",") 

#####
#df_split <- data %>%
#  separate_rows(Genres, sep = ",")
#df_split = df_split[c("Name", "Genres", "Metacritic.score")]

#df_split$Genres <- trimws(df_split$Genres)
#df_split <- df_split %>%
#  filter(Genres != "")


#df_encoded <- df_split %>%
#  mutate(value = 1) %>%
#  pivot_wider(names_from = Genres, values_from = value, values_fill = list(value = 0))
#####

genres <- count(data_separated_genres, Genres) %>%
  filter(n > 100) %>%
  arrange(desc(n)) %>%
  pull(Genres)

data_separated_languages <- data %>%
  mutate(Supported.languages=gsub("\\[|\\]|'", "", Supported.languages)) %>% 
  separate_rows(Supported.languages, sep = ", ") %>% 
  select(Supported.languages)

languages <- count(data_separated_languages, Supported.languages) %>% 
  filter(n > 100) %>% 
  arrange(desc(n)) %>% 
  pull(Supported.languages)

list_genres <- list()
for (g in genres) {
  if (g != "") {
    list_genres[[g]] <- g
  }
}

list_languages <- list()
for (lang in languages) {
  if (lang != "")
    list_languages[[lang]] <- lang
}

violin_x <- c("Peak.CCU", "Metacritic.score", "Positive", "Negative")



#### Area Plot
data_area = data_separated_genres
data_area$date = as.Date(data_area$Release.date, format = "%b %d, %Y")

data_area$year_month <- year(data_area$date)
data_area = data_area %>% filter(year_month <= 2024 & year_month >= 2005)

data_area = data_area %>% filter(Genres != "") %>% filter(Release.date != "")
data_area = data_area[c("Name", "Genres", "year_month")]

genre_freq <- table(data_area$Genres)

# Identify the top 5 most popular genres
n=9
top_genres <- names(sort(genre_freq, decreasing = TRUE))[1:n]

# Create a new column to categorize genres
data_area$category <- ifelse(data_area$Genres %in% top_genres, data_area$Genres, "Other")

agg_data_area <- data_area %>%
  group_by(year_month, category) %>%
  summarise(count = n()) %>%
  ungroup()
agg_data_area <- agg_data_area %>%
  group_by(year_month) %>%
  mutate(proportion = count/sum(count)) %>%
  ungroup()

####
### heatmap
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
  # Skip the first row
  # Apply softmax to the row (excluding the first element)
  softmax_row <- softmax(minmax(row[-1]))
  # Add the softmax probabilities back to the dataframe
  agg_data_wide[i, -1] <- softmax_row
}

# Reshape the data into long format
data_long_categories <- agg_data_wide %>%
  gather(key = "Category", value = "Value", -year_month)
###























