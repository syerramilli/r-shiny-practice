library(dplyr)
library(shiny)
library(leaflet)

hex_colors <- c(
  '#001C7F','#B1400D','#12711C','#8C0800','#591E71',
  '#592F0D','#A23582','#3C3C3C','#B8850A','#006374'
)

# define cluster colors
cluster_colors <- colorFactor(
  palette = hex_colors,
  levels = seq(1, 10)
)

df <- read.csv('nyc_taxi_trips_june.csv') %>%
  filter(
    # filtering out rides less than 3 minutes and more than 6 hours
    trip_duration > 180, trip_duration < 6*3600, 
    # dropping observations where the pickup and dropoff geo-coordinates are the same
    pickup_longitude != dropoff_longitude | pickup_latitude != dropoff_latitude,
    # restricting coordinates to NYC using a bounding box approach
    pickup_longitude > -74.03, pickup_longitude < -73.75,
    pickup_latitude > 40.63, pickup_longitude < 40.85
  ) %>% 
  select(pickup_latitude, pickup_longitude)

about_text <- paste(
  'This database of a random selection of  NYC taxi rides in June 2016 is taken', 
  'from a kaggle competition.The app performs k-means clustering on the pickup coordinates.',
  'See if you can spot any interesting patterns'
)


server <- function(input, output, session){
  # pop-up when user clicks on the About button
  observeEvent(input$show_about,{
    showModal(
      modalDialog(about_text, title = 'About')
    )
  })
  
  
  reactive_kmeans <- reactive({
    clust_model <- kmeans(df, centers = input$n_clusters)
    list(
      df_w_labels = df %>%
        mutate(clust_label = factor(clust_model$cluster)) %>%
        group_by(clust_label) %>%
        sample_frac(0.1) %>%
        ungroup()
      , inertia = clust_model$tot.withinss
    )
  })
  
  output$sum_squares <- renderText({
    paste('Clustering Inertia (within sum of squares):', round(reactive_kmeans()$inertia, 2))
  })
  
  output$cluster_map <- renderLeaflet({
    leaflet() %>%
      #setView(lng = -74.0060, lat= 40.7128, zoom=11) %>%
      setView(lng = -73.9 , lat= 40.75, zoom=11) %>%
      addTiles()
  })
  
  observe({
    df_w_labels <- reactive_kmeans()$df_w_labels
    
    leafletProxy('cluster_map', deferUntilFlush = T) %>%
      clearMarkers() %>%
      clearControls() %>% # for removing the legend
      addCircleMarkers(
        lng = df_w_labels$pickup_longitude, 
        lat = df_w_labels$pickup_latitude,
        radius = 3, fillOpacity = 0.75,
        label = df_w_labels$clust_label,
        color = cluster_colors(df_w_labels$clust_label) # Apply color palette
      ) %>%
      # Add a legend
      addLegend(
        position = "bottomleft", # Customize the legend position
        colors = hex_colors[1:input$n_clusters], # Same colors as the palette
        labels = levels(df_w_labels$clust_label), # Cluster labels
        title = "Cluster Labels"
      )
  })
  
  observe({
    input$myMap_center
  })
}


