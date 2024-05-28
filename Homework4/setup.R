library(ggplot2)
library(dplyr)
library(tidyverse)
library(tidyr)
library(plotly)
library(stringr)

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


data <- read.csv("../data/games.csv")

#data_separated_genres <- data %>%
#  separate_rows(Genres, sep = ",") %>% 
#  select(Genres)
data_separated_genres <- data %>%
  separate_rows(Genres, sep = ",") 

#####
df_split <- data %>%
  separate_rows(Genres, sep = ",")
#df_split = df_split[c("Name", "Genres", "Metacritic.score")]

df_split$Genres <- trimws(df_split$Genres)
df_split <- df_split %>%
  filter(Genres != "")


df_encoded <- df_split %>%
  mutate(value = 1) %>%
  pivot_wider(names_from = Genres, values_from = value, values_fill = list(value = 0))
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