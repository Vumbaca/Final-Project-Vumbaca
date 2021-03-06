# call library for working with data
library(tidyverse)

# call library for creating shiny app
library(shiny)

# call library for stylizing shiny app
library(shinythemes)

# call library for creation of map
library(leaflet)

# call library for creating map data
library(ggmap)

# save data on total Cambridge homeless from file into dataframe
cambridge_total <- read_rds("cambridge_total.rds")

# save data on type of homelessness in Cambridge from file into dataframe
cambridge_type <- read_rds("cambridge_type.rds")

# save national homelessness data from file into dataframe
homeless_total <- read_rds("homeless.rds")

# create shiny app ui
ui <- fluidPage(
  
  # pick theme
  theme = shinytheme("sandstone"),

  # create navigation bar with app title
  navbarPage("Homelessness in Cambridge, MA",
    
      # create first navigation tab called time
      tabPanel("Time",
               
        # create set of tabs within tab called time
        tabsetPanel(
          
          # create tab called age
          tabPanel("Age", 
                   
                   # create row within tab called age with two columns inside
                   fluidRow(
                     
                     # create half page column with first age plot
                     column(width = 6, plotOutput(outputId = "time_age_plot_01")),
                     
                     # create half page column with second age plot
                     column(width = 6, plotOutput(outputId = "time_age_plot_02")))),
          
          # create tab called gender
          tabPanel("Gender",
                   
                   # create row within tab called gender with two columns inside
                   fluidRow(
                     
                     # create half page column with first gender plot
                     column(width = 6, plotOutput(outputId = "time_gender_plot_01")),
                     
                     # create half page column with second gender plot
                     column(width = 6, plotOutput(outputId = "time_gender_plot_02")))),
          
          # create tab called race
          tabPanel("Race",
                   
                   # create row within tab called race with two columns inside
                   fluidRow(
                     
                     # create half page column with first race plot
                     column(width = 6, plotOutput(outputId = "time_race_plot_01")),
                     
                     # create half page column with second race plot
                     column(width = 6, plotOutput(outputId = "time_race_plot_02")))),
          
          # create tab called other
          tabPanel("Other",
                   
                   # create row within tab called other with two columns inside
                   fluidRow(
                     
                     # create half page column with plot of others
                     column(width = 6, plotOutput(outputId = "time_other_plot")),
                     
                     # create half page column with overall homelessness plot
                     column(width = 6, plotOutput(outputId = "time_overall_plot")))))),
      
      # create second navigation tab called situation
      tabPanel("Situation",
               
               # create set of tabs within tab called situation
               tabsetPanel(
                 
                 # create another tab called age nested under situation
                 tabPanel("Age",
                          
                          # create row under age tab containing two columns
                          fluidRow(
                            
                            # create half page column with different age plot
                            column(width = 6, plotOutput(outputId = "sit_age_plot")),
                            
                            # create half page column with table on age
                            column(width = 6, tableOutput(outputId = "sit_age_table")))),
                 
                 # create another tab called gender nested under situation
                 tabPanel("Gender",
                          
                          # create row under gender tab containing two columns
                          fluidRow(
                            
                            # create half page column with different gender plot
                            column(width = 6, plotOutput(outputId = "sit_gender_plot")),
                            
                            # create half page column with table on gender
                            column(width = 6, tableOutput(outputId = "sit_gender_table")))),
                 
                 # create another tab called race nested under situation
                 tabPanel("Race",
                          
                          # create row under race tab containing two columns
                          fluidRow(
                            
                            # create half page column with different race plot
                            column(width = 6, plotOutput(outputId = "sit_race_plot")),
                            
                            # create half page column with table on race
                            column(width = 6, tableOutput(outputId = "sit_race_table")))),
                 
                 # create another tab called other nested under situation
                 tabPanel("Other",
                          
                          # create row under other tab containing two columns
                          fluidRow(
                            
                            # create half page column with different other plot
                            column(width = 6, plotOutput(outputId = "sit_other_plot")),
                            
                            # create half page column with overall homelessness plot
                            column(width = 6, plotOutput(outputId = "sit_overall_plot")))))),
      
      # create third and final navigation tab called place
      tabPanel("Place",
               
               # create one third left side panel for input
               sidebarPanel(
                 
                 # prompt user to select a year
                 selectInput(inputId = "year", label = "Year", choices = c(2014, 2015, 2016, 2017), selected = 2017),
               
                 # prompt user to select a living situation type
                 sliderInput(inputId = "count", label = "Number of Results to Display", min = 01, max = 50, value = 15),
                 
                 # ask user if they want 
                 checkboxInput(inputId = "prop", label = "Use Proportionally Sized Map Circles", value = FALSE)),
               
               # create two thirds right side panel for output
               mainPanel(
                 
                 # create set of tabs located in main panel
                 tabsetPanel(
                   
                   # create tab called total
                   tabPanel("Total",
                            
                     # create total homeless map
                     leafletOutput(outputId = "total_map"),
                 
                     # create row with pair of column for to organization
                     fluidRow(
                     
                     # create table within tab called total
                     column(tableOutput(outputId = "total_table"), width = 6),
                     
                     # create text on total in Cambridge
                     column(textOutput(outputId = "total_cambridge"),
                     
                     # create nationwide total text
                     textOutput(outputId = "total_nation"), width = 6))),
                   
                   # create tab called veterans
                   tabPanel("Homeless Veterans",
                            
                     # create homeless veterans map
                     leafletOutput(outputId = "vet_map"),
                     
                     # create row with pair of columns for organization
                     fluidRow(
                     
                     # create table within tab called veterans
                     column(tableOutput(outputId = "vet_table"), width = 6),
                     
                     # create text on veterans in Cambridge
                     column(textOutput(outputId = "vet_cambridge"),
                     
                     # create nationwide veterans text
                     textOutput(outputId = "vet_nation"), width = 6))),
                   
                   # create tab called chronic
                   tabPanel("Chronically Homeless",
                            
                     # create chronically homeless map
                     leafletOutput(outputId = "chron_map"),
                     
                     # create row with pair of columns for organization
                     fluidRow(
                     
                     # create table within chronically homeless tab
                     column(tableOutput(output = "chron_table"), width = 6),
                     
                     # create chronically homeless in Cambridge text
                     column(textOutput(outputId = "chron_cambridge"),
                     
                     # create text on chronically homeless nationwide
                     textOutput(outputId = "chron_nation"), width = 6))))))))

# create server for app
server <- function(input, output) {
  
  # create age percentage plot
  output$time_age_plot_01 <- renderPlot({
    
      # start with cambridge data
      cambridge_total %>%
      # remove entries without data on age
      filter(p_over_twentyfour != 0) %>%
      # keep only age variables and year
      select(year,
             "< 18" = p_under_eighteen,
             "18 - 24" = p_eighteen_twentyfour,
             "> 24" = p_over_twentyfour) %>%
      # reorganize data
      gather(key = age, value = percentage, -year) %>%
      # make age into factor
      mutate(age = factor(age, c("< 18", "18 - 24", "> 24"))) %>%
      # plot age group percentages as distinguished by color as function of time
      ggplot(aes(x = year, y = percentage, fill = age)) +
      # plot as bar graph
      geom_bar(stat = "identity") +
      # label plot
      labs(fill = "Age", x = "Year", y = "Percentage of Homeless Community")
    
  # set dimensions of plot
  }, height = 500, width = 500)
  
  # create age total plot
  output$time_age_plot_02 <- renderPlot({
    
    # start with cambridge data
    cambridge_total %>%
      # remove entries without data on age
      filter(t_over_twentyfour != 0) %>%
      # keep only age variables and year
      select(year,
             "< 18" = t_under_eighteen,
             "18 - 24" = t_eighteen_twentyfour,
             "> 24" = t_over_twentyfour) %>%
      # reorganize data
      gather(key = age, value = total, -year) %>%
      # make age into factor
      mutate(age = factor(age, c("< 18", "18 - 24", "> 24"))) %>%
      # plot age group total as distinguished by color as function of time
      ggplot(aes(x = year, y = total, color = age)) +
      # plot as line graph
      geom_line(size = 1, alpha = 0.5) +
      # label plot
      labs(color = "Age", x = "Year", y = "Total Individuals Experiencing Homelessness") +
      # set y axis bounds
      ylim(0, 600)
  
  # set dimensions of plot
  }, height = 500, width = 500)
  
  # create gender percentage plot
  output$time_gender_plot_01 <- renderPlot({
    
      # start with cambridge data
      cambridge_total %>%
      # remove entries without data on gender
      filter(p_males != 0) %>%
      # keep only gender variables and year
      select(year,
             "Male" = p_males,
             "Female" = p_females,
             "Trans" = p_trans,
             "Non-binary" = p_non_identifying) %>%
      # reorganize data
      gather(key = gender, value = percentage, -year) %>%
      # plot gender group percentages as distinguished by color as function of time
      ggplot(aes(x = year, y = percentage, fill = gender)) +
      # plot as bar graph
      geom_bar(stat = "identity") +
      # label plot
      labs(fill = "Gender", x = "Year", y = "Percentage of Homeless Community")
  
  # set dimension of plot  
  }, height = 500, width = 500)
  
  # create gender total plot
  output$time_gender_plot_02 <- renderPlot({
    
      # start with cambridge data
      cambridge_total %>%
      # remove entries without data on gender
      filter(t_males != 0) %>%
      # keep only gender variables and year
      select(year,
             "Male" = t_males,
             "Female" = t_females,
             "Trans" = t_trans,
             "Non-binary" = t_non_identifying) %>%
      # reorganize data
      gather(key = gender, value = total, -year) %>%
      # plot gender group totals as distinguished by color as function of time
      ggplot(aes(x = year, y = total, color = gender)) +
      # plot as line graph
      geom_line(size = 1, alpha = 0.5) +
      # label plot
      labs(color = "Gender", x = "Year", y = "Total Individuals Experiencing Homelessness") +
      # set y axis bounds
      ylim(0, 600)
  
  # set dimensions of plot  
  }, height = 500, width = 500)
  
  # create race percentage plot
  output$time_race_plot_01 <- renderPlot({
    
      # start with cambridge data
      cambridge_total %>%
      # remove entries without data on race
      filter(p_white != 0) %>%
      # keep only race variables and year
      select(year,
             "White" = p_white,
             "Black" = p_black,
             "Asian" = p_asian,
             "Native American" = p_indian_alaskan,
             "Pacific Islander" = p_hawaiian_islander,
             "Multiple" = p_multiple) %>%
      # reorganize data
      gather(key = race, value = percentage, -year) %>%
      # plot racial group percentages as distinguished by color as function of time
      ggplot(aes(x = year, y = percentage, fill = race)) +
      # plot as bar graph
      geom_bar(stat = "identity") +
      # label plot
      labs(fill = "Race", x = "Year", y = "Percentage of Homeless Community")
  
  # set dimensions of plot  
  }, height = 500, width = 500)
  
  # create race total plot
  output$time_race_plot_02 <- renderPlot({
    
    # start with cambridge data
    cambridge_total %>%
      # remove entries without data on race
      filter(t_white != 0) %>%
      # keep only race variables and year
      select(year,
             "White" = t_white,
             "Black" = t_black,
             "Asian" = t_asian,
             "Native American" = t_indian_alaskan,
             "Pacific Islander" = t_hawaiian_islander,
             "Multiple" = t_multiple) %>%
      # reorganize data
      gather(key = race, value = total, -year) %>%
      # plot racial group totals as distinguished by color as function of time
      ggplot(aes(x = year, y = total, color = race)) +
      # plot as line graph
      geom_line(size = 1, alpha = 0.5) +
      # label plot
      labs(color = "Race", x = "Year", y = "Total Individuals Experiencing Homelessness") +
      # set y axis bounds
      ylim(0, 600)
    
  # set dimensions of plot
  }, height = 500, width = 500)
  
  # create other total plot
  output$time_other_plot <- renderPlot({
    
    # start with cambridge data
    cambridge_total %>%
      # keep other variables and year variable
      select(year,
             "Veterans" = veteran,
             "Those with Mental Health Issues" = mental,
             "Those with Substance Abuse Issues" = substance,
             "Those with HIV" = hiv,
             "Victims of Domestic Violence" = domestic,
             "Chronically Homeless" = chronic) %>%
      # reorganize data
      gather(key = group, value = total, -year) %>%
      # plot other group averages as distinguished by color as function of time
      ggplot(aes(x = year, y = total, color = group)) +
      # plot as line graph
      geom_line(size = 2, alpha = .5) +
      # label plot
      labs(color = "Group", x = "Year", y = "Total Individuals Experiencing Homelessness") +
      # set y axis bounds
      ylim(0, 600)
    
    # set dimensions of plot
  }, height = 500, width = 600)
  
  # create overall total plot
  output$time_overall_plot <- renderPlot({
    
    # start with cambridge data
    cambridge_total %>%
      # keep other variables and year variable
      select(year,
             persons) %>%
      # plot other group averages as distinguished by color as function of time
      ggplot(aes(x = year, y = persons)) +
      # plot as line graph
      geom_line(size = 2, alpha = .5) +
      # label plot
      labs(x = "Year", y = "Total Individuals Experiencing Homelessness") +
      # set y axis bounds
      ylim(0, 600)
    
    # set dimensions of plot
  }, height = 500, width = 400)
  
  # create age average plot
  output$sit_age_plot <- renderPlot({
    
    # start with cambridge data on type
    cambridge_type %>%
      # keep average age variables and type
      select(type,
             "< 18" = a_under_eighteen,
             "18 - 24" = a_eighteen_twentyfour,
             "> 24" = a_over_twentyfour) %>%
      # reorganize data
      gather(key = age, value = average, -type) %>%
      # set age as factor
      mutate(age = factor(age, c("< 18", "18 - 24", "> 24"))) %>%
      # set type as factor
      mutate(type = factor(type, c("Unsheltered", "Emergency Shelter", "Transitional Housing"))) %>%
      # plot age group averages as distinguished by color as function of type
      ggplot(aes(x = type, y = average, fill = age)) +
      # plot as bar graph
      geom_bar(stat = "identity") +
      # label plot
      labs(fill = "Age", x = "Living Situation", y = "Average Individuals Experiencing Homelessness 2012-2017")
  
  # set dimensions of plot  
  }, height = 500, width = 500)
  
  # create age average table
  output$sit_age_table <- renderTable({
    
    # start with cambridge data on type
    cambridge_type %>%
      # keep average age variables and type in table
      select("Living Situation" = type,
             "< 18" = a_under_eighteen,
             "18 - 24" = a_eighteen_twentyfour,
             "> 24" = a_over_twentyfour)
  
  # set dimensions of table
  }, height = 500, width = 500)
  
  # create gender average plot
  output$sit_gender_plot <- renderPlot({
    
    # start with cambridge data on type
    cambridge_type %>%
      # keep average gender variables and type
      select(type,
             "Male" = a_males,
             "Female" = a_females,
             "Trans" = a_trans,
             "Non-binary" = a_non_identifying) %>%
      # reorganize data
      gather(key = gender, value = average, -type) %>%
      # set type as factor
      mutate(type = factor(type, c("Unsheltered", "Emergency Shelter", "Transitional Housing"))) %>%
      # plot gender group averages as distinguished by color as function of type
      ggplot(aes(x = type, y = average, fill = gender)) +
      # plot as bar graph
      geom_bar(stat = "identity") +
      # label plot
      labs(fill = "Gender", x = "Living Situation", y = "Average Individuals Experiencing Homelessness 2012-2017")
  
  # set dimensions of plot
  }, height = 500, width = 500)
  
  # create gender average table
  output$sit_gender_table <- renderTable({
    
    # start with cambridge data on type
    cambridge_type %>%
      # keep average gender variables and type in table
      select("Living Situation" = type,
             "Male" = a_males,
             "Female" = a_females,
             "Trans" = a_trans,
             "Non-binary" = a_non_identifying)
  
  # set dimensions of table
  }, height = 500, width = 500)
  
  # create race average plot
  output$sit_race_plot <- renderPlot({
    
    # start with cambridge data on type
    cambridge_type %>%
      # keep average race variables and type
      select(type,
             "White" = a_white,
             "Black" = a_black,
             "Asian" = a_asian,
             "Native American" = a_indian_alaskan,
             "Pacific Islander" = a_hawaiian_islander,
             "Multiple" = a_multiple) %>%
      # reorganize data
      gather(key = race, value = average, -type) %>%
      # set type as factor
      mutate(type = factor(type, c("Unsheltered", "Emergency Shelter", "Transitional Housing"))) %>%
      # plot racial group averages as distinguished by color as function of type
      ggplot(aes(x = type, y = average, fill = race)) +
      # plot as bar graph
      geom_bar(stat = "identity") +
      # label plot
      labs(fill = "Race", x = "Living Situation", y = "Average Individuals Experiencing Homelessness 2012-2017")
  
  # set dimensions of plot
  }, height = 500, width = 500)
  
  # create race average table
  output$sit_race_table <- renderTable({
    
    # start with cambridge data on type
    cambridge_type %>%
      # keep average race variables and type in table
      select("Living Situation" = type,
             "White" = a_white,
             "Black" = a_black,
             "Asian" = a_asian,
             "Native American" = a_indian_alaskan,
             "Pacific Islander" = a_hawaiian_islander,
             "Multiple" = a_multiple)
    
  # set dimensions of table
  }, height = 500, width = 500)
  
  # create other average plot
  output$sit_other_plot <- renderPlot({
    
    # start with cambridge data on type
    cambridge_type %>%
      # keep average other variables and type
      select(type,
             "Veterans" = a_veteran,
             "Individuals with Mental Health Issues" = a_mental,
             "Individuals with Substance Abuse Issues" = a_substance,
             "Individuals with HIV" = a_hiv,
             "Victims of Domestic Violence" = a_domestic,
             "Chronically Homeless" = a_chronic) %>%
      # reorganize data
      gather(key = group, value = average, -type) %>%
      # set type as factor
      mutate(type = factor(type, c("Unsheltered", "Emergency Shelter", "Transitional Housing"))) %>%
      # plot other group averages as distinguished by color as function of type
      ggplot(aes(x = type, y = average, fill = group)) +
      # plot as bar graph
      geom_bar(stat = "identity", position = position_dodge()) +
      # label plot
      labs(fill = "Group", x = "Living Situation", y = "Average Individuals Experiencing Homelessness 2012-2017")
    
    # set dimensions of plot
  }, height = 500, width = 600)
  
  # create overall average plot
  output$sit_overall_plot <- renderPlot({
    
    # start with cambridge data on type
    cambridge_type %>%
      # keep average other variables and type
      select(type,
             persons) %>%
      # set type as factor
      mutate(type = factor(type, c("Unsheltered", "Emergency Shelter", "Transitional Housing"))) %>%
      # plot other group averages as distinguished by color as function of type
      ggplot(aes(x = type, y = persons)) +
      # plot as bar graph
      geom_bar(stat = "identity") +
      # label plot
      labs(x = "Living Situation", y = "Average Individuals Experiencing Homelessness 2012-2017")
    
    # set dimensions of plot
  }, height = 500, width = 400)

  # create table on total national homelessness
  output$total_table <- renderTable({
    
    # start with national data
    homeless_total %>%
      # keep only year selected by user and remove annual sum
      filter(year == input$year & coc_name != "Total") %>%
      # sort locations from highest total count to lowest
      arrange(desc(total)) %>%
      # keep only location and count variables
      select("Continuum of Care" = spot, "Individuals Experiencing Homelessness" = total) %>%
      # display how many top results requested by user or default of fifteen
      head(input$count)
    
  # set dimensions of table
  }, height = 500, width = 500)
  
  # report total homelessness figure for cambridge
  output$total_cambridge <- renderText({
    
    # combine phrase with value
    paste("Individuals Experiencing Homelessness in Cambridge:",  
      # extract total number of homeless people in cambridge that year
      filter(cambridge_total, year == input$year)$persons,
      # separate parts with space
      sep = " ")})
  
  # report total homelessness figure for nation
  output$total_nation <- renderText({
    
    # combine phrase with value
    paste("Individuals Experiencing Homelessness in the United States:", 
      # extra total number of homeless people in whole united states that year
      filter(homeless_total, coc_name == "Total" & year == input$year)$total,
      sep = " ")})
  
  # create table on total veteran homelessness
  output$vet_table <- renderTable({
    
    # start with national data
    homeless_total %>%
      # keep only year selected by user and remove annual sum
      filter(year == input$year & coc_name != "Total") %>%
      # sort locations from highest amount of homeless veterans to lowest
      arrange(desc(veterans)) %>%
      # keep only location and amount variables
      select("Continuum of Care" = spot, "Veterans Experiencing Homelessness" = veterans) %>%
      # display how many top results requested by user or default of fifteen
      head(input$count)
  
  # set dimensions of table  
  }, height = 500, width = 500)
  
  # report veteran homelessness figure for cambridge
  output$vet_cambridge <- renderText({
    
    # combine phrase with value
    paste("Veterans Experiencing Homelessness in Cambridge:", 
      # extract total number of homeless veterans in cambridge that year
      filter(cambridge_total, year == input$year)$veteran,
      # separate parts with space
      sep = " ")})
  
  # report veteran homelessness figure for nation
  output$vet_nation <- renderText({
    
    # combine phrase with value
    paste("Veterans Experiencing Homelessness in the United States:", 
      # extract total number of homeless veterans in whole united states that year
      filter(homeless_total, coc_name == "Total" & year == input$year)$veterans,
      # separate parts with space
      sep = " ")})
  
  # create table on total chronic homelessness
  output$chron_table <- renderTable({
    
    # start with national data
    homeless_total %>%
      # keep only year selected by user and remove annual sum
      filter(year == input$year & coc_name != "Total") %>%
      # sort locations from highest amount of chronically homeless to lowest
      arrange(desc(chronic)) %>%
      # keep only location and count variables
      select("Continuum of Care" = spot, "Individuals Experiencing Chronic Homelessness" = chronic) %>%
      # display how many top results requested by user or default of fifteen
      head(input$count)
   
  # set dimensions of table 
  }, height = 500, width = 500)
  
  # report chronic homelessness figure for cambridge
  output$chron_cambridge <- renderText({
    
    # combine phrase with value
    paste("Individuals Experiencing Chronic Homelessness in Cambridge:", 
      # extract total number of chronically homeless in cambridge that year
      filter(cambridge_total, year == input$year)$chronic,
      # separate parts with space
      sep = " ")})
  
  # report chronic homelessness figure for nation
  output$chron_nation <- renderText({
    
    # combine phrase with value
    paste("Individuals Experiencing Chronic Homelessness in the United States:", 
      # extract total number of chronically homeless in whole united states that year
      filter(homeless_total, coc_name == "Total" & year == input$year)$chronic,
      # separate parts with space
      sep = " ")})

  # create total homelessness map
  output$total_map <- renderLeaflet({
    
    # save as new dataframe
    homeless_map_total <- homeless_total %>%
      # keep only year selected by user and remove annual sum
      filter(year == input$year & coc_name != "Total") %>%
      # sort locations from highest total count to lowest
      arrange(desc(total)) %>%
      # display how many top results requested by user or default of fifteen
      head(input$count)
    
    # create new variable row from row number in ordered list
    homeless_map_total$row <- as.numeric(rownames(homeless_map_total))
    
    # save new variables lon and lat to dataframe
    homeless_map_total <- homeless_map_total %>%
      # create new variable which is longitude of location
      mutate(lon = geocode(spot, output = "latlon", source = "dsk")[row, 1],
             # create new variable which is latitude of location
             lat = geocode(spot, output = "latlon", source = "dsk")[row, 2])
    
    # save new variable label to dataframe
    homeless_map_total <- homeless_map_total %>%
      # create new variable which is combination of location and total
      mutate(label = paste(spot, total, sep = ": "))
    
    # create map from data
    leaflet(homeless_map_total, options = leafletOptions(minZoom = 4, maxZoom = 10)) %>%
      # use osm black and white for map background
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      # center starting map view on middle of continental united states
      setView(lng = -98.5795, lat = 39.8283, zoom = 4) %>%
      # add circle markers for top results
      addCircleMarkers(radius = if(input$prop){~total/1000}else{10},
                       # make label information viewable on hover
                       label = ~label, color = "purple", weight = 0.1)})
  
  # create veteran homelessness map
  output$vet_map <- renderLeaflet({

    # save as new dataframe
    homeless_map_vet <- homeless_total %>%
      # keep only year selected by user and remove annual sum
      filter(year == input$year & coc_name != "Total") %>%
      # sort locations from highest amount of homeless veterans to lowest
      arrange(desc(veterans)) %>%
      # display how many top results requested by user or default of fifteen
      head(input$count)

    # create new variable row from row number in ordered list
    homeless_map_vet$row <- as.numeric(rownames(homeless_map_vet))

    # save new variables lon and lat to dataframe
    homeless_map_vet <- homeless_map_vet %>%
      # create new variable which is longitude of location
      mutate(lon = geocode(spot, output = "latlon", source = "dsk")[row, 1],
             # create new variable which is latitude of location
             lat = geocode(spot, output = "latlon", source = "dsk")[row, 2])

    # save new variable label to dataframe
    homeless_map_vet <- homeless_map_vet %>%
      # create new variable which is combination of location and total
      mutate(label = paste(spot, veterans, sep = ": "))

    # create map from data on veterans
    leaflet(homeless_map_vet, options = leafletOptions(minZoom = 4, maxZoom = 10)) %>%
      # use osm black and white for map background
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      # center starting map view on middle of continental united states
      setView(lng = -98.5795, lat = 39.8283, zoom = 4) %>%
      # add circle markers for top results
      addCircleMarkers(radius = if(input$prop){~veterans/100}else{10},
                       # make label information viewable on hover
                       label = ~label, color = "blue", weight = 0.1)})

  # create chronic homelessness map
  output$chron_map <- renderLeaflet({

    # save as new dataframe
    homeless_map_chron <- homeless_total %>%
      # keep only year selected by user and remove annual sum
      filter(year == input$year & coc_name != "Total") %>%
      # sort locations from highest amount of chronic homelessness to lowest
      arrange(desc(chronic)) %>%
      # display how many top results requested by user or default of fiften
      head(input$count)

    # create new variable row from row number in ordered list
    homeless_map_chron$row <- as.numeric(rownames(homeless_map_chron))

    # save new variabels lon and lat to dataframe
    homeless_map_chron <- homeless_map_chron %>%
      # create new variable which is longitude of location
      mutate(lon = geocode(spot, output = "latlon", source = "dsk")[row, 1],
             # create new variable which is latitude of location
             lat = geocode(spot, output = "latlon", source = "dsk")[row, 2])

    # save new variable label to dataframe
    homeless_map_chron <- homeless_map_chron %>%
      # create new variable which is combination of location and total
      mutate(label = paste(spot, chronic, sep = ": "))

    # create map from chronic homelessness data
    leaflet(homeless_map_chron, options = leafletOptions(minZoom = 4, maxZoom = 10)) %>%
      # use osm black and white for map background
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      # center starting map view on middle of continental united states
      setView(lng = -98.5795, lat = 39.8283, zoom = 4) %>%
      # add circle markers for top results
      addCircleMarkers(radius = if(input$prop){~chronic/250}else{10},
                       # make label information viewable on hover
                       label = ~label, color = "red", weight = 0.1)})}

# run app
shinyApp(ui = ui, server = server)
