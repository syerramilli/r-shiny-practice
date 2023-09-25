library(dplyr)
library(shiny)
library(plotly)

con <- DBI::dbConnect(RSQLite::SQLite(), 'movies.db')
omdb <- tbl(con, 'omdb')
tomatoes <- tbl(con, 'tomatoes')

# join the two tables and collect
all_movies <- inner_join(omdb, tomatoes, by="ID") %>%
  filter(Reviews >= 10) %>% 
  select(
    ID, imdb_rating = Rating.x, Title, Year, Runtime, Genre, 
    Director, Cast, Oscars,tomato_meter = Rating.y, Reviews, BoxOffice 
  ) %>%
  mutate(has_oscars = ifelse(Oscars > 0, "Yes", "No") )

# close connection
# DBI::dbDisconnect(con)


server <- function(input, output, session){
  movies <- reactive({
    df <- all_movies %>%
      filter(Reviews >= local(input$min_reviews),
             Year >= local(input$year[1]), Year <= local(input$year[2]),
             Oscars >= local(input$min_oscars),
             BoxOffice >= local(input$box_office[1]*1e6), 
             BoxOffice <= local(input$box_office[2]*1e6))
    
    # filter by genre
    if(input$genre != "All"){ df <- df %>% filter(Genre %like% local(input$genre))}
    
    # filter by director
    if(!is.null(input$director) && input$director!=""){
      df <- df %>% filter(Director %like% local(director))
    }
    
    df %>% collect()
  })
  
  # plotly 
  plot_reactive <- reactive({
    plot_ly(
      data = movies(), x = ~tomato_meter, y = ~Reviews
    ) %>%
      
      # Add hollow markers with increased size and transparency
      add_markers(marker = list(size = 5, opacity = 0.6, line = list(width = 3)), 
                  color = ~has_oscars, 
                  colors = c("orange", "black"),
                  text = ~paste("<b>", Title, "</b><br>", Year, "<br>$", 
                                format(BoxOffice, big.mark = ",", scientific = F),
                                sep=""),
                  hovertemplate = '%{text}') %>%
      
      # Customize the legend title
      layout(legend = list(title = "Won Oscar")) %>%
      
      # Customize x and y axis labels
      layout(xaxis = list(title = "Tomato Meter"),
             yaxis = list(title = "Reviews"))
  })
  
  output$scatter <- renderPlotly({
    plot_reactive()
  })
  
  output$n_movies <- renderText({ nrow(movies()) })
}
