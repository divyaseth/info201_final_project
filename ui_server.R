library("shiny")
library(ggplot2)

my_ui <- fluidPage(
   
  titlePanel("Diet Differences and Life Expectancy"),
  
  sidebarLayout(
    sidebarPanel(
      # The slider should let user pick a range between the minimum and maximum 
      # age they are interested in.
      sliderInput(inputId = "age", label = "Life Expectancy(years)", 
                  min = life_range[1], max = life_range[2], value = life_range),
      
      # The dropdown should let user pick a year between 2009 and 2013.
      selectInput(inputId = "year", label = "Year of Interest:", 
                  choices = c("2009" = "2009",
                              "2010" = "2010", 
                              "2011" = "2011", 
                              "2012" = "2012", 
                              "2013" = "2013"),
                  selected = "2013")
    ),
    
    mainPanel(
      h4("What is the relationship between life expectancy in countries with 
         calorie intake?"), 
      p("Sugar dominated calories versus fat and protein dominated calories. 
        Does the source of the daily calories also influence the life expectancy?"),
      
      plotOutput("my_plot"),
      textOutput("my_text")
    )
  )
)


my_server <- function(input, output) {
  
  
  output$my_plot <- renderPlot({
    cal_colname <- reactive({paste0("calorie_X", input$year)})
    sugar_colname <- reactive({paste0("sugar_pct_", input$year)})
    le_colname <- reactive({paste0("le_", input$year)})
    
    # filtered_life <- life_cal_pct %>% 
    #   select(generate_colname("calorie_X", input$year), generate_colname("le_", input$year), 
    #          generate_colname("sugar_pct_", input$year)) %>%
    #   filter(generate_colname("le_", input$year) > input$age[1] & generate_colname("le_", input$year) < input$age[2])
    # 
    # p <- ggplot(data = filtered_life) +
    #   geom_point(mapping = aes_string(x = generate_colname("le_", input$year), 
    #                                   y = generate_colname("calorie_X", input$year),
    #                                   generate_colname("sugar_pct_", input$year)),
    #              alpha = 0.6
    #   ) +
    #   labs(title = paste0("Relationship between diet and life expectancy in ",
    #                       input$year),
    #        x = paste0("Life expectancy between ", input$age[1], " and ",
    #                   input$age[2]),
    #        y = "Daily Calorie Intake(calories)",
    #        color = "Sugar Proportion"
    #   ) +
    #   theme(axis.title = element_text(size=14, face = "bold"))
    # p
    
    ###############

    filtered_life <- life_cal_pct %>%
      select(cal_colname(), le_colname(), sugar_colname()) %>%
      filter(le_colname() > input$age[1] & le_colname() < input$age[2])

    p <- ggplot(data = filtered_life) +
      geom_point(mapping = aes_string(x = le_colname(), y = cal_colname(),
                                      color = sugar_colname()),
                 alpha = 0.6
      ) +
      labs(title = paste0("Relationship between diet and life expectancy in ",
                          input$year),
           x = paste0("Life expectancy between ", input$age[1], " and ",
                      input$age[2]),
           y = "Daily Calorie Intake(calories)",
           color = "Sugar Proportion"
      ) +
      theme(axis.title = element_text(size=14, face = "bold"))
    p
  })
  
  # output$my_text <- renderText({
  #   paste0("The plot shows the relationship between calorie intake and life 
  #          expectancy of the world in ", input$year, ".")
  # })
}