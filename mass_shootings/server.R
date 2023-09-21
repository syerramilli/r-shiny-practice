# load required libraries
library(dplyr)
library(shiny)
library(leaflet)

# uncomment the following line to fetch and save the data 
# source('fetch_data_and_clean.R')

# read in the data
mass_shootings <- read.csv('mass_shootings.csv') %>%
  mutate(date=lubridate::mdy(date))
  

# Text in the about description
about_text <- paste(
  'This database of US mass shootings was compiled by Mother Jones.', 
  'This database originally covered cases from 1982 to 2012.',
  'It has since been updated and expanded numerous times.'
)

# server function
server <- function(input, output, session){
  # pop-up when user clicks on the About button
  observeEvent(input$show_about,{
    showModal(
      modalDialog(about_text, title = 'About')
    )
  })
  
  # leaflet plot
  output$map <- renderLeaflet({
    mass_shootings %>%
      filter(
        fatalities >= input$n_fatalities,
        date >= input$date_range[1], date <= input$date_range[2]
      ) %>%
      leaflet() %>%
      setView( -98.58, 39.82, zoom = 4) %>%
      addTiles() %>%
      addCircleMarkers(
        popup = ~summary, radius = ~5 * sqrt(fatalities),
        lng = ~longitude, lat = ~latitude,
        fillColor = '#CD3700', color = '#CD3700', weight = 1
      )
  })
}