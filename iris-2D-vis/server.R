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
  
  rval_plot <- reactive({
    ggplot(rval_subset(), aes(
      x=.data[[input$x_var]], y=.data[[input$y_var]]
    ))  + list(
      if(input$by_species) { aes(color=Species) },
      theme(legend.position = 'bottom'),
      geom_point(),
      if(input$add_smooth) { geom_smooth()}
    )
  })
  
  output$scatter <- renderPlot({
    g <- rval_plot()
    if(input$show_marginals) {
      return(ggMarginal(
        g, 
        # marginal density plots without species colors 
        # don't look great, will use histograms instead
        type= if(input$by_species) 'density' else 'histogram',  
        margins = 'both', size = 5, 
        groupColour = input$by_species,
        groupFill =  input$by_species
      ))
    }
    g
  })
}