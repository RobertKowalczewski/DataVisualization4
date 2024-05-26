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

data <- read.csv("../data/games.csv")

#data_separated_genres <- data %>%
#  separate_rows(Genres, sep = ",") %>% 
#  select(Genres)
data_separated_genres <- data %>%
  separate_rows(Genres, sep = ",") 

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