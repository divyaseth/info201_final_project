library("shiny")
library(dplyr)
library(ggplot2)
library(tidyr)
options(scipen = 999)

sugar_calorie <- read.csv(file = "data/sugar_calorie.csv", stringsAsFactors = FALSE)

year_data <- read.csv(file = "data/2009-2013.csv", stringsAsFactors = FALSE)

# Combine the life expectancy data with the calorie data
life_cal <- left_join(year_data, sugar_calorie, by = "country") %>% 
  select(-X)

# Calculate the amount of calories comming from sugar
life_cal_pct <- life_cal %>% 
  mutate(sugar_pct_2009 = round((sugar_X2009 * 4) / calorie_X2009 * 1000) / 10) %>% 
  mutate(sugar_pct_2010 = round((sugar_X2010 * 4) / calorie_X2010 * 1000) / 10) %>% 
  mutate(sugar_pct_2011 = round((sugar_X2011 * 4) / calorie_X2011 * 1000) / 10) %>%
  mutate(sugar_pct_2012 = round((sugar_X2012 * 4) / calorie_X2012 * 1000) / 10) %>% 
  mutate(sugar_pct_2013 = round((sugar_X2013 * 4) / calorie_X2013 * 1000) / 10) 
  

source("ui_server.R", local = TRUE)

shinyApp(ui = my_ui, server = my_server)

