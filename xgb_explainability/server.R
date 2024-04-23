library(dplyr)
library(xgboost)
library(pdp)

# Load the data
train <- read.csv("concrete.csv")
X <- as.matrix(train %>% select(-c("Strength")))
y <- train$Strength

# XGBoost hyperparameters - found through a few rounds
# of the TPE algorithm in hyperopt
params <- list(
  objective = "reg:squarederror",
  tree_method = 'approx',
  grow_policy= 'lossguide',
  eta=0.0920501443274767,
  max_leaves=16,
  min_child_weight=14,
  subsample=0.80577910383382
)

model <- xgb.train(params, xgb.DMatrix(data=X, label=y), nrounds=1129)

# gain_based feature importances
feat_importances <- xgb.importance(model=model)

# get SHAP values
shap_contr <- predict(model, X, predcontrib=TRUE)
shap_importances <- data.frame(
  Feature = colnames(X), 
  SHAP = colMeans(abs(shap_contr[,1:ncol(X)]), na.rm = TRUE)
)

# shap dependence plot
shap_dependnce <- function(model, pred.var, shap_contr, X){
  # get a dataframe of the shape values
  # combine the pred.var from X and the shap_contr
  shap_df <- data.frame(
    X[,pred.var], shap_contr[,pred.var]
  )
  colnames(shap_df) <- c(pred.var, "SHAP")
  
  ggplot(shap_df, aes(x=.data[[pred.var]], y=SHAP)) +
    geom_point(color='#B1400D', size=0.25) +
    geom_smooth(method='gam') + geom_rug(sides='b')
}

# Shiny server
server <- function(input, output, session){
  
  output$feat_imp_plot <- renderPlot({
    ggplot(feat_importances, aes(x = reorder(Feature, Gain), y = Gain)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Gain-based Feature Importances", x = "Feature", y = "Gain") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))  + coord_flip()
  })
  
  output$shap_imp_plot <- renderPlot({
    ggplot(shap_importances, aes(x = reorder(Feature, SHAP), y = SHAP)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "SHAP Feature Importances", x = "Feature", 
           y = "mean(|SHAP|)") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + coord_flip()
  })
  
  output$pdp_plot <- renderPlot({
    feature <- input$feature
    pdp_values <- partial(model, pred.var = feature, train = X)
    autoplot(pdp_values)
  })
  
  output$shap_plot <- renderPlot({
    feature <- input$feature
    shap_df <- data.frame(X[, feature], shap_contr[, feature])
    colnames(shap_df) <- c(feature, "SHAP")
    ggplot(shap_df, aes(x=.data[[feature]], y=SHAP)) +
      geom_point(color='#B1400D', size=0.25) +
      geom_smooth(method='loess')
  })
}