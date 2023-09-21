library(shiny)
data("iris")

ui <- fluidPage(
  titlePanel('2D scatter plots for the iris dataset'),
  theme = shinythemes::shinytheme('simplex'),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        'x_var', label = 'Choose x variable',
        selected = 'Sepal.Length',
        choices = colnames(iris)[1:4]
      ),
      selectInput(
        'y_var', label = 'Choose y variable',
        selected = 'Sepal.Width',
        choices = colnames(iris)[1:4]
      ),
      checkboxGroupInput(
        'species', label = 'Filter by Species',
        choices = unique(iris$Species),
        selected = unique(iris$Species)
      ),
      hr(),
      checkboxInput('by_species', label = 'Show species',value = TRUE),
      checkboxInput('add_smooth', label = 'Add smoother',value = FALSE),
      checkboxInput('show_marginals', label = 'Show marginals',value = TRUE)
    ), 
    mainPanel(
      plotOutput('scatter')
    )
  )
)