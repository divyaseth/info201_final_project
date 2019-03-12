library("shiny")
first_page <- tabPanel(
  "Diet x Life Expectancy"
)
second_page <- tabPanel(
  "Calorie x Income Level"
)
third_page <- tabPanel(
  "Regional Consistancy"
)
fourth_page <- tabPanel(
  "Scenario", 
  titlePanel("Horn of Africa Crisis"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "diff", label = "Select a feature to see the influence of 
                   the food crisis.",
                   choices = c("Change in sugar intake", "Change in life expectancy"),
                   selected = "Change in sugar intake"
      )
    ),
    mainPanel(
      textOutput(outputId = "intro_crisis"),
      plotOutput(outputId = "africa"),
      textOutput(outputId = "explain_crisis")
    )
  )
)

ui <- navbarPage(
  "Diet data",
  first_page,
  second_page,
  third_page,
  fourth_page
)