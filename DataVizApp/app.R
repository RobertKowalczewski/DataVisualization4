library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(tidyr)
library(plotly)


log_transform <- function(x) {
  return(log1p(x))  # log1p is log(1 + x) to handle zero values
}
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
} 

data = read.csv("../data/games.csv")


data_separated_genres = data %>%
  separate_rows(Genres, sep = ",")

genres = count(data_separated_genres, Genres) %>%
  filter(n > 100) %>%
  arrange(desc(n)) %>%
  pull(Genres)

list_genres = list()
for (g in genres) {
  if(g!=""){
    list_genres[[g]] = g
  }

}

violin_x = c("Peak.CCU", "Metacritic.score", "Positive", "Negative")

# Define UI for application that draws a histogram
# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("united"),
                navbarPage(
                  "Steam games",
                  tabPanel("Violin",
                           sidebarLayout(
                             position = "right",
                             sidebarPanel(
                               style = "height: 800px; overflow-y: scroll;",
                               wellPanel(
                                 selectInput(
                                   inputId = "violinChoice",
                                   label = "Metric:",
                                   choices = violin_x
                                 )
                               ),
                               checkboxGroupInput(
                                 inputId = "violinGenres",
                                 label = "Genres:",
                                 choices = list_genres
                               ),
                               width=4
                             ),
                             mainPanel(
                               wellPanel(
                                 style = "height: 800px; overflow-y: scroll;",
                                 plotlyOutput("violinPlots"),
                                 #verbatimTextOutput("hover_info")
                               ),
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
  
  #output$violinPlots = renderPlot({
  #  data_filtered = data_separated_genres %>% filter(Genres %in% input$violinGenres) %>% filter(.data[[input$violinChoice]] > 0)
  #  
  #  
  #  ggplot(data_filtered, aes(Genres, normalize(log_transform(.data[[input$violinChoice]])))) + geom_violin(fill="white") + geom_jitter(alpha=0.2)  + coord_flip()
  #})
  
  
  output$violinPlots =  renderPlotly({
    data_filtered = data_separated_genres %>% filter(Genres %in% input$violinGenres) %>% filter(.data[[input$violinChoice]] > 0)
    p <- ggplot(data_filtered, aes(x=Genres, 
                                   y=normalize(log_transform(.data[[input$violinChoice]])))) + 
      geom_violin(fill="white") + 
      geom_point(alpha=0.2)  + 
      coord_flip()
    
    p_plotly = ggplotly(p)
  })
  
  #output$hover_info <- renderPrint({
  #  data_filtered = data_separated_genres %>% filter(Genres %in% input$violinGenres) %>% filter(.data[[input$violinChoice]] > 0)
  #  
  #  hover_data <- event_data("plotly_hover")
  #  if (!is.null(hover_data)) {
  #    point_index <- hover_data$pointNumber
  #    paste(data_filtered$Name[point_index])
  #  }
  #})
}

# Run the application 
shinyApp(ui = ui, server = server)