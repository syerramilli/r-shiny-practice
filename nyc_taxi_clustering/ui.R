library(shiny)

ui <- fluidPage(
  titlePanel('Clustering taxi pickup locations in New York City'),
  theme = shinythemes::shinytheme('simplex'),
  sidebarLayout(
    sidebarPanel(
      sliderInput('n_clusters', 'Number of clusters', 2, 10, value=5),
      actionButton('show_about','About'),
      width = 3
    ),
    mainPanel(
      h4(textOutput('sum_squares')),
      leaflet::leafletOutput('cluster_map', width = '100%', height = 600),
      textOutput("mapCenterText"),
      width = 9
    )
  )
)