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
                   choices = list_genres
                 ),
                 width = 4
               ),
               mainPanel(
                 wellPanel(
                   style = "height: 600px; overflow-y: scroll;",
                   plotlyOutput("violinPlots", height="550px")
                 )
               )
             )
    ),
    tabPanel("Table",
             sidebarLayout(
               position = "right",
               sidebarPanel(
                 style = "height: 600px; overflow-y: scroll;",
                 checkboxGroupInput(
                   inputId = "tableGenres",
                   label = "Genres:",
                   choices = list_genres
                 )
               ),
               mainPanel(
                 wellPanel(
                   style = "height: 600px; overflow-y: scroll;",
                   plotOutput("tableSpot")
                 )
               )
             )
    ),
    tabPanel("by price",
             sidebarLayout(
               position = "right",
               sidebarPanel(
                 style = "height: 600px; overflow-y: scroll;",
                 checkboxGroupInput(
                   inputId = "priceOS",
                   label = "OS:",
                   choices = list("Windows"="Windows", "Mac"="Mac", "Linux"="Linux")
                 ),
                 sliderInput(
                   inputId="priceSlider",
                   label="maximum price (in $):",
                   min=0,
                   max=100,
                   value=0
                 ),
                 checkboxGroupInput(
                   inputId = "priceGenres",
                   label = "Genres:",
                   choices = list_genres
                 ),
                 width = 4
               ),
               mainPanel(
                 wellPanel(
                   style = "height: 600px; overflow-y: scroll;",
                   plotlyOutput("pricePlot")
                 )
               )
             )
    ),
    tabPanel("other",
             "coming soon..."
    )
  )
)
