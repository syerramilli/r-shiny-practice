library(shiny)

ui <- fluidPage(
  titlePanel('Visualizing topics in Associated Process identified via Latent Dirichlet Allocation'),
  theme = shinythemes::shinytheme('simplex'),
  sliderInput('n_topics', label = 'Slide to adjust number of LDA topics',
              min = 3, max = 10, value = 5),
  hr(),
  LDAvis::visOutput('lda_vis')
)