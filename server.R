library(shiny)
library(datasets)
library(ggplot2)

#stores mtcars data for reshaping.
mpgData <- mtcars


#Define server logic
shinyServer( function(input, output) {
  
  
  varType <- reactive({input$variable}) ##stores vehicle attribute chosen
  
  plotData <- reactive(cbind(mpgData[varType()], 
                             mpgData["mpg"], 
                             data.frame(names = row.names(mpgData))
                             )) ##stores data to plot based on chosen attribute
  
  reactiveValuesList<- reactiveValues(data = NULL) ##a list of reactive values
  
  #resets vehTable to null if reset button pressed
  observeEvent(
    input$resetButton,{
      reactiveValuesList$vehTable <- NULL
    }
  ) 
  
  #Adds vehicle data to vehTable if add button pressed
  observeEvent(
    input$addButton,{
      
      rNames <- row.names(reactiveValuesList$vehTable)
      if(is.null(rNames)){
        isNameRepeated <- 0 
      } else {
        isNameRepeated <- sum(rNames == input$vehicle)
      }
      
      if(isNameRepeated != 0) {
      } else {reactiveValuesList$vehTable <- 
        rbind(reactiveValuesList$vehTable,mpgData[input$vehicle,])}
    }
  )
  
  #stores vehTable as reactive output for main panel
  output$newVehTable <- renderTable(reactiveValuesList$vehTable)
  
  #plotting data for vehicles users have chosen
  subPlotData <- reactive({
    if(!is.null(reactiveValuesList$vehTable)){
    cbind(reactiveValuesList$vehTable[varType()], 
          reactiveValuesList$vehTable["mpg"],
          data.frame(names = row.names(reactiveValuesList$vehTable)))
    } else {
      subPlotData <- NULL
      }
    })
          
  
  #stores plotting data as reactive output
  output$linPlot <- renderPlot({
     
    var <- varType()
    
    #plots all data from mtcars
    plot <- ggplot(data = plotData(), aes_string( x = varType(), y = "mpg"))+
            geom_boxplot(aes_string(group = varType()))+
            geom_point(colour = "blue")+
            ggtitle( paste("Mpg against", varType(), sep = " "))
    
    #plots data for vehicles user chose. Effect is to
    #highlight user's choices on main plot
    if(!is.null(subPlotData())){
    plot <- plot+geom_point(aes_string(x = varType(), 
                                       y = "mpg", 
                                       colour = "names"), 
                            size = 4, 
                            data = subPlotData())
    } 
    
    plot #final plot
    
  })
  
  
  
  
  
    
  
  
})