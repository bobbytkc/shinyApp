#This app allows user to categorize vehicle data according
#to number of cylinder, transmission and gears and view
#their fuel efficiency. Also allows selection of specific
#vehicles to view their attributes.

library(shiny)
library(datasets)
library(ggplot2)


vehNames <- row.names(mtcars) ##Creates column of vehicle names  


#Define the UI first
shinyUI(pageWithSidebar(
  
  #Title
  headerPanel("Vehicle Miles Per Gallon Comparison"), 
  
  #Sidebar for user input
  sidebarPanel(
    
    #Select vehicle attribute
    selectInput("variable", 
                "Tansmission Type", 
                c("Cylinder" = "cyl",
                  "Transmission" = "am",
                  "Gears" = "gear")),
    
    #Select Vehicle name
    selectInput("vehicle", "Vehicle Name", vehNames),
    
    #add button to add vehicles for viewing
    actionButton("addButton", "Add/View Vehicle Data"),
    
    #resets the selected vehicles back to default
    actionButton("resetButton", "Reset Vehicle Data")
    
  ),
  
  #Main panel to view information
  mainPanel(
    
    #plots fuel efficiency
    plotOutput("linPlot"),
    
    #prints table to attributes
    tableOutput("newVehTable")
  )
  
))