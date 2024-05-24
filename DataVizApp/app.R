library(shiny)
library(shinythemes)
library(dplyr)
library(tidyr)
library(ggplot2)

log_transform <- function(x) {
  return(log1p(x))  # log1p is log(1 + x) to handle zero values
}
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
} 

data = read.csv("../data/games.csv")
data_separated_genres = data %>%
  separate_rows(Genres, sep = ",")
genres = c((count(data_separated_genres, Genres) %>% filter(n > 100))$Genres)

list_genres = list()
for (g in genres) {
  if(g!=""){
    list_genres[[g]] = g
  }

}

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("united"),
                navbarPage(
                  "Steam games",
                  tabPanel("Violin",
                           sidebarLayout(
                             position = "right",
                             sidebarPanel(
                               style = "height: 400px; overflow-y: scroll;",
                               checkboxGroupInput(
                                 inputId = "violinGenres",
                                 label = "Genres:",
                                 choices = list_genres
                               )
                             ),
                             mainPanel(
                               wellPanel(
                                 style = "height: 400px; overflow-y: scroll;",
                                 plotOutput("violinPlots")
                               )
                             )
                           )
                  ),
                  tabPanel("table",
                           sidebarLayout(
                             position = "right",
                             sidebarPanel(
                               style = "height: 400px; overflow-y: scroll;",
                               checkboxGroupInput(
                                 inputId = "tableGenres",
                                 label = "Genres:",
                                 choices = list("RPG"="RPG", "Anime"="Anime")
                               )
                             ),
                             mainPanel(
                               wellPanel(
                                 style = "height: 400px; overflow-y: scroll;",
                                 plotOutput("table")
                               )
                             )
                           )
                  ),
                  tabPanel("other",
                           "Here goes something else..."
                  )
                )
)

server <- function(input, output) {
  
  output$violinPlots = renderPlot({
    data_filtered = data_separated_genres %>% filter(Genres %in% input$violinGenres) %>% filter(Peak.CCU>0) %>% filter(Average.playtime.forever>0)
    ggplot(data_filtered, aes(Genres, Average.playtime.forever)) + geom_violin(fill="white") + geom_jitter(alpha=0.2)  + coord_flip()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)