library(shiny)
library(dplyr)

feature_names <- colnames(
  read.csv("concrete.csv") %>% select(-Strength)
)

ui <- fluidPage(
  titlePanel("XGBoost on Concrete Compressive Strength: Feature Analysis"),
  theme = shinythemes::shinytheme('simplex'),
  tabsetPanel(
    tabPanel("Feature Importances", {
      fluidRow(
        column(6, plotOutput("feat_imp_plot")),
        column(6, plotOutput("shap_imp_plot"))
      )
    }),
    tabPanel("Dependence Plots",
      sidebarLayout(
        sidebarPanel(
          selectInput("feature", "Select Feature:", choices = feature_names),
          width=3
        ),
        mainPanel(
          fluidRow(
            column(6,
                   h3("Partial Dependence Plot"),
                   plotOutput("pdp_plot")
            ),
            column(6,
                   h3("SHAP Dependence Plot"),
                   plotOutput("shap_plot")
            )
          )
        )
      )
    )
  )
)