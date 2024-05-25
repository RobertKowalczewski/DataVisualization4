library(shiny)

source("setup.R")

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$violinPlots <- renderPlotly({
    data_filtered <- data_separated_genres %>%
      filter(Genres %in% input$violinGenres) %>%
      filter(.data[[input$violinChoice]] > 0)
    
    p <- ggplot(data_filtered, aes(x = Genres, y = normalize(log_transform(.data[[input$violinChoice]])))) + 
      geom_violin(fill = "white") + 
      geom_point(alpha = 0.2) + 
      coord_flip()
    
    ggplotly(p)
  })
  
}
