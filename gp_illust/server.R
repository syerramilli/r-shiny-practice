library(shiny)
library(reticulate)
library(ggplot2)
library(dplyr)

# Create a new Python virtual environment
venv_name <- "./gp_app"

# Use the virtual environment
use_virtualenv(venv_name, required = TRUE)

# load the required python libraries through reticulate
gpflow <- import("gpflow")
numpy <- import("numpy")

# create a vector on which the test predictions are computed
x_pred <- numpy$array(matrix(seq(0, 1, by = 0.01), ncol = 1))

server <- function(input, output, session){
  
  r_data <- reactive({
    set.seed(123)
    x <- runif(input$n_obs)
    y_true <- sin(2*pi*x)
    y <- y_true + rnorm(length(x), mean = 0, sd = 0.2)
    
    data.frame(x = x, y = y)
  })
  
  r_gp_model <- reactive({
    # get input data
    data <- r_data()
    
    # define kernel function based on user input
    kernel <- switch(input$kernel,
                     'Squared Exponential' = gpflow$kernels$SquaredExponential(),
                     'Matern 1/2' = gpflow$kernels$Matern12(),
                     'Matern 3/2' = gpflow$kernels$Matern32(),
                     'Matern 5/2' = gpflow$kernels$Matern52())
    
    # convert data to numpy arrays
    x_np <- numpy$array(matrix(data$x, ncol = 1))
    y_np <- numpy$array(matrix(data$y, ncol = 1))
    
    # create a gpflow model
    gp_model <- gpflow$models$GPR(tuple(x_np, y_np), kernel)
    
    # optimize the model using L-BFGS
    opt <- gpflow$optimizers$Scipy()
    res <- opt$minimize(gp_model$training_loss, gp_model$trainable_variables)
    
    gp_model
  })
  
  r_predictions <- reactive({
    gp_model <- r_gp_model()
    
    # generate predictions
    if(input$drop_noise){
      pred <- gp_model$predict_f(x_pred)
    } else{
      pred <- gp_model$predict_y(x_pred)
    }
    
    mean_pred <- numpy$squeeze(pred[[1]]$numpy())
    var_pred <- numpy$squeeze(pred[[2]]$numpy())
    
    data.frame(
      x_pred = x_pred[,1],
      mean_pred = mean_pred,
      std_pred = sqrt(var_pred)
    )
  })
  
  output$gp_plot <- plotly::renderPlotly({
    input_data <- r_data()
    plot_data <- r_predictions()
    
    alpha <- 1 - input$confidence_width
    
    plot_data <- plot_data %>%
      mutate(lower_bound = mean_pred - std_pred * qnorm(1 - alpha / 2)) %>%
      mutate(upper_bound = mean_pred + std_pred * qnorm(1 - alpha / 2))
    
    # TODO: display the width of the confidence interval in the legend
    ci_label = paste(input$confidence_width, '% CI', sep="")
    
    g <- ggplot(plot_data, aes(x = x_pred, y = mean_pred)) + 
      geom_line(aes(color = 'Prediction')) + 
      geom_ribbon(aes(ymin = lower_bound, ymax= upper_bound, fill = 'Confidence Interval'), alpha = 0.5) + 
      geom_point(data = input_data, mapping = aes(x = x, y = y, color = 'Observed')) + 
      scale_color_manual(values = c('Prediction' = 'steelblue', 'Observed' = 'black')) + 
      scale_fill_manual(values = c('Confidence Interval' = 'steelblue')) + 
      theme_minimal() + theme(legend.title = element_blank()) + 
      xlab('x') + ylab('y')
    
    g
  })
}

