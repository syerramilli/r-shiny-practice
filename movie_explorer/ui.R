library(shiny)

ui <- fluidPage(
  titlePanel('Movie Explorer'),
  sidebarLayout(
    sidebarPanel(
      h4("Filter"),
      sliderInput('min_reviews', "Minimum number of reviews on Rotten Tomatoes",
                  10, 300, 80, step = 10),
      sliderInput('year', 'Year Released', 1940, 2014, value= c(1970, 2014)),
      sliderInput('min_oscars', 'Minimum number of Oscar wins (all categories)', 0, 4, 0),
      sliderInput('box_office', 'Dollars at Box Office (millions)', 
                  0, 800, c(0, 800), step = 20),
      selectInput("genre", "Genre (a movie can have multiple genres)",
                  c("All", "Action", "Adventure", "Animation", "Biography", "Comedy",
                    "Crime", "Documentary", "Drama", "Family", "Fantasy", "History",
                    "Horror", "Music", "Musical", "Mystery", "Romance", "Sci-Fi",
                    "Short", "Sport", "Thriller", "War", "Western")),
      textInput('director', 'Director name contins (e.g., Miyazaki)')
      #textInput('Cast names contains (e.g., Tom Hanks)')
    ), mainPanel(
      plotly::plotlyOutput('scatter'),
      wellPanel(
        span("Number of movies selected:",
             textOutput("n_movies")
        )
      )
    )
  )
)