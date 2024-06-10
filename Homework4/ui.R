library(shiny)
library(shinythemes)

source("setup.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("united"),
  tags$style(
    HTML(
      "
      html, body {
        background-color: #B8860B;
        margin: 0;
        padding: 0;
        height: 100%;
      }
      "
    )
  ),
  
  navbarPage(
    "Steam games",
    tabPanel("Home",
             style="color: #A52A2A; hr{color: #A52A2A};",
             h1("Hello, welcome to the Steam Games dashboard!"),
             hr(),
             h2("Available items:"),
             h4("Score - you can check how good games from different genres are"),
             h4("Query - you can find games based on your specific criteria"),
             h4("Popular genres - you can view popularity of genres across the time"),
             h4("Popular tags - you can check how popular were games with different tags across the years"),
             hr(),
             h2("Authors:"),
             h3("Robert Kowalczewski 156040"),
             h3("Marcin Leszczynski 156061")
    ),
    tabPanel("Score",
             sidebarLayout(
               position = "right",
               sidebarPanel(
                 style = "height: 600px; overflow-y: scroll;",
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
                   choices = list_genres,
                   selected = "Indie"
                 ),
                 width = 4
               ),
               mainPanel(
                 wellPanel(
                   style = "height: 600px; overflow-y: scroll;",
                   plotlyOutput("violinPlots", height="550px")
                 )
               )
             ),
             h3("These violin plots how distributions of chosen score for every chosen genre.", style="color: #A52A2A;")
    ),
    tabPanel("Query",
             sidebarLayout(
               position = "right",
               sidebarPanel(
                 style = "height: 600px; overflow-y: scroll;",
                 
                 sliderInput(
                   inputId="playtimeSlider",
                   label="average playtime (in hours):",
                   min=0,
                   max=1000,
                   value=0
                 ),
                 checkboxInput("over1000", "1000+ hours", value=F),
                 sliderInput(
                   inputId="priceSlider",
                   label="maximum price (in $):",
                   min=0,
                   max=100,
                   value=0
                 ),
                 checkboxGroupInput(
                   inputId = "priceOS",
                   label = "OS:",
                   choices = list("Windows"="Windows", "Mac"="Mac", "Linux"="Linux")
                 ),
                 sliderInput(
                   inputId="yearSlider",
                   label="release year:",
                   min=2007,
                   max=2024,
                   value=2007
                 ),
                 checkboxGroupInput(
                   inputId = "tableGenres",
                   label = "Genres:",
                   choices = list_genres
                 )
               ),
               mainPanel(
                 wellPanel(
                   style = "height: 600px; overflow-y: scroll;",
                   plotlyOutput("tableSpot")
                 )
               )
             ),
             h3("Adjust your prefered parameters to find your favourite game!", style="color: #A52A2A;")
    ),
    tabPanel("Popular genres",
             fluidPage(
               wellPanel(
                 style = "height: 600px; overflow-y: scroll;",
                 plotlyOutput("areaPlot", height="550px")
               )
             ),
             h3("Here are most popular genres, fell free to expand for more information!", style="color: #A52A2A;")
    ),
    tabPanel("Popular tags",
             fluidPage(
               wellPanel(
                 style = "height: 600px; overflow-y: scroll;",
                 plotlyOutput("heatmapPlot", height="550px")
               ),
             ),
             h3("Here are tags, and they're shown by how popular their are", style="color: #A52A2A;")
    )
  )
)
