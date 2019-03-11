library("shiny")
library(dplyr)
library(ggplot2)
library(tidyr)
options(scipen = 999)

sugar_calorie <- read.csv(file = "data/sugar_calorie.csv", stringsAsFactors = FALSE)

year_data <- read.csv(file = "data/2009-2013.csv", stringsAsFactors = FALSE)

# Get the range of life expectancy from 2009 to 2013.
life_only <- na.omit(year_data %>% select(le_2009:le_2013))
life_gather <- life_only %>% gather(le_2009, le_2010, le_2011, le_2012, le_2013)
life_range <- round(range(life_gather$le_2010) * 100) / 100

source("ui_server.R", local = TRUE)

shinyApp(ui = my_ui, server = my_server)

