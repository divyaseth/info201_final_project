library("shiny")
library("ggplot2")
library("dplyr")

data <- left_join(year_data, sugar_calorie, by = "country") %>% 
  select(-X)

server <- function(input, output) {
  output$intro_crisis <- renderText({
    paragraph <- paste0("Between 2011 and 2012 there was a food crisis in Africa
                        (Horn of Africa Crisis). Is the crisis reflected in the 
                        sugar intake data? Was there a decrease in life-expectancy?
                        The graph below shows the ", input$diff, " during this food crisis.
                        (Some countries don't have the data and are blank in the map.)")  
  })
  output$africa <- renderPlot({
    data <- data %>% 
      filter(region == "Sub-Saharan Africa" | region == "Middle East & North Africa") %>% 
      filter(country != "United Arab Emirates" & country != "Bahrain" & 
                      country != "Iran, Islamic Rep." & country != "Iraq" &
                      country != "Jordan" & country != "Kuwait" & country != "Lebanon" &
                      country != "Malta" & country != "Oman" & country != "Qatar" &
                      country != "Saudi Arabia" & country != "Syrian Arab Republic" &
                      country != "Yemen, Rep.") %>% 
      select(country, le_2011, le_2012, sugar_X2011, sugar_X2012) %>% 
      mutate(`Change in sugar intake` = le_2011 - le_2012,
             `Change in life expectancy` = sugar_X2011 - sugar_X2012) %>% 
      filter(!is.na(`Change in life expectancy`)) %>% 
      filter(!is.na(`Change in sugar intake`))
    data$country[[6]] <- "Ivory Coast"
    data$country[[8]] <- "Democratic Republic of the Congo"
    map_shape <- map_data("world")
    data <- data %>% 
      left_join(map_shape, by = c("country" = "region"))
    ggplot(data = data) +
      geom_polygon(
        mapping = aes(x = long, y = lat, group = group, fill = data[[input$diff]]),
        color = "white",
        size = .1
      ) +
      scale_fill_continuous(low = "Green", high = "Red") +
      labs(title = paste0(input$diff, " during 2011 Africa food crisis"),
           fill = input$diff)
  })
  output$explain_crisis <- renderText({
    if(input$diff == "Change in sugar intake") {
      paragraph <- "We can see from the map that the sugar intake in most of the
                    part in Africa was negative. Especially South Africa had the
                    biggest decrease in sugar intake." 
    } else if(input$diff == "Change in life expectancy") {
      paragraph <- "The map shows that a country in Eastern Africa experienced the 
                    biggest decrease in life expectancy which verifies the horn of 
                    Africa food crisis."
    }
    paragraph
  })
}