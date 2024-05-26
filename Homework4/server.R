library(shiny)

source("setup.R")

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$violinPlots <- renderPlotly({
    output$violinPlots <- renderPlotly({
      data_filtered <- data_separated_genres %>%
        filter(Genres %in% input$violinGenres) %>%
        filter(.data[[input$violinChoice]] > 0) %>% arrange(.data[[input$violinChoice]])
      
      
      
      data_filtered$TransformedValue <- normalize(log_transform(data_filtered[[input$violinChoice]]))
      data_filtered$Bins <- cut(data_filtered$TransformedValue, breaks = 1000, include.lowest = TRUE)
      
      data_aggregated <- data_filtered %>%
        group_by(Genres, Bins) %>%
        summarize(
          Value = mean(TransformedValue),
          ValueRaw = mean(.data[[input$violinChoice]]),
          Names = ifelse(n() > 10, 
                         paste(paste(Name[1:10], collapse = "\n"), paste("\nAnd",n()-10, "more...")), 
                         paste(Name, collapse = "\n"))
        ) %>%
        ungroup()
      
      # Create a ggplot object with aggregated data
      p <- ggplot(data_aggregated, aes(x = Genres, y = Value)) + 
        geom_violin(data = data_filtered, aes(y = TransformedValue), fill = "white") + 
        geom_point(aes(text = paste(Names, "\n", input$violinChoice, " = ", ValueRaw)), alpha = 0.2) + 
        coord_flip()
      
      # Convert the ggplot object to a plotly object
      p_plotly <- ggplotly(p, tooltip = "text")
      p_plotly <- p_plotly %>%
        style(hoverinfo = "none", traces = c(1)) %>%  # Disabling hoverinfo for geom_violin
        style(hoverinfo = "text", traces = c(2))  
      p_plotly
      
      # Print the plotly object
      p_plotly
    })
  })
  
  
  output$tableSpot = renderPlotly({
    
  })
  
}
