library("shiny")
server <- function(input, output) {
  
  # Q1
  output$my_plot <- renderPlot({
    
    # Turn year strings into correct column names.
    cal_colname <- paste0("calorie_X", input$year)
    sugar_colname <- paste0("sugar_pct_", input$year)
    le_colname <- paste0("le_", input$year)
    
    # Gather life expectancy data.
    year_data_gathered <- year_data %>%
      gather(
        key = year,
        value = life_expectancy,
        na.rm = T,
        le_2009:le_2013
      ) %>% filter(year == le_colname)
    
    # Gather the data frame for sugar percent only.
    # Then merge the sugar percent table with the life expectancy table.
    life_cal_pct <- sugar_calorie %>%
      mutate(sugar_pct_2009 = round((sugar_X2009 * 4) / calorie_X2009 * 1000) / 10) %>%
      mutate(sugar_pct_2010 = round((sugar_X2010 * 4) / calorie_X2010 * 1000) / 10) %>%
      mutate(sugar_pct_2011 = round((sugar_X2011 * 4) / calorie_X2011 * 1000) / 10) %>%
      mutate(sugar_pct_2012 = round((sugar_X2012 * 4) / calorie_X2012 * 1000) / 10) %>%
      mutate(sugar_pct_2013 = round((sugar_X2013 * 4) / calorie_X2013 * 1000) / 10) %>%
      select(country, sugar_pct_2009:sugar_pct_2013) %>%
      gather(
        key = year,
        value = sugar_pct,
        na.rm = T,
        - country
      ) %>% filter(year == sugar_colname) %>%
      left_join(year_data_gathered, by = "country")
    
    # Gather the calorie data table for a certain year
    # Join with the sugar and life expectancy table to become a full data table
    all_data <- sugar_calorie %>%
      select(country, calorie_X2009:calorie_X2013) %>%
      gather(
        key = year,
        value = calorie,
        na.rm = T,
        - country
      ) %>% filter(year == cal_colname) %>%
      left_join(life_cal_pct, by = "country")
    
    
    filtered_life <- all_data %>%
      filter(life_expectancy > input$age[1] & life_expectancy < input$age[2])
    
    
    p <- ggplot(data = filtered_life) +
      geom_point(mapping = aes(x = filtered_life[["life_expectancy"]],
                               y = filtered_life[["calorie"]],
                               color = filtered_life[["sugar_pct"]]),
                 alpha = 0.85
      ) +
      scale_color_gradient(low = "#756bb1", high = "#d95f0e") +
      labs(title = paste0("Relationship between diet and life expectancy in ",
                          input$year),
           x = paste0("Life expectancy between ", input$age[1], " and ",
                      input$age[2], " years"),
           y = "Daily Calorie Intake(calories)",
           color = "Sugar Proportion(in %)"
      ) +
      theme(axis.title = element_text(size=14, face = "bold"))
    p
  })
  
  output$my_text <- renderText({
    paste0("The plot shows the relationship between calorie intake and life
           expectancy of the world in ", input$year, ".")
  })
  
  # Q2 ----------------------------------
  
  combined <- data%>%
    group_by(income_group)%>%
    summarise(calorie2009 = mean(calorie_X2009, na.rm = TRUE), 
              calorie2010 = mean(calorie_X2010, na.rm = TRUE),
              calorie2011 = mean(calorie_X2011, na.rm = TRUE), 
              calorie2012 = mean(calorie_X2012, na.rm = TRUE), 
              calorie2013 = mean(calorie_X2013, na.rm = TRUE),
              
              sugar2009 = mean(sugar_X2009, na.rm = TRUE), 
              sugar2010 = mean(sugar_X2010, na.rm = TRUE),
              sugar2011 = mean(sugar_X2011, na.rm = TRUE), 
              sugar2012 = mean(sugar_X2012, na.rm = TRUE), 
              sugar2013 = mean(sugar_X2013, na.rm = TRUE)) 
  
  combined$income_group <- factor(combined$income_group, 
                                  levels = c("Low income", "Lower middle income", 
                                             "Upper middle income", "High income: OECD", "High income: nonOECD")) 
  
  
  filtered <- reactive({
    data <- combined%>%
      select_("income_group",paste0(input$feature,input$select))
  })
  
  output$plot <- renderPlotly({
    
    ggplot(data = filtered(),mapping = aes_string(x = "income_group", y = paste0(input$feature,input$select), 
                                                  fill = "income_group"))+
      geom_col()+ labs(title = paste( "Data of", input$feature, "in", input$select ), 
                       x = "Income Group",
                       y = "Calorie",
                       fill = "Income Group") 
  })
  
  # Q3 ----------------------------------
  output$table <- renderTable({
    # Data Wrangling
    # Code for Calorie Data Table
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
    
    filtered_year <- final_table %>% 
      filter(Year == input$Year)
    filtered_year
    })
  
  # Q4 ----------------------------------
  output$intro_crisis <- renderText({
    paragraph <- paste0("Between 2011 and 2012 there was a food crisis in Africa
                        (Horn of Africa Crisis).
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
      mutate(`Change in sugar intake` = sugar_X2011 - sugar_X2012,
             `Change in life expectancy` = le_2011 - le_2012) %>% 
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
      part in Africa was negative. As shown in the map, the countries that were most
      impacted by the Horn of Africa food crisis were Mali, Mauritius, South Africa, Sudan,
      and Zimbabwe. During the food crisis, Sudan most notably dropped in 29
      average calories of sugar." 
    } else if(input$diff == "Change in life expectancy") {
      paragraph <- "The map shows that a country in Eastern Africa experienced the 
      biggest decrease in life expectancy which verifies the horn of 
      Africa food crisis."
    }
    paragraph
    })
}