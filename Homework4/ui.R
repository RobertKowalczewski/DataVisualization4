library(shiny)

source("setup.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("united"),
  
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
                 width = 4
               ),
               mainPanel(
                 wellPanel(
                   style = "height: 800px; overflow-y: scroll;",
                   plotlyOutput("violinPlots")
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
                   choices = list("RPG" = "RPG", "Anime" = "Anime")
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
