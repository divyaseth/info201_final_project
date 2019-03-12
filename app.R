library("shiny")
library("plotly")
library("dplyr")
library("tidyr")
library("reshape2")

country <- read.csv("data/2009-2013.csv", stringsAsFactors = FALSE)
calories <- read.csv("data/sugar_calorie.csv", stringsAsFactors = FALSE)
combine <- left_join(country, calories, by = "country")
combine[is.na(combine)] <- 0
 


combined <- combine%>%
  group_by(income_group)%>%
  summarise(calorie2009 = mean(calorie_X2009),calorie2010 = mean(calorie_X2010),
            calorie2011 = mean(calorie_X2011),calorie2012 = mean(calorie_X2012), 
            calorie2013 = mean(calorie_X2013),
            
            sugar2009 = mean(sugar_X2009), sugar2010 = mean(sugar_X2010),
            sugar2011 = mean(sugar_X2011), sugar2012 = mean(sugar_X2012), 
            sugar2013 = mean(sugar_X2013)) 

combined$income_group <- factor(combined$income_group, 
                                levels = c("Low income", "Lower middle income", 
                                           "Upper middle income", "High income: OECD", "High income: nonOECD")) 
 
ui <- fluidPage(
  titlePanel("Correlation between Calorie and Income Level"),
  sidebarLayout(
    sidebarPanel(
      selectInput("select",
                  "Select year",
                  c("2009", "2010", "2011", "2012","2013"),
                  selected = "2009"),
      br(),
      
      
      radioButtons("feature", "Features:",
                         c("calorie",
                           "sugar"),
                         selected = "calorie")
      
    ),
    mainPanel(plotlyOutput("plot"),strong("Explanation:"),textOutput("text"))
  )
)


server <- function(input, output) {
  filtered <- reactive({
    data <- combined%>%
      select_("income_group",paste0(input$feature,input$select))
  })
  
  output$plot <- renderPlotly({
    
        ggplot(data = filtered(),mapping = aes_string(x = "income_group", y = paste0(input$feature,input$select), 
                                                    fill = "income_group"))+
        geom_col()+ labs(title = paste( "Data of", input$feature, "in", input$select ), 
                         y = "Calorie") 
  })
  output$text <- renderText({
    "As we can see from the graph, the X axis stands for the income group level, while the Y axis stands for the Calorie and Sugar intake level.
    Using this plot we can learn more about the correlation between income level and calorie & sugar intake. It shows that when the income level 
    increases, both the calorie and sugar intake increase."
  })

}

shinyApp(ui, server)