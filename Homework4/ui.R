library(shiny)
library(shinythemes)

source("setup.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("united"),
  
  navbarPage(
    title = div(img(src = "https://fontawesome.com/icons/square-steam?f=brands&s=solid"), alt = "Steam games"),
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
             )
    ),
    tabPanel("area plot",
              fluidPage(
                wellPanel(
                  style = "height: 600px; overflow-y: scroll;",
                  plotlyOutput("areaPlot", height="550px"),
                )
              )
            ),
    tabPanel("heatmap",
             fluidPage(
               wellPanel(
                 style = "height: 600px; overflow-y: scroll;",
                 plotlyOutput("heatmapPlot", height="550px"),
               ),
               wellPanel(
                 radioButtons("chooseNormalizer", label = "normalize by:",
                              choices = c("Year", "Category")),
               )
             )
    )
  )
)
