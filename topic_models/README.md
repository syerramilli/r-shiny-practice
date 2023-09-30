# Visualizing topics in the Associated Press (AP) corpus

In this app, we visualize the topics identified for the AP corpus through Latent Dirchlet Allocation (LDA). The number of topics is a hyperparameter to the LDA model. The app provides an option to specify the number of topics (range: 3-10). Refer to the LDAvis paper [Sievert and Shirley (2014)] as well as the LDAvis vignette for more details about the visualization

## Required Libraries

```
install.packages(c('shiny', 'dplyr', 'topicmodels', 'tidytext', 'LDAvis'))
```


## References

1. Blei, D. M., Ng, A. Y., & Jordan, M. I. (2003). Latent dirichlet allocation. Journal of machine Learning research, 3(Jan), 993-1022.
2. Sievert, C., & Shirley, K. (2014, June). LDAvis: A method for visualizing and interpreting topics. In Proceedings of the workshop on interactive language learning, visualization, and interfaces (pp. 63-70) 
3. LDAvis vignette: https://cran.r-project.org/web/packages/LDAvis/vignettes/details.pdf

