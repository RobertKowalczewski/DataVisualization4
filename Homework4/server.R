library(shiny)
library(lubridate)

source("setup.R")

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
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
  
  
  output$tableSpot = renderPlotly({
    n = 10
    windows = ifelse("Windows" %in% input$priceOS, "True", "False")
    mac = ifelse("Mac" %in% input$priceOS, "True", "False")
    linux = ifelse("Linux" %in% input$priceOS, "True", "False")
    data_filtered = data %>% 
      filter(sapply(Genres, function(row) check_all_genres_matched(row, input$tableGenres)) &
        year(mdy(Release.date)) <= input$yearSlider &
        Price <= input$priceSlider &
        (Average.playtime.forever <= input$playtimeSlider | input$over1000) & 
        (Windows==windows | Linux==linux | Mac==mac)) %>% 
      arrange(desc(Metacritic.score))
    
    #data_filtered = df_encoded %>% filter(rowSums(select(., all_of(df_encoded[[input$tableGenres]]))) == length(columns_to_check))
    
    data_filtered = data_filtered[1:n,]
    data_filtered = data_filtered[c("Name", "Genres", "Metacritic.score", "Price")]
    
    #sorted_games_list <- list()
    #for (genre in input$tableGenres) {
      # Apply the function and store the result in the list
    #  sorted_games_list[[genre]] <- filter_and_sort_games(data_separated_genres, genre, n)
    #}
    
    
    p = plot_ly(type="table", columnwidth = rep(100, length(input$tableGenres)),
                header = list(
                  values = c("name", "price"),
                  align = c("center"),
                  line = list(width = 1, color = 'black'),
                  fill = list(color = c("grey", "grey")),
                  font = list(family = "Arial", size = 14, color = "white")
                ),
                cells = list(
                  values = rbind(data_filtered$Name, data_filtered$Price),
                  align = c("center"),
                  line = list(color = "black", width = 1),
                  font = list(family = "Arial", size = 12, color = c("black"))
                )
    )
    p
  })
  
  output$pricePlot = renderPlotly({
    windows = ifelse("Windows" %in% input$priceOS, "True", "skibidi")
    mac = ifelse("Mac" %in% input$priceOS, "True", "skibidi")
    linux = ifelse("Linux" %in% input$priceOS, "True", "skibidi")
    
    
    data_filtered = data %>% filter(Windows==windows | Mac==mac | Linux==linux) %>%
      filter(sapply(Genres, function(row) check_all_genres_matched(row, input$priceGenres)))
    
    p = ggplot(data_filtered,
           aes(x=Metacritic.score, y=(Positive+1)/(Negative+1))
    ) + geom_point(aes(alpha=0.4)) + geom_smooth(model=lm) + coord_cartesian(xlim=c(10, 100), ylim=c(0, 150))
    ggplotly(p)
    
  })
  
  output$areaPlot = renderPlotly({
    fig <- plot_ly(
      data = agg_data_area,
      x = ~year_month,
      y = ~proportion,
      color = ~category,
      type = 'scatter',
      mode = 'none',
      stackgroup = 'one', 
      groupnorm = 'percent', 
      fillcolor = ''
    )
    
    # Customize layout
    fig <- fig %>%
      layout(
        title = "Proportion of 9 most popular genres over time",
        xaxis = list(title = "Date"),
        yaxis = list(title = "Proportion", showticklabels = FALSE),
        showlegend = TRUE
      )
    
    
    fig
  })
  
  output$heatmapPlot = renderPlotly({
    # Create the heatmap
    heatmap <- plot_ly(
      data = data_long_categories,
      x = ~year_month,
      y = ~Category,
      z = ~Value,
      type = 'heatmap',
      colors = colorRamp(c("blue", "green", "yellow", "red"))
    )
    
    # Display the heatmap
    heatmap
  })
}
