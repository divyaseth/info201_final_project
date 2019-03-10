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
  "Scenario"
)
ui <- navbarPage(
  "Diet data",
  first_page,
  second_page,
  third_page,
  fourth_page
)