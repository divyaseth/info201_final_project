library("shiny")
library(ggplot2)

my_ui <- tabPanel(
  "Q1", 
  titlePanel("Diet Differences and Life Expectancy"),
  
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "username", label = "What is your name?")
    ),
    
    mainPanel(
      h4("What is the relationship between life expectancy in countries with 
         calorie intake?"), 
      p("Sugar dominated calories versus fat and protein dominated calories. 
        Does the source of the daily calories also influence the life expectancy?")
      
    )
  )
)

my_server <- function(input, output) {
  
  
}