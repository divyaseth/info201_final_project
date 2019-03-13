library("shiny")
first_page <- tabPanel(
  "Diet x Life Expectancy",
  titlePanel("Diet and Life Expectancy"),
  h5("How to use this page:"),  
  HTML("<ul>
       <li>Select a span of life expectancy.</li>
       <li>Pick a year that you are interested in.</li>
       <li>Play around with the widgets and explore!</li>
       </ul>"),
  sidebarLayout(
    sidebarPanel(
      # The slider should let user pick a range between the minimum and maximum 
      # age they are interested in.
      sliderInput(inputId = "age", label = "Life Expectancy(years):", 
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
  h5("How to use this page:"),  
  HTML("<ul>
       <li>Pick a year that you are interested in.</li>
       <li>Select a feature and explore!</li>
       </ul>"),
  sidebarLayout(
    sidebarPanel(
      selectInput("select",
                  "Year of Interest:",
                  c("2009", "2010", "2011", "2012","2013"),
                  selected = "2009"),
      br(),
      
      
      radioButtons("feature", "Feature of Interest:",
                   c("calorie",
                     "sugar"),
                   selected = "calorie")
      
    ),
    mainPanel(
      plotlyOutput("plot"), 
      h4("Explanation:"),
      HTML("<ul>
       <li>OECD stands for the
        Organization for Economic Co-operation and Development and includes 36 
           countries.</li>
           </ul>"),
      p("The x-axis of the graph describes the income level of a country
        in accending order while the y axis represents sugar calories or total
        calories depending on what option the user chooses. Using this plot we can
        learn more about the correlation between income level and calorie & sugar
        intake.It shows that when the income level 
        increases, both the calorie and sugar intake increase. Most notably, 
        the US, France, Germany, and Canada. As the bar
        graph demonstrates, the higher the overall country income, the higher the
        average calorie intake for its citizens. This data makes sense as those
        in countries with more accumulated wealth or a higher GDP would have
        the resources to invest in higher calorie diets. It is interesting to note
        that high income countries that are nonOECD such as India and China have lower
        calorie levels and sugar intake levels. One reason for this could be the large
        amount of income inequality and variance in standard of living within the
        nations.")
    )
  )
  
)
third_page <- tabPanel(
  "Regional Consistancy",
  titlePanel("Are regional preferences for calorie and sugar intake consistent?"),
  h5("How to use this page:"),  
  HTML("<ul>
       <li> Use this widget to select a year of data to display in the table.</li>
       </ul>"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput("Year", "Choose a Year:",
                  choices = c("2010", "2011", "2012"),
                  label = "Year of Interest:")
    ),
    
    mainPanel(
      dataTableOutput("table"),
      p("The data shown is the standard deviation of average calorie intake
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
  h5("How to use this page:"),  
  HTML("<ul>
       <li> Select a feature to see the influence of the food crisis.</li>
       </ul>"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "diff", label = "Feature of Interest: ",
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