library(shiny)

ui <- bootstrapPage(
  theme = shinythemes::shinytheme('simplex'),
  leaflet::leafletOutput('map', width = '100%', height = '100%'),
  absolutePanel(
    top = 10, right = 10, id = 'controls',
    sliderInput('n_fatalities', 'Minimum Fatalities', 1, 40, 10),
    dateRangeInput(
      'date_range', 'Select Date', "2000-01-01", "2019-12-01"
    ),
    actionButton('show_about','About')
  ),
  tags$style(type = "text/css", "
    html, body {width:100%;height:100%}     
    #controls{background-color:white;padding:20px;}
  ")
)