library(shiny)
library(dplyr)
library(ggplot2)
library(ggExtra)

data('iris')

server <- function(input, output, session){
  rval_subset <- reactive({
    iris %>%
      filter(Species %in% input$species)
  })
  
  output$scatter <- renderPlot({
    g <- ggplot(rval_subset(), aes(
        x=.data[[input$x_var]], y=.data[[input$y_var]]
      ))  + list(
        if(input$by_species) { aes(color=Species) },
        theme(legend.position = 'bottom'),
        geom_point(),
        if(input$add_smooth) { geom_smooth()}
    )
    g
  })
}