library(shiny)
library(shinythemes)
library(ggplot2)

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
                                 inputId = "genders",
                                 label = "Genres:",
                                 choices = list("RPG"="RPG", "Anime"="Anime")
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
                                 inputId = "genders",
                                 label = "Genres:",
                                 choices = list("RPG"="RPG", "Anime"="Anime")
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
                  tabPanel("other",
                           "Here goes something else..."
                  )
                )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
}

# Run the application 
shinyApp(ui = ui, server = server)