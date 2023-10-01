library(shiny)

ui <- fluidPage(
  titlePanel('Visualizing topics in Associated Process identified via Latent Dirichlet Allocation'),
  theme = shinythemes::shinytheme('simplex'),
  sidebarLayout(
    sidebarPanel(
      sliderInput('n_topics', label = 'Select number of LDA topics',
                  min = 3, max = 10, value = 5),
      sliderInput('n_terms_display', label = 'Number of terms to display',
                  min = 5, max = 30, value = 15),
      width =  3
    ),
    mainPanel(
      LDAvis::visOutput('lda_vis'),
      width = 9
    )
  )
)