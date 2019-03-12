library("shiny")
first_page <- tabPanel(
  "Diet x Life Expectancy",
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
           <li>X axis represents the span of life expectancy by age.</li>
           <li>Y axis represents the calorie intake in calories.</li>
           </ul>"),
      
      br(),
      
      p("Each dot represents a country and is colored by the percentage of sugar as
        a proportion of
        calories that is in the diet. For instance, a dot that is orange represents
        a country where sugar is a high percentage of the total diet in calories.
        As we can see from the graph,there is a relatively strong correlation 
        between life expectancy and calorie intake. The countries that hava a 
        higher life expectancy tend to have high-calorie diets. However, the 
        relationship between sugar and life expectancy is not distinct. One   
        general conclusion I can draw is that high-calorie diets do contain more 
        sugar than low-calorie diets. ")
      )
    )
)
second_page <- tabPanel(
  "Calorie x Income Level", 
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
third_page <- tabPanel(
  "Regional Consistancy",
  titlePanel("Are regional preferences for calorie and sugar intake consistent?"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput("Year", "Choose a Year",
                  choices = c("2010", "2011", "2012"),
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
fourth_page <- tabPanel(
  "Scenario",
  titlePanel("Horn of Africa Crisis"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "diff", label = "Select a feature to see the influence of 
                   the food crisis.",
                   choices = c("Change in sugar intake", "Change in life expectancy"),
                   selected = "Change in sugar intake"
      )
    ),
    mainPanel(
      textOutput(outputId = "intro_crisis"),
      plotOutput(outputId = "africa"),
      textOutput(outputId = "explain_crisis")
    )
  )
)
ui <- navbarPage(
  "Diet data",
  first_page,
  second_page,
  third_page,
  fourth_page
)