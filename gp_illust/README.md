# Visualizing Gaussian process predictions

In this application, we plot the predictions and confidence intervals on the domain from a Gaussian process (GP) model fitted on the observed data. By fitting a GP model, we are estimating its hyperparameters through maximum likelihood estimation. The user can input the number of observations and the type of covariance kernel. 

## Required libraries

We will be using the `GPFlow` Python library (through the `reticulate` library) to train and obtain predictions from the GP model. Run the shell `venv_script.sh` script to setup a Python 3.9 virtual environment containing the required Python libraries.

On the R side, run the following command to install the required libraries

```
install.packages(c('shiny', 'shinyWidgets', 'reticulate', 'dplyr', 'ggplot2', 'plotly'))
```