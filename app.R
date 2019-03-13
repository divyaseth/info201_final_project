library("shiny")
library(dplyr)
library(ggplot2)
library(tidyr)
library("plotly")
library("DT")
library(maps)
options(scipen = 999)

sugar_calorie <- read.csv(file = "data/sugar_calorie.csv", stringsAsFactors = FALSE)

year_data <- read.csv(file = "data/2009-2013.csv", stringsAsFactors = FALSE)

data <- left_join(year_data, sugar_calorie, by = "country") %>% 
  select(-X)

# Get the range of life expectancy from 2009 to 2013.
life_only <- na.omit(year_data %>% select(le_2009:le_2013))
life_gather <- life_only %>% gather(le_2009, le_2010, le_2011, le_2012, le_2013)
life_range <- round(range(life_gather$le_2010) * 100) / 100

source("my_server.R", local = TRUE)
source("my_ui.R", local = TRUE)

shinyApp(ui, server)
