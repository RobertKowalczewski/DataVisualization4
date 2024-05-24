library(ggplot2)
library(dplyr)
library(tidyverse)
library(tidyr)

log_transform <- function(x) {
  return(log1p(x))  # log1p is log(1 + x) to handle zero values
}
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

data = read.csv("games.csv")

data_separated_genres = data %>%
  separate_rows(Genres, sep = ",")

distinct(data.frame(data_separated_genres$Genres))

counted = count(data_separated_genres, Genres)

data_RPG = data_separated_genres %>% filter(Genres="RPG" | Genres="Action") %>% filter(Peak.CCU>0) %>% filter(Average.playtime.forever>0)
#data_RPG$Peak.CCU = (data_RPG$Peak.CCU - mean(data_RPG$Peak.CCU)) / sd(data_RPG$Peak.CCU)
#data_RPG$Peak.CCU = (data_RPG$Peak.CCU - min(data_RPG$Peak.CCU)) / (max(data_RPG$Peak.CCU) - min(data_RPG$Peak.CCU))

data_RPG$Peak.CCU = log_transform(data_RPG$Peak.CCU)
data_RPG$Peak.CCU = normalize(data_RPG$Peak.CCU)

data_RPG$Average.playtime.forever = log_transform(data_RPG$Average.playtime.forever)
data_RPG$Average.playtime.forever = normalize(data_RPG$Average.playtime.forever)



#ggplot(data_RPG, aes(Genres, Peak.CCU)) + geom_violin(fill="white") + geom_jitter(alpha=0.2)  + coord_flip()

#ggplot(data_RPG, aes(Genres, Average.playtime.forever)) + geom_violin(fill="white") + geom_jitter(alpha=0.2)  + coord_flip()

ggplot(data_RPG, aes(Genres, Average.playtime.forever)) + geom_violin(fill="white") + geom_dotplot(binaxis="y")  + coord_flip()



ggplot(data,
 aes(x=Metacritic.score, y=(Positive+1)/(Negative+1))
) + geom_jitter(aes(alpha=0.4)) + geom_smooth(model=lm) + coord_cartesian(xlim=c(10, 100), ylim=c(0, 150))


ggplot(data,
       aes(x=(Positive+1)/(Negative+1), y=Average.playtime.forever)
) + geom_jitter(aes(alpha=0.4)) + geom_smooth(model=lm) + coord_trans(x="sqrt")


