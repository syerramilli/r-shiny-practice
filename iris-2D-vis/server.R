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
        x=.data[[input$x_var]], y=.data[[input$y_var]], color = Species
      ))  + list(
      theme(legend.position = 'bottom'),
      geom_point()
    )
    g
  })
}