library(shiny)
library(shinythemes)


source("ui.R")
source("server.R")

# Run the Shiny application
shinyApp(ui = ui, server = server)
