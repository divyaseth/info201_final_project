#Packages
library(dplyr)
library(tidyr)
library(shiny)
library(ggplot2)

#Are regional preferences for calorie and sugar intake consistent?

#Data Set Up
sugar_calorie <- read.csv(file = "data/sugar_calorie.csv", stringsAsFactors = FALSE)
year_data <- read.csv(file = "data/2009-2013.csv", stringsAsFactors = FALSE)
data <- left_join(year_data, sugar_calorie, by = "country") %>% 
  select(-X)
#Code for Calorie Data Table
cal_sd_region10 <- data %>%
  group_by(region) %>%
  summarise(sd= sd(calorie_X2010, na.rm = TRUE))
cal_sd_region11 <- data %>%
  group_by(region) %>%
  summarise(sd= sd(calorie_X2011, na.rm = TRUE))
cal_sd_region12 <- data %>%
  group_by(region) %>%
  summarise(sd= sd(calorie_X2012, na.rm = TRUE))
#Code for Sugar Data Table
sug_sd_region10 <- data %>%
  group_by(region) %>%
  summarise(sd= sd(sugar_X2010, na.rm = TRUE))
sug_sd_region11 <- data %>%
  group_by(region) %>%
  summarise(sd= sd(sugar_X2011, na.rm = TRUE))
sug_sd_region12 <- data %>%
  group_by(region) %>%
  summarise(sd= sd(sugar_X2012, na.rm = TRUE))

#2010 Joined Data
sug_cal_2010 <- left_join(cal_sd_region10, sug_sd_region10, by = "region") %>% 
  mutate(Year = "2010")
colnames(sug_cal_2010)[colnames(sug_cal_2010)=="sd.x"] <- "Calorie"
colnames(sug_cal_2010)[colnames(sug_cal_2010)=="sd.y"] <- "Sugar"
colnames(sug_cal_2010)[colnames(sug_cal_2010)=="region"] <- "Region"
#2011 Joined Data
sug_cal_2011 <- left_join(cal_sd_region11, sug_sd_region11, by = "region") %>% 
  mutate(Year = "2011")
colnames(sug_cal_2011)[colnames(sug_cal_2011)=="sd.x"] <- "Calorie"
colnames(sug_cal_2011)[colnames(sug_cal_2011)=="sd.y"] <- "Sugar"
colnames(sug_cal_2011)[colnames(sug_cal_2011)=="region"] <- "Region"
#2012 Joined Data
sug_cal_2012 <- left_join(cal_sd_region12, sug_sd_region12, by = "region") %>% 
  mutate(Year = "2012")
colnames(sug_cal_2012)[colnames(sug_cal_2012)=="sd.x"] <- "Calorie"
colnames(sug_cal_2012)[colnames(sug_cal_2012)=="sd.y"] <- "Sugar"
colnames(sug_cal_2012)[colnames(sug_cal_2012)=="region"] <- "Region"


#Joined All Data Frames For All Years Together
final_table <- rbind(sug_cal_2010, sug_cal_2011, sug_cal_2012)

#UI: sidebar + mainpanel layout
ui <- fluidPage(
  
  titlePanel("Are regional preferences for calorie and sugar intake consistent?"),
  sidebarLayout(
    sidebarPanel(
    
      selectInput("Year", "Choose a Year",
                  choices = final_table$Year,
                 label = "Select a Year")
      ),
      
    mainPanel(
          tableOutput("table"),
          p("
            Use this widget to select a year of data to display in the table.
            The data shown is the standard deviation of average calorie intake
            data and average sugar intake data (grams). Using this data we can learn more about
            how calorie and sugar intake varies on a regional level. This is important because
            sometimes we make assumptions about an area and what the regional food prefrences or
            food security situation might be. This data highlights the problem with generalizing
            this and also sheds light on how calorie intake and sugar intake may vary. Note that North America
            across the years (primarily: Canada, US, Mexico), has a lower standard deviation for calorie intake.
            This indicator can be used as diversity and economic growth indicator in the context of nutrition, calorie, and sugar content.
            The variance of the standard deviation can be because of a variety of reason, including but not limited too:
            culture, geographic growing conditions, and trade and country wealth.")
          )
    )
)

#Server
server <- function(input, output){
output$table <- renderTable({
  filtered_year <- final_table %>% 
    filter(Year == input$Year)
  filtered_year})}

#App Run Function
shinyApp(ui = ui, server = server )