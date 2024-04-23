# Analysis of feature contributions from a XGBoost model

In this app, we will analyze the feature contributions from a XGBoost regression model that predicts the compressive strength of concrete. The dataset used in this analysis is the [Concrete Compressive Strength Dataset](https://archive.ics.uci.edu/ml/datasets/Concrete+Compressive+Strength) from the UCI Machine Learning Repository. The app has two main components:

1. Feature importances: In this section, we will analyze the global feature importances of the model using two different methods: gain-based feature importances and SHAP based feature importances.
2. First order effects: In this section, we plot the first-order effects for each feature in the dataset. The first-order effects show how the predicted compressive strength changes as a function of each feature while keeping all other features constant. We use two different methods: partial dependence plots, and SHAP dependence plots. 

## Required Libraries

```
install.packages(c('shiny', 'dplyr', 'shinythemes', 'xgboost', 'pdp'))
```
