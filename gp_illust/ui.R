library(shiny)

ui <- fluidPage(
  titlePanel("Gaussian Process Model Fit"),
  sidebarLayout(
    sidebarPanel(
      sliderInput('n_obs', 'Number of training observations', min = 3, max = 30, value=5),
      selectInput("kernel", "Choose Kernel:",
                  choices = c("Squared Exponential", "Matern 5/2", "Matern 3/2", "Matern 1/2")),
      checkboxInput("drop_noise", "Show confidence interval without noise", value = FALSE),
      shinyWidgets::sliderTextInput("confidence_width", "Width of Confidence Interval:",
                                    choices=c(0.90, 0.95, 0.99))
    ),
    mainPanel(
      plotly::plotlyOutput("gp_plot")
    )
  )
)