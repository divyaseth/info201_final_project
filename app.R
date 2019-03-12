library("shiny")
source("my_server.R")
source("my_ui.R")
library(shiny)

year_data <- read.csv(file = "data/2009-2013.csv", stringsAsFactors = FALSE)
sugar_calorie <- read.csv(file = "data/sugar_calorie.csv", stringsAsFactors = FALSE)

shinyApp(ui, server)