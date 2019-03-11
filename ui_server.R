library("shiny")
library(ggplot2)


my_ui <- fluidPage(
   
  titlePanel("Diet and Life Expectancy"),
  h5("How to use the site:"),  
  HTML("<ul>
       <li>Select a span of life expectancy.</li>
       <li>Pick a year that you are interested in.</li>
       <li>Play around with the widgets and explore!</li>
       </ul>"),
  sidebarLayout(
    sidebarPanel(
      # The slider should let user pick a range between the minimum and maximum 
      # age they are interested in.
      sliderInput(inputId = "age", label = "Life Expectancy(years)", 
                  min = life_range[1], max = life_range[2], value = life_range),
      
      # The dropdown should let user pick a year between 2009 and 2013.
      selectInput(inputId = "year", label = "Year of Interest:", 
                  choices = c("2009",
                              "2010", 
                              "2011", 
                              "2012", 
                              "2013"),
                  selected = "2013")
    ),
    
    mainPanel(
      h4("What is the relationship between life expectancy and 
         calorie intake?"), 
      p("Does the percent of calories", em("coming from sugar"), 
        "affect the life expectancy?"),
      
      plotOutput("my_plot"),
      textOutput("my_text"),
      
      HTML("<ul>
         <li>X axies represents the span of life expectancy.</li>
         <li>Y axies represents the calorie intake.</li>
         </ul>"),
      
      br(),
      
      p("As we can see from the graph, there is a relatively strong correlation 
        between life expectancy and calorie intake. The countries that hava a 
        higher life expectancy tend to have high-calorie diets. However, the 
        relationship between sugar and life expectancy is not distinct. One   
        general conclusion I can draw is that high-calorie diets do contain more 
        sugar than low-calorie diets")
    )
  )
)


my_server <- function(input, output) {


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
                      input$age[2]),
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
}